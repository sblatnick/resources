#!/usr/bin/env python
from scan import *

class Unpin(Scan):
  recreate = False
  action = "unpin"

  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)

