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

  #List groups current user is part of:
    groups

  #List groups of ${user}:
    id -nG ${user}

  #Create group:
    groupadd ${group}

  #Add user to group(s):
    usermod -a -G ${group} ${user}
    usermod -a -G ${group1},${group2},${group3} ${user}

  #Remove by explicitly setting group(s)
    usermod -G ${group1},${group2} ${user}

  #Change primary group:
    usermod -g ${group} ${user}
