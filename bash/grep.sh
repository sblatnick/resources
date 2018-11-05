
#grep:
grep -r 'search' path/
grep -C 15 'search' file.txt #context of 15 lines
grep -B 5 'search' file.txt #only before context of 5 lines
grep -A 5 'search' file.txt #only after context of 5 lines
grep -c 'search' file.txt #print matches (per file with -r)
grep -m 1 'search' file.txt #only get the first match per file

#ack-grep/ack (faster than grep by skipping hidden and binary files):
ack-grep "search"

#ag silversearcher (fastest, rewritten in c):
ag 'search'
ag 'search' --pager 'less -S' #truncating long lines in less
ag 'search' | cut -c1-120 #truncating long lines for consumption to 120 characters

cut -f1 -d' ' <<< "hello world"

#Scan HTTPD configs recursively:
HTTPD_CONF="
  /var/httpd/admin/conf/httpd.conf
  /var/httpd/user/conf/httpd.conf
"

#search for regex without comments:
function search_conf() {
  local regex=$1
  shift

  for configs in $HTTPD_CONF
  do
    echo -e "\033[34;1m${configs##*/}:\033[0m"
    #Included configs:
    while read line
    do
      configs="${configs} ${line##*Include }"
    done < <(grep -P "^\s*Include\s+" "${configs}" 2>/dev/null)

    for conf in $configs
    do
      echo -e "  \033[32m${conf##*/}:\033[0m"
      grep --color=always -P "${regex}" "${conf}" 2>&1 | sed '/^[ ]*#/d' | sed 's/^/    /'
    done
  done
}

#print <Directory> without comments:
function print_directories() {
  for configs in $HTTPD_CONF
  do
    echo -e "\033[34;1m${configs##*/}:\033[0m"
    #Included configs:
    while read line
    do
      configs="${configs} ${line##*Include }"
    done < <(grep -P "^\s*Include\s+" "${configs}" 2>/dev/null)

    for conf in $configs
    do
      echo -e "  \033[32m${conf##*/}:\033[0m"
      perl -ne 'print if /^ *<Directory /i .. /<\/Directory/i' $conf | sed '/^[ ]*#/d' | sed 's/^/    /'
    done
  done
}

#perl print from one to another:
  perl -ne 'print if /^ *<Directory *\//i .. /<\/Directory/i' $file