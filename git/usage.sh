#!/bin/bash

#basic:
	git diff #show local
	git diff --cached #show staged changes (also works: git status -v)
	git show sha #show changes from the commit sha
	git show #show last commit changes
	git log #show git logs of commits

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

	#revert to last:
	git reset --soft HEAD@{1}

	#single file
		#revert a single file:
		git show <commit> -- <path> | git apply -R
		git show eff3f4865248bd29fdeb46b3ed3f7632ab3ad64e src/eon/infra/email/store/v3/BodyDAO.java | git apply -R

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
		git show stash@{0} > temp.diff

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

#other

	#ignore local changes:
	git update-index --assume-unchanged filepath
	git update-index --no-assume-unchanged filepath


#compare branches:
	git diff release2013_q4_01..release2013_q4_02 #two dots == diff between tips of branches (I used this one)
	git diff release2013_q4_01...release2013_q4_02 #two dots == diff between common ancestors
	#source: http://stackoverflow.com/questions/9834689/compare-two-branches-in-git

#logs

	#single line logs
	git log --oneline

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

#revision references:

	git show sha
	git show sha^
	git log --reverse --ancestry-path sha^..master
