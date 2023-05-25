#!/usr/bin/env python
import os, shutil, time, re, puremagic, exifread, hashlib, datetime

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
  try:
    obj = puremagic.magic_file(path)
  except:
    obj = []
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

def copy(src, dst):
  dst = f"../organized/{dst}"
  if os.path.exists(dst):
    ss = os.path.getsize(src)
    ds = os.path.getsize(dst)
    if ss <= ds:
      print(f"Skipping: {src} {dst}")
      return
    else:
      print(f"Overwriting: {src} {dst}")
  else:
    print(src)
    print(f"  {dst}")
  os.makedirs(os.path.dirname(dst), exist_ok=True)
  shutil.copy2(src, dst)

def common_data(mime, path):
  ext = mime.extension
  size = os.path.getsize(path)
  md5 = md5sum(path) if size < 4000000 else "file bigger than 4GB"
  return (ext, size, md5)

class Obj(object):
  pass

class Common(object):
  src = None
  dst = None
  filetype = None
  ext = None
  created = None
  size = None
  md5 = None
