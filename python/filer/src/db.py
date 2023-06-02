#!/usr/bin/env python
import os, re, sqlite_utils
from util import *

class DB():
  def __init__(self, recreate=False):
    self.db = sqlite_utils.Database(".filer.db",recreate=recreate)

  def insert(self, table, obj):
    try:
      self.db[table].insert_all([{
        "src": obj.src,
        "dst": obj.dst,
        "type": obj.filetype,
        "ext": obj.ext,
        "created": obj.created,
        "size": obj.size,
        "md5": obj.md5,
      }], pk=["md5","src"])
      print(f"{obj.filetype}: {obj.src}")
      print(f"  {obj.dst}")
    except:
      print(f"Already scanned: {obj.src}")

  def add_list(self, table, path):
    print(f"{table}: {path}")
    try:
      self.db[table].insert_all([{
        "src": path
      }], pk="src")
    except:
      print(f"Already scanned: {path}")

  def is_done(self, base):
    try:
      return len(list(self.db.execute(f"""
        SELECT
          src
        FROM done
        WHERE src = ?
        LIMIT 1
      """, [base]))) == 1
    except:
      return False

  def query(self, sql):
    return self.db.query(sql)

