#!/bin/bash

#mounted files:
  /etc/fstab

#mount ssh:
  sshfs -o cache=no,allow_other,uid=0,gid=0,nonempty steve@vmhost:/home/steve/work /root/work/
  #nonempty = ignore if the directory has contents on the local filesystem
  #unmount:
  fusermount -u /user_bak/
  #install (yum):
  yum install fuse-sshfs

#simulate a full device:
  ln -s /dev/full /users_clone/connected-qaenv03
#"mount" directory
  mkdir /users_slow_clone
  mount --bind /users_clone /users_slow_clone
  #find the device it uses:
  cat /proc/mounts | grep users
  #output: /dev/root /users_slow_clone ext3 rw,data=ordered 0 0
#simulate a slow connection:
  tc qdisc add dev eth1 root netem delay 1000ms
  #modify:
  tc qdisc change dev eth1 root netem delay 100ms 10ms 25%
  #remove:
  tc qdisc del dev eth1 root

#debug connection:
  strace ls /var/www/