#!/bin/bash

alias ls='ls --color=auto'
alias ll='ls -l'
alias grep='grep --color=auto'

passed() {
	start=$(date --date="$1" +%s)
	end=$(date --date="$2" +%s)
	passed=$((end - start))
	echo "$((passed / 60)) min $(( passed % 60 )) sec"
}