#!/bin/bash
export PATH="$PATH:$HOME/projects/resources/path/"

export GIT_MERGE_AUTOEDIT=no
export LESS="${LESS}R"

function bash_prompt()
{
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  dirty=''
  if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    dirty='*'
  fi
  PS1="\w \[\033[32m\]$branch\[\033[36m\]$dirty\[\033[0m\]\$ "
  #repo=$(basename $(git rev-parse --show-toplevel 2>/dev/null) 2>/dev/null)
  #if [ -n "$repo" ]; then
  #	echo -en "\033]0;$*${repo}\a"
  #else
  #	echo -en "\033]0;$*$(pwd)\a"
  #fi
}
PROMPT_COMMAND=bash_prompt

function extract()
{
  if [ $# -lt 1 ];then
    echo "extract [archive.zip|jar]"
    return 1
  fi
  archive=$1
  
  if [ -f ${archive} ];then
    if [ -d ${archive%.*} ];then
      rm -rf ${archive%.*} 2>/dev/null
    fi
    mkdir ${archive%.*}
    tar -xvzf ${archive} -C ${archive%.*}
  else
    echo "no such archive: ${archive}"
    return 1
  fi
}

function jag()
{
  if [ $# -lt 1 ];then
    echo "jag [pattern]"
    echo "  Java Ag - Search all jars for files matching pattern"
    return 1
  fi
  pattern=$1
  find . -type f -name "*.jar" -print0 | xargs -0 -n 1 -I {} bash -c "jar -tf {} | grep -E ${pattern} && echo 'file: {}'" _ {}
}