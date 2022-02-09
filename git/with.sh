#!/bin/bash

#GitEx Group Example 'with' Script to checkout dev branch for a current release:
# git with with.sh
#   'release/1.0' => 'dev/1.0'
#Works with utils in this repo like log()
case ${branch} in
  Release/*|release/*)
      br="dev/${branch##*/}"
      git rev-parse --abbrev-ref origin/\${br} >/dev/null 2>&1
      if [ $? -eq 0 ];then
        log "checkout \${br}"
        git co \${br}
      else
        log "no branch: \${br}"
      fi
    ;;
esac
