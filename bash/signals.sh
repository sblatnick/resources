
#::::::::::::::::::::SIGNAL HANDLING::::::::::::::::::::

#kill children processes of a bash script (untested):
  trap 'kill $(jobs -p)' SIGINT
  trap "kill -- -$$" SIGINT

  function cleanup
  {
    echo "cleanup"
    rm report.csv
    kill -- -$$
    exit
  }
  trap cleanup SIGHUP SIGINT SIGTERM

  #example.sh
    #!/bin/bash
    echo start
    trap 'echo ERROR in script $BASH_SOURCE on line $BASH_LINENO running command: \"$BASH_COMMAND\" exit code: $?;exit 1' ERR
    echo source something
    source something.sh
    echo done

  ~ $ ./example.sh
  start
  source something
  ./example.sh: line 5: something.sh: No such file or directory
  ERROR in script ./example.sh on line 0 running command: "source something.sh" exit code: 1

  #example with exit:
    trap 'if [ "$?" -eq "0" ]; then exit; fi; echo -e "\033[31mERROR:\033[0m in script $BASH_SOURCE on line $BASH_LINENO running command: \"$BASH_COMMAND\"";exit 1' ERR EXIT

#exit from child process:
  set -E
  trap '[ "$?" -ne 77 ] || exit 77' ERR

  val="$(exit 77)"
  echo "val: ${val}" #never gets here

  #source: https://unix.stackexchange.com/questions/48533/exit-shell-script-from-a-subshell