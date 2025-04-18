#!/usr/bin/env python
import os
from files import *
from images import *
from util import *

class Videos(Files):
  table = 'video'

  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)

  @staticmethod
  def process(path, mime):
    filetype = mime.mime_type.split("/")[0]
    obj = Common()
    obj.src = path
    obj.filetype = filetype
    obj.ext, obj.size, obj.md5 = common_data(mime, path)
    obj.created = timestamp(path)
    obj.dst = Images.destination(obj.src, obj.ext, obj.created, "Videos")
    return (Videos.table, obj)
