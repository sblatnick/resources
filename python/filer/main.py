#!/usr/bin/env python
import sys, argparse, time
from src.db import *

tic = time.perf_counter()

parser = argparse.ArgumentParser(
  prog='filer',
  usage='%(prog)s [options] [command]',
)
parser.add_argument(
  '--dry',
  action='store_true',
  help="Description here"
)

commands = parser.add_subparsers()

#Actions:
db = commands.add_parser(
  'db',
  help='Database actions'
)
db.set_defaults(func=DB)

#Action options:
db.add_argument(
  '--dry',
  action='store_true',
  help="Dry Run"
)

#Args processed:
args = parser.parse_args()
if hasattr(args, 'func'):
  args.func(args, None)
else:
  parser.print_help()

toc = time.perf_counter()
print(f"Execution Time: {toc - tic:0.4f} seconds")
