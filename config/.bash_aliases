#!/bin/bash

ls --color >/dev/null 2>&1 && alias ls='ls --color=auto' || alias ls='ls -G'
alias ll='ls -l'
alias grep='grep --color=auto'
#alias diff='diff -u' #use +- instead of <>
alias agg='ag --color -H' #keep ag coloring in piped output

passed() {
  start=$(date --date="$1" +%s)
  end=$(date --date="$2" +%s)
  passed=$((end - start))
  echo "$((passed / 60)) min $(( passed % 60 )) sec"
}

