
sed
  #Options:
  -n, --quiet, --silent
  -e script, --expression=script      #add the script to the commands to be executed
  -f script-file, --file=script-file  #add the contents of script-file to the commands to be executed
  --follow-symlinks                   #follow symlinks when processing in place; hard links will still be broken.
  -i[SUFFIX], --in-place[=SUFFIX]     #edit  files in place (makes backup if extension supplied)
                                      #The default operation mode is to break symbolic and hard links.  This can be changed with --follow-sym-
                                      #links and --copy.
  -c, --copy                          #use copy instead of rename when shuffling files in -i mode.  While this will avoid breaking links (symbolic or  hard),  the  resulting  editing  operation  is  not
                                      #atomic.  This is rarely the desired mode; --follow-symlinks is usually enough, and it is both faster and more secure.
  -l N, --line-length=N               #specify the desired line-wrap length for the ‘l’ command
  --posix                             #disable all GNU extensions.
  -r, --regexp-extended
  -s, --separate                      #consider files as separate rather than as a single continuous long stream.
  -u, --unbuffered
  --help
  --version
  #Commands:
   Zero-address ‘‘commands’’
       : label
              Label for b and t commands.

       #comment
              The comment extends until the next newline (or the end of a -e script fragment).

       }      The closing bracket of a { } block.

   Zero- or One- address commands
       =      Print the current line number.

       a \

       text   Append text, which has each embedded newline preceded by a backslash.

       i \

       text   Insert text, which has each embedded newline preceded by a backslash.

       q [exit-code]
              Immediately quit the sed script without processing any more input, except that if auto-print is not disabled the current pattern space will be printed.   The  exit
              code argument is a GNU extension.

       Q [exit-code]
              Immediately quit the sed script without processing any more input.  This is a GNU extension.

       r filename
              Append text read from filename.

       R filename
              Append a line read from filename.  Each invocation of the command reads a line from the file.  This is a GNU extension.

   Commands which accept address ranges
       {      Begin a block of commands (end with a }).

       b label
              Branch to label; if label is omitted, branch to end of script.

       t label
              If  a  s///  has  done  a  successful substitution since the last input line was read and since the last t or T command, then branch to label; if label is omitted,
              branch to end of script.

       T label
              If no s/// has done a successful substitution since the last input line was read and since the last t or T command, then branch to  label;  if  label  is  omitted,
              branch to end of script.  This is a GNU extension.

       c \

       text   Replace the selected lines with text, which has each embedded newline preceded by a backslash.

       d      Delete pattern space.  Start next cycle.

       D      Delete up to the first embedded newline in the pattern space.  Start next cycle, but skip reading from the input if there is still data in the pattern space.

       h H    Copy/append pattern space to hold space.

       g G    Copy/append hold space to pattern space.

       x      Exchange the contents of the hold and pattern spaces.

       l      List out the current line in a ‘‘visually unambiguous’’ form.

       l width
              List out the current line in a ‘‘visually unambiguous’’ form, breaking it at width characters.  This is a GNU extension.

       n N    Read/append the next line of input into the pattern space.

       p      Print the current pattern space.

       P      Print up to the first embedded newline of the current pattern space.

       s/regexp/replacement/
              Attempt  to match regexp against the pattern space.  If successful, replace that portion matched with replacement.  The replacement may contain the special charac-
              ter & to refer to that portion of the pattern space which matched, and the special escapes \1 through \9 to refer to the corresponding matching sub-expressions  in
              the regexp.

       w filename
              Write the current pattern space to filename.

       W filename
              Write the first line of the current pattern space to filename.  This is a GNU extension.

       y/source/dest/
              Transliterate the characters in the pattern space which appear in source to the corresponding character in dest.

  #Addresses
    start,end   #line range
    number      #specified line number.
    !           #not match
    first~step  #every step'th line starting with line first (example: `sed -n 1~2p` will print all the odd-numbered lines)
    $           #last line.
    /regex/     #all lines that match regex
    \cregexc    #Match lines matching the regular expression regexp.  The "c" may be any character.

    0,end       #first line to end, even if first line
    1,end       #first line to end, ignoring first line

    start,+N    #N-lines after start
    start,~N    #lines until multiple of N (example: 22,~5 would match lines 22 through 25)

