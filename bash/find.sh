#!/bin/bash

#Find all empty folders:
find . -type d -empty
#Delete all empty folders:
find . -type d -empty -delete
#Find newest modified files:
find ./ -type f -exec stat --format '%Y :%y %n' "{}" \; | sort -nr | cut -d: -f2- | head

find $1 \( -name "*$2" -o -name ".*$2" \) -print |
while read f; do
  echo $f
done

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
  find . -print0 | xargs -0 -iSUB mv SUB /tmp/
  #xargs can take -n1 to limit output to just 1 per run:
  find . -print0 | xargs -0 -iSUB -n1 mv SUB /tmp/
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

#get largest directories (KB) in the current path:
du -sx * 2>/dev/null | sort -r -n | head

#list files which are being used by a process but have been deleted (like a run-away log file):
lsof +L1

cd /
for dir in $(ls */ -d);do echo $dir;cd $dir;du -sx * 2>/dev/null | sort -r -n | head | sed 's/^/  /';cd /;done