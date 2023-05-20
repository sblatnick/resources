#!/usr/bin/env python
import os, argparse, re, sqlite_utils
from util import *

class DB():
  def __init__(self, recreate=False):
    db_file = os.path.expanduser("~/.filer.db")
    self.db = sqlite_utils.Database(db_file,recreate=recreate)

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

  def query(self, sql):
    return self.db.query(sql)
