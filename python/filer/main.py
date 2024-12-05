#!/usr/bin/env python
from signal import signal, SIGPIPE, SIG_DFL  
signal(SIGPIPE,SIG_DFL) 

import sys, argparse, time
from src.scan import *
from src.rescan import *
from src.organize import *
from src.pin import *
from src.unpin import *

from src.images import *
from src.audio import *
from src.videos import *
from src.repos import *
from src.hidden import *
from src.files import *

from src.tables import *
from src.report import *

tic = time.perf_counter()

parser = argparse.ArgumentParser(
  prog='filer',
  usage='%(prog)s [command]',
)

commands = parser.add_subparsers(title="actions", metavar="")
options = ["action", "filetype"]

#Common:
def add_command(name, obj, arg="action", default="list", help="list (default) | ext | md5|dst | copy|move|dry"):
  subparser = commands.add_parser(
    name,
    help=help
  )
  subparser.set_defaults(func=obj)
  subparser.add_argument(arg, nargs='?', default=default)
  for opt in [opt for opt in options if opt != arg]:
    subparser.add_argument(opt, nargs='?')

#Actions:
add_command(
  "scan", Scan,
  arg="filetype", default="all",
  help="all (default) | images|videos|audio = Update table(s) to current"
)
add_command(
  "rescan", Rescan,
  arg="filetype", default="all",
  help="all (default) | images|videos|audio = Recreate table(s) from scratch"
)
add_command(
  "org", Organize,
  arg="action", default="dry",
  help="dry (default) | copy | move"
)
add_command(
  "pin", Pin,
  arg="path", default=None,
  help="Mark file(s) in path as correct."
)
add_command(
  "unpin", Unpin,
  arg="path", default=None,
  help="Remove marked file(s) in path as correct."
)

add_command("images", Images)
add_command("videos", Videos)
add_command("audio", Audio)
add_command("files", Files)
add_command("repos", Repos, help="list (default) | dst | copy|move|dry")
add_command("hidden", Hidden, help="list (default) | dst | copy|move|dry")

add_command("tables", Tables, help="Show list of tables")
add_command("report", Report, help="Show Details about the tables")



#Args processed:
args = parser.parse_args()
if hasattr(args, 'func'):
  args.func(args, None)
else:
  parser.print_help()

toc = time.perf_counter()
print(f"Execution Time: {toc - tic:0.4f} seconds")
