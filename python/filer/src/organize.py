#!/usr/bin/env python
from scan import *

class Organize(Scan):
  recreate = False
  action = "organize"

  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)
