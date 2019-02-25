

#::::::::::::::::::::ARRAYS::::::::::::::::::::

${#ArrayName[@]} #array length
unset array[$element] #delete element in an array

ARRAY=() #initialize
ARRAY+=('element') #add element
echo ${ARRAY[@]: -5:3} #5th-to-last element and the next 2, or start:count
echo ${ARRAY[@]: 0:3} #first 3 elements

ARRAY=(a b c d e f g h)
echo ${#ARRAY[@]} #8
echo ${!ARRAY[@]} #indicies: 0 1 2 3 4 5 6 7
indicies=(${!ARRAY[@]}) #store the indicies to an array
echo "${indicies[@]}" #prints: 0 1 2 3 4 5 6 7

#INDIRECTION array indices in loop:
AR=('foo' 'bar' 'baz' 'bat')
for i in "${!AR[@]}"; do
  printf '${AR[%s]}=%s\n' "$i" "${AR[i]}"
done
#source: https://unix.stackexchange.com/questions/278502/accessing-array-index-variable-from-bash-shell-script-loop

#Note: Arrays can have specified indicies (int), but not keys (string)
#specify other indicies for a sparse array (notice numerical reordering)
declare -a ARRAY='([5]="my" [10]="very" [14]="energetic" [25]="mother" [26]="just" [74]="bought" [47]="me" [56]="nine pizzas")'
echo ${ARRAY[@]} #my very energetic mother just me nine pizzas bought
echo ${!ARRAY[@]} #5 10 14 25 26 47 56 74

#EXAMPLE:
IFS='
'
array=($(ls | grep .flv))
for video in ${array[@]}
do
  echo $video
done

#Don't forget the outter () when creating an array.
#Otherwise it's just a single string.
#The loop still works since it iterates over strings dilimited by whitespace
#but the array length is off:
length=${#array[@]}

#You can set the delimiter just to create an array and have it revert back in one line:
IFS=',' read -ra VARIABLE <<< "$IN" #make sure $IN is wrapped in double quotes, or the array length is off
IFS=$'\n' read -rd '' -a VARIABLE <<< "$(pgrep -f "--test $VAR")" #or "$(commands)" with no escaping necessary

#Get variables in a CSV line:
IFS=',' read first second third <<< "one,two,three"
echo $third

#Array length:
  ${#ArrayName[@]}
#sort by descending order of unique count:
  grep -P '^2014-10-22 10:00' ~/mail.log | grep 'bounce' | grep ' to=<[^>]*>' -o | sort | uniq -c | sort -nr

#Concatinate two arrays when delimeted by a newline:
streams=`
for x in ${pdf[@]}
do
  echo "$x"
done
`'
'`
for x in ${doc[@]}
do
  echo "$x"
done`

#2 ARRAY intersection:
  IFS=$'\n'
  for element in $(echo "${array_one[@]} ${array_two[@]}" | tr ' ' $'\n' | sort | uniq -d)
  do
    echo $element
  done
#2 ARRAY no-overlap (non-intersection)
  IFS=$'\n'
  for element in $(echo "${array_one[@]} ${array_two[@]}" | tr ' ' $'\n' | sort | uniq -u)
  do
    echo $element
  done

#3 ARRAY diff add/remove:
  #!/bin/bash
  TMP=/dev/shm/${PID} #shared memory

  function cleanup()
  {
    rm -Rf ${TMP} 2>/dev/null
  }
  trap "cleanup" SIGINT SIGTERM EXIT
  mkdir ${TMP}

  function action_diff() {
    declare -a LEFT=("${!1}") #pass array by reference
    shift
    declare -a RIGHT=("${!1}")
    shift
    adder=${1}
    shift
    remover=${1}
    shift

    #clear temp files
    echo -n "" > ${TMP}/left 
    echo -n "" > ${TMP}/right

    printf '%s\n' "${LEFT[@]}" | sed 's/^\/opt\/src/\/opt\/dest/' | sort > ${TMP}/left
    printf '%s\n' "${RIGHT[@]}" | sort > ${TMP}/right

    diff ${TMP}/left ${TMP}/right | grep -P '^(<|>)' | \
    while read -r line
    do
      case "$line" in
        "< "*) #add
            path="${line#< }"
            eval ${adder} "${path}"
            echo -e "${path} \033[32madded\033[0m"
          ;;
        "> "*) #remove
            path="${line#> }"
            eval ${remover} "${path}"
            echo -e "${path} \033[33mremoved\033[0m"
          ;;
      esac
    done
  }

  left=(1 2 4)
  right=(1 2 3)
  action_diff left[@] right[@] "echo adder" "echo remover"
  #output:
    adder 4
    4 added
    remover 3
    3 removed


#::::::::::::::::::::JOIN::::::::::::::::::::

#printf:
  foo=('foo bar' 'foo baz' 'bar baz')
  bar=$(printf ",%s" "${foo[@]}")
  bar=${bar:1}
  echo $bar
  #source: https://stackoverflow.com/questions/1527049/join-elements-of-an-array

#IFS:
  csv=$(IFS=',';echo "${array[*]}")
  echo "${csv//,/, }" #add space