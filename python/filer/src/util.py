#!/usr/bin/env python
import os, shutil, time, re, puremagic, exifread, hashlib, datetime

def exif(path):
  #print(f"exif: {path}")
  with open(path, "rb") as fh:
    tags = exifread.process_file(fh, details=False)
    #for tag in tags.keys():
    #  print(f"  '{tag}' = '{tags[tag]}'")
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

def image_destination(path, ext, dt, base = "Pictures"):
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

class Obj(object):
  pass