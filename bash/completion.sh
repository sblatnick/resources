#!/bin/bash

#get current function for completion:
complete -p program

#set completion function:
complete -F complete_function command

#See also:
# config/.gitrc
# https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html#Programmable-Completion-Builtins
# https://iridakos.com/tutorials/2018/03/01/bash-programmable-completion-tutorial.html
# http://ifacethoughts.net/2009/04/06/extending-bash-auto-completion/
# https://stackoverflow.com/questions/36314565/how-do-you-get-a-bash-function-to-autocomplete-as-if-it-were-something-else