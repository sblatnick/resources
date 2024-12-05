#!/usr/bin/env python
import os, time, re, puremagic, hashlib, datetime, logging

logging.basicConfig(level=logging.ERROR)

def md5sum(path, size):
  limit = 40_000_000
  with open(path, "rb") as fh:
    if size > limit:
      md5 = hashlib.md5(fh.read(limit) + bytes(size)).hexdigest()
    else:
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
    if obj[0].extension == ".xxx":
      return fake_magic(path)
    return obj[0]
  else:
    return fake_magic(path)

def fake_magic(path):
  obj = Obj()
  m = re.search(r"\.[^/]*$", path)
  if m is None:
    ext = "none"
  else:
    ext = m.group(0)
  setattr(obj, "extension", ext)
  setattr(obj, "mime_type", "unknown")
  return obj

def common_data(mime, path):
  ext = mime.extension
  size = os.path.getsize(path)
  md5 = md5sum(path, size)
  return (ext, size, md5)

def rowToObj(row):
  o = Common()
  print(row)
  for k, v in row.items():
    setattr(o, k, v)
  return o

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
