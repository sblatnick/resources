#!/usr/bin/env python
import os, shutil, time, re, puremagic, exifread, hashlib, datetime

def exif(path):
  with open(path, "rb") as fh:
    tags = exifread.process_file(fh, details=False)
    #for tag in tags.keys():
    #  print(f"  '{tag}' = 'tags[tag]'")
    return tags

def md5sum(path):
  with open(path, "rb") as fh:
    md5 = hashlib.md5(fh.read()).hexdigest()
    return md5

def timestamp(path):
  #use modified time in case it is using when it was copied:
  return time.strftime(
    "%Y-%m-%d %H:%M:%S",
    time.strptime(time.ctime(os.path.getmtime(path)))
  )

def mimetype(path):
  obj = puremagic.magic_file(path)
  if 0 < len(obj):
    return obj[0]
  else:
    obj = Obj()
    m = re.search(r"\.[^/]*$", path)
    if m is None:
      ext = "none"
    else:
      ext = m.group(0)
    setattr(obj, "extension", ext)
    setattr(obj, "mime_type", "unknown")
    return obj

def image_destination(path, ext, dt):
  filename = re.search("/([^/.]*)\.[^/]*$", path).groups()[0]
  obj = datetime.datetime.strptime(dt, "%Y-%m-%d %H:%M:%S")
  if ext == ".heif":
    ext = ".heic"
  return obj.strftime(f"Pictures/%Y/%m - %b/%Y-%m-%d %H:%M:%S {filename}{ext}")

def copy(src, dst):
  dst = f"../organized/{dst}"
  if os.path.exists(dst):
    print(f"Exists: {src} {dst}")
  else:
    print(src)
    print(f"  {dst}")
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    shutil.copy2(src, dst)

class Obj(object):
  pass