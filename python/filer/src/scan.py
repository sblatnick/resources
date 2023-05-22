#!/usr/bin/env python
import os, re
from command import *
from db import *

class Scan(Command):
  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)
    self.db = DB() #DB(recreate=True)
    root = os.getcwd()
    print("Traversing files")
    for b, dirs, files in os.walk(".", topdown=True):
      base = b[2:]
      done = self.db.is_done(base)
      print(f"'{base}' done: {done}")
      if self.db.is_done(base):
        continue
      dirs[:] = [d for d in dirs if not self.filter(root, base, d)]
      for filename in files:
        self.db.add(os.path.join(root,base,filename), self.options.filetype)
      self.db.add_list('done', base)

  def filter(self, root, base, folder):
    path = os.path.join(root, base, folder)
    is_repo = os.path.exists(os.path.join(path, ".git"))
    is_hidden = bool(re.search(r"^\.", folder))
    if is_repo:
      self.db.add_list('repos', path)
    if is_hidden:
      self.db.add_list('hidden', path)
    return (is_repo or is_hidden)