#!/usr/bin/env python
import os
from files import *
from util import *

class Audio(Files):
  table = 'audio'

  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)

  @staticmethod
  def add(db, mime, path, filetype):
    obj = Common()
    obj.src = path
    obj.filetype = filetype
    obj.ext, obj.size, obj.md5 = common_data(mime, path)
    obj.created = timestamp(path)
    obj.dst = Audio.destination(obj.src, obj.ext)
    db.insert(Audio.table, obj)

  @staticmethod
  def destination(path, ext):
    match ext:
      case ".mp3" | ".wma":
        base = "Music"
      case _:
        base = "Audio"
    #FIXME:
    return f"{base}/"

