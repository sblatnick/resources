#!/bin/bash
#Permissions related help

#::::::::::::::::::::ATTRIBUTES::::::::::::::::::::

#Make a file immutable, even to root:
chattr +i /path/to/file.txt
#view attributes:
lsattr /path/to/file.txt
# ----i------------e- file.txt # i means immutable, e is there by default on ext4 as "extends"

#Other attributes:
# i = immutable
# a = can only be appended to
# Not honored on ext2/3/4 filesystems:
# c = compressed
# u = when deleted, contents are saved so it can be undeleted
# s = when deleted, contents are zeroed

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
    1:  x
    2:  w
    4:  r
    #Examples:
    chmod 511 filename

#OTHER:
  ls -l #shows file permissions
  chmod --help #more concise than "man chmod"

#::::::::::::::::::::CHOWN::::::::::::::::::::
#Examples:
  chown user:group file
  chown $(whoami):group file

#::::::::::::::::::::INSTALL::::::::::::::::::::

#create empty file with ownership and permissions:
install -m 640 -o user -g group /dev/null /var/log/example

#::::::::::::::::::::DIRECTORY DEFAULT PERMISSIONS::::::::::::::::::::
#ACL=Access Control Lists

#Sets permissions for all current and future files in a directory:
setfacl -Rdm u::rwx folder
setfacl -Rdm u::7,g::4,o::0 folder
  -R = recursive
  -d = default (new files)
  -m = modify
  u:username:rwx
  g:groupname:rwx

getfacl folder

#(https://www.computerhope.com/unix/usetfacl.htm)
#(https://serverfault.com/questions/444867/linux-setfacl-set-all-current-future-files-directories-in-parent-directory-to)
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

#Fix dirty bit on flash drive:
fdisk -l #find the device
dosfsck /dev/sdc1 #detect and fix the dirty bit from not umounting properly

#User defaults set by umask in /etc/profile or .bashrc:
umask 022
#source: http://www.cyberciti.biz/tips/understanding-linux-unix-umask-value-usage.html

umask 0077 #results in 600 permissions
#SAR umask on CentOS defined in: /usr/lib64/sa/sa1 /usr/lib64/sa/sa2

#change default group
  setfacl -d -m group:<group>:r /path/to/directory #not working?
  #(old way):
  chgrp <group> <directory>
  chmod g+s <directory>

#::::::::::::::::::::SELINUX::::::::::::::::::::

vi /etc/selinux/config
  SELINUX=disabled
$ semanage permissive -a mysqld_t
$ getenforce
Enforcing
$ sudo setenforce 0
$ sestatus
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   permissive
Mode from config file:          enforcing
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Max kernel policy version:      28
