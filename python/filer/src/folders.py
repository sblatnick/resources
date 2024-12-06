#!/usr/bin/env python
from command import *
from db import *

class Folders(Command):
  table = 'folder' #unused

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
      case "dst":
        duplicates = self.db.find_duplicates(self.table, action)
        for key, sources in duplicates.items():
          print(key)
          for src in sources:
            print(f"  {src}")
      case "copy" | "move" | "dry":
        self.do(action)
      case _:
        print(f"No such action '{action}'")

