#!/usr/bin/env python
import os, re, sqlite_utils
from util import *

class DB():
  def __init__(self, recreate=False):
    db_file = os.path.expanduser("~/.filer.db")
    self.db = sqlite_utils.Database(db_file,recreate=recreate)

  def add(self, path, scan_filetype):
    mime = mimetype(path)
    filetype = mime.mime_type.split("/")[0]

    if scan_filetype not in [filetype, "all"]:
      return

    match filetype:
      case "image":
        ext, size, md5 = self.common_data(mime, path)
        metadata = exif(path)
        created = str(metadata.get(
          "EXIF DateTimeOriginal",
          timestamp(path)
        ))
        if re.search(r"^\d\d\d\d:\d\d:\d\d ", created):
          created = re.sub(":", "-", created, 2)
        dst = image_destination(path, ext, created)
        print(f"  {dst}")

        self.db["images"].insert_all([{
          "src": path,
          "dst": dst,
          "type": filetype,
          "ext": ext,
          "created": created,
          "size": size,
          "md5": md5,
        }])
      case _:
        ext, size, md5 = self.common_data(path)
        created = timestamp(path)

        self.db["files"].insert_all([{
          "src": path,
          "type": filetype,
          "ext": ext,
          "created": created,
          "size": size,
          "md5": md5,
        }])

  def add_list(self, table, path):
    self.db[table].insert_all([{
      "src": path
    }])

  def query(self, sql):
    return self.db.query(sql)

  def common_data(self, mime, path):
    print(path)
    ext = mime.extension
    size = os.path.getsize(path)
    md5 = md5sum(path) if size < 4000000 else "file bigger than 4GB"
    return (ext, size, md5)