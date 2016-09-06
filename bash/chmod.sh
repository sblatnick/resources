#!/bin/bash
#Permissions related help

#Make a file immutable, even to root:
chattr +i /path/to/file.txt

#::::::::::::::::::::CHMOD::::::::::::::::::::
#Examples:
	chmod 700 filename
	chmod -R a+x directory
#Format:
	chmod [OPTIONS] PERMISSIONS file

#PERMISSIONS:
	#MODE:
		u: user
		g: group
		o: others
		
		r: read
		w: write
		x: execute
		#Examples:
			chmod u+rwx,g-rwx,o-rwx filename
			chmod u=rx,g=x,o=x filename
	#OCTAL: by bit mask
		1:	x
		2:	w
		4:	r
		#Examples:
		chmod 511 filename

#OTHER:
	ls -l #shows file permissions
	chmod --help #more concise than "man chmod"

#::::::::::::::::::::CHOWN::::::::::::::::::::
#Examples:
	chown user:group file
	chown $(whoami):group file

#::::::::::::::::::::DIRECTORY DEFAULT PERMISSIONS::::::::::::::::::::
#Sets permissions for all future files in a directory:
setfacl -d -m u::rwx folder

#User defaults set by umask in /etc/profile or .bashrc:
umask 022
#source: http://www.cyberciti.biz/tips/understanding-linux-unix-umask-value-usage.html