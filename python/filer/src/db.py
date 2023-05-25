#!/usr/bin/env python
import os, re, sqlite_utils
from files import *
from images import *
from audio import *
from videos import *
from hidden import *
from repos import *
from folders import *
from util import *

class DB():
  def __init__(self, recreate=False):
    db_file = os.path.expanduser("~/.filer.db")
    self.db = sqlite_utils.Database(db_file,recreate=recreate)

  def add(self, path, scan_filetype):
    mime = mimetype(path)
    filetype = mime.mime_type.split("/")[0]

    if scan_filetype not in [filetype, "all"]:
      return

    match filetype:
      case "image":
        Images.add(self, mime, path, filetype)
      case "video":
        Videos.add(self, mime, path, filetype)
      case "audio":
        Audio.add(self, mime, path, filetype)
      case _:
        Files.add(self, mime, path, filetype)

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
      }], pk="src")
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

