#!/usr/bin/env python
import sys, argparse, time
from src.db import *

tic = time.perf_counter()

parser = argparse.ArgumentParser(
  prog='filer',
  usage='%(prog)s [command]',
)

commands = parser.add_subparsers()

#Actions:
db = commands.add_parser(
  'db',
  help='Database actions'
)
db.set_defaults(func=DB)
db.add_argument("arg")

#Args processed:
args = parser.parse_args()
if hasattr(args, 'func'):
  args.func(args, None)
else:
  parser.print_help()

toc = time.perf_counter()
print(f"Execution Time: {toc - tic:0.4f} seconds")
