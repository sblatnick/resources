#!/bin/bash
#DEPRECATED but retained as an example how to interact with copyq from the command line

source ~/projects/resources/config/bashrc

clipboard=/dev/shm/clipboard
touch $clipboard

current=$clipboard$(<$clipboard)
touch $current

action=$1

##Main
case "${action}" in
  help|'') ##print this usage information
      document_title "Clipboard Management" "actions"
      document ${BASH_SOURCE}
      echo ""
      exit
    ;;
  set) #[number]#set current clipboard
      echo -n $2 > $clipboard
      copyq copy - < $($0 get)
      #$0 show
      exit
    ;;
  get) ##get current clipboard file
      echo -n $current
      exit
    ;;
  show) ##show current clipboard
      copyq eval -- "popup(\"\", clipboard(), 1000);"
      exit
    ;;
esac

