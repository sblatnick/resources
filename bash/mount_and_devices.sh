#!/bin/bash

#mounted files:
  /etc/fstab
  #printf "%-23s %-23s %-7s %-15s 0 0" /dev/sda1 "${location}" ext4 "${options}"

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


#LVM - Logical Volume Management
  fdisk -l #list devices and partitions

  #command prefixes:
    pv = physical volume
    vg = volume group
    lv = logical volume

  #Example: ls volumes:
    pvs #list physical volumes
    vgs #list volume groups
    lvs #list logical volumes

  #Reduce LV size:
    echo y | lvreduce --resizefs -L -30G /dev/mapper/vgName-lv_name

  #Grow LV size:
    lvextend --resizefs -L +5G /dev/mapper/vgName-lv_name

  #Create a new LV:
    lvcreate -L 5G -n lv_name vgName

  #Restore deleted LV:
    head /etc/lvm/archive/*.vg #look for the one you want to restore
    vgcfgrestore vgName -f /etc/lvm/archive/vgName_00003-file.vg
    lvscan
    lvchange -a y /dev/vgName/lv_name