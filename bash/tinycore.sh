#!/bin/bash
###TinyCore Linux
#::::::::::::::::::::INSTALL::::::::::::::::::::
  #Frugal install: http://www.tinycorelinux.net/install_manual.html

  #32-Bit: TinyCore-current.iso
  #64-Bit: TinyCorePure64-current.iso
  #Debian: dCore

  #Write to flash drive
  #Boot

  tce-load -wi grub2-multi liblvm2
  sudo su
    #Disable write protection on the internal drive:
      hdparm -r0 /dev/sda
    #Partition:
      fdisk -l
      fdisk /dev/sda
        #help:
          m         #shows help information
          p         #prints current partitions
          q         #quit
          d         #delete
      fdisk /dev/sda
        o <return>  #create new partition table
        w <return>  #write to disk
        #exits after write
      fdisk /dev/sda
        n <return>  #new
        p <return>  #primary partition
        1 <return>  #1st partition
        <return>    #start address default
        <return>    #end address default
        w           #write changes
    #Format:
      mkfs.ext4 /dev/sda1 -I 256
    #Flag bootable:
      fdisk /dev/sda
        a <return>  #toggle boot flag
        1           #first partition
        w           #write changes
    #Update fstab:
      rebuildfstab
    #mount:
      mount /mnt/sda1
    #install:
      mkdir -p /mnt/sda1/boot
      cp -p /mnt/sdb/boot/* /mnt/sda1/boot/ #ignore "omitting directory isolinux"
    mkdir -p /mnt/sda1/tce
    touch /mnt/sda1/tce/mydata.tgz
    grub-install --boot-directory=/mnt/sda1/boot /dev/sda
    vi /mnt/sda1/boot/grub/grub.cfg
      set default=0
      set timeout=0
      menuentry "Tiny Core 32" {
        set root="(hd0,msdos1)"
        linux /boot/vmlinuz home=sda1 opt=sda1
        initrd /boot/core.gz
      }
      menuentry "Tiny Core 64" {
        set root="(hd0,msdos1)"
        linux /boot/vmlinuz64 home=sda1 opt=sda1
        initrd /boot/corepure64.gz
      }
  exit
  #Add GUI:
    tce-load -wi Xorg-7.7-3d.tcz Xlibs.tcz Xprogs.tcz aterm.tcz flwm_topside.tcz wbar.tcz
  #Allow changing screen resolution using xrandr (adds modes and provider detection)
    tce-load -wi graphics-6.1.2-tinycore
  #Add Sound:
    tce-load -wi alsa alsa-config
  #reboot

  #disable backup checkbox default:
    vi .profile
      export BACKUP=0

  #Paths:
    /opt
      .filetool.lst   #backup list
      .xfiletool.lst  #backup exclude list
      bootlocal.sh    #startup

  #Boot codes:
    home=sda1 home=LABEL=example home=UUID=xxxx-xxxx
    opt=sda1

#::::::::::::::::::::SSH Server::::::::::::::::::::
#source: https://firewallengineer.wordpress.com/2012/04/01/how-to-install-and-configure-openssh-ssh-server-in-tiny-core-linux/
  tce-load -wi openssh
  sudo su
    cp /usr/local/etc/ssh/sshd_config.orig /usr/local/etc/ssh/sshd_config
    #If you want x11 forwarding:
    vi /usr/local/etc/ssh/sshd_config
      X11Forwarding yes
      X11DisplayOffset 10
    vi /opt/.filetool.lst
      usr/local/etc/ssh
      etc/passwd
      etc/shadow
      etc/motd
    vi /opt/bootlocal.sh
      #!/bin/sh
      # put other system startup commands here
      /usr/local/etc/init.d/openssh start
      #If you can't configure static from the DHCP server:
      ifconfig eth1 100.64.0.128 netmask 255.255.255.0
    #setup new password for tc
    passwd tc
  exit
  backup

#::::::::::::::::::::WARCRAFT 2 BNE (original, not gog version)::::::::::::::::::::
#Note: Must use 32-bit TinyCore
  #Install wine:
    tce-load -wi wine
    #The latest wine is incompatible with the original WarCraft2's CDROM check, so manually downgrade
    rm /mnt/sda1/tce/optional/wine.tcz
    wget http://repo.tinycorelinux.net/12.x/x86/tcz/wine.tcz
    mv wine.tcz /mnt/sda1/tce/optional/
    cd /mnt/sda1/tce/optional/
    md5sum wine.tcz > wine.tcz.md5.txt
  #Set up IPX emulation: https://ipxemu.sourceforge.io
    mv thipx32.dll ~/.wine/drive_c/windows/system32/
    mv wsock32.dll ~/.wine/drive_c/windows/system32/
  #Copy iso to home directory (should be persistent and not backed up)
  #Startup in /opt/bootlocal.sh:
    #Mount on boot:
      mkdir /mnt/wc2
      mount -o loop /home/tc/war2bnecd.iso /mnt/wc2
    #Set sound volume:
      sleep 3
      amixer set "Master" 50 unmute
  #mount or reboot
  #Install:
    cd /mnt/wc2
    wine setup.exe
  #Add /mnt/wc2 to Drives in winecfg
  #Backup in /opt/.filetool.lst for wine certs:
    usr/local/etc/ssl/certs
  #Helper scripts: .local/bin/
    #wc2
      #!/bin/ash
      xrandr -s 640x480
      export WINEDLLOVERRIDES=wsock32=n
      wine ~/.wine/drive_c/"Program Files"/"Warcraft II BNE"/"Warcraft II BNE.exe"
      #restore screen resolution:
      xrandr -s 1280x1024
    #wc2-map
      #!/bin/ash
      wine ~/.wine/drive_c/"Program Files"/"Warcraft II BNE"/"Warcraft II Map Editor.exe"
  backup
  sudo reboot

  #TODO: consider adding /usr/local/tce.icons to .filetool.lst and adding icons to helper scripts

#::::::::::::::::::::REMASTER::::::::::::::::::::

  core='corepure64' #64-bit version

  mkdir tc
  mv corepure64.iso tc/
  cd tc

  #extract iso (-aos means skip overwrites):
  7z x ${core}.iso -aos

  #extract gz (extracted from iso):
  cd boot
  mkdir ${core}
  cd ${core}
  zcat ../${core}.gz | cpio -i -H newc -d

  #modify contents...

  #package:
  cd ${core}
  find | cpio -o -H newc | gzip -2 > ../${core}.gz
  mkisofs -l -J -R -V TC-custom -no-emul-boot -boot-load-size 4 \
    -boot-info-table -b boot/isolinux/isolinux.bin \
    -m ${core} \
    -c boot/isolinux/boot.cat -o tc.iso img


