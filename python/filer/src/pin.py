#!/usr/bin/env python
from scan import *

class Pin(Scan):
  recreate = False
  action = "pin"

  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)
