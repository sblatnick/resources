#!/bin/bash

#AWK:

  #MY SUMMARY
    #awk basically greps lines out and prints the results based on the actions passed:
    
    #match lines with regex and print the first "column" delimited by whitespace (bash array),
    #followed by '=' and the second "column":
    awk '/regex/ {print $1,"=",$2}'
    #match all lines (no patter specified) and print the whole line:
    awk '{print}'
    #use it like an sql query
    #print all the first columns before 1980:
    awk '{if ($3 < 1980) print $1}' db.txt
    
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
    ~ $ each pop "ls -lh /var/lcta/pop/logs/lcta_log | awk '{ printf(\"%5s\n\", \$5) }'"
    m0004260
        12G
    m0004261
       8.4G
    m0004262
       8.4G
  #END SUMMARY

  #source: http://www.vectorsite.net/tsawk.html
  #source: http://www.vectorsite.net/tsawk_1.html#m1

  #print range of file from nth match to match, include the line just before too
  #in other words: print the line just before the "$index"-th match of pattern "patt" to the first match of "complete" after that.
  awk -v n=$index -v patt="subject: $subject" -v complete='pipeline complete' '$0 ~ patt {++count} count >= n && $0 ~ complete {print;exit} count == n {print last;} count > n {print} {last=$0}' < logfile.log

#SED:

  #MY SUMMARY:

    #sed replaces by regex instances of a string in a file
    sed 's/replace/regex/' <oldFile >newFile
    #backreferences use \1
    #flags: normal regex has 's///g' for greedy, but sed has:
    #'s///2g' meaning greedy from the 2nd on
    #'s///3' meaning only the 3rd instance

  #END SUMMARY


  #source: http://www.grymoire.com/Unix/Sed.html

    #Sed has several commands, but most people only learn the substitute command: s. The substitute command changes all occurrences of the regular expression into a new value. A simple example is changing "day" in the "old" file to "night" in the "new" file:

    sed s/day/night/ <old >new

    #Or another way (for Unix beginners),

    sed s/day/night/ old >new

    #and for those who want to test this:

    echo day | sed s/day/night/ 

    #This will output "night".

    #I didn't put quotes around the argument because this example didn't need them. If you read my earlier tutorial on quotes, you would understand why it doesn't need quotes. However, I recommend you do use quotes. If you have meta-characters in the command, quotes are necessary. And if you aren't sure, it's a good habit, and I will henceforth quote future examples to emphasize the "best practice." Using the strong (single quote) character, that would be:

    sed 's/day/night/' <old >new

    #example:
    #note: escape parenthesis and plus, don't use \d, etc
    cd /home/steve/work/www/
    ack-grep '"http://www\.everyone\.net' | cat | sed 's/:\([0-9]\+\):.*/:\1/g'


    #sed can also do commands?
    sed -n 'H;${x;s/nameserver .*\n/nameserver 127.0.0.1\
&/;p;}' resolv.conf

    #manual:
        h H    Copy/append pattern space to hold space.
        g G    Copy/append hold space to pattern space.

        n N    Read/append the next line of input into the pattern space.

    #see: http://stackoverflow.com/questions/12833714/the-concept-of-hold-space-and-pattern-space-in-sed
        

        When sed reads a file line by line, the line that has been currently read is inserted into the pattern buffer (pattern space).
        Pattern buffer is like the temporary buffer, the scratchpad where the current information is stored.
        When you tell sed to print, it prints the pattern buffer.

        Hold buffer / hold space is like a long-term storage, such that you can catch something, store it and reuse it later
        when sed is processing another line.
        You do not directly process the hold space, instead, you need to copy it or append to the pattern space if you want to
        do something with it. For example, the print command p prints the pattern space only.
        Likewise, s operates on the pattern space.

        Here is an example:

        sed -n '1!G;h;$p'

        (the -n option suppresses automatic printing of lines)

        There are three commands here: 1!G, h and $p. 1!G has an address, 1 (first line), but the ! means that
        the command will be executed everywhere but on the first line. $p on the other hand
        will only be executed on the last line. So what happens is this:

            1. first line is read and inserted automatically into the pattern space
            2. on the first line, first command is not executed; h copies the first line into the hold space.
            3. now the second line replaces whatever was in the pattern space
            4. on the second line, first we execute G, appending the contents of the hold buffer to the pattern buffer,
                separating it by a newline. The pattern space now contains the second line, a newline, and the first line.
            5. Then, h command inserts the concatenated contents of the pattern buffer into the hold space, which now holds the
                reversed lines two and one.
            6. We proceed to line number three -- go to the point (3) above.

        Finally, after the last line has been read and the hold space
        (containing all the previous lines in a reverse order)
        have been appended to the pattern space, pattern space is
        printed with p. As you have guessed, the above does exactly
        what the tac command does -- prints the file in reverse.

    #insert localhost into resolve.conf source: http://stackoverflow.com/questions/6739258/how-do-i-add-a-line-of-text-to-the-middle-of-a-file-using-bash

        Here is a solution using sed:

        $ sed -n 'H;${x;s/nameserver .*\n/nameserver 127.0.0.1\
        &/;p;}' resolv.conf

        # Generated by NetworkManager
        domain dhcp.example.com
        search dhcp.example.com
        nameserver 127.0.0.1
        nameserver 10.0.0.1
        nameserver 10.0.0.2
        nameserver 10.0.0.3

        How it works: first, the output of sed should be suppressed with the -n flag. Then, for each line, we append the line to the hold space, separating them with newlines:

        H

        When we come to the end of the file (addressed by $) we move the content of the hold space to the pattern space:

        x

        hen we replace the first line starting with nameserver by a line containing nameserver 127.0.0.1, a new line (represented by \ followed by a newline - maybe your sed version supports \n instead...) and the original line (represented by &):

        s/nameserver .*\n/nameserver 127.0.0.1\
        &/

        Now we just need to print the results:

        p


    #append ok to line 2:
    sed '2s/$/ok/' file.txt
    #Append $append on line $i:
    sed "${i}s/$/${append}/" file.txt

    #replace all octal with numeric values:
    cp $1 $2
    for i in $(seq 200 377)
    do
        LC_ALL="POSIX" sed -i "s/\(\o${i}\)/$i/gi" $2
    done
    #or with just dashes:
    LC_ALL="POSIX" sed 's/\([\o200-\o377]\)/-/gi' unicode.txt
    tr '\200-\377' '-' < unicode.txt > output.txt

    #Use + and other extended perl-like regular expressions:
    sed -r "s/\s+/ /gi" $2

    #Print from line 45 to line 50:
    sed -n '45,50 p' file.sql

    echo "first1
second1
third1
fourth1
fifth1
sixth1
seventh1
repeat
first2
second2
third2
fourth2
fifth2
sixth2
seventh2" > test.txt
    #find matches from one pattern to another and print ('addr1,addr2 command'):
    sed -n '/second/,/fifth/ p' test.txt
        second1
        third1
        fourth1
        fifth1
        second2
        third2
        fourth2
        fifth2
