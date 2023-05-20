#!/usr/bin/env python
import sys, argparse, time
from src.scan import *
from src.images import *
from src.files import *

tic = time.perf_counter()

parser = argparse.ArgumentParser(
  prog='filer',
  usage='%(prog)s [command]',
)

commands = parser.add_subparsers()

#Actions:
scan = commands.add_parser(
  'scan',
  help='Traverse the filesystem from the current directory and create the database.'
)
scan.set_defaults(func=Scan)

images = commands.add_parser(
  'images',
  help='Print all image data'
)
images.set_defaults(func=Images)
images.add_argument("action", nargs='?', default='list')

files = commands.add_parser(
  'files',
  help='Print all file data'
)
files.set_defaults(func=Files)
files.add_argument("action", nargs='?', default='list')

#Args processed:
args = parser.parse_args()
if hasattr(args, 'func'):
  args.func(args, None)
else:
  parser.print_help()

toc = time.perf_counter()
print(f"Execution Time: {toc - tic:0.4f} seconds")
