#!/bin/bash

#(NOT WORKING with ext4) auto-mount usb drives as user:
  #debian uses udisks2: (see http://storaged.org/doc/udisks2-api/latest/mount_options.html )
    sudo vi /etc/udisks2/mount_options.conf
      [defaults]
      allow=uid=$UID,gid=$GID,exec,noexec,nodev,nosuid,atime,noatime,nodiratime,relatime,strictatime,lazytime,ro,rw,sync,dirsync,noload,acl,nosymfollow,uhelper=udisks2,errors=remount-ro
      defaults=uid=$UID,gid=$GID
    systemctl restart udisks2
  #udev rule:
    sudo vi /lib/udev/rules.d/80-steve.rules #number matters for order
      SUBSYSTEM=="block", ENV{DEVTYPE}=="usb_device", MODE="0664", OWNER="steve", GROUP="steve"
    systemctl restart udev

#mounted files:
  /etc/fstab
  #printf "%-23s %-23s %-7s %-15s 0 0" /dev/sda1 "${location}" ext4 "${options}"

#mount drive at boot:
  #get uuid:
    sudo blkid
  #edit:
    /etc/fstab:
      UUID=e8a2adfb-6356-4aef-a638-5dd5faaef57e /home/steve/raid ext4 errors=remount-ro 0 1
  #prep:
    sudo systemctl daemon-reload
    sudo mount -a
    sudo chown steve:steve -R raid/

#mount an iso:
  mount -o loop name.iso /mnt/iso
#/etc/fstab for iso:
  /opt/file.iso /mnt/iso iso9660 loop 0 0

#mount ssh:
  sshfs -o cache=no,allow_other,uid=0,gid=0,nonempty steve@vmhost:/home/steve/work /root/work/
  #nonempty = ignore if the directory has contents on the local filesystem
  #unmount:
  fusermount -u /user_bak/
  #install (yum):
  yum install fuse-sshfs

#force unmount hanging nfs:
  umount -f -l /share/nfs
    -f #force
    -l #lazy

#repair usb drive that wasn't unmounted:
  umount /dev/sdb
  sudo fsck /dev/sdb #follow prompts

  sudo fsck -N /dev/sdb #dry run
  sudo fsck -y /dev/sdb #print errors found
  sudo fsck -y /dev/sdb #fix all errors

#Change usb drive label:
  sudo mlabel -i /dev/sdb ::<label>

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

#set up nfs server:
  mkdir -p /mnt/volume
  yum install nfs-utils nfs-utils-lib
  systemctl start rpcbind nfs-server rpc-statd
  systemctl enable rpcbind nfs-server
  vi /etc/exports
    /mnt/volume	*.intra.net(rw)
  exportfs -a