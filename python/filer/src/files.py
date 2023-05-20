#!/usr/bin/env python
import os, argparse, re
from command import *
from db import *

class Files(Command):
  table = 'files'

  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)
    action = self.options.action
    db = DB()
    match action:
      case "list":
        for row in db.query(f"SELECT * FROM {self.table}"):
          print(row)
      case "dup":
        for row in db.query(f"""
          SELECT
            *,
            COUNT(md5) AS duplicates
          FROM {self.table}
          GROUP BY md5
          HAVING duplicates > 1
          ORDER BY duplicates DESC
        """):
          print(row)
      case _:
        print(f"No such action '{action}'")
