#!/usr/bin/env python
import os, time, json, subprocess, re, sqlite_utils, puremagic, exifread, hashlib

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
  return puremagic.magic_file(path)[0]

