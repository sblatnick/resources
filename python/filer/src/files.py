#!/usr/bin/env python
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
        for row in self.db.query(f"SELECT * FROM {self.table}"):
          print(row)
      case "distinct":
        for row in self.db.query(f"""
          SELECT
            ext,
            COUNT(ext) AS count
          FROM {self.table}
          GROUP BY ext
          ORDER BY count DESC
        """):
          print(f"{row['count']: >4} {row['ext']}")
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