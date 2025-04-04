#!/usr/bin/env python
import os, exifread
from files import *
from util import *

class Images(Files):
  table = 'image'

  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)

  @staticmethod
  def process(path, mime):
    filetype = mime.mime_type.split("/")[0]
    obj = Common()
    obj.src = path
    obj.filetype = filetype
    obj.ext, obj.size, obj.md5 = common_data(mime, path)
    metadata = Images.exif(path)
    obj.created = str(metadata.get(
      "EXIF DateTimeOriginal",
      timestamp(path)
    ))
    if re.search(r"^\d\d\d\d:\d\d:\d\d ", obj.created):
      obj.created = re.sub(":", "-", obj.created, 2)
    obj.dst = Images.destination(obj.src, obj.ext, obj.created)
    return (Images.table, obj)

  @staticmethod
  def destination(path, ext, dt, base = "Pictures"):
    filename = re.search("/?([^/.]*)\.?[^/]*$", path).groups()[0]
    #Remove date from filename if already present:
    filename = re.sub(r" ?\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d ?", "", filename)
    match ext:
      case ".heif":
        ext = ".heic"
      case ".png":
        base = "Images"
    #print(f"dt: {dt}")
    try:
      obj = datetime.datetime.strptime(dt, "%Y-%m-%d %H:%M:%S")
    except:
      #Invalid exif date, so use timestamp instead:
      obj = datetime.datetime.strptime(timestamp(path), "%Y-%m-%d %H:%M:%S")
    return obj.strftime(f"{base}/%Y/%m - %b/%Y-%m-%d %H:%M:%S {filename}{ext}")

  @staticmethod
  def exif(path):
    with open(path, "rb") as fh:
      try:
        tags = exifread.process_file(fh, details=False)
        #for tag in tags.keys():
        #  print(f"  '{tag}' = '{tags[tag]}'")
        return tags
      except:
        #no exif data
        return {}
