#!/usr/bin/env python
import os, argparse, re, sqlite_utils
from src.util import *
from src.command import *

class DB(Command):
  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)
    action = self.options.arg
    db_file = os.path.expanduser("~/.filer.db")
    self.db = sqlite_utils.Database(db_file)
    root = os.getcwd()
    match action:
      case "init" | "create":
        print("traversing all files")
        for base, _, files in os.walk("."):
          for filename in files:
            self.add(os.path.join(root,base[2:],filename))
      case "images" | "files":
        for row in self.db.query(f"SELECT * FROM {action}"):
          print(row)
      case "clean":
        os.remove(db_file)
      case _:
        print(f"No such action: {action}")

  def add(self, path):
    print(path)
    mime = mimetype(path)
    ext = mime.extension
    filetype = mime.mime_type.split("/")[0]
    size = os.path.getsize(path)
    md5 = md5sum(path)

    match filetype:
      case "image":
        metadata = exif(path)

        created = str(metadata.get(
          "EXIF DateTimeOriginal",
          timestamp(path)
        ))
        if re.search(r"^\d\d\d\d:\d\d:\d\d ", created):
          created = re.sub(":", "-", created, 2)
        #print(f"  {created}")

        self.db["images"].insert_all([{
          "src": path,
          "type": filetype,
          "ext": ext,
          "created": created,
          "size": size,
          "md5": md5,
        }])
      case _:
        created = timestamp(path)
        self.db["files"].insert_all([{
          "src": path,
          "type": filetype,
          "ext": ext,
          "created": created,
          "size": size,
          "md5": md5,
        }])

