#!/usr/bin/env python
from scan import *

class Rescan(Scan):
  where = "."
  action = "rescan"
  recreate = True

  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)
