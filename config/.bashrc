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
}
PROMPT_COMMAND=bash_prompt
