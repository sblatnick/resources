#!/usr/bin/env python
import os
from files import *

class Images(Files):
  table = 'images'

  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)

