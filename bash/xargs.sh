
#search files for something and show all the output until a blank newline:
ag -l ${search} | xargs -I '{}' bash -c "echo '{}'; sed -n '/${search}/,/^$/ p' '{}'"

#search files and print last git log for each and indent:
ag -l ${search} | xargs -I '{}' bash -c "echo '{}';git log -n1 '{}' | sed 's/^/  /'"