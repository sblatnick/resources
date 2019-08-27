#!/bin/bash

#::::::::::::::::::::SELINUX::::::::::::::::::::

#Security Enhanced Linux

#SELinux is a Mandatory Access Control (MAC) system developed by the NSA
#as a replacement for Discretionary Access Control (DAC= rwx,chmod,acl,root/sudo)

#sources:
#  https://www.digitalocean.com/community/tutorials/an-introduction-to-selinux-on-centos-7-part-1-basic-concepts
#  https://www.linode.com/docs/security/getting-started-with-selinux/
#  https://opensource.com/business/13/11/selinux-policy-guide
#  https://wiki.centos.org/HowTos/SELinux

#Labelling system of policies
#Can apply to: files, directories, ports, devices, etc
#Only applied AFTER chmod permissions

#::::::::::::::::::::OVERVIEW::::::::::::::::::::

Access Control Levels:
  Discretionary Access Control (DAC, normal)
    chmod
    chown
    umask
    su
    sudo
  Access Control List (ACL, extended)
    getfacl
    setfacl
  Mandatory Access Control (MAC, SELinux)

    Type Enforcement (access vector)
      allow user_t lib_t : file { execute };

      Classes:
        ls /sys/fs/selinux/class


    Role-based Access Control
    User-based Access Control
    MLS - Multi-Level Security

    Labels/Contexts:
      process: user_u:user_r:user_t
        user_u - SELinux user
        user_r - role
        user_t - type
        sensitivity (optional)
      target:  system_u:object_r:lib_t
    Policies:
      allow user_t bin_t:file { execute };
      allow user_t user_bin_t:file { execute };





MCS #Multi-Category Security
LSM #Linux Security Modules - kernel modules causing "Permission Denied"

#::::::::::::::::::::POLICIES::::::::::::::::::::

#source: https://www.digitalocean.com/community/tutorials/an-introduction-to-selinux-on-centos-7-part-1-basic-concepts

An SELinux policy defines user access to roles, role access to domains, and domain access to types.


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

#::::::::::::::::::::SECURITY CONTEXT::::::::::::::::::::

user #system users
role #group of users policies
type #filetypes available to the user

#::::::::::::::::::::BOOLEAN::::::::::::::::::::

getsebool
  $name         #get the named boolean
  -a            #all

setsebool
  $setting ON
  $setting OFF
  -P            #persist through reboots

#::::::::::::::::::::SEMANAGE::::::::::::::::::::

semanage permissive -a mysqld_t


#::::::::::::::::::::VIEWING::::::::::::::::::::

ls -Z #view security context


#::::::::::::::::::::LOGS::::::::::::::::::::

grep "SELinux" /var/log/messages


#::::::::::::::::::::Multi Category Security (MCS)::::::::::::::::::::


#::::::::::::::::::::SELINUXTYPE::::::::::::::::::::
#....................MULTI-LEVEL SECURITY (MLS)....................

#Setting:
  /etc/selinux/config
    SELINUXTYPE=mls


#....................TARGETED....................

#Setting:
  /etc/selinux/config
    SELINUXTYPE=targeted
