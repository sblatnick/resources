#!/bin/bash

function origin() {
  while [ -n "$1" ]; do
    where=$(which $1 --skip-alias 2>/dev/null || continue)
    eval $1=${where}
    shift
  done
}

origin less grep diff ag git

ls --color >/dev/null 2>&1 && alias ls='ls --color=auto' || alias ls='ls -G'
alias ll='ls -l'
which ggrep >/dev/null 2>&1 && alias grep='ggrep --color=auto' || alias grep='grep --color=auto'
alias less='less -SRi' #add N for line numbers, use `less -+S` to re-enable wrapping
alias resource="trap - RETURN;source ${BASHRC};" #unset trap from tmpdir
#Alternatively: `eval $SHELL`

#Facilitate connecting to NAS:
function nasfs() {
  sshfs -o cache=no,uid=1000,gid=1000 $USER@nas:/ ~/nas
}
alias nas='ssh $USER@nas'

BINDER=$(/usr/sbin/ifconfig 2>/dev/null | grep -Po 'inet 192\.[0-9\.]*' | cut -d' ' -f2)
function binder() {
  alias ${1}="ssh -b ${BINDER} ${3-root}@192.168.0.${2}"
}
binder c1 25
binder c2 26
binder c3 27
binder elite 14 steve
binder tc 22 tc

function proxy() {
  ssh -b ${BINDER} root@192.168.0.27 -D 1313
}

function tunnel() {
  ssh -b ${BINDER} -L 24800:192.168.0.14:24800 -D 1313 steve@192.168.0.14
}

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
    ag --color -H "$@" # -W $(tput cols) doesn't work on mac
  else
    pattern=$(echo -n "${groups}" | tr $'\n' '|')
    ag --color -H --color-match '0' "$@" | ag --color --passthrough "${pattern}"
  fi
  tput smam #undo trim setting
}

#ag coloring and pipe to less
function lag() {
  less_search "$@"
  agg "$@" | $less -SRi
}

#ag no comments
function nag() {
  needle=${@//\//\\/}
  less_search "$@"
  for file in $(ag "${needle}" -l)
  do
    nocomment $file | sed "/ #.*${needle}/d" | ag "${needle}" >/dev/null 2>&1
    if [ $? -eq 0 ];then
      ag --color -H "${needle}" $file | sed "/ #.*${needle}/d"
    fi
  done | $less -SRi
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
  if [ -t 0 ];then
    if [ -z "$1" ]; then
      TERM_NAME=${PWD##*/}
    else
      TERM_NAME=${1}
    fi
    export TERM_NAME
    echo -en "\033]0;${TERM_NAME}\a"
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
