#!/usr/bin/env python
import os
from command import *
from db import *
from util import *

class Files(Command):
  table = 'files'

  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)
    action = self.options.action
    self.db = DB()
    match action:
      case "list":
        try:
          for row in self.db.query(f"SELECT * FROM {self.table}"):
            print(row)
        except Exception as e:
          print(e)
      case "distinct" | "ext":
        try:
          for row in self.db.query(f"""
            SELECT
              ext,
              COUNT(ext) AS count
            FROM {self.table}
            GROUP BY ext
            ORDER BY count DESC
          """):
            print(f"{row['count']: >4} {row['ext']}")
        except Exception as e:
          print(e)
      case "md5" | "dst":
        duplicates = self.find_duplicates(action)
        for key, sources in duplicates.items():
          print(key)
          for src in sources:
            print(f"  {src}")
      case "copy":
        duplicates = self.find_duplicates("dst", "")
        for dst, sources in duplicates.items():
          copy(sources[0], dst)
      case _:
        print(f"No such action '{action}'")

  def find_duplicates(self, column, condition = 'WHERE duplicate > 1'):
    duplicates = {}
    try:
      for row in self.db.query(f"""
        SELECT
          (
            SELECT
              COUNT({column})
            FROM {self.table} AS d
            WHERE d.{column} = t.{column}
          ) AS duplicate,
          t.{column},
          t.src
        FROM {self.table} AS t
        {condition}
        ORDER BY duplicate DESC, t.{column} ASC
      """):
        duplicates.setdefault(row[column], []).append(row["src"])
    except Exception as e:
      print(e)
    return duplicates

  @staticmethod
  def add(db, mime, path, filetype):
    obj = Common()
    obj.ext, obj.size, obj.md5 = common_data(mime, path)
    match obj.ext:
      case ".mp3":
        from audio import Audio
        Audio.add(db, mime, path, filetype)
        return
    obj.src = path
    obj.filetype = filetype
    obj.created = timestamp(path)
    obj.dst = Files.destination(obj.src, obj.ext)
    db.insert(Files.table, obj)

  @staticmethod
  def destination(path, ext):
    root = os.getcwd()
    src = path.removeprefix(root)
    obj = datetime.datetime.strptime(timestamp(path), "%Y-%m-%d %H:%M:%S")
    #Only add a year directory to Documents:
    return obj.strftime(f"Documents/%Y{src}")

