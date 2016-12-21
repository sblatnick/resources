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

#(http://unix.stackexchange.com/questions/1314/how-to-set-default-file-permissions-for-all-folders-files-in-a-directory)
chmod g+s <directory>  //set gid 
setfacl -d -m g::rwx /<directory>  //set group to rwx default 
setfacl -d -m o::rx /<directory>   //set other

#Fix mounted flash drive permissions:
sudo chmod g+s /media/<user>
sudo setfacl -d -m u::rwx /media/<user>
sudo setfacl -d -m u:<user>:rwx /media/<user>
sudo setfacl -d -m g::rwx /media/<user>
sudo setfacl -d -m o::rwx /media/<user>
#check permissions were set:
getfacl /media/<user>
#You may have to fix permissions manually on previously mounted drives:
sudo chmod 777 /media/<user>/<drive>

#User defaults set by umask in /etc/profile or .bashrc:
umask 022
#source: http://www.cyberciti.biz/tips/understanding-linux-unix-umask-value-usage.html