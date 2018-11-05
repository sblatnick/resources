

#::::::::::::::::::::CHANNEL REDIRECTION::::::::::::::::::::
  #Piping errors shorthand:
    |&
  #shorthand for:
    2>&1 |

  #Redirecting stderr and stdout shorthand:
  &> file # (>& supported but not preferred because of appending)
  #shorthand for:
  > file 2>&1
  #append shorthand:
  &>> # (>>& is not supported)
  #shorthand for:
  >> file 2>&1

#Example:
  #open up an extra input file
  exec 7</dev/tty
  #read each file from standard input, prompting for file
  #deletion and reading response from extra input
  while read file
  do
    echo -n "Do you want to delete file $file (y/n)? "
    read resp <&7
    case "$resp" in [yY]*) rm -f "$file" ;; *) ;; esac
  done
  #close the extra input file
  exec 7<&-

