#!/usr/bin/env python
from command import *
from db import *

class Folders(Command):
  table = 'folders' #unused

  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)
    action = self.options.action
    self.db = DB()
    match action:
      case "list":
        for row in self.db.query(f"SELECT * FROM {self.table}"):
          print(row)
      case _:
        print(f"No such action '{action}'")

