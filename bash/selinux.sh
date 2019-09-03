#!/bin/bash

#::::::::::::::::::::SELINUX::::::::::::::::::::

Security Enhanced Linux, created by the NSA
Used for creating policies that restrict processes to have minimal rights
Can apply to: files, directories, ports, devices, etc
Only applied AFTER chmod permissions

tutorial: https://www.digitalocean.com/community/tutorials/an-introduction-to-selinux-on-centos-7-part-1-basic-concepts
how to:   https://wiki.centos.org/HowTos/SELinux

LSM #Linux Security Modules - kernel modules causing "Permission Denied"

#::::::::::::::::::::ACCESS CONTROL::::::::::::::::::::

Access Control Levels:
  Discretionary Access Control (DAC, normal chmod) - See chmod.sh
    chmod
    chown
    umask
  Access Control List (ACL, extended) - See chmod.sh
    getfacl
    setfacl
  Mandatory Access Control (MAC, SELinux)
    Mode Defaults:
      targeted
        Type Enforcement (TE)
        Role-Based Access Control (RBAC, less used)
      mls
        Multi-Level Security (MLS)
        Multi-Category Security (MCS, MLS extension for vms/sVirt/containers)

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
  strict

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

#::::::::::::::::::::CONTEXT::::::::::::::::::::
#AKA: SECURITY CONTEXT LABELS

  Format: user:role:type:mls
  Example: user_u:role_r:type_t:s0:c0
    user_u #SELinux user
    role_r
    type_t #file type | process domain
    s0     #sensitivity (default in SELINUXTYPE=mls)
    c0     #category    (MCS default in SELINUXTYPE=mls)

#....................VIEWING CONTEXTS....................

ls -Z   #files
ps -Z   #processes
id -Z   #users
seinfo -uuser_u -x #se-user user_u
seinfo -ruser_r -x #se-role user_r

#....................CONTEXT INHERITANCE....................

#Inherited from parent directory when:
  cp

#Retain original context when:
  mv
  cp --preserve=context
  cp -c

#....................CONTEXT MODIFICATION....................
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
  semanage login -a -s user_u $user #add user to se-user, effectively removing su since user_u doesn't have su

  semanage login -a -s "staff_u" -r "s0-s0:c0.c1023" $user
    login      #acting on linux login users
    -a         #add to system user
    -s staff_u #se-user staff_u
    -r "$mls"  #set levels/categories (mls)
    $user      #linux user
  #allows user to sudo to other roles:
    sudo -r sysadm_r -i
  #change default role of user:
    /etc/sudoers.d/
      %wheel  ALL=(ALL)       TYPE=sysadm_t   ROLE=sysadm_r   ALL

#::::::::::::::::::::BOOLEAN MODIFICATION::::::::::::::::::::

#Examples:
  getsebool allow_guest_exec_content      #check setting
    guest_exec_content --> on
  semanage login -a -s guest_u user       #make user a guest user
  semanage login -l                       #check mapping
  setsebool allow_guest_exec_content off  #disable guest from executing scripts in their home
  [user@localhost ~]$ ~/myscript.sh
    -bash: /home/user/myscript.sh: Permission denied

#::::::::::::::::::::PORTS::::::::::::::::::::

semanage port -l
#add rule to allow port:
semanage port -a -t http_port_t -p tcp 81 

#::::::::::::::::::::PERMISSIVE TYPES::::::::::::::::::::

#instead of system-wide permissive via setenforce 0,
#just put what you are troubleshooting as permissive

  #log:
    type=AVC msg=audit(1218128130.653:334): avc:  denied  { connectto } for  pid=9111 comm="smtpd" path="/var/spool/postfix/postgrey/socket"
scontext=system_u:system_r:postfix_smtpd_t:s0 tcontext=system_u:system_r:initrc_t:s0 tclass=unix_stream_socket
  #setting:
    semanage permissive -a postfix_smtpd_t
  #unsetting (enforcing):
    semanage permissive -d postfix_smtpd_t


