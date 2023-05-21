#!/usr/bin/env python
import argparse

class Command(argparse.Action):
  def __init__(self, option_strings=None, dest=None):
    self.options = option_strings
