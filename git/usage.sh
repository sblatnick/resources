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
  git --no-pager log --oneline --author $USER #get all of your own commits on the branch
  git whatchanged --invert-grep --author=$USER directory #get everyone else's whatchanged logs for the specified directory
  git -C /path #run as if in the git directory

#create repo:
  git init
  git init --bare #usefull for when you want no working copy for a server to trigger autodeploy

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

  #skip file(s):
  git diff -- . ':(exclude)example.json' ':(exclude)example2.json'

  #always exclude files (persisted):
    #enable:
      git config --global diff.nodiff.command true
    #source: https://gist.github.com/Kirkkt/b86d453b14f2dab78e09

  #create patch named after the current directory on desktop for upload to crucible, etc:
  git show --unified=1000 $sha > ~/Desktop/${PWD##*/}.patch

  #diff even showing contents of deleted files:
  git diff HEAD

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
    git branch -vv | grep -o "\[.*${BRANCH}\]"
    git branch -vv | grep -o "\[.*\]"
    #Change remote: (source: http://stackoverflow.com/questions/4878249/how-do-i-change-the-remote-a-git-branch-is-tracking)
    git branch branch_name -u your_new_remote/branch_name
    #vs copy but not tracking:
    git checkout -b release2013_q1_01 origin/release2013_q1_01
    #add a track:
    git branch --set-upstream localbranch upstream/remotebranch
    #(source: http://stackoverflow.com/questions/520650/how-do-you-make-an-existing-git-branch-track-a-remote-branch)

  #Changing remotes and tracking:
    git remote rename origin upstream
    git remote add origin https://github.com/example.git
    git fetch origin
    #now tracking upstream: git branch -vv
    git branch master -u origin/master
  #show branches:
  git branch
  #show all branches (local and remote):
  git branch -a
  #show remote branches:
  git branch -r

  #view file in another branch:
  git show branch:file

  #delete a local branch:
  git branch -d bugfix #Delete a branch.
  git branch -D bugfix #Delete a branch irrespective of its merged status.

  #delete remote branch:
  git push origin --delete branch
  #older version of git to delete remote branch:
  git push origin :branch

  #remote deleted and can't re-push?
  git push
    ! [rejected] feature/mybranch -> feature/mybranch (stale info)
    error: failed to push some refs to 'https://repo.intra.net/myrepo.git'
  git remote prune origin

  #rename both local and remote branch:
  git branch -m new_branch
  git push origin -u new_branch
  git push origin --delete old_branch

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

    #pull tags:
    git fetch --tags
    
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
  #merge with a remote branch not checked out:
  git push origin my_branch:remote_branch

  #get all updates, even from remote branches on secondary sources (in case of tracking problems):
  git fetch --all

  #revert uncommitted changes/merge:
  git reset --hard HEAD

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

    #show version of an individual file:
    git show eff3f4865248bd29fdeb46b3ed3f7632ab3ad64e:src/path/ObjectExample.java #notice the colon, use a space for the changeset

    #restore a deleted file:
    git log --diff-filter=D --summary #find the deleted changeset
    git log -- deletedFile.txt        #view changes on a file deleted
    git checkout HEAD filename        #check it out
    #old: git checkout $commit~1 filename

  #Abandon all my changes in Master branch and make it identical to the upstream's master branch?
    #(source: http://stackoverflow.com/questions/8134960/git-how-to-revert-master-branch-to-upstream)
    git remote update
    git reset --hard upstream/master
    #then push ignoring it won't be a fast forward:
    git push origin +master

  #Get forced update to history (pull fails with "fatal: refusing to merge unrelated histories":
    git fetch
    git reset origin/master --hard

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

    #switch trunk of feature branch:
    git rebase --onto newMaster oldMaster feature/branch

  #fatal error on fast forward:
  $ git pull origin <branch>
    fatal: Not possible to fast-forward, aborting.
  $ git pull origin <branch> --rebase
  #or add merges missing in this branch before pulling:
  git log ${BRANCH}..master --grep Merge | grep -Po 'Merge in .* from [^\s]*' | cut -d' ' -f5 #cut assumes no spaces in branch names
    branch1
  git merge branch1 #local merge == `git pull . branch1`

  #Try updating the desired branch and merging manually:
  git co master #co part of gitex
  git pull
  git co ${BRANCH}
  git merge master #local merge

#merge status: (source: https://stackoverflow.com/questions/226976/how-can-i-know-if-a-branch-has-been-already-merged-into-master)
  #lists branches merged into master
    git branch --merged master
    git branch -r --merged master #remote branches only
    git branch -a --merged master #gets all local and remote branches
  #lists branches that have not been merged
    git branch --no-merged
    git branch -r --no-merged master #remote branches only
    git branch -a --no-merged master #gets all local and remote branches
  #lists branches merged into HEAD (i.e. tip of current branch)
    git branch --merged

#filter-branch - alter history:

  #remove large file from commit history (DANGEROUS):
  git filter-branch --prune-empty --index-filter "git rm --cached -f --ignore-unmatch img/boot/tinycore.gz" --tag-name-filter cat -- --all
    Rewrite a9a124822407f28f1b622d2a28b08f879bf5b12a (12/15) (0 seconds passed, remaining 0 predicted)    rm 'img/boot/tinycore.gz'
    Rewrite ea5d987ae1167bf471f9f2e3f071a0cc2c7c8883 (13/15) (0 seconds passed, remaining 0 predicted)    rm 'img/boot/tinycore.gz'
    Rewrite e9fe720f2a2ca2c174cce831ea99a228c483a91a (14/15) (1 seconds passed, remaining 0 predicted)    rm 'img/boot/tinycore.gz'
    Rewrite cb3335a87ec52af0825a7d0f778d20466f778af6 (14/15) (1 seconds passed, remaining 0 predicted)
    Ref 'refs/heads/master' was rewritten
    Ref 'refs/remotes/origin/master' was rewritten
  #source: https://stackoverflow.com/questions/2100907/how-to-remove-delete-a-large-file-from-commit-history-in-git-repository

  #Remove all commits from history by "build" without removing the changes:
  git filter-branch --commit-filter '
    if [ "$GIT_AUTHOR_NAME" = "build" ];
    then
      skip_commit "$@";
    else
      git commit-tree "$@";
    fi
  ' HEAD

  #remove all history except within the subdirectory to make its own repo:
  git filter-branch --subdirectory-filter foodir -- --all

  #move files into subdirectory: (gitex tmm $dir)
  git filter-branch --index-filter '
    git ls-files -s \
      | sed "s~\t\"*~&newsubdir/~" \
      | GIT_INDEX_FILE=$GIT_INDEX_FILE.new \
        git update-index --index-info &&
    mv "$GIT_INDEX_FILE.new" "$GIT_INDEX_FILE"
  ' HEAD
  #WARNING: \t may get unescaped with gitex, making it replace on \t, so use a literal tab character instead

  #source: https://git-scm.com/docs/git-filter-branch

#flog - fix really bad merge and force push
  #merged and force pushed to remote?
  git reflog
    f8b968a (HEAD -> master, origin/master) HEAD@{0}: pull --allow-unrelated-histories -Xtheirs SVN master: Merge made by the 'recursive' strategy.
    38dc53d HEAD@{1}: reset: moving to origin/master
    88dea68 HEAD@{2}: pull --allow-unrelated-histories -Xtheirs SVN master: Merge made by the 'recursive' strategy.
    38dc53d HEAD@{3}: commit: Bug fix
    ...
  git reset --hard HEAD@{3}
  git push origin +master

  #source: https://github.community/t/i-accidentally-force-pushed-to-my-repo/277/3

#committing:

  #add untracked files
  git add filename
  #force add previously ignored:
  git add -f filename
  #force add file ignored by another repo using config bare repo:
  config update-index --add workspace.xml

  #commit all changes to the local repo:
  git commit -a -m "<message>"

  #undo last local commit without losing changes:
  git reset HEAD~

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
  git name-rev --name-only <commit>
  #all branches containing that commit:
  git branch -a --contains <commit>

  #fix last commit message:
  git commit --amend -m "New commit message"

  #fix multiple commit messages:
  git rebase --interactive $sha^
    #Change 'pick' => 'reword'
    #Save each changeset with new message

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

  #find all authors and sort by commit counts:
  git --no-pager log | grep 'Author' | sort | uniq -c | sort -nr

  #find branches containing sha:
  git --no-pager branch -a --contains $sha

#revision references:

  git show sha
  git show sha^
  git log --reverse --ancestry-path sha^..master

#git-filter
  #filter to gitignore lines (via deletion) before commit:
    #source: https://stackoverflow.com/questions/16244969/how-to-tell-git-to-ignore-individual-lines-i-e-gitignore-for-specific-lines-of
    #WARNING: wipes lines out for every pull
    .gitattributes #in repo
    /.git/info/attributes #local only
      *.txt filter=gitignore #syntax: pattern filter=filter_name

    git config --global filter.gitignore.clean "sed '/#gitignore$/'d" #delete lines before commit
    git config --global filter.gitignore.smudge cat #do nothing when pulling

    #You could also try a pre-commit hook that warns if the line was modified.
    #githooks: https://git-scm.com/docs/githooks#_pre_commit

#git-svn (https://git-scm.com/book/en/v1/Git-and-Other-Systems-Git-and-Subversion)
  #cloning from svn takes a LONG time and downloads A LOT of data:
  git svn clone svn://svn.site.com/repo -s
  # (roughly 1 Terabyte of downloads became 13GB on disk)

  #clone just master and branch:
    #get latest revision:
      svn log --stop-on-copy svn://svn.site.com/repo/branches/opera | egrep "r[0-9]+" | tail -1
    #clone revision:
      git svn clone -r 400000 -s svn://svn.site.com/repo
      cd repo
    #follow that branch:
      git branch opera origin/opera
      git checkout opera

  #Migate svn branch and sub-directory to git retaining history:
    #Convert svn branch and sub-directory into git:
      #get oldest revision for the subdirectory:
      revision=$(svn log --stop-on-copy svn://svn.site.com/repo/branches/branch1/subpath/directory | egrep "r[0-9]+" | tail -1 | cut -d' ' -f1)
      #clone repo from that revision with the subdirectory:
      git svn clone -r ${revision#r} svn://svn.site.com/repo/branches/branch1/subpath/directory
      #enter new repo:
      cd directory
      #pull other revisions:
      git svn fetch
      #rebase to latest fetched locally:
      git svn rebase -l

      #get earliest commit sha:
      sha=$(git rev-list --max-parents=0 HEAD)
      #create/use a branch to retain moved history:
      git checkout -b move $sha

      #move files into same relative location you want them in the new repo:
      mkdir -p subpath/directory/
      git mv dir subpath/directory/
      git commit -a -m "Moved files for using in new git repo"

      #rebase changes on moved file:
      git rebase move master

      #problems rebasing?
        git status
        #move all "new file" yourself:
        git mv old subpath/directory/
        #ignore "modified"
        #add all "added by us":
        git add file
        #remove all "both deleted":
        git rm file
        #add then move "added by them":
        git add file
        git mv old subpath/directory/
        #continue the rebase:
        git rebase --continue

      #problems pulling latest or checking out another branch?
        Checking svn:mergeinfo changes since rXXXX: XX sources, XX changed
        YAML Error: Invalid element in map
           Code: YAML_LOAD_ERR_BAD_MAP_ELEMENT
           Line: 3
           Document: 1
         at /usr/lib/perl5/YAML/Loader.pm line 350.
      rm -rf .git/svn/.caches

      #directories missed? repeat above on later commits by file

    #Merge history into existing git repo:
      cd oldrepo
      #add other repo as a remote and fetch (-f):
      git remote add -f NAME ../directory/

      #merge/read the other history in:
      git pull --allow-unrelated-histories -Xtheirs NAME master

      #remove other repo:
      git remote rm NAME

      #similar commands that lose history:
        git merge -s ours --no-commit --allow-unrelated-histories NAME/master
        git read-tree --prefix=subpath/directory/ -u NAME/master
        git commit -a -m "Merged other repo in from svn"

      #if anything goes wrong, revert:
        git reset --hard origin/master

    #Create a new repo from svn subdirectory:
      revision=$(svn log --stop-on-copy svn://svn.intranet.com/repo/branches/0.1 | egrep "r[0-9]+" | tail -1 | cut -d' ' -f1)
      git svn clone -r ${revision#r} svn://svn.intranet.com/repo/branches/0.1 git-repo-name
      cd git-repo-name
      git svn fetch
      git svn rebase -l
      #remove the svn repo so you don't accidentally try to push to it:
      git config --unset svn-remote.svn.url

      #push to a new repo server:
      git remote add origin ssh://git@git.intranet.com/repo.git
      git push -u origin --all
      git push origin --tags

    #Get disparate svn history:

      #get each history segment:
        revision=$(svn log --stop-on-copy svn://svn.intranet.com/repo/branches/0.1/subdirectory | egrep "r[0-9]+" | tail -1 | cut -d' ' -f1)
        git svn clone -r ${revision#r} svn://svn.intranet.com/repo/branches/0.1/subdirectory
        mv subdirectory subdirectory-0.1
        cd subdirectory-0.1
        git svn fetch
        git svn rebase -l
        cd ../

        revision=$(svn log --stop-on-copy svn://svn.intranet.com/repo/branches/0.2/subdirectory | egrep "r[0-9]+" | tail -1 | cut -d' ' -f1)
        git svn clone -r ${revision#r} svn://svn.intranet.com/repo/branches/0.2/subdirectory
        mv subdirectory subdirectory-0.2
        cd subdirectory-0.2
        git svn fetch
        git svn rebase -l
        cd ../

        revision=$(svn log --stop-on-copy svn://svn.intranet.com/repo/branches/0.3/subdirectory | egrep "r[0-9]+" | tail -1 | cut -d' ' -f1)
        git svn clone -r ${revision#r} svn://svn.intranet.com/repo/branches/0.3/subdirectory
        mv subdirectory subdirectory-0.3
        cd subdirectory-0.3
        git svn fetch
        git svn rebase -l
        cd ../

      #pull each history into the oldest one:
        cd ../subdirectory-0.1/

        git remote add -f 0.2 ../subdirectory-0.2
        git pull --allow-unrelated-histories -Xtheirs 0.2 master

        git remote add -f 0.3 ../subdirectory-0.3
        git pull --allow-unrelated-histories -Xtheirs 0.3 master

      #Update git repo with svn history where discrepancies:
        git tmm subdir #move to location (gitex time machine move)
        git remote add old ../path
        #in old cloned repo:
          git log path/file
        git cherry-pick -n $sha

        git cherry-pick add file #stage changes
        git checkout HEAD file   #revert
        git reset HEAD file      #remove

        git cherry-pick --continue

        #force merge history:
        git push old +master:old_branch

        #in old cloned repo:
          git reset --hard origin/old_branch

  #switch branches/tags and merge:
    #get other branch:
    git svn clone -r 400000:HEAD -s svn://svn.site.com/repo
    cd repo
    #enter other branch:
    git branch opera origin/opera
    git checkout opera
    #get latest (especially if you killed early):
    git svn rebase
    #checkout the branch you want to merge to:
    git checkout master
    #merge (didn't work for me):
    git merge --allow-unrelated-histories --squash origin/opera
    #???? git rebase origin/tag branch
    #problems? revert:
    git reset --hard HEAD
    #commit and push:
    git commit -a -m "message"
    git svn dcommit

  #find tag path:
    svn ls svn://svn.site.com/repo/tags

  #diff tags using svn:
    cvs diff -u -r 1.17 -r 1.18

  #resetting to HEAD will leave untracked changes:
  git reset --hard
  #remove untracked files:
  git clean -f -d

  #commit as usual:
  git commit -am 'message'
  #push commits to svn:
  git svn dcommit
  #pull latest, fix conflicts using rebase:
  git svn rebase
  #don't merge locally, only rebase or the linear history of svn hides your work from dev branches

  #create a new svn branch (does not switch to branch):
  git svn branch release01
  #track svn branches:
  git branch opera origin/opera
  #merging back will effectively --squash the history:
  git merge master

  #svn-style logs:
  git svn log
  #lines edited by who (svn annotate):
  git svn blame file.txt

  #svn info:
  git svn info

  #avoid .gitignore in svn project:
  git svn show-ignore > .git/info/exclude


#Apply all of your changes from one branch to another:
  for sha in $(git --no-pager log ${branch} --oneline --reverse --author ${USER} | awk '{print $1}')
  do
    git cherry-pick -n $sha -Xtheirs
  done






