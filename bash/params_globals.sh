#!/bin/bash

#::::::::::::::::::::VARIABLE MANIPULATION::::::::::::::::::::
	${variable%pattern}		#Trim the shortest match from the end
	${variable##pattern}	#Trim the longest match from the beginning
	${variable%%pattern}	#Trim the longest match from the end
	${variable#pattern}		#Trim the shortest match from the beginning

	#Given:
		foo=/tmp/my.dir/filename.tar.gz

	#We can use these expressions:

	path=${foo%/*}
		#To get: /tmp/my.dir (like dirname)
	file=${foo##*/}
		#To get: filename.tar.gz (like basename)
	base=${file%%.*}
		#To get: filename
	ext=${file#*.}
		#To get: tar.gz

  #Replace substrings:
    #first:
      ${string/substring/replacement}
    #all:
      ${string//substring/replacement}

	#pad number:
		i=99
		printf -v j "%05d" $i
		echo $j #stored into j from printf

	#run on a sequence of numbers that are padded:
		for i in $(seq -f "%05g" 10 15)
		do
			echo $i
		done

  #get the value of a variable by variable name (reflection, or parameter expansion):
    example="name"
    name="My Name"
    echo ${!example} #prints: My Name

#::::::::::::::::::::ARITHMETIC::::::::::::::::::::

echo $((125924 + 31097))
echo $(($variable + 125924))
echo $((125924 + variable))

#increment:
	(( n += 1 ))
	((n++))
#WRONG: (( $n += 1 ))

#division with formatting:
progress=$(echo "${DONE}" "${TOTAL}" | awk '{printf "%.1f", $1/$2 * 100}' 2>/dev/null)
bc <<< 'scale=2; 100/3'

#bc can use variables (separate logic with newlines or semicolons):
$ bc <<< 'four=4;3+four'
7

#extract digits:
digits=$(tr -cd 0-9 <<<"spy007")
#remove 0 padding:
number=$((10#$digits))

#::::::::::::::::::::PARAMETER VARIABLES::::::::::::::::::::

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

#::::::::::::::::::::HISTORY EXPANSION::::::::::::::::::::

  history | less #view history with line numbers
  !24 #run 24th line in history
  !! #run the last command
  !!:/bash/ash/ #re-runs last command replacing text
  !?bash?:s/bash/ash/ #re-runs last matching command replacing text
  !?bash?:s/%/ash/
  !-3 #execute 3rd to last command
  !echo #execute last command starting with 'echo'

#::::::::::::::::::::MULTITHREADED VARIABLES::::::::::::::::::::

#source: http://stackoverflow.com/questions/13207292/bash-background-process-modify-global-variable

#Store variables in shared memory to reduce file IO in /dev/shm
pid=$$
rm /dev/shm/total.$pid /dev/shm/files.$pid 2>/dev/null

thread() {
	number=10
	file="filename.txt"
	echo $file >> /dev/shm/files.$pid #keep a list of files
	echo $number >>/dev/shm/total.$pid #increment by $number, append to prevent race conditions
}

threads=4
thread &
thread &
thread &
thread &

old=0
while [ $(wc -l /dev/shm/total.$pid | cut -f1 -d' ') -lt "$threads" ]
do
	current=$(wc -l /dev/shm/total.$pid | cut -f1 -d' ')
	if [ $old -ne $current ];then
		old=$current
		printf "  (%4s/%4s) %s\n" "$old" "$threads" "$(date)"
	fi
	sleep 1
done
printf "  (%4s/%4s) DONE %s\n" "$old" "$threads" "$(date)"

echo "RESULTS:"
current=$(wc -l /dev/shm/total.$pid | cut -f1 -d' ')
echo "  count: $current"
total=$(awk '{sum+=$1} END {print sum}' /dev/shm/total.$pid)
echo "  no change: $total"
echo "  files:"
cat /dev/shm/files.$pid | sed 's/^/    /'
rm /dev/shm/total.$pid /dev/shm/files.$pid 2>/dev/null

#don't use this in multiple threads, or there could be a race condition between
#read and write:
echo $(($(</dev/shm/foo)+1)) >/dev/shm/foo;
#instead, use a lock file:
#source: http://stackoverflow.com/questions/169964/how-to-prevent-a-script-from-running-simultaneously
(
  # Wait for lock on /var/lock/.myscript.exclusivelock (fd 200) for 10 seconds
  flock -x -w 10 200 || exit 1

  # Do stuff

) 200>/var/lock/.myscript.exclusivelock

#::::::::::::::::::::EXCEPTION HANDLING::::::::::::::::::::
#EXCEPTION HANDLING using $?:
	/usr/local/bin/my-command
	if [ "$?" -ne "0" ]; then
		echo "Sorry, we had a problem there!"
	fi

#::::::::::::::::::::SIGNAL HANDLING::::::::::::::::::::

#kill children processes of a bash script (untested):
	trap 'kill $(jobs -p)' SIGINT
	trap "kill -- -$$" SIGINT

	function cleanup
	{
		echo "cleanup"
		rm report.csv
		kill -- -$$
		exit
	}
	trap cleanup SIGHUP SIGINT SIGTERM

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

ARRAY=() #initialize
ARRAY+=('element') #add element
echo ${ARRAY[@]: -5:3} #5th-to-last element and the next 2, or start:count
echo ${ARRAY[@]: 0:3} #first 3 elements

ARRAY=(a b c d e f g h)
echo ${#ARRAY[@]} #8
echo ${!ARRAY[@]} #indicies: 0 1 2 3 4 5 6 7
indicies=(${!ARRAY[@]}) #store the indicies to an array
echo "${indicies[@]}" #prints: 0 1 2 3 4 5 6 7

#Note: Arrays can have specified indicies (int), but not keys (string)
#specify other indicies for a sparse array (notice numerical reordering)
declare -a ARRAY='([5]="my" [10]="very" [14]="energetic" [25]="mother" [26]="just" [74]="bought" [47]="me" [56]="nine pizzas")'
echo ${ARRAY[@]} #my very energetic mother just me nine pizzas bought
echo ${!ARRAY[@]} #5 10 14 25 26 47 56 74

#EXAMPLE:
IFS='
'
array=($(ls | grep .flv))
for video in ${array[@]}
do
	echo $video
done

#Don't forget the outter () when creating an array.
#Otherwise it's just a single string.
#The loop still works since it iterates over strings dilimited by whitespace
#but the array length is off:
length=${#array[@]}

#You can set the delimiter just to create an array and have it revert back in one line:
IFS=',' read -ra VARIABLE <<< "$IN" #make sure $IN is wrapped in double quotes, or the array length is off
IFS=$'\n' read -rd '' -a VARIABLE <<< "$(pgrep -f "--test $VAR")" #or "$(commands)" with no escaping necessary

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

#::::::::::::::::::::MULTILINE STRING/COMMENT::::::::::::::::::::

#Multi-line comment:
<<COMMENT1
	your comment 1
	comment 2
	blah
COMMENT1
#Multi-line variable:
read -d '' variable << EOF
  usage: up [--level <n>| -n <levels>][--help][--version]

  Variable: $var
EOF
echo "$variable"

#Echo all in one:
cat << EOF
  usage: up [--level <n>| -n <levels>][--help][--version]

  Variable: $var
EOF
#File redirection:
cat > output.txt << EOF
  usage: up [--level <n>| -n <levels>][--help][--version]

  Variable: $var
EOF
#redirection after EOF, var substitution and save to file:
cat << EOF > package.spec
Name: ${package}
Version: ${version}
Summary: ${summary}
...
EOF

#Note: <<- means remove indentation (preceding whitespace from each line):
cat <<- EOF
  usage: up [--level <n>| -n <levels>][--help][--version]

  Variable: $var
EOF

#Change indentation width in printed output:
tabs 4

#::::::::::::::::::::PARAMETER CAPTURING::::::::::::::::::::

while [ -n "$1" ]; do
	case $1 in
		(--help|-help)           help ;;
		(--profile|-profile)     _profile=$2; shift ;;
		(--gui|-gui)             _gui=true ;;
		(--nogui|-nogui)         _gui=false ;;
		(--nojava|-nojava)       _java=false ;;
		(--root|-root)           _rootok=true ;;
		(--fg|-fg)               _background=false ;;
		(--deconfig|-deconfig)   uninstall=false ;;
		(--uninstall|-uninstall) uninstall=true ;;
		(--kill)                 kill=true ;;
		(--) shift; break ;;
		(*) break ;;
	esac
	shift
done

while
	case $1 in
		(--freq|-f)
				frequency="$2"
				shift
				if ! [[ "$frequency" =~ 'daily|hourly|ten-minutes' ]];then
					echo "ERROR: invalid frequency parameter"
					usage
					exit
				fi
			;;
		(--help|-h|*)
				usage
				exit
			;;
	esac
	shift
	[ -n "$1" ]
do
	continue
done

case "$service" in
	all)
		services=(proxy apache dm network)
		#intentionally left out: "setup"
		for name in ${services[@]}
		do
			$0 "$name" "$action"
		done
		;;
	setup)
			echo -e "\033[32m${service}\033[0m"
			cp /etc/resolv.conf.bak /etc/resolv.conf
			/etc/init.d/named restart
		;;
	proxy)
		/etc/init.d/proxy "$action"
		;;
	apache)
		/etc/init.d/httpd "$action"
		;;
	dm)
		/etc/init.d/dm "$action"
		;;
	*)
		/etc/init.d/${service} "$action"
		;;
esac


#take list from pipe, file or args:

function process()
{
	dist=$1
	echo "Processing $dist"
	#ssh takes stdin, so you have to switch it to use /dev/null:
	ssh "$destination" "./addActiveSync.pl $dist" < /dev/null
	echo "next"
}

if [ -t 0 ];then
	if [ "$#" -lt 1 ];then
		echo -e "Usage: ${0##*/} [distids|csv files]"
		echo "You can also pipe distids"
		exit
	else
		while [ -n "$1" ]; do
			if [ -f $1 ];then
				cat $1 |
				while read pipe
				do
					process $pipe
				done
			else
				process $1
			fi
			shift
		done
	fi
else
	while read pipe
	do
		process $pipe
	done
fi

#sudo append to file:
echo "text" | sudo tee -a /path/to/file