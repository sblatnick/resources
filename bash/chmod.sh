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

#::::::::::::::::::::ACCESS CONTROL LISTS (ACL)::::::::::::::::::::
#Additional users/groups and permissions
ls -l $file
  -rw-r--r-+ #+ means additional permissions through ACL
getfacl $file
  # file: $file   #
  # owner: root
  # group: root
  user::rw-       #normal chmod permissions
  user:john:rw-   #additional permissions for other user
  user:sam:rwx
  group::r--
  mask::rwx       #permissions granted to additional user/groups
  other:---
setfacl -m u:john:rw,g:accounts:rwx $file

#Defaults:
setfacl -m default:u:john:rw,g:accounts:rwx $directory

#source: https://www.thegeekdiary.com/unix-linux-access-control-lists-acls-basics/
#Formats:
  [d[efault]:] [u[ser]:]uid [:perms]
    Permissions of a named user. Permissions of the file owner if uid is empty.
  [d[efault]:] g[roup]:gid [:perms]
    Permissions of a named group. Permissions of the owning group if gid is empty.
  [d[efault]:] m[ask][:] [:perms]
    Effective rights mask
  [d[efault]:] o[ther][:] [:perms]
    Permissions of others.

getfacl
  #Traversal:
  -R          #recursive
  -s          #skip files with chmod permissions only (ugo)

  -P          #physical (no links)
  -L          #logical, follow links (default)

  #Output:
  -a          #file access control list
  -d          #default access control list

  -e          #effective rights
  -E          #no effective rights

  -c          #skip file header
  -t          #tab output
  -p          #full path with leading / (default: ^/ stripped)
  -n          #numberic ids for users/groups

  #Misc:
  -v          #version
  -h          #help
  --          #end options
  -           #read from stdin

setfacl
  #Traversal:
  -R          #recursive

  -P          #physical (no links)
  -L          #logical, follow links (default)

  #Modification:
  -m          #--modify
  -x          #--remove specified: -x u:steve
  --set       #replace

  -M          #modify from file
  -X          #remove from file
  --set-file  #replace by file

  -b          #remove all
  -k          #remove default ACL
  -d          #default: applied to default chmod ACL
  --restore   #restore from output of `getfacl -R`
  --mask      #recalculate effective rights using masking
  -n          #no mask used
  --test      #dry run

  #Misc:
  -v          #version
  -h          #help
  --          #end options
  -           #read from stdin

#Backup/restore:
  getfacl -R * > acl.txt
  setfacl --restore=acl.txt


#::::::::::::::::::::DIRECTORY DEFAULT PERMISSIONS::::::::::::::::::::

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
chmod g+s <directory>              #set gid 
setfacl -d -m g::rwx /<directory>  #set group to rwx default 
setfacl -d -m o::rx /<directory>   #set other

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

#Directory permissions analysis:
  dir=/etc/example/long/path/to/file.conf
  while [ -n "${dir}" ]; do ls -ld ${dir}; dir=${dir%/*}; done

