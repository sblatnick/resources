#!/bin/bash

#::::::::::::::::::::WAIT::::::::::::::::::::

#install inotify-tools

inotifywait -e $event $file

#EVENTS:
  #A watched file or a file within a watched directory was...
  access
  modify
  attrib        #metadata, includes timestamps, file permissions, extended attributes etc. 
  close_write   #closed after being opened in writeable mode
  close_nowrite #closed after being opened in read-only mode
  close         #close_write || close_nowrite
  open

  #A watched file or watched directory was... (after, no longer watched)
  move_self     #moved
  delete_self   #deleted

  #A file or directory was...
  moved_to      #moved into watched
  moved_from    #moved out of watched
  move          #moved_to || moved_from
  create        #created within
  delete        #deleted within

  #Misc:
  unmount       #filesystem with watched file/directory umounted

#make service: https://www.server-world.info/en/note?os=CentOS_6&p=inotify

#::::::::::::::::::::PROCESSES::::::::::::::::::::
#This works with tail and doesn't require inotify-tools

#You can tail by process id, use /dev/null if you don't want any logs:
tail --pid=$pid -f /dev/null
#this will return once the process id has gone away

#::::::::::::::::::::EXAMPLES::::::::::::::::::::

#get information about a short-lived pid in McAfee Application Control (MAC)
  #!/bin/bash
  scl=/var/log/mcafee/solidcore/solidcore.log
  inotifywait -e modify $scl
  read process id pid < <(tail -n 1 $scl | grep -Po 'Process Id: \d+')
  auxwe=$(ps auxwe | grep $pid | grep -v grep)
  tree=$(pstree $pid)
  echo "log:"
  tail -n 1 $scl
  echo "pid:  $pid"
  echo -e "\033[32mps auxwe:\033[0m"
  echo $auxwe | sed 's/^/  /'
  echo -e "\033[32mpstree:\033[0m"
  echo $tree | sed 's/^/  /'

#get information about a quick process you can start:
  script.sh & pstree -a $!

#take an MAC xray of the process:
  scl=/var/log/mcafee/solidcore/solidcore.log
  inotifywait -e modify $scl;sadmin xray

#look at whole process tree:
  inotifywait -e modify /var/log/mcafee/solidcore/solidcore.log;ps axwwejf | less

#faster via monitor mode instead of re-attaching:
  # -m monitor
  inotifywait -m -e modify $log |
    while read line
    do
      echo "File Modified: $line"
    done

#loop:
  #!/bin/bash
  log=/var/log/mcafee/solidcore/solidcore.log
  inotifywait -m -e modify $log |
    while read line
    do
      echo -e "\033[33m${line}\033[0m"
      read process id pid < <(tail -n 1 $log | grep -Po 'Process Id: \d+')
      echo -e "  \033[32mpid:\033[0m $pid"
      if [ -n "${pid}" ];then
        auxwe=$(ps auxwe | grep $pid | grep -v grep)
        tree=$(pstree $pid)
        echo -e "  \033[34mLine:\033[0m ${line}"
        echo -e "  \033[34mps auxwe:\033[0m"
        echo $auxwe | sed 's/^/    /'
        echo -e "  \033[34mpstree:\033[0m"
        echo $tree | sed 's/^/    /'
        sadmin xray
      fi
    done

#what creates the directory?
  inotifywait -m /var/spool/update/ -e create -e moved_to | while read line; do   echo -e "\033[32mLine:\033[0m ${line}";sadmin xray;pstree;ps auxwe; done

#watch services (make sure they aren't running as updaters in McAfee Application Control):

  #!/bin/bash

  SERVICE=${0##*/}
  SERVICE=${SERVICE%%.*}

  LOCK=/var/run/${SERVICE}.lock
  PID=/var/run/${SERVICE}.pid
  LOG=/var/log/${SERVICE}.log

  exec 1> >(tee $LOG) 2>&1

  umask 177
  echo $$ > $PID

  function log
  {
    local service="$1:"
    local text="$2"

    printf '%s %-8s %b\n' "$(date +%F_%H:%M)" "${service}" "${text}"
  }

  function cleanup
  {
    log "${SERVICE}" "\033[33mEND\033[0m - closing service"
    rm -f $LOCK $PID
    kill -- -$$ 2>/dev/null
    exit
  }
  trap cleanup SIGHUP SIGINT SIGTERM EXIT

  function watcher
  {
    local service=$1
    shift
    local process=${1-$service}

    log "${service}" "\033[33mWATCH\033[0m - watcher added to service"
    local pid="first run"
    local retry=0

    while [ 1 ];
    do
      while [ 1 ];
      do
        log "${service}" "inspecting..."
        #don't use pgrep because of transient pids
        local npid=$(cat /var/run/${process}.pid 2>/dev/null)
        if [[ "${pid}" == "${npid}" ]] || [ -z "${npid}" ];then
          log "${service}" "  waiting for new pid... (${pid})"
          if [ $retry -eq 30 ];then
            log "${service}" "\033[31mERROR\033[0m - service not started, starting..."
            /sbin/service ${service} start
          elif [ $retry -gt 60 ];then
            log "${service}" "\033[31mCRITICAL\033[0m - service won't start, ABANDONED"
            return 1
          fi
        else
          pid="$npid"
          break
        fi
        sleep 1
        let retry++
      done

      #Can't use $? in background because of race conditions:
      local updater=$(sadmin xray | sed -n "/^[^[:space:]].*${service}/,/^$/ p" | grep -cm 1 'Updater')
      if [ $updater -eq 1 ];then
        log "${service}" "\033[31mERROR\033[0m - service running as an updater"
        log "${service}" "Restarting..."
        /sbin/service ${service} restart
        if [[ "${service}" == "sshd" ]];then
          log "${service}" "\033[33mWARN\033[0m - checking for ssh sessions that are updaters"
          for session in $(pgrep -f 'sshd:')
          do
            local updater=$(sadmin xray | sed -n "/^[^[:space:]].*sshd $session/,/^$/ p" | grep -cm 1 'Updater')
            if [ $updater -eq 1 ];then
              log "${service}" "  \033[33mWARN\033[0m killing ssh session in updater mode: ${session}"
              kill -9 ${session}
            else
              log "${service}" "  safe pid: ${session}"
            fi
          done
        fi
      else
        log "${service}" "\033[32mOK\033[0m - not an updater (${pid})"
      fi

      log "${service}" "\033[33mWAIT\033[0m - listening for changes to the service process... (${pid})"
      tail --pid=$pid -f /dev/null
    done
  }

  watcher 'ntpd' &
  watcher 'sshd' &
  watcher 'named' &
  watcher 'rsyslog' 'syslogd' &
  watcher 'crond' &

  for job in $(jobs -p)
  do
    wait $job
  done
  log "${SERVICE}" "\033[33mEND\033[0m - service main process exiting"


#::::::::::::::::::::TAIL::::::::::::::::::::
inotail

#::::::::::::::::::::CRON::::::::::::::::::::
inocron