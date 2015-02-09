#!/bin/bash

#get a repo:
git clone https://github.com/geany/geany.git
git clone git@github.com:geany/geany.git

#add git remote repo by alias "upstream":
git remote add upstream git@github.com:geany/geany.git
git remote add shanghai git@shanghai01:lcta.git

#custom alias:
git config --global alias.rev 'checkout --'
#custom program:
git config --global alias.modified '!git-modified'
#remove custom alias/program:
git config --global --unset alias.modified

#alias helper to unapply a stash:
git config --global alias.stash-unapply '!git stash show -p | git apply -R'
git stash-unapply

#change your name/email:
git config --global user.name "<first> <last>"
git config --global user.email "<email>"

#set pager, changing tab length:
git config --global core.pager 'less -x2'

#colorful output:
git config --global -e
#============== Begin =================
[color]
        diff = auto
        branch = auto
        status = auto
[color "branch"]
        current = yellow reverse
        local = yellow
        remote = green
[color "diff"]
        whitespace = red reverse
[color "status"]
        added = yellow
        changed = green
        untracked = cyan
#============== End =================

#colorful alias lg for log:
git config --global alias.lc "log --pretty='format:%C(yellow)%h%C(reset), %C(cyan)%an%C(reset), %s, %C(green)%cr'"
#then you can use this to get a tree view:
git lc --graph

#If there's any garbage characters in the output, you may need to fix it by the following step:
~/.bash_profile:
  export LESS="${LESS}R"

#rapid Push
git config --global -e
#============== Begin =================
[push]
  default = tracking
#============== End =================
#Then using:
git push
#will only push the current branch to the remote one which is tracked by the former one. No necessary to do with
git push origin <branch>

#personal ignore list:
config --global -e
#============== Begin =================
[core]
  excludesfile = /home/<user>/.gitignore
#============== End =================