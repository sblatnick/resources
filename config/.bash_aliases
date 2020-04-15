#!/bin/bash

function origin() {
  while [ -n "$1" ]; do
    where=$(which $1 2>&1 || continue)
    eval $1=${where}
    shift
  done
}

origin less grep diff ag git

ls --color >/dev/null 2>&1 && alias ls='ls --color=auto' || alias ls='ls -G'
alias ll='ls -l'
which ggrep >/dev/null 2>&1 && alias grep='ggrep --color=auto' || alias grep='grep --color=auto'
alias less='less -SRi' #add N for line numbers
alias resource="source ${BASHRC}"

#alias diff='colordiff -u' #use +- instead of <>
function diff() {
  if tty -s <&1; then
    colordiff -u $@ | $less -SRi
  else
    $diff $@
  fi
}

#set search in less:
function less_search() {
  sed -i "s/^\.shell\$/\"$1/" ${HOME}/.lesshst
  echo '.shell' >> ${HOME}/.lesshst
}

#keep ag coloring in piped output, highlighting match groups if applicable
function agg() {
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
function lag() {
  less_search "$@"
  agg $@ | $less -SRi
}

#remove comment lines and blank lines
function nocomment() {
  cat $@ | sed -e '/^[ ]*#/d' -e '/^[ ]*\/\//d' -e '/^[ ]*$/d'
}

function passed() {
  start=$(date --date="$1" +%s)
  end=$(date --date="$2" +%s)
  passed=$((end - start))
  echo "$((passed / 60)) min $(( passed % 60 )) sec"
}

function name() {
  if [ -z "$1" ]; then
    tty -s <&1 && echo -en "\033]0;${PWD##*/}\a"
  else
    tty -s <&1 && echo -en "\033]0;${1}\a"
  fi
}

function tea() {
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
