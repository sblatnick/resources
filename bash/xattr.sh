#!/bin/bash
#xattr = extended attributes, extra metadata (inode) on files
#ext2/ext3 require mounting with user_xattr option

yum install attr

#keys:   <= 255 bytes
  #format: $namespace.$name
  #namespaces:
    user     #open read/write
    security #selinux, write requires CAP_SYS_ADMIN
    trusted  #root, read/write requires CAP_SYS_ADMIN
    system   #ACL, read/write based on policies
#values: <= 64KiB

#tools:
  getfattr
    -n $key                 #get value from key
    -d                      #dump all key=values
    -m $rex                 #regex of keys, - for all
    -h                      #link attr, not the link target

    -R                      #recursive
    #with -R:
      -L                    #follow links (default)
      -P                    #physical, skips links

    -e $enc                 #encode
      text
      hex
      base64

    --absolute-names        #retain leading /
    --only-values           #dump values only
    --version
    --help
    -- $files[@]            #all remaining args are files, even if they start with a -

  setfattr
    -n $key -v $value $file #set extended attribute key to value
    -x $key                 #remove key/value

    -h                      #link attr, not the link target
    --restore=$file         #set keys/values to --dump formatted file

    --version
    --help
    -- $files[@]            #all remaining args are files, even if they start with a -

#APIs:
  getxattr
  setxattr


#Examples:
  #must use a proper namespace:
  setfattr -n wl.enabled -v example file.txt
    setfattr: file.txt: Operation not supported
  #only should work as root:
  setfattr -n security.wl -v a file.txt
  #get specified key/value:
  getfattr -n security.wl file.txt
    # file: file.txt
    security.wl="a"
  #dumps only world readable (user namespace):
  getfattr -d file.txt
    # file: file.txt
    user.wl="example"
  #match all keys:
  getfattr -m '-' file.txt
    # file: file.txt
    security.wl
    user.wl
  #dump all:
  getfattr -dm '-' file.txt
    # file: file.txt
    security.wl="a"
    user.wl="example"