#::::::::::::::::::::COMMANDS::::::::::::::::::::

  chcon         #change context temporarily (across reboots until filesystem relabeled
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

#::::::::::::::::::::POLICIES::::::::::::::::::::

Policies are stored in versioned formats (/etc/selinux/targeted/policy/policy.$version):
  1. source      (versions 12-21)
  2. binary      (versions 15-21)
  3. modular     (list of packages where first is a base module)
  4. policy list (text file)

Compiled into binary modules:
  modules:         /etc/selinux/targeted/modules/active/modules/*.pp
  combined binary: /etc/selinux/targeted/policy/

Restrict access in this order:
  user => role => domain => type

Classes:
  seinfo -c #all classes currently used
  ls /sys/fs/selinux/class #systemd?

Syntax:
  allow domain_t type_t:class { permissions };

Types:
  seinfo -t #all types currently used

  Files:
    Examples:
      allow httpd_t httpd_sys_content_t : file { ioctl read getattr lock open } ;
      allow httpd_t httpd_content_type : file { ioctl read getattr lock open } ;
      allow httpd_t httpd_content_type : file { ioctl read getattr lock open } ;
      allow httpd_t httpdcontent : file { ioctl read write create getattr setattr lock append unlink link rename execute open } ;
      allow user_t bin_t:file { execute };
      allow user_t user_bin_t:file { execute };

  Processes/Services:
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

  Search Examples:
    sesearch -AC -s antivirus_t -t antivirus_t -c process -p execmem
      DT allow antivirus_t antivirus_t : process execmem ; [ antivirus_use_jit ]
        DT = disabled
        antivirus_use_jit = boolean (false)
    #find policies using boolean:
    sesearch -AC -b antivirus_use_jit
    #set boolean (enable policy)
    setsebool -P antivirus_use_jit=1

#::::::::::::::::::::CUSTOM POLICIES::::::::::::::::::::

When booleans cannot solve a given situation
audit2allow helps you generate allow policies from auditd logs

  1. Permissive
    setenforce 0 #permissive
  2. Search auditd logs
    ausearch -c "smtpd" -m AVC,USER_AVC -i
      type=AVC msg=audit(1218128130.653:334): avc:  denied  { connectto } for  pid=9111 comm="smtpd" path="/var/spool/postfix/postgrey/socket"
      scontext=system_u:system_r:postfix_smtpd_t:s0 tcontext=system_u:system_r:initrc_t:s0 tclass=unix_stream_socket
      type=AVC msg=audit(1218128130.653:334): avc:  denied  { write } for  pid=9111 comm="smtpd" name="socket" dev=sda6 ino=39977017
      scontext=system_u:system_r:postfix_smtpd_t:s0 tcontext=system_u:object_r:postfix_spool_t:s0 tclass=sock_file 
  3. Analyze proposed policy
    grep smtpd_t /var/log/audit/audit.log | audit2allow -m postgreylocal > postgreylocal.te #te = type enforcement
      module postgreylocal 1.0;
      require {
              type postfix_smtpd_t;
              type postfix_spool_t;
              type initrc_t;
              class sock_file write;
              class unix_stream_socket connectto;
      }
      #============= postfix_smtpd_t ==============
      allow postfix_smtpd_t initrc_t:unix_stream_socket connectto;
      allow postfix_smtpd_t postfix_spool_t:sock_file write;
  4. Modify as needed
    -allow ...
    +dontaudit ...
  5. Compile policy module
    No modifications? Just pipe in:
      grep smtpd_t /var/log/audit/audit.log > errors.log
      audit2allow -M postgreylocal < errors.log
    Customized?
      checkmodule -M -m -o postgreylocal.mod postgreylocal.te
      semodule_package -o postgreylocal.pp -m postgreylocal.mod
  6. Install policy module
    semodule -i postgreylocal.pp
      installed to: /etc/selinux/targeted/modules/active/modules/postgreylocal.pp
  7. Verify Loaded
    semodule -l

#::::::::::::::::::::LOGS::::::::::::::::::::

grep "SELinux" /var/log/messages #rsyslog
grep "AVC" /var/log/audit/audit.log #auditd

  #auditd log types:

    AVC                   #granted/denied (auditallow/dontaudit policies)
    USER_AVC              #user space: D-Bus, systemd

    SELINUX_ERR           #systemd service has NoNewPrivileges=True and/or calls setcon
    USER_SELINUX_ERR

    MAC_POLICY_LOAD       #When a policy is loaded
    USER_MAC_POLICY_LOAD 

    MAC_CONFIG_CHANGE     #boolean updated via setsebool
    MAC_STATUS            #enforcing/permissive change (setenforce)
    USER_ROLE_CHANGE      #user switched roles via sudo/newrole/login
    USER_LABEL_EXPORT     #user exports labeled object using CUPS

    #Misc:
    MAC_UNLBL_ALLOW, MAC_UNLBL_STCADD, MAC_UNLBL_STCDEL, MAC_MAP_ADD, MAC_MAP_DEL, MAC_IPSEC_EVENT, MAC_CIPSOV4_ADD, MAC_CIPSOV4_DEL.

    #search examples:
      ausearch -m AVC,USER_AVC,SELINUX_ERR,USER_SELINUX_ERR -i
      ausearch --checkpoint="./audit-checkpoint" -m AVC,USER_AVC,SELINUX_ERR,USER_SELINUX_ERR -i
      ausearch -c "httpd" -m AVC,USER_AVC,SELINUX_ERR,USER_SELINUX_ERR -i
      ausearch -m MAC_STATUS -i
      ausearch -m AVC,USER_AVC -i --success yes

      semodule -DB #disable dontaudit module
      ausearch -m AVC,USER_AVC -i
      semodule -B #rebuild with dontaudit


#Examples:
  grep "SELinux is preventing" /var/log/messages
    Aug 23 12:59:42 localhost setroubleshoot: SELinux is preventing /usr/bin/bash from execute access on the file . For complete SELinux messages. run sealert -l 8343a9d2-ca9d-49db-9281-3bb03a76b71a
    Aug 23 12:59:42 localhost python: SELinux is preventing /usr/bin/bash from execute access on the file .
  #details:
  sealert -l 8343a9d2-ca9d-49db-9281-3bb03a76b71a
  sealert -b #gui
  sealert -a /var/log/audit/audit.log

  #service for email or desktop notifications:
    setroubleshootd

#::::::::::::::::::::RELABEL::::::::::::::::::::
genhomedircon #OS upgraded
touch /.autorelabel
reboot


#::::::::::::::::::::MULTI-LEVEL SECURITY::::::::::::::::::::
SELINUXTYPE=mls

MLS #Multi-Level Security (MLS) deny-by-default
MCS #Multi-Category Security

user_u:role_r:type_t:s0-s1:c3.c4  #4th optional field is sensitivity and categories
                     -----------

Sensitivity Levels:
  min:      s0
  max:      s15 #traditionally
  range:    -
  example:  s0-s12 #"current sensitivity"-"clearance sensitivity"

Category:
  min:      c0
  max:      c1023
  range:    .     #example:  c0.c12
  set:      ,     #example:  c0,c3,c5
  

Translation into meaningful output: /etc/selinux/targeted/setrans.conf
  s0:c0=CompanyConfidential
  s0:c3=TopSecret

#The higher a process's sensitivity and category, the more access it has.
#source "domainates" target if superset of categories


#::::::::::::::::::::PACKAGES::::::::::::::::::::
selinux-policy-doc #man pages for policies:
  man httpd_selinux
setools-console
  sesearch
policycoreutils
  fixfiles
  load_policy
  restorecon
  setfiles
  secon
  semodule_deps
  semodule_expand
  semodule_link
  semodule_package
  genhomedircon
  load_policy
  open_init_pty
  restorecond
  run_init
  semodule
  sestatus
  setsebool
policycoreutils-python
  semanage
  audit2allow
  audit2why
  chcat
  sandbox
  sepolgen
  sepolgen-ifgen
  sepolgen-ifgen-attr-helper




