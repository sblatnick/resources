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

#trace system calls and signals
strace
  -f
  -o

  -c   #count
  -C   #count at end with normal output

  -D   #detached grandchild, reducing strace's process output
  -d   #strace debugging output
  -f   #follow children processes (-F obsoleted)
  -ff  #with -o filename, writes to filename.pid, incompatible with -c counts


  -h   #help

  -i   #print instruction pointer at the time of the system call

  -k   #print execution stack trace of the traced processes after each system call (experimental, built with libunwind)
  -q   #quiet attaching/detaching messages from stdout
  -qq  #suppress messages about process exit status

  -r   #relative timestamp or delta time between system calls
  -t   #prefix time

  -tt  #include microseconds

  -ttt #include microseconds and seconds since epoch

  -T   #time taken on system call
  -w   #summarise time taken between on system call

  -v   #verbose env, stat, etc
  -V   #version

  -x   #print non-ASCII in hex
  -xx  #print in hex

  -y   #print paths with file descriptors

  -yy  #print protocol specific information associated with socket file descriptors.

  -a column   #align return values in a specific column (default column 40).

  -b syscall #detach from traced process upon syscall, only "execve" is supported, for avoiding complex children processes

  -e expr    #events to trace by expression: [qualifier=][\!]value1[,value2]...

  -e trace=set #what calls to trace (-e trace=open,close,read,write, default: -e trace=all)
  -e trace=file #trace  all  system  calls which take a file name as an argument. (-e trace=open,stat,chmod,unlink,lsstat,...)
  -e trace=process #trace process management like fork, wait, and exec steps
  -e trace=network
  -e trace=signal
  -e trace=ipc
  -e trace=desc #file descriptor
  -e trace=memory #memory mapping

  -e abbrev=set #abbreviate members of large structures (-v means abbrev=none, default: abbrev=all)
             
  -e verbose=set
             Dereference structures for the specified set of system calls.  The default is verbose=all.

  -e raw=set #raw, undecoded (in hex) arguments for the specified set of system calls

  -e signal=set #trace only subset of signals (example: "signal=\!io", default: signal=all)


  -e read=set #full hexadecimal and ASCII dump of data read from file descripters (-e read=3,5)

  -e write=set #full hexadecimal and ASCII dump of data written to file descripters (-e read=3,5)

  -I interruptible
             When strace can be interrupted by signals (such as pressing ^C).  1: no signals are blocked; 2: fatal signals are blocked while decoding syscall (default);  3:  fatal
             signals are always blocked (default if '-o FILE PROG'); 4: fatal signals and SIGTSTP (^Z) are always blocked (useful to make strace -o FILE PROG not stop on ^Z).
  -o filename Write the trace output to the file filename rather than to stderr.  Use filename.pid if -ff is used.  If the argument begins with '|' or with '!' then the rest of the
             argument is treated as a command and all output is piped to it.  This is convenient for piping the debugging output to a program without affecting the redirections of
             executed programs.
  -O overhead Set  the  overhead for tracing system calls to overhead microseconds.  This is useful for overriding the default heuristic for guessing how much time is spent in mere
              measuring when timing system calls using the -c option.  The accuracy of the heuristic can be gauged by timing a given program run without tracing (using time(1)) and
              comparing the accumulated system call time to the total produced using -c.
  -p pid #-p "`pidof PROG`"
  -P path     Trace only system calls accessing path.  Multiple -P options can be used to specify several paths.
  -s strsize  Specify the maximum string size to print (the default is 32).  Note that filenames are not considered strings and are always printed in full.
  -S sortby   Sort the output of the histogram printed by the -c option by the specified criterion.  Legal values are time, calls, name, and nothing (default is time).
  -u username Run  command  with  the user ID, group ID, and supplementary groups of username.  This option is only useful when running as root and enables the correct execution of
             setuid and/or setgid binaries.  Unless this option is used setuid and setgid programs are executed without effective privileges.
  -E var=val  Run command with var=val in its list of environment variables.
  -E var      Remove var from the inherited list of environment variables before passing it on to the command.
       


