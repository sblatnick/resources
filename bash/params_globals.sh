#!/bin/bash

#::::::::::::::::::::PRAMETER VARIABLES::::::::::::::::::::

$0	# basename of program, but use `basename $0` to get just the program
		# (in case the user called it with a path)
$1	# ... $9	first 9 parameters
$@	# all parameters
$*	# all parameters delimited, even if in quotes or with spaces
		# (like "hello world" becomes "hello" "world")
$#	#number of parameters
$?	#exit value of the last run command (error detection, use after you run
		# something to see if it worked)
$$	#PID (process ID number) of currently running shell, usefull for temp
		# file generation in case the script is ran more than once before completion
$!	#PID of last running background process
		# "This is useful to keep track of the process as it gets on with its job."

#::::::::::::::::::::GLOBAL VARIABLES::::::::::::::::::::
#Internal Field Separator (See ARRAYS)
	IFS='
'
	# (notice it's on two lines) allows the array to be divided by different things
	# default = SPACE TAB NEWLINE
	# recommended to be backed up if only for one part of the script

	EDITOR=geany #Set default editor
	PATH #Search path for executables
	echo `pwd` #current script directory
	echo `basename $0` #name of the program
	echo `dirname $0` #directory of the program

#::::::::::::::::::::EXCEPTION HANDLING::::::::::::::::::::
#EXCEPTION HANDLING using $?:
	/usr/local/bin/my-command
	if [ "$?" -ne "0" ]; then
		echo "Sorry, we had a problem there!"
	fi
#::::::::::::::::::::CHANNEL REDIRECTION::::::::::::::::::::
	#Piping errors shorthand:
		|&
	#shorthand for:
		2>&1 |
#Example:
	#open up an extra input file
	exec 7</dev/tty
	#read each file from standard input, prompting for file
	#deletion and reading response from extra input
	while read file
	do
		echo -n "Do you want to delete file $file (y/n)? "
		read resp <&7
		case "$resp" in [yY]*) rm -f "$file" ;; *) ;; esac
	done
	#close the extra input file
	exec 7<&-

#::::::::::::::::::::PARAMETERS::::::::::::::::::::
	#GET MORE THAN 9 PARAMETERS: (shifts off paramters until there aren't any left)
		while [ "$#" -gt "0" ]
		do
			echo "\$1 is $1"
			shift
		done

	#USAGE INFORMATION:
		if [[ $# -lt 1 ]]; then
			echo "Usage: ${0##*/} [param]"
			exit 1
		fi

#::::::::::::::::::::VARIABLES::::::::::::::::::::
	#no spaces!
	variable=34
	# use $ after declared
	echo "$variable"
	# use {} to separate variable from content
	echo "${variable}stuff"

	#DEFAULT VALUE VARIABLE
		echo "${myname:-John Doe}" #unset
		echo "${myname:=John Doe}" #undefined
		#uses "John Doe" if not set

#::::::::::::::::::::READ::::::::::::::::::::

	echo -n "type something: "
	read variable
	echo $variable "is what you typed!"

#::::::::::::::::::::SUB-SHELL::::::::::::::::::::

	#Keep a scripts variables by not running in a sub-shell:
		#running the program with
			. ./executable
		#instead of:
			./executable

	#COMMAND SUBSTITUTION:
		files=$(ls)
		files=`ls`

#::::::::::::::::::::ARRAYS::::::::::::::::::::

${#ArrayName[@]} #array length
unset array[$element] #delete element in an array

#EXAMPLE:
IFS='
'
array=$(ls | grep .flv)
for video in ${array[@]}
do
	echo $video
done

#Concatinate two arrays when delimeted by a newline:
streams=`
for x in ${pdf[@]}
do
	echo "$x"
done
`'
'`
for x in ${doc[@]}
do
	echo "$x"
done`

#::::::::::::::::::::QUOTES::::::::::::::::::::
'' #raw
"" #pre-render
`` #pre-execute

#::::::::::::::::::::MULTILINE COMMENT::::::::::::::::::::

echo "Say Something"
<<COMMENT1
    your comment 1
    comment 2
    blah
COMMENT1
echo "Do something else"