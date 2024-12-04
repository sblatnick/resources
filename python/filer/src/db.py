#!/usr/bin/env python
import os, shutil, re, sqlite_utils
from util import *

class DB():
  def __init__(self, recreate=False):
    self.db = sqlite_utils.Database(".filer.db",recreate=recreate)

  def insert(self, table, obj, log=True):
    #print(f"insert {table}: {obj.src}")
    try:
      self.db[table].insert_all([{
        "src": obj.src,
        "dst": obj.dst,
        "type": obj.filetype,
        "ext": obj.ext,
        "created": obj.created,
        "size": obj.size,
        "md5": obj.md5,
      }], pk=["src", "md5"])
      if log:
        print(f"{obj.filetype}: {obj.src}")
        print(f"  {obj.dst}")
    except:
      #print(f"Already scanned: {obj.src}")
      pass

  def add_list(self, table, path, dst=None):
    try:
      self.db[table].insert_all([{
        "src": path,
        "dst": dst
      }], pk="src")
      print(f"{table}: {path}")
    except:
      #print(f"Already scanned: {path}")
      pass

  def is_done(self, base):
    return self.found(base)

  def found(self, value, key = "src", table = "done"):
    try:
      return len(list(self.db.execute(f"""
        SELECT
          {key}
        FROM {table}
        WHERE {key} = ?
        LIMIT 1
      """, [value]))) >= 1
    except:
      return False

  def query(self, sql):
    return self.db.query(sql)

  def remove_lost(self):
    for table in self.db.table_names():
      try:
        for row in self.db[table].rows:
          if not os.path.exists(row["src"]):
            self.db[table].delete((row["src"],row["md5"]))
            print(f"Removed {table}: {row["src"]}")
      except Exception as e:
        print(e)

  def find_duplicates(self, table, column, condition = 'WHERE duplicate > 1'):
    duplicates = {}
    try:
      for row in self.query(f"""
        SELECT
          (
            SELECT
              COUNT({column})
            FROM {table} AS d
            WHERE d.{column} = t.{column}
          ) AS duplicate,
          t.{column},
          t.src
        FROM {table} AS t
        {condition}
        ORDER BY duplicate DESC, t.{column} ASC
      """):
        duplicates.setdefault(row[column], []).append(row["src"])
    except Exception as e:
      print(e)
    return duplicates

  def drop(self, table = "done"):
    try:
      self.db[table].drop()
    except:
      print(f"{table} could not be dropped")

  def act(self, action, table, obj):
    #action = None (insert) | "copy" | "move" | "dry"
    if action == None:
      self.insert(table, obj, log=True)
      return
    if not os.path.exists(obj.src):
      ##Should never happen
      #print(f"Missing source, removing from db: {obj.src}")
      self.db[table].delete((obj.src, obj.md5))
      return
    
    #in case a new file:
    self.insert(table, obj, log=False)
    
    if os.path.exists(obj.dst):
      if obj.src == obj.dst:
        print(f"Correct: {obj.src}")
        return
      dstmd5 = md5sum(obj.dst)
      if obj.md5 == dstmd5:
        if action == "move":
          self.db[table].delete((obj.src, obj.md5))
          print(f"shutil.rmtree({obj.src})")
          #shutil.rmtree(obj.src)
      else:
        print(f"COLLISION:")
        print(f"  src: {obj.src}")
        print(f"  dst: {obj.dst}")
        obj.md5 = dstmd5
      obj.src = obj.dst
      self.insert(table, obj, log=False)
      return
    else:
      print(f"{action} {obj.filetype}: {obj.src}")
      print(f"  {obj.dst}")
      match action:
        case "copy":
          obj.src = obj.dst
          self.insert(table, obj, log=False)
          print(f"shutil.copy2('{obj.src}', '{obj.dst}')")
          #shutil.copy2(obj.src, obj.dst)
        case "move":
          self.db[table].update((obj.src, obj.md5), {"src" : obj.dst})
          print(f"shutil.move('{obj.src}', '{obj.dst}')")
          #shutil.move(obj.src, obj.dst)
      return

