

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