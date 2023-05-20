#!/usr/bin/env python
import os, argparse, re
from command import *
from db import *

class Images(Command):
  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)
    action = self.options.action
    db = DB()
    match action:
      case "list":
        for row in db.query(f"SELECT * FROM images"):
          print(row)
      case _:
        print(f"No such action '{action}'")