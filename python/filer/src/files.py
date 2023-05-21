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
        duplicates = {}
        for row in db.query(f"""
          SELECT
            (
              SELECT
                COUNT(md5)
              FROM {self.table} AS d
              WHERE d.md5 = t.md5
            ) AS duplicate,
            t.md5,
            t.src
          FROM {self.table} AS t
          WHERE duplicate > 1
          ORDER BY duplicate DESC, t.md5 ASC
        """):
          duplicates.setdefault(row["md5"], []).append(row["src"])
        for md5, sources in duplicates.items():
          print(md5)
          for src in sources:
            print(f"  {src}")
      case _:
        print(f"No such action '{action}'")
