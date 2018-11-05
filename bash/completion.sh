#!/bin/bash

#get current function for completion:
complete -p program

#set completion function:
complete -F complete_function command

#completion function variables:
  COMP_CWORD #Index of word with the cursor
  COMPREPLY  #Array used for the completion
  COMP_WORDS #Array of words in the terminal
  COMP_LINE  #Full command line

  #example:
    COMPREPLY+=($(compgen -W "one two three" -- "${COMP_WORDS[${COMP_CWORD}]}"))

#compgen:
  -f #files
  -W #words listed
  -- #filter by this

#See also:
# config/.gitrc
# https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html#Programmable-Completion-Builtins
# https://iridakos.com/tutorials/2018/03/01/bash-programmable-completion-tutorial.html
# http://ifacethoughts.net/2009/04/06/extending-bash-auto-completion/
# https://stackoverflow.com/questions/36314565/how-do-you-get-a-bash-function-to-autocomplete-as-if-it-were-something-else
