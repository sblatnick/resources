#!/usr/bin/env python
import os, json, argparse, subprocess, re
from src.command import *

class DB(Command):
  def __init__(self, option_strings=None, dest=None):
    super().__init__(option_strings, dest)
    print(f"DB init")