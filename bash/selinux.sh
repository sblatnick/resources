#!/bin/bash

#::::::::::::::::::::SELINUX::::::::::::::::::::

#Security Enhanced Linux, created by the NSA
#Used for creating policies that restrict processes to have minimal rights
#Can apply to: files, directories, ports, devices, etc
#Only applied AFTER chmod permissions

#tutorial: https://www.digitalocean.com/community/tutorials/an-introduction-to-selinux-on-centos-7-part-1-basic-concepts

LSM #Linux Security Modules - kernel modules causing "Permission Denied"

#Policies are stored in formats (/etc/selinux/targeted/policy/policy.$version):
  #1. source      (versions 12-21)
  #2. binary      (versions 15-21)
  #3. modular     (list of packages where first is a base module)
  #4. policy list (text file)

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
      $topic      #common args for all topics
        #List:
        -l          #--list       List the OBJECTS
        -C          #--locallist  List OBJECTS local customizations
        -n          #--noheading  Do not print heading when listing OBJECTS
        #CRUD:
        -m          #--modify     Modify a OBJECT record NAME
        -a          #--add        Add a OBJECT record NAME
        -d          #--delete     Delete a OBJECT record NAME
        -D          #--deleteall  Remove all OBJECTS local customizations
        #Transactions:
        -E          #--extract    extract customizable commands
        -i          #--input      Input multiple semange commands in a transaction
        -o          #--output     Output current customizations as semange commands
        #Misc:
        -N          #--noreload   Do not reload policy after commit
        -S          #--store      Select and alternate SELinux store to manage
        -h          #--help       Display this message
      $object     #common args for all objects
        #Enable:
        --enable    #Enable a module
        --disable   #Disable a module
        #Selection:
        -R          #--roles      SELinux Roles
        -s          #--seuser     SELinux User Name
        -t          #--type       SELinux Type for the object
        -f          #--ftype      File Type of OBJECT
          ""          #all files
          --          #regular file
          -d          #directory
          -c          #character device
          -b          #block device
          -s          #socket
          -l          #symbolic link
          -p          #named pipe
        -F $file    #--file       list of OBJECTS, - for stdin
        #Network:
        -p          #--proto      Port protocol (tcp or udp) or internet protocol version of node (ipv4 or ipv6)
        -M          #--mask       Netmask
        #Path:
        -e          #--equal      Substitue source path for dest path when labeling
        -P          #--prefix     Prefix for home directory labeling
        #MLS/MCS Systems only:
        -L          #--level      Default SELinux Level
        -r          #--range      MLS/MCS Security Range
      #Topics:
        permissive  #process type enforcement mode
        import
        export
      #Objects:
        module      #policy modules
        boolean     #selectively enable functionality
          -1, --on    #Enable the boolean
          -0, --off   #Disable the boolean
        login       #login mappings between linux users and SELinux confined users
          #Defaults -l:
          users       se-user      #notes
          ------------------------------------
          __default__ unconfined_u #most users
          root        unconfined_u #root user
          system_u    system_u     #services
        user        #selinux users
          #Defaults -l:
          se-user   xserver  networking su/sudo #notes
          --------------------------------------------
          guest_u   no       no         no
          xguest_u  yes      yes        no
          user_u    yes      config     no
          staff_u   yes      config     yes
          system_u                              #system services
        #Network:
        port
        interface
        node        #network node type
        #Misc:
        fcontext    #file context mapping
        dontaudit   #Disable/Enable dontaudit rules in policy
        ibpkey      #infiniband pkey type
        ibendport   #infiniband end port type definitions

    sesearch      #search policies/rules
      #types (must specify one):
        -A        #--allow
        --neverallow
        --auditallow
        --dontaudit
        -T        #--type searches for type_(transition|member|change) rules
        --role_allow
        --role_trans
        --range_trans
        --all
      #expressions
        -s        #--source
        -t        #--target
        --role_source
        --role_target
        -c        #--class
        -p        #--perm "permission1,permission2"
        -b        #--bool
      #options
        -d        #--direct literal (no *, self)
        -R        #--regex symbol names
        -n        #--linenum if available, ignored with -S
        -S        #--semantic vs syntactic
        -C        #--show_cond print conditional expressions

        -h        #--help
        -V        #--version

    seinfo        #policy query tool
      #expressions
        #list of objects or ${name}, expanded via -x:
          -${o}${name}
          --${obj}=${name}
        #objects:
          -c      #--class
          --sensitivity
          --category
          -t      #--type (not including aliases or attributes)
          -a      #--attribute
          -r      #--role
          -u      #--user
          -b      #--bool
          --initialsid #initial SID(s)
          #filesystem:
          --fs_use
          --genfscon
          #network:
          --netifcon  #netif context
          --nodecon   #node context 
          --portcon   #port context
            --protocol=PROTO  #filter portcon statements for specified protocol
          --constrain #list of constraints
          --all       #all components
      #options
        -x          #--expand additional details
        --stats     #type, version, and component/rule counts
        -l          #line breaks in constraints
        -h          #help
        -V          #--version

    matchpathcon  #compares with selinux db
      -V          #verify and make suggestions
    ausearch      #search auditd logs
    sealert       #selinux details of error
      -l $id        #UUID of error in /var/log/messages