#SUMMARY:

  #sed replaces by regex instances of a string in a file
  sed 's/replace/regex/' <oldFile >newFile
  #backreferences use \1
  #flags: normal regex has 's///g' for greedy, but sed has:
  #'s///2g' meaning greedy from the 2nd on
  #'s///3' meaning only the 3rd instance

  #sed inplace replacement:
  sed 's/replace/regex/' -i file.txt

  #only act on matching lines like awk:
    #replace trailing comma on all lines matching regex with a semicolon
    sed -i '/regex/ s/,$/;/' /dev/shm/file.$$
    #remove last line's comma:
    sed -i '$ s/,$//' /dev/shm/file.$$

  -n = quiet (supress printing of pattern space)
  -r = extended regex


#Character Classes: https://www.gnu.org/software/sed/manual/html_node/Character-Classes-and-Bracket-Expressions.html
  [:alnum:]  # [0-9A-Za-z]
  [:alpha:]  # [A-Za-z]
  [:blank:]  # space and tab.
  [:cntrl:]  # control characters, octal codes 000 through 037, and 177 (DEL)
  [:digit:]  # [0-9]
  [:graph:]  # [:alnum:] and [:punct:]
  [:lower:]  # [a-z]
  [:print:]  # [:alnum:] [:punct:] and space
  [:punct:]  # ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~.
  [:space:]  # tab, newline, vertical tab, form feed, carriage return, and space.
  [:upper:]  # [A-Z]
  [:xdigit:] # Hexadecimal digits: [0-9a-fA-F]
  #When used in [] must still include [] of the class:
  sed 's/^[[:space:]]*//' $file

  #ignore coloring with anchors:
  echo -e "\033[32mThis is green.\033[0m" | sed 's/^\([[:cntrl:]]\[[[:digit:]]*m\)*This/\1THAT/'
    #source: https://stackoverflow.com/questions/17998978/removing-colors-from-output

#Commands:

  # $replace $search only on $match lines:
  sed -i "/${match//\//\\/}/{s/${search//\//\\/}/${replace//\//\\/}/}" ${file}

  #source: http://www.grymoire.com/Unix/Sed.html

    #substitute command: s
    sed 's/day/night/' <old >new
    sed 's/day/night/' old >new
    echo day | sed 's/day/night/' 


    #escape parenthesis and or |
    sed 's/\(this\|that\)/else/'
    #+ not supported
    #perl's \d and character classes not supported by default
    #capture group:
    echo -e "100: something\n200: else" | sed 's/^\([0-9][0-9]*\):.*$/\1/g'
      100
      200


    #sed can also do commands
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

        Then we replace the first line starting with nameserver by a line containing nameserver 127.0.0.1, a new line (represented by \ followed by a newline - maybe your sed version supports \n instead...) and the original line (represented by &):

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
    #Print from line 45 to line 50, 55 to 60:
    sed -n '45,50 p;55,60 p' file.sql

    #Delete lines matching the pattern:
    sed -i '/PS1/d' ~/.bashrc

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

    #perl print from one to another:
    perl -ne 'print if /^ *<Directory *\//i .. /<\/Directory/i' $file
    #see awk.sh "print range" too


#Insert line after match:
sed -i '/^pattern$/a\    indented text' test.txt
#Insert line before match:
sed -i '/^pattern$/i\    indented text' test.txt

#Replace from first match to first match:
sed -i '/^start$/,/^end$/ s/search/replace/' test.txt
#Multiple replace within matches (group commands)
sed -i '/^start$/,/^end$/ {s/search/replace/;s/one/two/}' test.txt

#print values of a variable without the variable name:
sed -n 's/^hosts=//p' test.conf

#print array trimming out localhost:
sed -n '/^hosts=/{s/^hosts=//;s/,*127\.0\.0\.1,*//;s/,/\n/;p};' test.cfg

#Remove last 10 lines:
sed -e :a -e '$d;N;2,10ba' -e 'P;D'
#source: https://stackoverflow.com/questions/13380607/how-to-use-sed-to-remove-the-last-n-lines-of-a-file

#watch top with summary and matching processes:
  watch "top -bn 1 | sed -n '1,7 p;/${process}/ p'"

#mac OSX:
  brew install gsed #gnu sed

#replace range with new contents using c\:
  sed '/from/,/to/c\
New Content'


