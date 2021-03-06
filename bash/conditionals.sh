#!/bin/bash

#::::::::::::::::::::CONDITIONALS::::::::::::::::::::

#IF/ELIF/ELSE:
  string=0
  if [ "$string" -lt 0 ]; then
    echo "negative"
  elif [ "$string" -gt 0 ]; then
    echo "positive"
  else
    echo "0"
  fi
  
  if [[ $a -eq 24 && $b -eq 24 ]]; then
  if [[ "${a}" == "txt1" ]] || [ "$a" = "txt2" ] || [ "$b" -eq 47 ] || [ -n "$c" ]; then

  #check file exists in each directory:
  if ls {$RPM_DIR,$SRPM_DIR}/* >/dev/null 2>&1;then echo yes; else echo no; fi

#CASE
  case $f in
    hello)
        echo English
        #final:
      ;;
    "guten tag")
        echo German
        #bash 4.0: continue with additional tests (non-POSIX)
      ;;&
    "blah")
        echo Jibberish
        #bash 4.0: fall-through next case (non-POSIX)
      ;&
      #source: https://unix.stackexchange.com/questions/75354/can-bash-case-statements-cascade
    this|that)
        echo Rambling
      ;;
    *)
        echo Unknown Language: $f
      ;;
  esac

#STRING COMPARISON:
#  1 operand:
#     -n        operand non zero length
#     -z        operand has zero length
#  2 operands:
#     =         the operands are equal (as strings)
#     !=        opposite of =
#INTEGER COMPARISON:
#  2 operands:
#     -eq       equal
#     -ne       not equal
#     -lt       <
#     -gt       >
#     -ge       >=
#     -le       <=

#OTHER COMPARISON OPERATORS:
#  1 operand:
#     -d        directory exists
#     -f        file exists
#     -s        file exists with size greater than 0
#     -L        simlink exists

#see:
#  http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html
#  https://www.tldp.org/LDP/abs/html/comparison-ops.html
#  "*Always* quote a tested string"

#bash specific:
#     -nt       newer than (files)
#     -ot       older than (files)
#     -e        file exists
#     -a        file exists
#     -S        file is a socket
#     -ef       paths refer to the same file
#     -O        owned by my user

#     -r        readable
#     -w        writable
#     -x        executable

#     ==        equal strings (use [[ ]] or file expansion will occur if globbing)
#     !=        not equal (strings)
#     ||        or      EXAMPLE: if [ "$a" -eq 98 ] || [ "$b" -eq 47 ]; then)
#     &&        and     EXAMPLE: if [[ $a -eq 24 && $b -eq 24 ]]; then
#     -t        file descriptor is open and refers to a terminal

#see: https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.htmlk

#BRACKETS
#     [[ ]]     pattern matching
#     [ ]       globbing and expansion
