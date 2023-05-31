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

def act(action, src, dst, md5, ext):
  if not os.path.exists(src):
    print(f"Missing source: {src}")
    return
  dst = f"../organized/{dst}"
  base = dst[:-len(ext)] #base = re.search(r"^.*\.", dst).group(0)
  num = 1
  while os.path.exists(dst):
    if md5 == md5sum(dst):
      print(f"Skipping already present: '{src}' at '{dst}'")
      return
    num = num + 1
    dst = f"{base} {num}{ext}"

  print(src)
  print(f"  {dst}")
  os.makedirs(os.path.dirname(dst), exist_ok=True)
  match action:
    case "copy":
      shutil.copy2(src, dst)
    case "move":
      shutil.move(src, dst)

def common_data(mime, path):
  ext = mime.extension
  size = os.path.getsize(path)
  md5 = md5sum(path) if size < 1000000000 else "file bigger than 1GB"
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
