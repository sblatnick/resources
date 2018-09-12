#!/bin/bash

#::::::::::::::::::::GDB::::::::::::::::::::

#Debug C program:
g++ -g program.cpp -o program
gdb ./program

#Tutorial: https://cs.baylor.edu/~donahoo/tools/gdb/tutorial.html

#::::::::::::::::::::STRACE::::::::::::::::::::

#Shows system calls:
strace ./program
strace -o debug.log ./program