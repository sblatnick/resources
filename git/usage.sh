#!/bin/bash

#basic:
  git diff #show local
  git diff --cached #show staged changes (also works: git status -v)
  git diff -w #show changes without any whitespace differences
  git show sha #show changes from the commit sha
  git show #show last commit changes
  git log #show git logs of commits
  git --no-pager #don't use less
  git --no-pager log --oneline --grep 'test' #search for the short sha with 'test' in the commit message
  git -C /path #run as if in the git directory

#diff
  #setup meld as a diff tool:
  git config --global diff.tool meld
  #compare differences in meld:
  git difftool -d fcdc6566e07b3f801c3adbcf4cf1fbb89b01c8cd^..HEAD

  #full-context diff:
  git diff -U$(wc -l file.txt) #single file patch
  git format-patch --unified=1000 $sha #from commit to HEAD as patches each
  git show --unified=1000 $sha > file.patch #single commit patch

  #show full contents of a file at a tag or commit sha:
  git show ${tag}:filename.txt
  git show ${sha}:filename.txt

#branching:

  #create a new branch and switch to it:
  git checkout -b branch3
  #track a remote branch that exists:
  git checkout --track origin/branch1

  #Tracking:
    # 1. tell git to show the relationship between the two branches in git status and git branch -v.
    # 2. directs git pull without arguments to pull from the upstream when the new branch is checked out.
    #(source: http://stackoverflow.com/questions/10002239/difference-between-git-checkout-track-origin-branch-and-git-checkout-b-branch)
    git checkout --track origin/release2013_q1_01
    #See which remote is being tracked:
    git branch -vv
    #Change remote: (source: http://stackoverflow.com/questions/4878249/how-do-i-change-the-remote-a-git-branch-is-tracking)
    git branch branch_name -u your_new_remote/branch_name
    #vs copy but not tracking:
    git checkout -b release2013_q1_01 origin/release2013_q1_01
    #add a track:
    git branch --set-upstream localbranch upstream/remotebranch
    #(source: http://stackoverflow.com/questions/520650/how-do-you-make-an-existing-git-branch-track-a-remote-branch)

  #show branches:
  git branch
  #show all branches (local and remote):
  git branch -a
  #show remote branches:
  git branch -r

  #delete a local branch:
  git branch -d bugfix #Delete a branch.
  git branch -D bugfix #Delete a branch irrespective of its merged status.

  #delete remote branch:
  git push origin --delete branch
  #older version of git to delete remote branch:
  git push origin :branch

  #tagging:
    #list tags:
    git tag
    git tag -l "pattern*"
    git show-ref --tags #sha
    git tag -n1 #commit messages
    git log -1 --format=%ai tagname #get datetime of tag

    #list remote tags:
    git ls-remote -t
    
    #create tag:
      #lightweight (unchangeable pointer to a specific commit)
      git tag "tag name"
      #annotated (includes history, who tagged, etc)
      git tag -a "tag name" -m "message"

    #add tag later at a commit:
    git tag -a [tag] [sha]
    git tag -a -m "message" [tag] [sha]

    #push tags:
    git push origin --tags
    git push origin [tagname]
    
    #checkout a new branch at a tagged point:
    git checkout -b [branchname] [tagname]

    #re-tag (update a tag)
    git tag -f [tagname]
    git push origin --force +master --tags

    #delete local tag:
    git tag -d [tagname]
    #delete remote tag:
    git push --delete origin [tagname]

