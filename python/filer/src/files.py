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
          for row in self.db.db[self.table].rows:
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
        duplicates = self.db.find_duplicates(self.table, action)
        for key, sources in duplicates.items():
          print(key)
          for src in sources:
            print(f"  {src}")
      case "copy" | "move" | "dry":
        self.do(action)
      case _:
        print(f"No such action '{action}'")

  def do(self, action):
    for row in self.db.db[self.table].rows:
      self.db.act(action, self.table, row)

  @staticmethod
  def process(mime, path, filetype):
    obj = Common()
    obj.ext, obj.size, obj.md5 = common_data(mime, path)
    match obj.ext:
      case ".mp3":
        from audio import Audio
        table, obj = Audio.process(mime, path, filetype)
        return (table, obj)
    obj.src = path
    obj.filetype = filetype
    obj.created = timestamp(path)
    obj.dst = Files.destination(obj.src, obj.ext)
    return (Files.table, obj)

  @staticmethod
  def destination(path, ext):
    root = os.getcwd()
    src = path.removeprefix(root)
    obj = datetime.datetime.strptime(timestamp(path), "%Y-%m-%d %H:%M:%S")
    #Only add a year directory to Documents:
    return obj.strftime(f"Documents/%Y{src}")

