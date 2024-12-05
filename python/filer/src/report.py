#!/usr/bin/env python
import os, re, sys, signal
import inc.pyratemp as pyratemp
from concurrent.futures import ThreadPoolExecutor, as_completed
from command import *
from db import *

class Report(Command):
  tables = ["images", "videos", "audio", "files", "repos", "hidden"]
  defaults = {
    "count" : 0,
    "placed" : 0
  }

  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)
    self.db = DB(recreate=False)
    
    totals = {}
    for table in self.tables: #self.db.db.table_names():
      totals.setdefault(table, self.defaults)
      if self.db.db[table].exists():
        dst_dups = self.db.find_duplicates(table, "dst")
        md5_dups = self.db.find_duplicates(table, "md5")

        totals[table] = {
          "count" : self.db.db[table].count,
          "placed" : self.db.db[table].count_where("src = dst"),
          "dst dups" : "%s destination of %s files" % (len(dst_dups.keys()), sum(len(files) for files in dst_dups.values())),
          "md5 dups" : "%s md5sum of %s files" % (len(md5_dups.keys()), sum(len(files) for files in md5_dups.values()))
        }

    totals = {k: v for k, v in sorted(totals.items(), key=lambda item: item[1]["count"], reverse=True)}

    chart = {}
    most = max(totals.values(), key=lambda table : table["count"])["count"]
    for table, counts in totals.items():
      count = counts["count"]
      for i in range(10):
        chart.setdefault(
          table, [True]
        ).append(count > i / 10 * most)
      chart[table].reverse()

    src = os.sep.join(os.path.dirname(os.path.realpath(__file__)).split("/")[:-1])
    template = pyratemp.Template(filename=os.path.join(src, "template/log.tpl"))
    result = template(
      fg={
        "images" : 31,
        "audio" : 32,
        "hidden" : 33,
        "files" : 34,
        "videos" : 35,
        "folders" : 36,
        "repos" : 31
      },
      bg={
        "images" : 41,
        "audio" : 42,
        "hidden" : 43,
        "files" : 44,
        "videos" : 45,
        "folders" : 46,
        "repos" : 41
      },
      totals=totals,
      chart=chart,
      most=most
    )

    log = open("/dev/stdout", "w")
    log.write(result)
    log.close()




