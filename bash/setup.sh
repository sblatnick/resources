#!/bin/bash

#ASUS ROG laptop quirks
  #Set power key to act as an END key - See keyboard.sh

  #Keyboard backlight setting from 0 (off) to 3:
    echo 3 > /sys/class/leds/asus::kbd_backlight/brightness

  #UEFI doesn't see linux.  You have to put the efi file where it expects Windows.


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


