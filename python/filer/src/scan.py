#!/usr/bin/env python
import os, re, sys, signal
from command import *
from db import *

class Scan(Command):
  recreate = False
  quiting = False

  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)
    self.db = DB(recreate=self.recreate)
    signal.signal(signal.SIGINT, self.interrupt_handler)
    self.root = os.getcwd()
    print("Traversing files")
    for b, dirs, files in os.walk(".", topdown=True):
      base = b[2:]
      if self.db.is_done(base):
        continue
      dirs[:] = [d for d in dirs if not self.filter(base, d)]
      for filename in files:
        path = os.path.join(self.root,base,filename)
        self.db.add(path, self.options.filetype)
        if self.quiting:
          sys.exit(0)
      self.db.add_list('done', base)

  def filter(self, base, folder):
    path = os.path.join(self.root, base, folder)
    is_repo = os.path.exists(os.path.join(path, ".git"))
    is_hidden = bool(re.search(r"^\.", folder))
    if is_repo:
      self.db.add_list('repos', path)
    if is_hidden:
      self.db.add_list('hidden', path)
    return (is_repo or is_hidden)

  def interrupt_handler(self, signum, frame):
    print(f'Handling signal {signum} ({signal.Signals(signum).name}).')
    #quit cleanly:
    self.quiting = True