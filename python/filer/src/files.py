#!/usr/bin/env python
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
      case "md5" | "dst":
        duplicates = {}
        for row in db.query(f"""
          SELECT
            (
              SELECT
                COUNT({action})
              FROM {self.table} AS d
              WHERE d.{action} = t.{action}
            ) AS duplicate,
            t.{action},
            t.src
          FROM {self.table} AS t
          WHERE duplicate > 1
          ORDER BY duplicate DESC, t.{action} ASC
        """):
          duplicates.setdefault(row[action], []).append(row["src"])
        for key, sources in duplicates.items():
          print(key)
          for src in sources:
            print(f"  {src}")
      case _:
        print(f"No such action '{action}'")
