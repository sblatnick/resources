#!/bin/bash

#Delete all empty folders:
find . -type d -empty
#Find all empty folders:
find . -type d -empty -delete


find $1 \( -name "*$2" -o -name ".*$2" \) -print |
while read f; do
	echo $f
done