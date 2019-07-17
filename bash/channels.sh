
#::::::::::::::::::::FILE DESCRIPTORS::::::::::::::::::::
#source: https://stackoverflow.com/questions/7082001/how-do-file-descriptors-work
0 #stdin
1 #stdout
2 #stderr

3-9 #additional which need to be opened first:
exec 3<> /tmp/foo #open fd 3
echo "test" >&3   #use fd 3
exec 3>&-         #close fd 3.

#::::::::::::::::::::CHANNEL REDIRECTION::::::::::::::::::::
  #Piping errors shorthand:
    |&
  #shorthand for:
    2>&1 |

  #Redirecting stderr and stdout shorthand:
  &> file # (>& supported but not preferred because of appending)
  #shorthand for:
  > file 2>&1
  #append shorthand:
  &>> # (>>& is not supported)
  #shorthand for:
  >> file 2>&1

#Example:
  #open up an extra input file
  exec 7</dev/tty
  #read each file from standard input, prompting for file
  #deletion and reading response from extra input
  while read file
  do
    echo -n "Do you want to delete file $file (y/n)? "
    read resp <&7
    case "$resp" in [yY]*) rm -f "$file" ;; *) ;; esac
  done
  #close the extra input file
  exec 7<&-

#::::::::::::::::::::CHANNELS AND ROUTING::::::::::::::::::::

#redirect STDERR to STDOUT:
script 2>&1
#redirect STDERR to file:
bash -x run 2>output.txt
#print to STDERR:
>&2 echo "error"
#print errors with the commands that caused them:
scp $src $dst 2>&1 | sed "s/^/:: ${BASH_COMMAND} :: args: $src, $dst :: /"

#capture output of time:
{ time date 2>&1 ; } 2>&1 | grep real

#route to a null device
  > /dev/null

#print BOTH to stdout and to a file (-a means append):
  echo hello world | tee -a /tmp/column.csv.$pid | sed "s/^/  /"

#tee and append to a log from within the script:
  exec > >(tee -ai /tmp/script.log) 2>&1
  
#redirect stdout/stderr of current script to log:
  exec 1>log.out 2>&1
#same as before, but output to CLI too:
  exec 1> >(tee log.out) 2>&1
#prepend date to log, but not stdout:
  exec 1> >(while read line;do echo "[$(date +'%Y%m%d%H%M%S')] ${line}" >> log.out;echo "${line}";done) 2>&1
#roll logs and log to two files and stdout:
  umask 037 #lock down permissions of logs

  exec 1> >(tee /var/log/cron.wrapper /var/log/cron.wrapper.$(date +%F-%H)) 2>&1
  echo "Cleanup old logs"
  cutoff=$(date -d "2 weeks ago" +%s)
  ls -1 /var/log/cron.wrapper.* | grep -P '\d\d\d\d-\d\d-\d\d' | sort | \
  while read log
  do
    when=$(echo ${log} | grep -Po '\d\d\d\d-\d\d-\d\d')
    when=$(date --date="${when}" +%s)
    if [ "${when}" -gt "${cutoff}" ];then
      break
    fi
    echo "  deleting ${log}"
    rm -f ${log}
  done
#print commands run:
  set -x