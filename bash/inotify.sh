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

#::::::::::::::::::::TAIL::::::::::::::::::::
inotail

#::::::::::::::::::::CRON::::::::::::::::::::
inocron