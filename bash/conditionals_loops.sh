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

#	operator	produces true if... 															number of operands
#	-n				operand non zero length														1
#	-z				operand has zero length														1
#	-d				there exists a directory whose name is operand		1
#	-f				there exists a file whose name is operand					1
# -s				there exists a file that with size greater than 0	1
#	-eq				the operands are integers and they are equal			2
#	-neq			the opposite of -eq																2
#	=					the operands are equal (as strings)								2
#	!=				opposite of = 																		2

#INTEGERS ONLY:

#	-lt				operand1 is strictly less than operand2						2
#	-gt				operand1 is strictly greater than operand2				2
#	-ge				operand1 is greater than or equal to operand2 		2
#	-le				operand1 is less than or equal to operand2				2

#	-L				simlink

#see: http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html

#bash specific:
#	-nt				newer than (files)
#	-ot				older than (files)
#	-e				file exists
#	-a				file exists
#	-S				file is a socket
#	-ef				paths refer to the same file
#	-O				owned by my user

#	-r				readable
#	-w				writable
#	-x				executable

#	==				equal (strings)
#	!=				not equal (strings)
#	||				or
#	&&				and

#	-d				is a directory

#::::::::::::::::::::LOOPS::::::::::::::::::::

#WHILE
	while read f
	do
		echo $f
		continue
		break
	done < myfile

	#prevent sub-shell issues in totals:
	total=0
	while read var
	do
		echo "variable: $var"
		((total+=var))
	done < <(echo 45) #output from a command, script, or function
	echo "total: $total"

	ls | while read file
	do
		echo $file
		string $file | grep '19%'
	done

  #prevent sub-shell issues in pipe:
  echo hello | {
    while IFS= read -r line
    do
      echo "$line"
      lastLine="$line"
    done

    #won't work without the braces:
    echo "$lastLine"
  }

	#counter:
	X=0
	while [ $X -le 20 ]
	do
		echo $X
		X=$((X+1))
	done

	#using let:
	i=0
	while [ $i -lt 400 ]; do
		printf "%i : %b\n" "$i" "\0$i"
		let "i++"
	done

#FOR LOOP:
	#using a sub-shell, so variables can be read after the loop:
	for video in $(ls | grep .flv)
	do
		echo $video
	done
	echo "last: $video"

	IFS='
'
	array=$(ls | grep .flv)
	for video in ${array[@]}
	do
		echo $video
	done

	#globbing:
	for var in *.html
	do
		grep -L 'gif' "${var}"
	done

	green="green purple" #separate
	for X in "red" "$green" "blue" $green
	do
		echo $X
	done

	#You can also set the delimiter just to create an array and have it revert back in one line:
	IFS=';' read -ra VARIABLE <<< "$IN"

#MAKE A BUNCH OF DIRECTORIES:
	mkdir rc{0,1,2,3,4,5,6,S}.d

#SEQUENCE of numbers that are padded:
	for i in $(seq -f "%02g" 10 15)
	do
		echo $i
	done

#for loop with index and value (untested):
	for i in "${!foo[@]}"; do 
		printf "%s\t%s\n" "$i" "${foo[$i]}"
	done

	for i in "${!services[@]}"
	do 
		server="${services[$i]}"
		echo -e "$server" > /tmp/left.csv.$pid
		ssh $server -q "$param" >> /tmp/left.csv.$pid 2>&1
	done

#Array length:
	${#ArrayName[@]}
#sort by descending order of unique count:
	grep -P '^2014-10-22 10:00' ~/mail.log | grep 'bounce' | grep ' to=<[^>]*>' -o | sort | uniq -c | sort -nr

#::::::::::::::::::::FUNCTIONS::::::::::::::::::::

	do_stuff()
	{
		echo "this is a script function, $1"
	{
	
	do_stuff ok

#::::::::::::::::::::OPERATORS::::::::::::::::::::

	#ARITHMATIC:
		X=`expr 3 \* 2 + 4` #escape *
		#WRONG: X=`expr "3 * 2 + 4"`
		#WRONG: X=`expr "3 \* 2 + 4"`

	#Substitute all:
		echo "hello world" | tr 'hell' '+' #++++o wor+d

#::::::::::::::::::::REGEX::::::::::::::::::::
#by Mitch Frazier, the System Administrator at Linux Journal.

if [[ $# -lt 2 ]]; then
	echo "Usage: $0 PATTERN STRINGS..."
	exit 1
fi
regex=$1
shift
echo "regex: $regex"
echo

while [[ $1 ]]
do
	if [[ $1 =~ $regex ]]; then
		echo "$1 matches"
		i=1
		n=${#BASH_REMATCH[*]}
		while [[ $i -lt $n ]]
		do
			echo "  capture[$i]: ${BASH_REMATCH[$i]}"
			let i++
		done
	else
		echo "$1 does not match"
	fi
	shift
done

#Resource: http://steve-parker.org/sh/sh.shtml