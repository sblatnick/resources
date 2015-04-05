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

#::::::::::::::::::::ARITHMETIC::::::::::::::::::::

echo $((125924 + 31097))
echo $(($variable + 125924))
echo $((125924 + variable))

(( n += 1 )) #increment
#WRONG: (( $n += 1 ))

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

#::::::::::::::::::::SIGNAL HANDLING::::::::::::::::::::

#kill children processes of a bash script (untested):
	trap 'kill $(jobs -p)' SIGINT
	trap "kill -- -$$" SIGINT

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
		services=(apache proxy glue tomcat pop dm qw resin cstools)
		#intentionally left out: mig, ldap, "setup"
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
		/usr/local/proxy/bin/apachectl "$action"
		;;
	apache)
		/usr/local/common/cc/bin/apachectl "$action"
		;;
	ldap)
		/var/mps/serverroot/slapd-devserver01/$action-slapd
		;;
	dm)
		~/work/lcta/bin/pmtactl "$action"
		;;
	*)
		~/work/lcta/bin/${service}ctl "$action"
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