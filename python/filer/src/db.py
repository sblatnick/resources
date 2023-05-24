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

        try:
          self.db["images"].insert_all([{
            "src": path,
            "dst": dst,
            "type": filetype,
            "ext": ext,
            "created": created,
            "size": size,
            "md5": md5,
          }], pk="src")
          print(f"image: {path}")
          print(f"  {dst}")
        except:
          print(f"Already scanned: {path}")
      case "video":
        ext, size, md5 = self.common_data(mime, path)
        created = timestamp(path)
        dst = image_destination(path, ext, created, "Videos")

        try:
          self.db["videos"].insert_all([{
            "src": path,
            "dst": dst,
            "type": filetype,
            "ext": ext,
            "created": created,
            "size": size,
            "md5": md5,
          }], pk="src")
          print(f"video: {path}")
          print(f"  {dst}")
        except:
          print(f"Already scanned: {path}")
      case _:
        ext, size, md5 = self.common_data(mime, path)
        created = timestamp(path)

        try:
          self.db["files"].insert_all([{
            "src": path,
            "type": filetype,
            "ext": ext,
            "created": created,
            "size": size,
            "md5": md5,
          }], pk="src")
          print(f"file ({filetype}): {path}")
        except:
          print(f"Already scanned: {path}")

  def add_list(self, table, path):
    print(f"{table}: {path}")
    try:
      self.db[table].insert_all([{
        "src": path
      }], pk="src")
    except:
      print(f"Already scanned: {path}")

  def is_done(self, base):
    try:
      return len(list(self.db.execute(f"""
        SELECT
          src
        FROM done
        WHERE src = ?
        LIMIT 1
      """, [base]))) == 1
    except:
      return False


  def query(self, sql):
    return self.db.query(sql)

  def common_data(self, mime, path):
    ext = mime.extension
    size = os.path.getsize(path)
    md5 = md5sum(path) if size < 4000000 else "file bigger than 4GB"
    return (ext, size, md5)