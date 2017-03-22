#!/bin/bash
export PATH="$PATH:/home/$USER/projects/resources/path/"

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
