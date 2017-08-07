#!/bin/bash

#::::::::::::::::::::GDB::::::::::::::::::::

  gdm binary
  #or after loading gdm:
  file binary

  break main #setup a breakpoint on main
  run

  #show other panels for following execution
  layout asm
  layout next
  layout split

  #change current position in code execution:
  set $pc = 0x400ee9


#::::::::::::::::::::UTILS::::::::::::::::::::
  #Get object information:
  readelf --symbols binary
  objdump -d binary | less