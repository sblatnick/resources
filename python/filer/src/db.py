#!/usr/bin/env python
import os, json, argparse, subprocess, re, sqlite_utils, puremagic, exifread
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
    mime = puremagic.magic_file(path)[0]
    ext = mime.extension
    filetype = mime.mime_type.split("/")[0]

    match filetype:
      case "image":
        metadata = self.exif(path)
        created = metadata["EXIF DateTimeOriginal"]
        print(created)
        self.db["images"].insert_all([{
          "src": path,
          "type": filetype,
          "ext": ext,
          "created": str(created)
        }])
      case _:
        self.db["files"].insert_all([{
          "src": path,
          "type": filetype,
          "ext": ext,
        }])

  def exif(self, path):
    with open(path, "rb") as fh:
      tags = exifread.process_file(fh, details=False)
      #print(path)
      #for tag in tags.keys():
      #  print(f"  '{tag}' = 'tags[tag]'")
      return tags

