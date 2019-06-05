#!/bin/bash

#::::::::::::::::::::X SESSIONS::::::::::::::::::::

#start another x session
  startx -- :1 (replace with :2, etc)
  #(change file .xinitrc)
  exec /usr/bin/enlightenment
#    *  KDE = startkde
#    * Gnome = gnome-session
#    * Blackbox = blackbox
#    * FVWM = fvwm (or, for FVWM2 it's fvwm2, surprise)
#    * Window Maker = wmaker
#    * IceWM = icewm

#::::::::::::::::::::GLX GRAPHIC ACCELERATION::::::::::::::::::::

#  -b bitrate: set the video bitrate in kbit/s (default = 200 kb/s)
#  -ab bitrate: set the audio bitrate in kbit/s (default = 64)
#  -ar sample rate: set the audio samplerate in Hz (default = 44100 Hz)
#  -s size: set frame size. The format is WxH (default 160×128 )

#Direct Rendering detection (glxgears)
  glxinfo | grep direct

#compiz on nvidia with direct rendering
  __GL_YEILD="NOTHING" compiz --replace --sm-disable --ignore-desktop-hints ccp&


#::::::::::::::::::::WIFI::::::::::::::::::::

#activate:
  sudo modprobe ndiswrapper
#install:
  sudo ndiswrapper -i bcmwl5.inf #(fill out your own drivers for bcmwl5.inf)
#view what's installed:
  sudo ndiswrapper -l (shows if the driver is installed)
#activate and test:
  sudo modprobe ndiswrapper
  sudo dmesg (shows that the card is installed (hopefully))
  sudo iwlist wlan0 scan (shows all APs surrounding you)
#load at bootup:
  sudo ndiswrapper -m

#::::::::::::::::::::GRUB::::::::::::::::::::

#edit grub default settings:
  sudo vi /etc/default/grub
    GRUB_TIMEOUT=0 #set to 0 wait time in grub menu
#apply defaults:
  #CentOS/Redhat:
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
  #Debian:
  sudo update-grub
  
#/boot/grub2/grub.cfg is where new kernels are listed when installed in /boot

#::::::::::::::::::::SYSTEM INFORMATION::::::::::::::::::::

#find system info:
  lshw
  hwinfo
  lspci

#Find your distribution:
  cat /etc/issue
#Find kernel parameters passed at boot by grub:
  cat /proc/cmdline
#show system info like ram/memory bios, etc
  sudo dmidecode

#cpu speeds:
  cat /proc/cpuinfo
#cpu set to performance:
  sudo cpufreq-selector -c 0 -g performance
  sudo cpufreq-selector -c 1 -g performance
#cpu available frequencies:
  cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
#Check Soundcard for Hardware Mixing (playback >1 means it can do hardware mixing)
  cat /proc/asound/pcm

#get linux kernel version:
  uname -r

#get linux version (redhat flavors):
  cat /etc/redhat-release

#default applications are set in:
  /etc/gnome/defaults.list

#Edit gconf-editor from command line:
  #(epiphany setting as example: Loading the clipboard url on middle-click like Mozilla)
  gconftool-2 --set /apps/epiphany/general/middle_click_open_url --type bool true

#find path of an executable:
  which command_name
    which perl
    /usr/bin/perl

#::::::::::::::::::::PROCESS INFORMATION::::::::::::::::::::

  jobs
  ps -elf | grep "process"
  ps -o etime= -p $(pgrep java) #how long java process has been running in days,hrs,etc
  ps -o etimes= -p $(pgrep java) #how long java process has been running in sec
  ps auxwe | grep $pid #full command in process
  ps axjf #like pstree
  pstree
  top
  htop
  jobs -p #get the pids of all thread started from within this shell/script
  pgrep
  pkill
  kill -9 $pid #aggresively kill a stubborn process
  killall

  ps options:
    Selection:
      a       all tty
      x       all non-tty
    Output:
      u       user-oriented format
      f       ASCII-art process hierarchy
      w       wide
      ww      unlimited wide
      e       environment
      j       BSD job control format


#::::::::::::::::::::USERS::::::::::::::::::::
#list distinct users:
cut -d: -f1 /etc/passwd
#list users currently logged in:
users
who
#list groups current user is part of:
groups
#add user:
sudo adduser name
sudo useradd name
#delete user:
sudo userdel name
#then clear the users home if applicable:
sudo rm -Rf /home/name
#modify user name:
usermod -l new_username old_username
#update user password:
sudo passwd username
#change shell for user:
sudo chsh username
#change user details:
sudo chfn username

#::::::::::::::::::::INIT::::::::::::::::::::
#old way is via init scripts:
/etc/init.d/tomcat start
#list:
chkconfig --list

#enabling:
chkconfig tomcat on
chkconfig tomcat off

#::::::::::::::::::::SYSTEMD::::::::::::::::::::
#systemd replaces SysV init.d:
systemctl start tomcat
#list:
systemctl #no arguments
systemctl list-units

#enabling:
systemctl enable tomcat
systemctl disable tomcat
systemctl is-enabled tomcat

#the script it runs is:
/usr/lib/systemd/system/tomcat.service
#logs are now stored via:
journalctl -u tomcat
#tail the log by the follow option:
journalctl -fu tomcat

#enable logs from previous boots:
mkdir /var/log/journal
systemd-tmpfiles --create --prefix /var/log/journal
systemctl restart systemd-journald

#look at previous logs:
journalctl -o short-precise -k -b -1
# -b means what boot relative to 0
# -k means dmesg
# -o means improves the readability to show human readable time

#Instead of modifying the script in /usr/lib/systemd/system/
#I found this note in mariadb.service:

  # It's not recommended to modify this file in-place, because it will be
  # overwritten during package upgrades.  If you want to customize, the
  # best way is to create a file "/etc/systemd/system/mariadb.service",
  # containing
  #  .include /lib/systemd/system/mariadb.service
  #  ...make your changes here...
  # or create a file "/etc/systemd/system/mariadb.service.d/foo.conf",
  # which doesn't need to include ".include" call and which will be parsed
  # after the file mariadb.service itself is parsed.

#Then reload after modifying:
systemctl daemon-reload

#NOTE: I couldn't get it to work through those other files

#See also:
# http://www.dynacont.net/documentation/linux/Useful_SystemD_commands/
# https://blog.hqcodeshop.fi/archives/93-Handling-varrun-with-systemd.html

#remove service:
systemctl stop service
systemctl disable service
rm /usr/lib/systemd/system/service.service /usr/libexec/service
systemctl daemon-reload
systemctl reset-failed #clear failures

#::::::::::::::::::::LIMITS::::::::::::::::::::
#limits on file handles, processes, etc:

#USER:
  #list:
  ulimit -a
  #see a user that can't be logged in:
  sudo -i -u mysql ulimit -a
  #configured in:
  /etc/security/limits.conf
  /etc/security/limits.d/

#SYSTEM:
  #list:
  sysctl -a

  #configured in:
  /etc/sysctl.conf
  /etc/sysctl.d/

  #get one:
  /sbin/sysctl net.ipv4.tcp_challenge_ack_limit

  #flush updates:
  sysctl -p

#::::::::::::::::::::KVM::::::::::::::::::::
virt-manager
virsh list --all
virsh shutdown name
virsh start name
virsh destroy name #shutdown by power off
virsh undefine #delete the vm definition (does not delete volumes, `lvremove /dev/vol0/hostname`)


