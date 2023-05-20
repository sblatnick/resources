#!/usr/bin/env python
import os, time, json, argparse, subprocess, re, sqlite_utils, puremagic, exifread, hashlib
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
    size = os.path.getsize(path)
    md5 = self.md5sum(path)

    match filetype:
      case "image":
        metadata = self.exif(path)

        created = str(metadata.get(
          "EXIF DateTimeOriginal",
          self.created(path)
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
        created = self.created(path)
        self.db["files"].insert_all([{
          "src": path,
          "type": filetype,
          "ext": ext,
          "created": created,
          "size": size,
          "md5": md5,
        }])

  def exif(self, path):
    with open(path, "rb") as fh:
      tags = exifread.process_file(fh, details=False)
      #for tag in tags.keys():
      #  print(f"  '{tag}' = 'tags[tag]'")
      return tags

  def md5sum(self, path):
    with open(path, "rb") as fh:
      md5 = hashlib.md5(fh.read()).hexdigest()
      return md5

  def created(self, path):
    #use modified time in case it is using when it was copied:
    return time.strftime(
      "%Y-%m-%d %H:%M:%S",
      time.strptime(time.ctime(os.path.getmtime(path)))
    )
