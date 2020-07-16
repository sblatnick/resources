#!/bin/bash

#get a repo:
git clone https://github.com/geany/geany.git
git clone git@github.com:geany/geany.git

#shallow copy subdirectory contents: (disabled for github)
git archive --remote=<repo_url> <branch> <path> | tar xvf -=

#remotes:
git remote #list remotes
git remote -v #show remotes and their urls

#add git remote repo by alias "upstream":
git remote add upstream git@github.com:geany/geany.git
git remote add shanghai git@shanghai01:lcta.git

#disable pushing to remote (by invalid url, but you can still pull, and you may want to set upstream):
git remote set-url --push origin no_push

#assign multiple remotes to a single alias (so you can push to more than one at once):
git remote add all git@yorktown:bin.git
git remote set-url --add all git@shanghai:bin.git

#custom alias:
git config --global alias.rev 'checkout --'
#custom program:
git config --global alias.modified '!git-modified'
#remove custom alias/program:
git config --global --unset alias.modified

#alias helper to pull then push:
git config --global alias.wash '!branch=$(git rev-parse --abbrev-ref HEAD);git pull origin $branch;if [ -n "$(git status --porcelain)" ];then echo -e "\033[33munmerged changes\033[0m";else git push origin $branch;fi'

#alias helper to unapply a stash:
git config --global alias.stash-unapply '!git stash show -p | git apply -R'
git stash-unapply

#other helpful aliases:
git config --global alias.tut '!$EDITOR ~/projects/resources/git/usage.sh' #load usage guide in your editor
#mac:
git config --global alias.tut '!open -a "$EDITOR" ~/projects/resources/git/usage.sh'

#change your name/email:
git config --global user.name "<first> <last>"
git config --global user.email "<email>"

#set pager, changing tab length:
git config --global core.pager 'less -x2'

#allow simple (instead of "matching") git push/pull without specifying a remote and branch:
git config --global push.default simple

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


#Hooks: https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks
  .git/hooks/*.sample
  #Types:
    #Client-Side
      #Commits:
        pre-commit
        prepare-commit-msg
        commit-msg
      #Email Workflow Hooks (git am hooks)
        applypatch-msg
        pre-applypatch
        post-applypatch
      #Misc
        pre-rebase
        post-rewrite
        post-checkout
        post-merge
        pre-push
        pre-auto-gc #when: git gc --auto
    #Server-Side
      pre-receive
      update
      post-receive


