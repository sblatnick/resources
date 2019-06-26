#!/bin/bash

#::::::::::::::::::::WAIT::::::::::::::::::::

#install inotify-tools

inotifywait

#make service: https://www.server-world.info/en/note?os=CentOS_6&p=inotify

#!/bin/bash
#get information about a short-lived pid in McAfee Application Control (MAC)
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