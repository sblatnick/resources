#!/bin/bash

#SUMMARY
  #awk basically greps lines out and prints the results based on the actions passed:

  #match lines with regex and print the first "column" delimited by whitespace (bash array),
  #followed by '=' and the second "column":
  awk '/regex/ {print $1,"=",$2}'
  #match all lines (no patter specified) and print the whole line:
  awk '{print}'
  #use it like an sql query
  #print all the first columns before 1980:
  awk '{if ($3 < 1980) print $1}' db.txt

  #change delimiter (Field Separator):
  awk 'BEGIN { FS = "," } ; { print $2 }' db.txt

  #print last column of each row:
  awk '{print $NF}' db.txt

  #it's like it's own programming language, with BEGIN for setup and END blocks for finishing:
  #END aggregates, NR is number of records
  awk 'END {print NR,"coins"}' coins.txt

  awk '{sum+=$1} END {print sum}' coins.txt

  #like tail -n +1, printing the whole file with everything except the first line:
  awk 'NR > 1' file #print is implied, or: awk 'NR > 2 { print }' file
  #pipe works too:
  echo -e "$results" | awk 'NR > 1'

  #padding:
  echo 1 | awk '{ printf("%02d\n", $1) }'
  #works with strings too:
  ls -lh /var/log/test.log | awk '{ printf("%5s\n", $5) }'
    12G

  #source: http://www.vectorsite.net/tsawk.html
  #source: http://www.vectorsite.net/tsawk_1.html#m1

  #print range of file from nth match to match, include the line just before too
  #in other words: print the line just before the "$index"-th match of pattern "patt" to the first match of "complete" after that.
  awk -v n=$index -v patt="subject: $subject" -v complete='pipeline complete' '$0 ~ patt {++count} count >= n && $0 ~ complete {print;exit} count == n {print last;} count > n {print} {last=$0}' < logfile.log

  #distinct values from one column:
  awk '{ a[$2]++ } END { for (b in a) { print b } }' file
  #source: https://www.commandlinefu.com/commands/view/10840/display-unique-values-of-a-column

  #1. get ${chart} pods in ${namespace}
  #2. sum the ready #/# fractions
  #3. print distinct status in parentheses
  #4. print total restarts
  kubectl -n ${namespace:-$chart} get pod | awk "/^${chart}/ {split(\$2,r,/\//);ready+=r[1];total+=r[2];restarts+=\$4;s[\$3]++} END {for (d in s) { status=status d};printf(\"%s/%s (%s, %s restarts)\n\", ready, total, status, restarts)}"

  #for all files with a yaml key, print until there is no more indentation
  #xargs configured for mac
  ag -l start::yaml::key | xargs -I@ cat @ | awk '
    $0 ~ "start::yaml::key" {start=1}
    start > 0 {print}
    $0 !~ "^  |start::yaml::key" {start=0}
  '
  ag 'org\.apache\.commons\.lang\.' -l | xargs -n 1 -I@ sed -i '' 's/org\.apache\.commons\.lang\./org.apache.commons.lang3./' @


#Example to clean up /etc/hosts:
  sed -i -n '/\(HEADER\|^10\.\)/!p;/m0/p' /etc/hosts

  -i #edit file in place
  -n #supress printing the output we will print with p instead

  /\(HEADER\|^10\.\)/
    Any line matching regex "(HEADER|^10\.)":
      Lines with the word "HEADER"
      OR
      Lines starting with "10."
  !p
    Do not print the matching lines
  ;
    end of command
  /m0/p
    print lines with m0 in them
  /etc/hosts
    file to edit

#Sort column keeping header row:
ps -elf | awk 'NR<2{print $0;next}{print $0| "sort -nrk 5,5"}' | head
ps -elf > DB; (head -n1 DB && tail -n+3 DB | tail -n+2 | sort -nrk 5,5 | head);rm DB

