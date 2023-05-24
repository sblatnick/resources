#!/usr/bin/env python
import os, re
from scan import *

class Rescan(Scan):
  recreate = True

  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)
