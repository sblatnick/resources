
grep
  #files
    -r            #recursive search
    -R            #recursive search following links
    -f $file      #use each line as patterns
    -a            #binary files considered text

  #pattern matching
    -E            #use extended regex
    -P            #use Perl regex
    -F            #fixed strings
    -i            #case insensitive
    -m $N         #matches N occurences then exits (per file if used with -r)
    -v            #invert matches
    -w            #match words only (whitespace surrounding)
    -x            #whole line matching

  #output
    #format
      --color     #auto | never | always
      -q          #don't output results
      -s          #silence any error messages
      -o          #only output matching patterns instead of lines

      --line-buffered    #prevent pipes from slowing output

    #prefix
      -H          #with filenames
      -h          #no filenames
      --label $l  #custom prefix for stdin
      -n          #line number
      -T          #tab indent from prefix

    #results (instead of matches)
      -c          #count (per file if used with -r)
      -l          #files with matches
      -L          #files without matches

  #context lines
    -C $N         #before && after context
    -B $N         #before
    -A $N         #after

    --group-separator    #change string between contexts (default = '--')
    --no-group-separator #use '' between contexts


#grep | line buffering:
#  grep uses line buffering only in a terminal, and because of the pipe,
#  it thinks it isn't running in a terminal
#You can force line buffering with the --line-buffered option
  grep --line-buffered | program
#source: https://blog.jpalardy.com/posts/grep-and-output-buffering/

#search for every match:
grep -F 'RCPT TO: <admin@intra.net>' pipe_log | grep -Po 'Thread-\d+' | xargs -n 1 -I{} grep {} pipe_log

#don't match sub-string (how to ignore ! in "")
  value='bad'
  set +H #disable history expansion
  #match anything but:
  grep -P "((?!${value}).)," file.txt
  #source: https://stackoverflow.com/questions/406230/regular-expression-to-match-a-line-that-doesnt-contain-a-word

#ack-grep/ack (faster than grep by skipping hidden and binary files):
ack-grep "search"

#ag silversearcher (fastest, rewritten in c):
ag 'search'
ag 'search' --pager 'less -S' #truncating long lines in less
ag 'search' | cut -c1-120 #truncating long lines for consumption to 120 characters

#search for one pattern, but only highlighting another:
ag --color -H --color-match '0' '^[^#\n]*reboot' | ag --passthrough 'reboot'

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