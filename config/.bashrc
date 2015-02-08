#!/bin/bash
export PATH="$PATH:~/projects/resources/path/"

function bash_prompt()
{
	branch=$(git status 2>/dev/null | grep "On branch " | sed 's/On branch//')
	if [[ -z "$branch" || $(git status 2>/dev/null | grep 'working directory clean' -c) -eq 1 ]];then
		dirty=''
	else
		dirty='*'
	fi
	PS1="\w\[\033[32m\]$branch\[\033[36m\]$dirty\[\033[0m\]\$ "
}
PROMPT_COMMAND=bash_prompt
