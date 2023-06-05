#!/usr/bin/env python
import sys, argparse, time
from src.scan import *
from src.rescan import *
from src.images import *
from src.audio import *
from src.videos import *
from src.repos import *
from src.hidden import *
from src.files import *
from src.tables import *
from src.organize import *

tic = time.perf_counter()

parser = argparse.ArgumentParser(
  prog='filer',
  usage='%(prog)s [command]',
)

commands = parser.add_subparsers()

#Common:
def add_command(name, obj, arg="action", default="list", help="list (default) | ext | md5|dst | copy|move|dry | org"):
  subparser = commands.add_parser(
    name,
    help=help
  )
  subparser.set_defaults(func=obj)
  subparser.add_argument(arg, nargs='?', default=default)

#Actions:
add_command(
  "scan", Scan,
  arg="filetype", default="all",
  help="Traverse the filesystem from the current directory and create the database."
)
add_command(
  "rescan", Rescan,
  arg="filetype", default="all",
  help="Scan with new database tables."
)
add_command(
  "org", Organize,
  arg="filetype", default="all",
  help="Process 'input' folder for new files."
)

add_command("images", Images)
add_command("videos", Videos)
add_command("audio", Audio)
add_command("repos", Repos)
add_command("hidden", Hidden)
add_command("files", Files)
add_command("tables", Tables, help="Show list of tables")


#Args processed:
args = parser.parse_args()
if hasattr(args, 'func'):
  args.func(args, None)
else:
  parser.print_help()

toc = time.perf_counter()
print(f"Execution Time: {toc - tic:0.4f} seconds")
