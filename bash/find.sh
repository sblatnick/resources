#!/bin/bash

#Find all empty folders:
find . -type d -empty
#Delete all empty folders:
find . -type d -empty -delete
#Find newest modified files:
find ./ -type f -exec stat --format '%Y :%y %n' "{}" \; | sort -nr | cut -d: -f2- | head
find . -type f -exec stat --format '%Y .%y. %n' "{}" \; | sort -nr | cut -d. -f2,5- | head

find . -type f -exec stat --format '%Y .%y. %n' "{}" \; | sort -nr | cut -d. -f5- | head -n 20 |
while read file
do
  echo -e "\033[34m${file}\033[0m"
  tail -n 3 .${file} | sed 's/^/  /'
done

#Find all images excluding hidden folders:
find . -not -path '*/\.*' -name '*' -exec file {} \; | grep -Eo '^.+: \w+ image'

find $1 \( -name "*$2" -o -name ".*$2" \) -print |
while read f; do
  echo $f
done

#Find all file extensions for ascii test filetypes:
find . -type f -exec file -i "{}" \; | grep -P 'charset=us-ascii$' | cut -d: -f1 | grep -Po '\.[^./]*$' | sort | uniq -c | sort -nr

#Find file/class in jars:
for i in *.jar; do jar -tvf $i | grep ClassName && echo "$i"; done

#conditionals:
  # -or == -o
  # -not == \!
  # grouping: \( \)

# prune is less intuitive because it disables printing by default:
find . -path ./.git -prune -or -print

#run command:
  find ./ -type f -name "*.txt" -exec gedit "{}" \;

#actions using xargs:
  #move all found directories somewhere:
  find . -print0 | xargs -0 -ISUB mv SUB /tmp/
  #xargs can take -n1 to limit output to just 1 per run:
  find . -print0 | xargs -0 -ISUB -n1 mv SUB /tmp/
  #otherwise, xargs takes the max arguments per run of the command
  #-print0 and -0 make sure that things are delimited by a null character to
  #handle spaces and newlines correctly

  #Check a bunch of files for discrepancies between data and data/production
  function check_diff() {
    file=${1/\.\//}
    d=$(diff -u "$file" "${file/data\//data\/production\/}" 2>/dev/null)
    case "$?" in
      0)
          echo -e "$file \033[32mno change\033[0m"
        ;;
      1)
          echo -e "$file \033[33mdifferences\033[0m:"
          echo "$d" | sed 's/^/  /'
        ;;
      *)
          echo -e "$file \033[31mmissing\033[0m"
        ;;
    esac
  }
  export -f check_diff
  find . -not -path './data/production*' -type f \( -ipath '*_name*' -or -path '*_name2*' \) | grep '\.txt' | grep -Ev 'svn|git' | xargs -n 1 -I {} bash -c 'check_diff "$@"' _ {}

#locate file:
  locate filename

#pipe find to find with files with >=8 digits:
  find -L /path/ -maxdepth 4 -iname folder -type d | xargs -0 -I{} find '{}' -regextype posix-extended -type f -regex '.*[^/]{8,}'

#Get largest directories under root:
find / -xdev -maxdepth 2 | grep -Po '^/.*/' | sort -u | xargs -I '{}' du -shx '{}' | sort -rh

#get largest directories (KB) in the current path:
du -shx * 2>/dev/null | sort -rh | head

#hidden directory sizes:
ls -1A | grep '^\.' | xargs -I '{}' du -shx '{}' | sort -rh

#Truncate deleted file with a process holding it:
# https://serverfault.com/questions/232525/df-in-linux-not-showing-correct-free-space-after-file-removal/232526
lsof +L1 | grep maillog
  rsyslogd 15114    root   23w   REG  253,0 11841540096     0  37637214 /var/log/maillog-20210530 (deleted)
cd /proc/15114/fd
ls -l |grep deleted
  l-wx------ 1 root root 64 Jun 25 12:19 23 -> /var/log/maillog-20210530 (deleted)
> 23

#in parallel (consider adding `timeout`):
  TMP=/dev/shm/size.tmp
  rm -f ${TMP}
  for here in $(ls -lQ | grep -P '^[d-]' | cut -d'"' -f2)
  do
    du -shx ${here} >> ${TMP} &
  done

  #optional if taking a while:
  for job in $(jobs -p)
  do
    wait $job
  done

  sort -rh ${TMP} | head

#find any files >=100MB
find -type f -size 100M

#list files which are being used by a process but have been deleted (like a run-away log file):
lsof +L1

cd /
for dir in $(ls */ -d);do echo $dir;cd $dir;du -sx * 2>/dev/null | sort -r -n | head | sed 's/^/  /';cd /;done

#Permissions:
  -perm 0400  #exact
    -0111 would only match 0111
  -perm -0400 #all match
    -0111 would match 0755, 0744, etc
  -perm /0037 #any match
    -0037 would match any:
      group  wx  0020 || 0010
      others rwx 0004 || 0003 || 0001
  -ls #print permissions like ls -l

#Set sticky bit on all world writable, skipping spool directory:
df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' build -not \( -path '/var/spool/*' -prune \) -xdev -type d -perm -0002 2>/dev/null | \
while read path
do
  mode=$(stat -c '%f' ${path})
  if [ $(( 0x0200 & 0x${mode} )) -eq 0 ];then
    chmod a+t ${path}
    echo -e "  ${path} \033[33mupdated\033[0m"
  fi
done