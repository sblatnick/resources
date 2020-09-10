#!/bin/bash
#source: http://tldp.org/LDP/lkmpg/2.6/html/index.html
package: module-init-tools
daemon:  kmod

kmod                                                    #kernel module daemon calls modprobe
  modprobe module                                       #loads module by:
    /etc/modprobe.conf                                  #1. alias lookup
      alias module module_name
    /lib/modules/version/modules.dep                    #2. dependency list: depmod -a
    insmod /lib/modules/2.6.11/kernel/module/module.so  #3. loads .so
lsmod                                                   #list modules in /proc/modules
  Module                  Size  Used by
  stp                    12976  1 bridge
  ...
modinfo module.ko                                       #get info/metadata stored in the module

#Authoring:
  CONFIG_MODVERSIONS = on (default) #off means kernel specific

#System Calls: https://man7.org/linux/man-pages/man2/syscalls.2.html

