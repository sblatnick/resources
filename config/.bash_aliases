#!/bin/bash

ls --color >/dev/null 2>&1 && alias ls='ls --color=auto' || alias ls='ls -G'
alias ll='ls -l'
alias grep='grep --color=auto'
#alias diff='diff -u' #use +- instead of <>
alias less='less -SRi'

#set search in less:
less_search() {
  sed -i "s/^\.shell\$/\"$1/" ${HOME}/.lesshst
  echo '.shell' >> ${HOME}/.lesshst
}

#keep ag coloring in piped output, highlighting match groups if applicable
agg() {
  tput rmam #trim lines to terminal width
  local IFS=$'\n'
  local groups=$(echo "$@" | grep -Eo '\([^)]*\)')
  if [ -z "${groups}" ];then
    ag --color -H $@ # -W $(tput cols) doesn't work on mac
  else
    pattern=$(echo -n "${groups}" | tr $'\n' '|')
    ag --color -H --color-match '0' $@ | ag --color --passthrough "${pattern}"
  fi
  tput smam #undo trim setting
}

#ag coloring and pipe to less
lag() {
  less_search "$@"
  agg $@ | less
}

#remove comment lines and blank lines
nocomment() {
  cat $@ | sed -e '/^[ ]*#/d' -e '/^[ ]*\/\//d' -e '/^[ ]*$/d'
}

passed() {
  start=$(date --date="$1" +%s)
  end=$(date --date="$2" +%s)
  passed=$((end - start))
  echo "$((passed / 60)) min $(( passed % 60 )) sec"
}

tea() {
  file="$1"
  shift
  line="$@"
  cnt=$(grep -cF "${line}" "${file}" 2>/dev/null)
  if [ "$cnt" -eq 0 ];then
    tee -a "${file}" <<< $(printf "\n${line}") 2>/dev/null
  else
    echo -e "\033[33mskipping\033[0m ${file}"
  fi
}

#KUBERNETES
  #kubectl/kate less = KL
  kl() {
    kate $@ | less
  }
  #kube control = KC
  alias k='kate'
  alias k8='kate'
