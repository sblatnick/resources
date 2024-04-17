#!/bin/bash

#ASUS ROG laptop quirks
  #Set power key to act as an END key - See keyboard.sh

  #Keyboard backlight setting from 0 (off) to 3:
    echo 3 > /sys/class/leds/asus::kbd_backlight/brightness

  #UEFI doesn't see linux.  You have to put the efi file where it expects Windows.

#Find JAVA_HOME:
  JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")

#Zoom Video Chat Bug: sets volume to 100% on entering a conference.
  # 1. Update /etc/pulse/daemon.conf to have:
    flat-volumes = no
  # (debian has it set to = yes, and commented out)
  # 2. restart pulse:
    pulseaudio -k
    pulseaudio --start


#Add Display-Link usb video cards:

  # 1. (Optional?) Installed the driver via:
  https://github.com/AdnanHodzic/displaylink-debian/blob/master/displaylink-debian.sh
  # (may have to modify script for obscure distros).
  # 2. blacklist udlfb in favor of udl (I was getting the green screen, but it turns out you don't want the green screen, or it means it's using the wrong driver):
    cat /etc/modprobe.d/displaylink.conf
    blacklist udlfb
  # `xrandr --listproviders` will now list the displaylink
  # 3. set provider for the framebuffer:
    xrandr --setprovideroutputsource 1 0

  #ERROR updating kernel?
    #Errors when installing:
      Setting up linux-headers-6.0.0-6-amd64 (6.0.12-1) ...
      /etc/kernel/header_postinst.d/dkms:
      dkms: running auto installation service for kernel 6.0.0-6-amd64:Sign command: /usr/lib/linux-kbuild-6.0/scripts/sign-file
      Signing key: /var/lib/dkms/mok.key
      Public certificate (MOK): /var/lib/dkms/mok.pub

      Building module:
      Cleaning build area...
      make -j16 KERNELRELEASE=6.0.0-6-amd64 all INCLUDEDIR=/lib/modules/6.0.0-6-amd64/build/include KVERSION=6.0.0-6-amd64 DKMS_BUILD=1...(bad exit status: 2)
      Error! Bad return status for module build on kernel: 6.0.0-6-amd64 (x86_64)
      Consult /var/lib/dkms/evdi/1.9.1/build/make.log for more information.
      Error! One or more modules failed to install during autoinstall.
      Refer to previous errors for more information.
       failed!
      run-parts: /etc/kernel/header_postinst.d/dkms exited with return code 11
      Failed to process /etc/kernel/header_postinst.d at /var/lib/dpkg/info/linux-headers-6.0.0-6-amd64.postinst line 11.
      dpkg: error processing package linux-headers-6.0.0-6-amd64 (--configure):
       installed linux-headers-6.0.0-6-amd64 package post-installation script subprocess returned error exit status 1
      dpkg: dependency problems prevent configuration of linux-headers-amd64:
       linux-headers-amd64 depends on linux-headers-6.0.0-6-amd64 (= 6.0.12-1); however:
        Package linux-headers-6.0.0-6-amd64 is not configured yet.

      dpkg: error processing package linux-headers-amd64 (--configure):
       dependency problems - leaving unconfigured
    #evdi is referring to displaylink here

    #Fix: The above displaylink script doesn't support 6.0 kernels,
    # so you need to uninstall displaylink and reconfigure the failed kernel:
      sudo /opt/displaylink/displaylink-installer.sh uninstall
      sudo dpkg --configure --pending

#modeline:
  cvt 1920 1080
    # 1920x1080 59.96 Hz (CVT 2.07M9) hsync: 67.16 kHz; pclk: 173.00 MHz
    Modeline "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync

  xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
  xrandr --addmode DP-1 "1920x1080_60.00"
  xrandr --output DP-1 --mode "1920x1080_60.00"

#Set up mini display:
~/.xinitrc:
  xrandr --output HDMI-A-0 --scale 0.6x0.6 #doesn't seem to work in ~/.xinitrc
  xinput --map-to-output 'wch.cn USB2IIC_CTP_CONTROL' HDMI-A-0

#Debian Quick Setup:

  #Add your user to sudoers:
  su root
  /usr/sbin/usermod -aG sudo username

  #Reboot:
  sudo reboot

  #Install packages:
  sudo apt-get install -y
    apt-xapian-index                        #quick filter in synaptic
    compiz compiz-mate emerald fusion-icon  #desktop effects
    git
    net-tools                               #ifconfig
    vim
    package-update-indicator
    lightdm-settings
    slick-greeter
    caja-admin caja-extensions-common caja-image-converter caja-open-terminal
    ifuse                                   #iphone mounting
    vlc                                     #media player
    rename
    dconf-editor
    audacious
    silversearcher-ag
    gdebi                                   #GUI to install deb files
    system-config-printer                   #Printer administration
    mozo                                    #MATE menu editor

  System => Preferences => Personal => Startup Applications
    Add
      fusion-icon
      package-update-indicator

  #Grub boot without waiting:
  sudo vi /etc/default/grub
    GRUB_TIMEOUT=0
  sudo update-grub

  #Use these resources:
  mkdir ~/projects
  cd ~/projects
  git clone https://github.com/sblatnick/resources.git
  vi ~/.bashrc
    source ~/projects/resources/config/bashrc

  #Compiz:
    fusion-icon right click
      Emerald Theme Manager => Import...
        ~/projects/resources/compiz/compiz.emerald
      Settings Manager => Preferences => Import As...
        ~/projects/resources/compiz/compiz.profile
        Enter name
      Reload Window Manager

  #Disable desktop icons:
    dconf-editor
    org -> mate -> caja -> desktop
      home-icon-visible
      volumes-visible

  #Synaptic Repositories:
    deb http://deb.debian.org/debian/ testing non-free-firmware non-free contrib main
    deb-src http://deb.debian.org/debian/ testing non-free-firmware non-free contrib main
    deb http://security.debian.org/debian-security/ testing-security main
    deb-src http://security.debian.org/debian-security/ testing-security main
    deb http://deb.debian.org/debian/ testing-updates contrib non-free main
    deb-src http://deb.debian.org/debian/ testing-updates contrib non-free main



