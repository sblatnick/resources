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

tic = time.perf_counter()

parser = argparse.ArgumentParser(
  prog='filer',
  usage='%(prog)s [command]',
)

commands = parser.add_subparsers()

#Common:
def add_command(name, obj):
  subparser = commands.add_parser(
    name,
    help='Print all {name} data'
  )
  subparser.set_defaults(func=obj)
  subparser.add_argument("action", nargs='?', default='list')

#Actions:
scan = commands.add_parser(
  'scan',
  help='Traverse the filesystem from the current directory and create the database.'
)
scan.set_defaults(func=Scan)
scan.add_argument("filetype", nargs='?', default='all')

rescan = commands.add_parser(
  'rescan',
  help='Scan with new database tables.'
)
rescan.set_defaults(func=Rescan)
rescan.add_argument("filetype", nargs='?', default='all')

add_command("images", Images)
add_command("videos", Videos)
add_command("audio", Audio)
add_command("repos", Repos)
add_command("hidden", Hidden)
add_command("files", Files)

#Args processed:
args = parser.parse_args()
if hasattr(args, 'func'):
  args.func(args, None)
else:
  parser.print_help()

toc = time.perf_counter()
print(f"Execution Time: {toc - tic:0.4f} seconds")
