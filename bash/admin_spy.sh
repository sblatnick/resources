#!/bin/bash

#boot them from your computer (look up the pid in whowatch or ps):
	kill -9 <pid>

#spy on other users:
	#show currently logged on people and what they're doing
	whowatch
	#show currently logged on people:
	who
	#run a program in a terminal fullscreen, repeating the output:
	watch
	#current process for each user:
	w
	#watch the current process for each user:
	watch w
	#watch tty's (if set up beforehand) See: (watch login, not over ssh) http://www.linuxhelp.net/guides/ttysnoop/
	ttysnoop pty

	#watch another command line over ssh even (hard to read, but get pid from whowatch -> user -> bash) (see: http://www.terminalinflection.com/strace-stdin-stdout/):
	#1,2 is STDOUT,STDERR, and this gets STDIN too
	sudo strace -ff -e trace=write -e write=1,2 -p <pid>

		#!/bin/bash
		if [ $# -lt 1 ]; then
			echo "Usage: ${0##*/} [pid]"
			echo "  Trails a bash process for keystrokes."
			exit
		fi

		regex=".*\"(.*)\".*)"

		sudo strace -ff -e trace=write -e write=1,2 -p $1 2>&1 | \
		while read pipe
		do
			[[ $pipe =~ $regex ]]
			key="${BASH_REMATCH[1]}"
			#echo "Pipe: \"$pipe\""
			echo -e "Key: \"$key\""
		done

#messaging:
	#send message to another user:
	write
	#send a message to all users:
	wall -n "Message"
	#echo to their command line ("who" can tell you which pts to use):
	echo "hello world" > /dev/pts/4