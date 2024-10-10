#!/bin/bash

#List numberic ids of the current user and their primary group and groups:
  id

#::::::::::::::::::::USERS::::::::::::::::::::

  #List all:
    cut -d: -f1 /etc/passwd #distinct users
    users                   #currently logged in
    who                     #users logged in from where

  #Create:
    useradd ${user}         #adduser == useradd
    adduser -u ${uid} -md ${home} ${user}

  #Delete:
    userdel ${user}
    rm -Rf /home/${user}    #delete home directory

  #Modify user name:
    usermod -l ${new} ${old}

  #update user password:
    passwd ${user}
  #change shell for user:
    chsh ${user}
  #change user details:
    chfn ${user}

#::::::::::::::::::::GROUPS::::::::::::::::::::

  #List all groups:
    getent group

  #Get group id:
    getent group docker | cut -d: -f3

  #List groups current user is part of:
    groups

  #List groups of ${user}:
    id -nG ${user}

  #Create group:
    groupadd ${group}

  #Add user to group(s):
    usermod -aG ${group} ${user}
    usermod -aG ${group1},${group2},${group3} ${user}

  #Remove by explicitly setting group(s)
    usermod -G ${group1},${group2} ${user}

  #Change primary group:
    usermod -g ${group} ${user}


#::::::::::::::::::::SSSD::::::::::::::::::::

#To make local customizations:
vi /etc/sssd/conf.d/local.conf
  [sssd]
  domains = default, local

  [domain/local]
  auth_provider = local
  id_provider = local
  description = Default Local Domain
chmod 600 /etc/sssd/conf.d/local.conf
systemctl restart sssd
sss_groupadd ${GROUP}
sss_useradd -G ${GROUP} ${USER}
#FIXME: need to manage user locally with this method