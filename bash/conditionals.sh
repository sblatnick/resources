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
  if [ "$a" -eq 98 ] || [ "$b" -eq 47 ]; then

#CASE
  case $f in
    hello)
        echo English
      ;;
    "guten tag")
        echo German
      ;;
    this|that)
        echo Rambling
    *)
        echo Unknown Language: $f
      ;;
  esac

# -eq = equal
# -lt = less than
# -gt = greater than

#  operator  produces true if...                               number of operands
#  -n        operand non zero length                            1
#  -z        operand has zero length                            1
#  -d        there exists a directory whose name is operand    1
#  -f        there exists a file whose name is operand          1
# -s         there exists a file that with size greater than 0  1
#  -eq       the operands are integers and they are equal      2
#  -neq      the opposite of -eq                                2
#  =         the operands are equal (as strings)                2
#  !=        opposite of =                                     2

#INTEGERS ONLY:

#  -lt        operand1 is strictly less than operand2            2
#  -gt        operand1 is strictly greater than operand2        2
#  -ge        operand1 is greater than or equal to operand2     2
#  -le        operand1 is less than or equal to operand2        2

#  -L        simlink

#see: http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html

#bash specific:
#  -nt       newer than (files)
#  -ot       older than (files)
#  -e        file exists
#  -a        file exists
#  -S        file is a socket
#  -ef       paths refer to the same file
#  -O        owned by my user

#  -r        readable
#  -w        writable
#  -x        executable

#  ==        equal (strings)
#  !=        not equal (strings)
#  ||        or
#  &&        and

#  -d        is a directory

#  -t        file descriptor is open and refers to a terminal


#see: https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.htmlk


