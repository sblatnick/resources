#!/usr/bin/env python
import os, re, sys, signal
from concurrent.futures import ThreadPoolExecutor, as_completed
from command import *
from db import *

class Scan(Command):
  where = "."
  recreate = False
  quiting = False

  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)
    self.db = DB(recreate=self.recreate)
    signal.signal(signal.SIGINT, self.interrupt_handler)
    self.root = os.getcwd()
    if not self.recreate:
      self.db.drop()
      self.db.remove_lost()
    print("Traversing files")
    with ThreadPoolExecutor(max_workers=4) as executor:
      for b, dirs, files in os.walk(self.where, topdown=True):
        futures = []
        base = b[2:]
        if self.where == "." and self.db.is_done(base):
          continue
        dirs[:] = [d for d in dirs if not self.filter(base, d)]
        files[:] = [f for f in files if not self.filter(base, f)]
        for filename in files:
          path = os.path.join(self.root,base,filename)
          futures.append(executor.submit(Scan.process, path, self.options.filetype))
          if self.quiting:
            self.finalize(futures)
            sys.exit(0)
        self.finalize(futures)
        if self.where == ".":
          self.db.add_list('done', base)

  def finalize(self, futures):
    if self.where == ".":
      action = self.db.insert
    else:
      action = self.db.process
    for future in as_completed(futures):
      table, obj = future.result()
      action(table, obj)

  @staticmethod
  def process(path, scan_filetype):
    mime = mimetype(path)
    filetype = mime.mime_type.split("/")[0]
    if scan_filetype not in [filetype, "all"]:
      return
    match filetype:
      case "image":
        from images import Images
        return Images.process(mime, path, filetype)
      case "video":
        from videos import Videos
        return Videos.process(mime, path, filetype)
      case "audio":
        from audio import Audio
        return Audio.process(mime, path, filetype)
      case _:
        from files import Files
        return Files.process(mime, path, filetype)

  def filter(self, base, folder):
    path = os.path.join(self.root, base, folder)
    if self.where == "." and base == "input":
      print(f"Filtered out 'input' folder")
      return True
    is_filer = bool(re.search(r"^\.filer", folder))
    is_repo = os.path.exists(os.path.join(path, ".git"))
    is_ignored = os.path.exists(os.path.join(path, ".ignore"))
    is_hidden = bool(re.search(r"^\.", folder))
    #print(f"{folder} is_filer: {is_filer}")
    if not is_filer:
      if is_repo:
        self.db.add_list('repos', path)
      if is_hidden:
        self.db.add_list('hidden', path)
    return (is_repo or is_hidden or is_ignored)

  def interrupt_handler(self, signum, frame):
    print(f'Handling signal {signum} ({signal.Signals(signum).name}).')
    #quit cleanly:
    self.quiting = True

