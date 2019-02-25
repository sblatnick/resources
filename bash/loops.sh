#::::::::::::::::::::LOOPS::::::::::::::::::::

#WHILE
  while read f
  do
    echo $f
    continue
    break
  done < myfile

  #prevent sub-shell issues in totals:
  total=0
  while read var
  do
    echo "variable: $var"
    ((total+=var))
  done < <(echo 45) #output from a command, script, or function
  echo "total: $total"

  ls | while read file
  do
    echo $file
    string $file | grep '19%'
  done

  #prevent sub-shell issues in pipe:
  echo hello | {
    while IFS= read -r line
    do
      echo "$line"
      lastLine="$line"
    done

    #won't work without the braces:
    echo "$lastLine"
  }

  #prevent multiple reads from using the same stdin as input
  #read -u [channel]
  while read -u 3 node
  do
    $0 ${node} #outputs something, breaking stdin channel 1
  done 3< <(echo ${hosts} | tr ' ' $'\n')
  #See: https://superuser.com/questions/421701/bash-reading-input-within-while-read-loop-doesnt-work

  #counter:
  X=0
  while [ $X -le 20 ]
  do
    echo $X
    X=$((X+1))
  done

  #using let:
  i=0
  while [ $i -lt 400 ]; do
    printf "%i : %b\n" "$i" "\0$i"
    let "i++"
  done

  #set numbered parameters to each:
  set -- one two three
  while [ "$1" != "" ];do
    variable="$1"
    #do stuff
    shift
  done

#FOR LOOP:
  #using a sub-shell, so variables can be read after the loop:
  for video in $(ls | grep .flv)
  do
    echo $video
  done
  echo "last: $video"

  IFS='
'
  array=$(ls | grep .flv)
  for video in ${array[@]}
  do
    echo $video
  done

  #globbing:
  for var in *.html
  do
    grep -L 'gif' "${var}"
  done

  green="green purple" #separate
  for X in "red" "$green" "blue" $green
  do
    echo $X
  done

  #You can also set the delimiter just to create an array and have it revert back in one line:
  IFS=';' read -ra VARIABLE <<< "$IN"

#MAKE A BUNCH OF DIRECTORIES:
  mkdir rc{0,1,2,3,4,5,6,S}.d

#SEQUENCE of numbers that are padded:
  for i in $(seq -f "%02g" 10 15)
  do
    echo $i
  done

#for loop with index and value (untested):
  for i in "${!foo[@]}"; do 
    printf "%s\t%s\n" "$i" "${foo[$i]}"
  done

  for i in "${!services[@]}"
  do 
    server="${services[$i]}"
    echo -e "$server" > /tmp/left.csv.$pid
    ssh $server -q "$param" >> /tmp/left.csv.$pid 2>&1
  done

#parse unique hiera values from helm templates:
while read -u 3 line
do
  output=""
  for attribute in $(echo "${line}" | tr '.' ' ')
  do
    output="$output.$attribute"
    echo "$output"
  done
done 3< <(grep -hEro '.Values.[a-zA-Z.]*' templates/ | sort | uniq | cut -d. -f 3-) | sort | uniq | sed -e 's/^.//' -e 's/[^\.]*\./  /g' -e 's/$/:/'