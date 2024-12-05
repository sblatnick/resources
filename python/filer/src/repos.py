#!/usr/bin/env python
from folders import *

class Repos(Folders):
  table = 'repo'

  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)


