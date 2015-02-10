#!/bin/bash

#Delete all empty folders:
find . -type d -empty
#Find all empty folders:
find . -type d -empty -delete


find $1 \( -name "*$2" -o -name ".*$2" \) -print |
while read f; do
	echo $f
done

#conditionals:
	# -or == -o
	# -not == \!
	# grouping: \( \)

# prune is less intuitive because it disables printing by default:
find . -path ./.git -prune -or -print

#actions using xargs:
	#move all found directories somewhere:
	find . -print0 | xargs -0 -iSUB mv SUB /tmp/
	#xargs can take -n1 to limit output to just 1 per run:
	find . -print0 | xargs -0 -iSUB -n1 mv SUB /tmp/
	#otherwise, xargs takes the max arguments per run of the command
	#-print0 and -0 make sure that things are delimited by a null character to
	#handle spaces and newlines correctly

#locate file:
	locate filename