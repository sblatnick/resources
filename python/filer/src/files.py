#!/usr/bin/env python
import shutil
from command import *
from db import *

class Files(Command):
  table = 'files'

  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)
    action = self.options.action
    self.db = DB()
    match action:
      case "list":
        for row in db.query(f"SELECT * FROM {self.table}"):
          print(row)
      case "md5" | "dst":
        duplicates = self.find_duplicates(action)
        for key, sources in duplicates.items():
          print(key)
          for src in sources:
            print(f"  {src}")
      case "copy":
        duplicates = self.find_duplicates("dst", "")
        for dst, sources in duplicates.items():
          print(sources[0])
          print(f"  {dst}")
          #shutil.copy2(sources[0], dst)
      case _:
        print(f"No such action '{action}'")

  def find_duplicates(self, column, condition = 'WHERE duplicate > 1'):
    duplicates = {}
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
    return duplicates