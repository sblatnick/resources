

#LVM - Logical Volume Management
  fdisk -l #list devices and partitions
  lsblk    #list attached block devices, even non-mounted

  #command prefixes:
    pv = physical volume
    vg = volume group
    lv = logical volume

    dm = device mapper

  #Example: ls volumes:
    pvs #list physical volumes
    vgs #list volume groups
    lvs #list logical volumes

  #Find volume:
    lvs -S "lv_name=~${vm}" #match name

  #Output Columns:
    lvs --noheadings -o lv_name,lv_size

  #Reduce LV size:
    echo y | lvreduce --resizefs -L -30G /dev/mapper/vgName-lv_name

  #Grow LV size:
    lvextend --resizefs -L +5G /dev/mapper/vgName-lv_name

  #Create a new LV:
    lvcreate -L 5G -n lv_name vgName

  #Delete LV:
    lvremove -f /dev/vol0/$vm

  #Delete Device Mapper:
    dmsetup remove /dev/dm-16

  #Restore deleted LV:
    head /etc/lvm/archive/*.vg #look for the one you want to restore
    vgcfgrestore vgName -f /etc/lvm/archive/vgName_00003-file.vg
    lvscan
    lvchange -a y /dev/vgName/lv_name

  #Remove volume that has a phantom mapping: "Logical volume vg/lv-old is used by another device."
    #find mappings:
    dmsetup info -c | grep old
      vg-lv--old       253  10 L--w    1    2      1 LVM-6O3jLvI6ZR3fg6ZpMgTlkqAudvgkfphCyPcP8AwpU2H57VjVBNmFBpL
    #use 253 and 10:
    ls -la /sys/dev/block/253\:10/holders
      total 0
      drwxr-xr-x 2 root root 0 Sep 14 09:54 .
      drwxr-xr-x 8 root root 0 Sep 14 09:54 ..
      lrwxrwxrwx 1 root root 0 Nov 30 10:01 dm-12 -> ../../dm-12
      lrwxrwxrwx 1 root root 0 Nov 30 10:01 dm-13 -> ../../dm-13
      lrwxrwxrwx 1 root root 0 Nov 30 10:01 dm-14 -> ../../dm-14
    #make sure nothing else has mapping:
    ls -l /sys/dev/block/253\:*/holders/dm-14
    #remove mapping:
    dmsetup remove /dev/dm-12
    dmsetup remove /dev/dm-13
    dmsetup remove /dev/dm-14
    #remove volume:
    lvremove -f /dev/vol0/$vm

  #Create loopback device:
    dd if=/dev/zero of=HDD.img bs=1G count=10
    mkfs.ext4 -F HDD.img
    losetup -Pf --show HDD.img
    #detach loopback device:
    losetup -d /dev/loop0
    #list block devices:
    lsblk

  #Snapshot of kvm virsh lv:
    virsh shutdown $vm
    lvs | grep $vm #get $vol_group and $size
    lvcreate -L ${size}G -s -n ${vm}.$(date +%F) /dev/${vol_group}/${vm}
    #revert:
    lvconvert --merge /dev/${vol_group}/${vm}.${date}

    #recreate the snapshot! (merging disposed of it)
    lvcreate -L ${size}G -s -n ${vm}.$(date +%F) /dev/${vol_group}/${vm}

    #start vm
    virsh start $vm

