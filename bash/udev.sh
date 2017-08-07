#!/bin/bash

#find device paths by listening for the events and connecting/disconnecting:
udevadm monitor

#get attributes for you rules:
udevadm info -a -p /devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2.1/3-2.1:1.0/drm/card1/card1-DVI-I-1

#debug rules on a device:
udevadm test /devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2.1/3-2.1:1.0/drm/card1/card1-DVI-I-1

#rules:
ls /etc/udev/rules.d
#rule syntax:
#conditionals, assignments/actions
ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", SYMLINK+="usb"

#restart udev:
/etc/init.d/udev restart

### Displaylink ### /etc/udev/rules.d/98-custom.rules

# Kensington (right)
KERNEL=="card1-DVI-I-1", ACTION=="add", RUN+="/opt/udev/screens.sh kensington start"
KERNEL=="card1-DVI-I-1", ACTION=="remove", RUN+="/opt/udev/screens.sh kensington stop"

# Plugable (left)
KERNEL=="card2-DVI-I-3", ACTION=="add", RUN+="/opt/udev/screens.sh plugable start"
KERNEL=="card2-DVI-I-3", ACTION=="remove", RUN+="/opt/udev/screens.sh plugable stop"

# screens.sh:
