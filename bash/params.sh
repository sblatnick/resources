
#::::::::::::::::::::PARAMETERS::::::::::::::::::::
  #GET MORE THAN 9 PARAMETERS: (shifts off paramters until there aren't any left)
    while [ "$#" -gt "0" ]
    do
      echo "\$1 is $1"
      shift
    done

  #USAGE INFORMATION:
    if [[ $# -lt 1 ]]; then
      echo "Usage: ${0##*/} [param]"
      exit 1
    fi

#::::::::::::::::::::PARAMETER CAPTURING::::::::::::::::::::

while [ -n "$1" ]; do
  case $1 in
    (--help|-help)           help ;;
    (--profile|-profile)     _profile=$2; shift ;;
    (--gui|-gui)             _gui=true ;;
    (--nogui|-nogui)         _gui=false ;;
    (--nojava|-nojava)       _java=false ;;
    (--root|-root)           _rootok=true ;;
    (--fg|-fg)               _background=false ;;
    (--deconfig|-deconfig)   uninstall=false ;;
    (--uninstall|-uninstall) uninstall=true ;;
    (--kill)                 kill=true ;;
    (--) shift; break ;;
    (*) break ;;
  esac
  shift
done

while
  case $1 in
    (--freq|-f)
        frequency="$2"
        shift
        if ! [[ "$frequency" =~ 'daily|hourly|ten-minutes' ]];then
          echo "ERROR: invalid frequency parameter"
          usage
          exit
        fi
      ;;
    (--help|-h|*)
        usage
        exit
      ;;
  esac
  shift
  [ -n "$1" ]
do
  continue
done

case "$service" in
  all)
    services=(proxy apache dm network)
    #intentionally left out: "setup"
    for name in ${services[@]}
    do
      $0 "$name" "$action"
    done
    ;;
  setup)
      echo -e "\033[32m${service}\033[0m"
      cp /etc/resolv.conf.bak /etc/resolv.conf
      /etc/init.d/named restart
    ;;
  proxy)
    /etc/init.d/proxy "$action"
    ;;
  apache)
    /etc/init.d/httpd "$action"
    ;;
  dm)
    /etc/init.d/dm "$action"
    ;;
  *)
    /etc/init.d/${service} "$action"
    ;;
esac


#take list from pipe, file or args:

function process()
{
  dist=$1
  echo "Processing $dist"
  #ssh takes stdin, so you have to switch it to use /dev/null:
  ssh "$destination" "./addActiveSync.pl $dist" < /dev/null
  echo "next"
}

if [ -t 0 ];then
  if [ "$#" -lt 1 ];then
    echo -e "Usage: ${0##*/} [distids|csv files]"
    echo "You can also pipe distids"
    exit
  else
    while [ -n "$1" ]; do
      if [ -f $1 ];then
        cat $1 |
        while read pipe
        do
          process $pipe
        done
      else
        process $1
      fi
      shift
    done
  fi
else
  while read pipe
  do
    process $pipe
  done
fi

#::::::::::::::::::::PARAMETER OVERWRITING::::::::::::::::::::
  #You have to reset all args
  set -- "${@:1:2}" "new_arg3" "${@:4}"
  #bash supports over 9 parameters with curly braces
  #Change Windows path to Linux in WSL:
  function param() {
    echo -n CHANGED
  }
  #IMPORTANT: ${@:start:count} (see array.sh)
  set -- "${@:1:2}" "$(param $3)" "${@:4:11}" "$(param ${15})" "${@:16}"

  #use:
    script 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
  #output:
    1 2 CHANGED 4 5 6 7 8 9 10 11 12 13 14 CHANGED 16 17 18 19 20 21

  #source: https://stackoverflow.com/questions/4827690/how-can-i-change-a-command-line-argument-in-bash

#See also: variables.sh