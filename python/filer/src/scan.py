#!/usr/bin/env python
import os, argparse, re
from command import *
from db import *

class Scan(Command):
  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)
    db = DB(recreate=True)
    root = os.getcwd()
    print("Traversing all files")
    for base, _, files in os.walk("."):
      for filename in files:
        db.add(os.path.join(root,base[2:],filename))
