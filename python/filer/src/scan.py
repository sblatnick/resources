#!/usr/bin/env python
import os, re, sys, signal
from concurrent.futures import ThreadPoolExecutor, as_completed
from command import *
from db import *

class Scan(Command):
  where = "."
  recreate = False
  quiting = False
  existing = []
  types = ["image", "video", "audio"]

  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)
    self.db = DB(recreate=self.recreate)
    signal.signal(signal.SIGINT, self.interrupt_handler)
    self.root = os.getcwd()
    if not self.recreate:
      self.db.remove_lost()
    print("Traversing files")
    with ThreadPoolExecutor(max_workers=4) as executor:
      for b, dirs, files in os.walk(self.where, topdown=True):
        futures = []
        base = b[2:]
        dirs[:] = [d for d in dirs if not self.filter(base, d)]
        files[:] = [f for f in files if not self.filter(base, f)]
        for filename in files:
          path = os.path.join(self.root,base,filename)
          mime = mimetype(path)
          table = mime.mime_type.split("/")[0]
          if table not in self.types:
            table = "file"
          if self.options.filetype not in [table, "all", None]:
            continue
          obj = None
          try:
            obj = self.db.db[table].get(path)
          except:
            pass
          if obj != None:
            self.existing.append((table, rowToObj(obj)))
            continue
          futures.append(executor.submit(Scan.process, path, mime))
          if self.quiting:
            self.finalize(futures)
            sys.exit(0)
        self.finalize(futures)


  def finalize(self, futures):
    for (table, obj) in self.existing:
      self.db.act(self.options.action, table, obj)
    for future in as_completed(futures):
      table, obj = future.result()
      self.db.act(self.options.action, table, obj)

  @staticmethod
  def process(path, mime):
    filetype = mime.mime_type.split("/")[0]
    match filetype:
      case "image":
        from images import Images
        return Images.process(path, mime)
      case "video":
        from videos import Videos
        return Videos.process(path, mime)
      case "audio":
        from audio import Audio
        return Audio.process(path, mime)
      case _:
        from files import Files
        return Files.process(path, mime)

  def filter(self, base, folder):
    path = os.path.join(self.root, base, folder)
    is_filer = bool(re.search(r"^\.filer", folder))
    is_repo = os.path.exists(os.path.join(path, ".git"))
    is_ignored = os.path.exists(os.path.join(path, ".ignore"))
    is_hidden = bool(re.search(r"^\.", folder))
    #print(f"{folder} is_filer: {is_filer}")
    if not is_filer:
      if is_repo:
        self.db.add_list('repos', path, os.path.join(self.root, 'Repositories', folder))
      if is_hidden:
        self.db.add_list('hidden', path, os.path.join(self.root, 'Hidden', folder))
    return (is_repo or is_hidden or is_ignored)

  def interrupt_handler(self, signum, frame):
    print(f'Handling signal {signum} ({signal.Signals(signum).name}).')
    #quit cleanly:
    self.quiting = True

