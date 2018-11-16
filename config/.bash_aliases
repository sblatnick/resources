#!/bin/bash

ls --color >/dev/null 2>&1 && alias ls='ls --color=auto' || alias ls='ls -G'
alias ll='ls -l'
alias grep='grep --color=auto'
#alias diff='diff -u' #use +- instead of <>
alias less='less -Ri'

#keep ag coloring in piped output, highlighting match groups if applicable
agg() {
  args="$@"
  local IFS=$'\n'
  local groups=$(echo "${args}" | grep -Eo '\([^)]*\)')
  if [ -z "${groups}" ];then
    ag --color -H "${args}"
  else
    pattern=$(echo -n "${groups}" | tr $'\n' '|')
    ag --color -H --color-match '0' "${args}" | ag --color --passthrough "${pattern}"
  fi
}

#ag coloring and pipe to less
lag() {
  agg "$@" | less -Ri
}

passed() {
  start=$(date --date="$1" +%s)
  end=$(date --date="$2" +%s)
  passed=$((end - start))
  echo "$((passed / 60)) min $(( passed % 60 )) sec"
}

