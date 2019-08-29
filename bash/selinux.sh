#!/bin/bash

#::::::::::::::::::::SELINUX::::::::::::::::::::

#Security Enhanced Linux, created by the NSA
#Used for creating policies that restrict processes to have minimal rights
#Can apply to: files, directories, ports, devices, etc
#Only applied AFTER chmod permissions

#tutorial: https://www.digitalocean.com/community/tutorials/an-introduction-to-selinux-on-centos-7-part-1-basic-concepts

MCS #Multi-Category Security
LSM #Linux Security Modules - kernel modules causing "Permission Denied"

#::::::::::::::::::::COMMANDS::::::::::::::::::::

Access Control Levels:
  Discretionary Access Control (DAC, normal chmod) - See chmod.sh
    chmod
    chown
    umask
  Access Control List (ACL, extended) - See chmod.sh
    getfacl
    setfacl
  Mandatory Access Control (MAC, SELinux)
    chcon         #change context temporarily
      -u user_u   #--user
      -r role_r   #--role
      -t type_t   #--type
      -l range    #--range
      -v          #--verbose
      -h          #--no-dereference or change link instead of target (--dereference default)
      -R          #--recursive
      --reference #use context of the file passed

      #last used takes priority:
      -H          #follow link if passed as an arg
      -L          #follow links
      -P          #don't follow links (default)

      --help
      --version

      $ctx $file

    restorecon    #restore file(s) default SELinux security contexts
      -i          #ignore non-existing files
      -f $file    #list of files, - for stdin
      -e $dir     #exclude directory
      -R, -r      #recursive
      -n          #don't change any file labels
      -o $file    #outfile for list of files with incorrect contexts
      -p          #progress "*" per 1000 files
      -v          #verbose, show changes
      -F          #force reset
      $path

    semodule      #policy modules
                    #bin in /etc/selinux/targeted/modules/active/modules/*.pp
                    #combined bin at boot in /etc/selinux/targeted/policy/
      -l          #list currently loaded

      -i $pkg     #install
      -u $pkg     #upgrade
      -b $pkg     #install/replace base module

      -R          #reload policy
      -d $mod     #disable
      -e $mod     #enable
      -r $mod     #remove
      -s $store   #act on store

      -B          #rebuild & reload policy
      -n          #don't reload
      -Bn         #rebuild policy
      -D          #temporarily disable dontaudits until next build

      -h          #help
      -v          #verbose

    getsebool
      $name       #get the named boolean
      -a          #all

    setsebool
      $s $v       #single setting
      -P          #persist through reboots
      -V          #verbose
      $s1=$v1 ..  #multiple

    semanage
      module      #policy modules
      boolean     #selectively enable functionality
        -l          #--list current booleans
        -C          #list boolean local customizations
        -n          #--noheading

        -1, --on    #Enable the boolean
        -0, --off   #Disable the boolean

        -m          #--modify
        -N          #--noreload
        -S $store   #--store select an alternate SELinux Policy Store to manage

        -E          #--extract customizable commands, for transactions
        -D          #--deleteall

        -h          #help

      permissive  #process type enforcement mode

      import
      export

      login       #login mappings between linux users and SELinux confined users
      user

      port
      interface
      node        #network node type


      fcontext    #file context mapping
      dontaudit   #Disable/Enable dontaudit rules in policy
      ibpkey      #infiniband pkey type
      ibendport   #infiniband end port type definitions

    sesearch
      --allow
      --source domain_t
      --target type_t
      --class file

    matchpathcon  #compares with selinux db
      -V          #verify and make suggestions

#::::::::::::::::::::VIEWING::::::::::::::::::::

ls -Z   #files
ps -Z   #processes


#::::::::::::::::::::POLICIES::::::::::::::::::::


user => role => domain => type

Classes:
  ls /sys/fs/selinux/class #systemd?


allow domain_t type_t:class { permissions };

#Examples:
  allow httpd_t httpd_sys_content_t : file { ioctl read getattr lock open } ;
  allow httpd_t httpd_content_type : file { ioctl read getattr lock open } ;
  allow httpd_t httpd_content_type : file { ioctl read getattr lock open } ;
  allow httpd_t httpdcontent : file { ioctl read write create getattr setattr lock append unlink link rename execute open } ;
  allow user_t bin_t:file { execute };
  allow user_t user_bin_t:file { execute };

#::::::::::::::::::::MODES::::::::::::::::::::

getenforce
  enforcing
  permissive #monitors in /var/log/messages
  disabled

setenforce
  0 #permissive
  1 #enforcing

#Changes between disabled and permissive/enforcing require config and reboot:
/etc/sysconfig/selinux #sysv, or symbolic link to the systemd one
/etc/selinux/config    #systemd
  SELINUX=disabled #| enforcing | permissive
  SELINUXTYPE=targeted #| mls (multi-level security)

SELINUX
  disabled
  enforcing
  permissive
SELINUXTYPE
  targeted    #explicitly restricted processes (default)
  mls         #Multi-Level Security (MLS) deny-by-default

sestatus
  SELinux status:                 enabled
  SELinuxfs mount:                /sys/fs/selinux
  SELinux root directory:         /etc/selinux
  Loaded policy name:             targeted
  Current mode:                   permissive
  Mode from config file:          enforcing
  Policy MLS status:              enabled
  Policy deny_unknown status:     allowed
  Max kernel policy version:      28

kernel arguments from grub (/boot/grub/menu.lst):
  selinux=1   #0: disabled,   1: enabled
  enforcing=0 #0: permissive, 1: enforcing 

#::::::::::::::::::::SECURITY CONTEXT LABELS::::::::::::::::::::

Format: user_u:role_r:type_t:s0
  user_u #SELinux user
  role_r
  type_t #file type | process domain
  s0     #sensitivity (for SELINUXTYPE=mls)


#::::::::::::::::::::CONTEXT INHERITANCE::::::::::::::::::::

#Inherited from parent directory when:
  cp

#Retain original context when:
  mv
  cp --preserve=context
  cp -c

#::::::::::::::::::::CONTEXT MODIFICATION::::::::::::::::::::
chcon #only changes temporarily, lost when file system relabel or by restorecon

#Files
  #existing contexts:
    /etc/selinux/targeted/contexts/files/file_contexts
  #pending contexts:
    /etc/selinux/targeted/contexts/files/file_contexts.local


#1. change context (file_contexts.local):
  semanage fcontext --add --type httpd_sys_content_t "/www/html(/.*)?"
#2. commit (file_contexts):
  restorecon -Rv /www


#::::::::::::::::::::LOGS::::::::::::::::::::

grep "SELinux" /var/log/messages

