#!/bin/bash

#::::::::::::::::::::VARIABLES::::::::::::::::::::
  #no spaces!
  variable=34
  # use $ after declared
  echo "$variable"
  # use {} to separate variable from content
  echo "${variable}stuff"

  #DEFAULT VALUE VARIABLE
    #read variable with default:
      echo "${myname-John Doe}"
      echo "${myname:-John Doe}" #declared, but null
    #set variable with default:
      echo "${myname=John Doe}"
      echo "${myname:=John Doe}" #declared, but null

#::::::::::::::::::::READ::::::::::::::::::::

  echo -n "type something: "
  read variable
  echo $variable "is what you typed!"

#::::::::::::::::::::SUB-SHELL::::::::::::::::::::

  #Keep a scripts variables by not running in a sub-shell:
    #running the program with
      . ./executable
    #instead of:
      ./executable

  #COMMAND SUBSTITUTION:
    files=$(ls)
    files=`ls`

#::::::::::::::::::::QUOTES::::::::::::::::::::
'' #raw
"" #pre-render
`` #pre-execute

#::::::::::::::::::::VARIABLE MANIPULATION::::::::::::::::::::
  ${variable%pattern}    #Trim the shortest match from the end
  ${variable##pattern}   #Trim the longest match from the beginning
  ${variable%%pattern}   #Trim the longest match from the end
  ${variable#pattern}    #Trim the shortest match from the beginning

  #question mark matches any character:
  ${variable%?}          #Trim the last character no matter what it is

  #get substring range:
  ${variable:0:3} #first 3 characters

  #array expressions work in bash 4.2 and above:
  ${variable::-1}        #Trim last character
  #pre-4.2 use spaces:
  ${variable: : -1}
  #see: https://unix.stackexchange.com/questions/144298/delete-the-last-character-of-a-string-using-string-manipulation-in-shell-script

  #Bash 4+:
  ${variable,,} #lower case
  #source: https://stackoverflow.com/questions/41166026/what-does-2-commas-after-variable-name-mean-in-bash

  #Given:
    foo=/tmp/my.dir/filename.tar.gz

  #We can use these expressions:

  path=${foo%/*}
    #To get: /tmp/my.dir (like dirname)
  file=${foo##*/}
    #To get: filename.tar.gz (like basename)
  base=${file%%.*}
    #To get: filename
  ext=${file#*.}
    #To get: tar.gz

  #Replace substrings:
    #first:
      ${string/substring/replacement}
    #all:
      ${string//substring/replacement}

  #pad number:
    i=99
    printf -v j "%05d" $i
    echo $j #stored into j from printf

  #run on a sequence of numbers that are padded:
    for i in $(seq -f "%05g" 10 15)
    do
      echo $i
    done

  #get the value of a variable by variable name (reflection, or parameter expansion):
    example="name"
    name="My Name"
    echo ${!example} #prints: My Name

  #store variable by name:
    example="name"
    declare $example="My Name"
    echo $name #prints: My Name
    echo ${!example} #prints: My Name


#::::::::::::::::::::ARITHMETIC::::::::::::::::::::

echo $((125924 + 31097))
echo $(($variable + 125924))
echo $((125924 + variable))

#increment:
  (( n += 1 ))
  ((n++))
#WRONG: (( $n += 1 ))

#division with formatting:
progress=$(echo "${DONE}" "${TOTAL}" | awk '{printf "%.1f", $1/$2 * 100}' 2>/dev/null)
bc <<< 'scale=2; 100/3'

#bc can use variables (separate logic with newlines or semicolons):
$ bc <<< 'four=4;3+four'
7

#extract digits:
digits=$(tr -cd 0-9 <<<"spy007")
#remove 0 padding:
number=$((10#$digits))

#::::::::::::::::::::OPERATORS::::::::::::::::::::

  #ARITHMATIC:
    X=`expr 3 \* 2 + 4` #escape *
    #WRONG: X=`expr "3 * 2 + 4"`
    #WRONG: X=`expr "3 \* 2 + 4"`

  #Substitute all:
    echo "hello world" | tr 'hell' '+' #++++o wor+d

#::::::::::::::::::::PARAMETER VARIABLES::::::::::::::::::::

$0    # basename of program, but use `basename $0` to get just the program
      # (in case the user called it with a path)
$1    # ... $9  first 9 parameters
$@    # all parameters
$*    # all parameters delimited, even if in quotes or with spaces
      # (like "hello world" becomes "hello" "world")
$#    #number of parameters
$?    #exit value of the last run command (error detection, use after you run
      # something to see if it worked)
$$    #PID (process ID number) of currently running shell, usefull for temp
      # file generation in case the script is ran more than once before completion
$PPID #parent pid
$!    #PID of last running background process
      # "This is useful to keep track of the process as it gets on with its job."

#$! is kinda tricky to use:
  set -e
  pid=$$
  echo "Running installer:"
  { ./installer.sh & echo $! > /tmp/${pid} ; } 2>&1 | sed 's/^/  /' || :
  log="/tmp/installer_$(</tmp/${pid}).log"
  echo "Log: $log"
  cat $log | sed 's/^/  /'
  rm -f $log /tmp/${pid}

  #Parts:
  #  ./installer.sh & echo $!  = run in background so you can echo the pid
  #  > /tmp/${pid}             = output into a temp file
  #  { ; }                     = run in a subshell
  #  2>&1 | sed 's/^/  /'      = indent stdout and stderr
  #  || :                      = skip exiting on errors if using set -e

set -e #error stops execution
set +e #error continues execution (default)
set -x #print every command executed to stdout

set -Eeuxo pipefail
  -e          #error stops execution
  -o pipefail #sets exit status $? to rightmost non-zero exit code
  -u          #unset variables throw an error, use defaults: if [ -z "${VARIABLE:-}" ]
  -x          #print commands executed
  -E          #allow ERR to execute trap before -e causes an exit (alternatively the trap can call exit)
  #source: https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

  #see: http://linuxcommand.org/lc3_man_pages/seth.html
  +H          #disable $! history substitution (helpful for regex not match word expressions: "(?!${value}),"

#Export all variables:
  set -a
    IMAGE=trivy
    BIN=/opt/trivy/trivy
  set +a
  #End export

#::::::::::::::::::::GLOBAL VARIABLES::::::::::::::::::::
#Internal Field Separator (See ARRAYS)
  IFS='
'
  # (notice it's on two lines) allows the array to be divided by different things
  # default = SPACE TAB NEWLINE
  # recommended to be backed up if only for one part of the script

  EDITOR=geany #Set default editor
  PATH #Search path for executables
  echo `pwd` #working directory
  echo `basename $0` #name of the program, same as ${0%/*}
  echo `dirname $0` #directory of the program, same as ${0##*/}

  $RANDOM #built in bash function creating a random integer
  echo $(($RANDOM % 100)) #random int from 0 to 99
  echo $(expr $RANDOM % 1000)

  #terminal width/height:
    $LINES
    $COLUMNS

  #Bash Variables: https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html
  #script.sh:
    #!/bin/bash

    VARS="BASH
    BASHOPTS
    BASH_ARGC
    BASH_ARGV
    BASH_CMDS
    BASH_COMMAND
    BASH_LINENO
    BASH_SOURCE"

    for var in $VARS
    do
      printf "%-22s %s\n" "${var}:" "${!var}"
    done


  ~ $ ./script.sh example script
  BASH:                  /bin/bash
  BASHOPTS:
  BASH_ARGC:             2
  BASH_ARGV:             script
  BASH_CMDS:
  BASH_COMMAND:          printf "%-22s %s\n" "${var}:" "${!var}"
  BASH_LINENO:           0
  BASH_SOURCE:           ./script.sh

  #Full path to script:
    readlink -f ${BASH_SOURCE}
  callee
    script.sh 0
  PARENT_COMMAND=$(ps -o comm= $PPID)
    parent_script.sh
  PARENT_COMMAND=$(ps -o args= $PPID)
    parent_script.sh --args --included
  #source: https://stackoverflow.com/questions/20572934/get-the-name-of-the-caller-script-in-bash-script

  #Write `set -x` output to it's own log:
  exec 3> $LOG
  BASH_XTRACEFD=3
  #resource: https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html

  #recursive stack trace:
    #!/bin/bash
    function stack() {
      pid=${1-$$}
      depth=${2-1}
      indentation=$(printf '  %.0s' $(seq ${depth}))
      if [[ 1 -eq ${depth} ]];then
        printf "%-5s${indentation}%s\n" "PID" "COMMAND"
      fi
      printf "%-5s${indentation}%s\n" ${pid} "$(ps -o args= $pid)"
      ppid=$(ps -o ppid= $pid)
      if [[ 1 -ne ${ppid} ]];then
        stack ${ppid} $((depth+1))
      fi
    }

#::::::::::::::::::::HISTORY EXPANSION::::::::::::::::::::

  history | less #view history with line numbers
  !24 #run 24th line in history
  !! #run the last command
  !!:/bash/ash/ #re-runs last command replacing text
  !?bash?:s/bash/ash/ #re-runs last matching command replacing text
  !?bash?:s/%/ash/
  !-3 #execute 3rd to last command
  !echo #execute last command starting with 'echo'

#::::::::::::::::::::HEX/BITMASKS::::::::::::::::::::

#Make sure a bitmap is at least as restrictive:
  grep -PHon "^\s*create\s+\d+\s+.+\s+.+" /etc/logrotate.d/service | sed -r 's/[: ]+/ /g' | \
  while read file line create bitmask user group
  do
    if [ $((0x${bitmask} | 0x740)) -gt $((0x740)) ];then
      new=$(printf "%03x\n" $((0x${bitmask} & 0x740)))
      sed -i "${line} s/ ${bitmask}/ ${new}/" ${file}
      echo -e "    ${file}:${line} \033[33mupdated\033[0m ${bitmask} to ${new}"
    fi
  done

#Make sure the umask is as restrictive (SAR config):
  grep -PHon "^\s*umask\s+\d+" /usr/lib64/sa/sa1 /usr/lib64/sa/sa2 | sed -r 's/[: ]+/ /g' | \
  while read file line umask bitmask
  do
    if [ $((0x${bitmask} & 0x37)) -lt $((0x37)) ];then
      new=$(printf "%04x\n" $((0x${bitmask} | 0x37)))
      sed -i "${line} s/ ${bitmask}/ ${new}/" ${file}
      echo -e "    ${file}:${line} \033[33mupdated\033[0m ${bitmask} to ${new}"
    fi
  done


#::::::::::::::::::::REGEX::::::::::::::::::::
#by Mitch Frazier, the System Administrator at Linux Journal.

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 PATTERN STRINGS..."
  exit 1
fi
regex=$1
shift
echo "regex: $regex"
echo

while [[ $1 ]]
do
  if [[ $1 =~ $regex ]]; then
    echo "$1 matches"
    i=1
    n=${#BASH_REMATCH[*]}
    while [[ $i -lt $n ]]
    do
      echo "  capture[$i]: ${BASH_REMATCH[$i]}"
      let i++
    done
  else
    echo "$1 does not match"
  fi
  shift
done

#Resource: http://steve-parker.org/sh/sh.shtml

#Use regex to find if string in array (doesn't handle spaces):
  if [[ " ${array[*]} " =~ " ${value} " ]]; then
    # whatever you want to do when array contains value
  fi

  if [[ ! " ${array[*]} " =~ " ${value} " ]]; then
    # whatever you want to do when array doesn't contain value
  fi
  #source: https://stackoverflow.com/questions/3685970/check-if-a-bash-array-contains-a-value

#::::::::::::::::::::GLOBBING::::::::::::::::::::

*           #matches any characters
?           #matches any one character
[abc]       #matches any one character in the list
{this,that} #matches this or that


#::::::::::::::::::::EXTENDED GLOBBING::::::::::::::::::::

shopt -s extglob #set extended globbing

  ?(pattern-list) #Matches zero or one occurrence of the given patterns
  *(pattern-list) #Matches zero or more occurrences of the given patterns
  +(pattern-list) #Matches one or more occurrences of the given patterns
  @(pattern-list) #Matches one of the given patterns
  !(pattern-list) #Matches anything except one of the given patterns

shopt -u extglob #unset extended globbing

#Source: https://stackoverflow.com/questions/216995/how-can-i-use-inverse-or-negative-wildcards-when-pattern-matching-in-a-unix-linu

#get all directories without profile_ or role_ as a prefix:
ls -d !(@(profile|role)_*)
  #this does NOT work because ! is for only one pattern (returns all directories):
  ls -d !({profile,role}_*)

#::::::::::::::::::::READ::::::::::::::::::::

#Array comma-delimited:
  IFS=',' read -ra PACKAGES <<< "$packages"
  echo ${PACKAGES[@]}
#space-delmited into separate variables:
  read month day year time < <(grep 'ERROR' /var/log/mcafee/solidcore/solidcore.log | tail -n 1 | grep -Po '[^\s]+ \d+ \d\d\d\d:\d\d:\d\d:\d\d' | sed 's/:/ /')
#tab-delmited data line by line:
  local IFS=$'\n'
  while IFS=$'\t' read -u 3 host role
  do
    echo -e "  \033[34m${host%%.*}\033[0m ${role}"
  done 3< <(jq -r ".[] | select(.id == \"${id}\") | [.hostname, .role] | @tsv" file.json)
  #IMPORTANT: must have a trailing new line to get the last line

#::::::::::::::::::::MULTITHREADED VARIABLES::::::::::::::::::::

#source: http://stackoverflow.com/questions/13207292/bash-background-process-modify-global-variable

#Store variables in shared memory to reduce file IO in /dev/shm
pid=$$
rm /dev/shm/total.$pid /dev/shm/files.$pid 2>/dev/null

thread() {
  number=10
  file="filename.txt"
  echo $file >> /dev/shm/files.$pid #keep a list of files
  echo $number >>/dev/shm/total.$pid #increment by $number, append to prevent race conditions
}

threads=4
thread &
thread &
thread &
thread &

old=0
while [ $(wc -l /dev/shm/total.$pid | cut -f1 -d' ') -lt "$threads" ]
do
  current=$(wc -l /dev/shm/total.$pid | cut -f1 -d' ')
  if [ $old -ne $current ];then
    old=$current
    printf "  (%4s/%4s) %s\n" "$old" "$threads" "$(date)"
  fi
  sleep 1
done
printf "  (%4s/%4s) DONE %s\n" "$old" "$threads" "$(date)"

echo "RESULTS:"
current=$(wc -l /dev/shm/total.$pid | cut -f1 -d' ')
echo "  count: $current"
total=$(awk '{sum+=$1} END {print sum}' /dev/shm/total.$pid)
echo "  no change: $total"
echo "  files:"
cat /dev/shm/files.$pid | sed 's/^/    /'
rm /dev/shm/total.$pid /dev/shm/files.$pid 2>/dev/null

#don't use this in multiple threads, or there could be a race condition between
#read and write:
echo $(($(</dev/shm/foo)+1)) >/dev/shm/foo;
#instead, use a lock file:
#source: http://stackoverflow.com/questions/169964/how-to-prevent-a-script-from-running-simultaneously
(
  # Wait for lock on /var/lock/.myscript.exclusivelock (fd 200) for 10 seconds
  flock -x -w 10 200 || exit 1

  # Do stuff

) 200>/var/lock/.myscript.exclusivelock

#source: https://unix.stackexchange.com/questions/22044/correct-locking-in-shell-scripts
lockfile=/var/tmp/mylock

if ( set -o noclobber; echo "$$" > "$lockfile") 2> /dev/null; then

  trap 'rm -f "$lockfile"; exit $?' INT TERM EXIT

  # do stuff here

  # clean up after yourself, and release your trap
  rm -f "$lockfile"
  trap - INT TERM EXIT
else
  echo "Lock Exists: $lockfile owned by $(cat $lockfile)"
fi

#::::::::::::::::::::EXCEPTION HANDLING::::::::::::::::::::
#EXCEPTION HANDLING using $? (try/catch):
  /usr/local/bin/my-command
  if [ "$?" -ne "0" ]; then
    echo "Sorry, we had a problem there!"
  fi

  #PIPE error handling:
    #PIPESTATUS:
    ./example.sh 2>&1 | tee -a $log_file
    if [ "${PIPESTATUS[0]}" -ne 0 ];then
      echo "ERROR in example.sh"
      exit 1
    fi

    #pipefail: set $? to the exit code of the last program to exit non-zero (or zero if all exited successfully)
    set -o pipefail
    false | true; echo $?

    #break up into parts:
    output=$(./example.sh)
    if [ "$?" -ne "0" ]; then
      echo "ERROR in example.sh"
      exit 1
    fi
    printf '%s' "$OUTPUT" | tee -a $log_file
  #see: https://unix.stackexchange.com/questions/14270/get-exit-status-of-process-thats-piped-to-another/73180#73180

  set -e #causes a script to abort with any error
  set +e #reverts error setting


#::::::::::::::::::::MULTILINE STRING/COMMENT::::::::::::::::::::

#"EOF" = no escaping, just variable interpolation
#'EOF' = no escaping, no variables
#<<-   = trim proceeding newline

#See: https://unix.stackexchange.com/questions/399488/keep-backslash-and-linebreak-with-eof

#Multi-line comment:
<<COMMENT1
  your comment 1
  comment 2
  blah
COMMENT1
#Multi-line variable:
read -d '' variable << EOF
  usage: up [--level <n>| -n <levels>][--help][--version]

  Variable: $var
EOF
echo "$variable"
#Important note: `read -d ''` exits with a 1, so make sure you don't have `set -e`

#Echo all in one:
cat << EOF
  usage: up [--level <n>| -n <levels>][--help][--version]

  Variable: $var
EOF
#File redirection:
cat > output.txt << EOF
  usage: up [--level <n>| -n <levels>][--help][--version]

  Variable: $var
EOF
#redirection after EOF, var substitution and save to file:
cat << EOF > package.spec
Name: ${package}
Version: ${version}
Summary: ${summary}
...
EOF

#Note: <<- means remove indentation (preceding whitespace from each line):
cat <<- EOF
  usage: up [--level <n>| -n <levels>][--help][--version]

  Variable: $var
EOF

#on OSX, trimming via <<- doesn't seem to work when reading into a variable,
#and only trims the first line

#Use this to combine http GET parameters with comment removed:
#(but no anchor links)
read -r -d '' parameters <<- EOF
  variable=example
  data=2
  component=${var} #comment within string
  #product=${var2} #commentted out parameter
EOF
parameters=$(echo "${parameters}" | sed -e 's/#.*$//' -e 's/^  *//' -e 's/  *$//' -e '/^$/d' | tr $'\n' '&' | sed 's/\&$//')

#download urls:
cat << EOF | xargs wget -c
https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-18.09.0-3.el7.x86_64.rpm
EOF

#::::::::::::::::::::FUNCTIONS::::::::::::::::::::

  do_stuff()
  {
    echo "this is a script function, $1"
  {

  do_stuff ok

  #export for a subshell:
  export -f do_stuff

#::::::::::::::::::::TEMPLATE::::::::::::::::::::

#package: gettext
hello_world="hola mundo"
envsubst < template.txt
  echo "hello world: ${hello_world}"
  echo "this does not work: ${hello_world#hello }"

#sed eval:
  source variables.sh
    EXAMPLE2="something else"
  EXAMPLE=/path/to/file.sh sed 's/"/\\\"/g;s/.*/echo "&"/e' example.txt
    echo "${EXAMPLE2}"
    echo "dir: $(echo ${EXAMPLE%*/})"
    echo "example: ${EXAMPLE##*/}"
    #Who am I? $0
  #Result:
    echo "something else"
    echo "dir: /path/to/file.sh"
    echo "example: file.sh"
    #Who am I? sh

#source: https://stackoverflow.com/questions/10683349/forcing-bash-to-expand-variables-in-a-string-loaded-from-a-file

