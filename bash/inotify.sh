#!/bin/bash

#::::::::::::::::::::WAIT::::::::::::::::::::

#install inotify-tools

inotifywait

#make service: https://www.server-world.info/en/note?os=CentOS_6&p=inotify

#!/bin/bash
#get information about a short-lived pid in McAfee Application Control
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



#::::::::::::::::::::TAIL::::::::::::::::::::
inotail

#::::::::::::::::::::CRON::::::::::::::::::::
inocron