#!/usr/bin/env python
import os, re, sqlite_utils
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

  def process(self, table, obj):
    if self.found(obj.md5, "md5", table):
      print(f"Already processed: {obj.src}")
    else:
      dst = act("move", obj.src, obj.dst, obj.md5, obj.ext, "")
      obj.src = dst
      self.insert(table, obj, log=False)

  def add_list(self, table, path):
    print(f"{table}: {path}")
    try:
      self.db[table].insert_all([{
        "src": path
      }], pk="src")
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

  def drop(self, table = "done"):
    try:
      self.db[table].drop()
    except:
      print(f"{table} could not be dropped")