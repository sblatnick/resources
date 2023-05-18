#!/usr/bin/env python
import os, json, argparse, subprocess, re, exifread
from src.command import *

class Exif(Command):
  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)
    with open(self.options.file, "rb") as fh:
      tags = exifread.process_file(fh, details=False)
      for tag in tags.keys():
        print("Key: %s, value %s" % (tag, tags[tag]))
      #HEIC fix: https://github.com/hpoul/exif-py/commit/41f9641932d5d8d5bb041d903f3061817ee7ae5c