#merging:

  #copy over the code from another branch:
  git pull origin branch2
  #copy the branch to remote:
  git push origin antiAbuse03

  #get all updates, even from remote branches on secondary sources (in case of tracking problems):
  git fetch --all

  #revert merge:
  git reset 56e05fced
  git reset --hard #just before last merge, head by default
  git reset --hard HEAD^ #revert to before last commit

  #revert to last:
  git reset --soft HEAD@{1}

  #single file
    #revert a single file:
    git show <commit> -- <path> | git apply -R
    git show eff3f4865248bd29fdeb46b3ed3f7632ab3ad64e src/path/ObjectExample.java | git apply -R

    #checkout a version of an individual file:
    git checkout <sha> path/to/file

    #restore a deleted file:
    git log --diff-filter=D --summary #find the deleted changeset
    git checkout $commit~1 filename #check it out

  #Abandon all my changes in Master branch and make it identical to the upstream's master branch?
    #(source: http://stackoverflow.com/questions/8134960/git-how-to-revert-master-branch-to-upstream)
    git remote update
    git reset --hard upstream/master
    #then push ignoring it won't be a fast forward:
    git push origin +master

  #Stashing:
    git stash #saves with generic name
    git stash save "<message here>"
    git stash list
    git stash apply #most recent
    git stash apply stash@{0}
    git stash drop
    git stash show -p > temp.diff
    git show stash@{0} > temp.diff #misses new files

    #unapply stash:
    git stash show -p stash@{0} | git apply -R
    git diff stash@{0}

    #create patch file for last commit:
    git format-patch HEAD^
    #create patch for commit for a specific file:
    git format-patch commit_id file(s)
    #create a diff:
    git diff > file.diff
    #apply a patch/diff:
    git apply file.diff

  #cherry pick
    #github cherry picking for upstream pull requesting:
    git checkout -b upstream upstream/master
    git cherry-pick sha1
    git push origin upstream

    #reverse cherry-pick by deleting lines of commits you no longer want:
    export EDITOR=vi
    git rebase -i <sha>

    #cherry pick select files (source: http://stackoverflow.com/questions/5717026/how-to-git-cherry-pick-only-changes-to-certain-files)
    git cherry-pick -n <commit> #cherry pick without committing
    git diff --cached #show staged changes
    git reset HEAD #Unstage everything
    git add <path> #Restage what you want
    git checkout . #revert everything you haven't staged
    #OR, if you want to remove just a few files:
    git cherry-pick -n <commit> #cherry pick without committing
    git checkout HEAD <path> #revert files you don't care about
    git commit #message already set by cherry pick

  #rebase
    #merge in changes from the remote branch without a merge commit statement
    #as if you're pulling out your current changes for a sec to pull the changes, then re-place the new changes after
    #as opposed to taking what you have and merging:
    git pull --rebase origin branch

#committing:

  #add untracked files
  git add filename
  #commit all changes to the local repo:
  git commit -a -m "<message>"

#squashing multiple commits into one:

  git checkout foo #check out the dev branch
  git rebase -i master #make sure it's derivative of the main branch
  git checkout master #check out the main branch
  git merge --squash foo #create a merge that consists of all changes in the dev branch
  git commit -m 'Squashed commit.' #commit the changes

#other

  #ignore local changes:
  git update-index --assume-unchanged filepath
  git update-index --no-assume-unchanged filepath


#compare branches:
  git diff release2013_q4_01..release2013_q4_02 #two dots == diff between tips of branches (I used this one)
  git diff release2013_q4_01...release2013_q4_02 #three dots == diff between common ancestors
  #source: http://stackoverflow.com/questions/9834689/compare-two-branches-in-git

#logs

  #single line logs
  git log --oneline

  #single line custom formatted logs (see `git help log`):
  git log --branches --date='format:%Y-%m-%d %T' --format="%cd %Cblue%h%Creset %s"

  #find branch name from 6 digit sha:
  git branch -a --contains <commit>

  #fix last commit message:
  git commit --amend -m "New commit message"

  #fix push timeout error for large files:
  git config http.postBuffer 524288000

  #run git by find:
  find . -name "CVS" -exec git rm -r {} \;

  #search history contents:
  git rev-list --all | xargs git grep expression

  #view logs on deleted file:
  git log --all -- path/to/file

  #view logs on a moved file:
  git log --follow path/to/current/file

  #view logs with files modified:
  git whatchanged

  #restore the deleted file:
  git checkout sha^ -- <file_path>

  #find and restore deleted:
  git checkout $(git rev-list -n 1 HEAD -- "$file")^ -- "$file"

#revision references:

  git show sha
  git show sha^
  git log --reverse --ancestry-path sha^..master