#::::::::::::::::::::VIEWING::::::::::::::::::::

ls -Z   #files
ps -Z   #processes
id -Z   #users
seinfo -uuser_u -x #se-user user_u
seinfo -ruser_r -x #se-role user_r

#::::::::::::::::::::POLICIES::::::::::::::::::::


user => role => domain => type

Classes:
  ls /sys/fs/selinux/class #systemd?

#Syntax:
  #Allow:
    allow domain_t type_t:class { permissions };

#Files:

  #Examples:
    allow httpd_t httpd_sys_content_t : file { ioctl read getattr lock open } ;
    allow httpd_t httpd_content_type : file { ioctl read getattr lock open } ;
    allow httpd_t httpd_content_type : file { ioctl read getattr lock open } ;
    allow httpd_t httpdcontent : file { ioctl read write create getattr setattr lock append unlink link rename execute open } ;
    allow user_t bin_t:file { execute };
    allow user_t user_bin_t:file { execute };

#Processes/Services:
  init (process) => exe (file) => target (process)

  init   #originator domain of the process, short lived
    class: process
    type:  init_t
  exe    #executable file used to start the process
    class: file
    type: exe_t
  target #running process
    class: process
    type: target_t

  #To allow process, all 3 paths must be permitted:
    init ={execute}> exe ={entrypoint}> target
        \=       {transition}         >/

    #1. execute:    init => exe      (a to b)
      sesearch -s init_t -t exe_t -c file -p execute -Ad
        allow init_t exe_t : file { execute } ;
    #2. entrypoint: exe => target    (b to c)
      sesearch -s target_t -t exe_t -c file -p entrypoint -Ad
        allow target_t exe_t : file { entrypoint } ;
    #3. transition: init => target   (a to c)
      sesearch -s init_t -t target_t -c process -p transition -Ad
        allow init_t target_t : process transition ;

  #Unconfined process domain:
    unconfined_t

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


#::::::::::::::::::::USER/ROLE MODIFICATION::::::::::::::::::::

#Examples:
  semanage login -a -s user_u user #add user to se-user, effectively removing su since user_u doesn't have su

#::::::::::::::::::::BOOLEAN MODIFICATION::::::::::::::::::::

#Examples:
  getsebool allow_guest_exec_content      #check setting
    guest_exec_content --> on
  semanage login -a -s guest_u user       #make user a guest user
  semanage login -l                       #check mapping
  setsebool allow_guest_exec_content off  #disable guest from executing scripts in their home
  [user@localhost ~]$ ~/myscript.sh
    -bash: /home/user/myscript.sh: Permission denied

#::::::::::::::::::::SERVICE ACCESS::::::::::::::::::::
  #TODO: "SELinux in Action 3: Restricting Access to Services"

#::::::::::::::::::::LOGS::::::::::::::::::::

rsyslogd: /var/log/messages
auditd:   /var/log/audit/audit.log

grep "SELinux" /var/log/messages

#Examples:
  grep "SELinux is preventing" /var/log/messages
    Aug 23 12:59:42 localhost setroubleshoot: SELinux is preventing /usr/bin/bash from execute access on the file . For complete SELinux messages. run sealert -l 8343a9d2-ca9d-49db-9281-3bb03a76b71a
    Aug 23 12:59:42 localhost python: SELinux is preventing /usr/bin/bash from execute access on the file .
  #details:
  sealert -l 8343a9d2-ca9d-49db-9281-3bb03a76b71a

#::::::::::::::::::::MULTI-LEVEL SECURITY::::::::::::::::::::
SELINUXTYPE=mls

MLS #Multi-Level Security (MLS) deny-by-default
MCS #Multi-Category Security

user_u:role_r:type_t:s0-s1:c0.c2  #>=4th optional field is sensitivity and categories
                     -----------

Sensitivity Levels:
  min:      s0
  max:      s15 #traditionally
  range:    -
  example:  s0-s12 #"current sensitivity"-"clearance sensitivity"

Category:
  min:      c0
  max:      c1023
  range:    .
  example:  c0.c12

Translation into meaningful output: /etc/selinux/targeted/setrans.conf
  s0:c0=CompanyConfidential
  s0:c3=TopSecret

#The higher a process's sensitivity and category, the more access it has.
