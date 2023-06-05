#!/usr/bin/env python
import os
from command import *
from db import *

class Tables(Command):

  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)
    action = self.options.action
    self.db = DB()
    for table in self.db.db.table_names():
      print(table)
