#::::::::::::::::::::CUT::::::::::::::::::::

  cut
    -d #delimiter
    -f #field

  #examples:
    #field 2:
    cut -f2 -d' ' <<< "hello world and everybody in it"
      world
    #field 2 and on:
    cut -f2- -d' ' <<< "hello world and everybody in it"
      world and everybody in it
    #all fields up to 2:
    cut -f-2 -d' ' <<< "hello world and everybody in it"
      hello world
    #last field:
    echo "hello world and everybody in it" | rev | cut -d' ' -f 1-2 | rev
      in it

#::::::::::::::::::::SORT::::::::::::::::::::

  sort
    -n, --numeric-sort                  #compare according to string numerical value
    -r, --reverse                       #reverse the result of comparisons
    -u, --unique                        #with -c, check for strict ordering; without -c, output only the first of an equal run
    -V, --version-sort                  #natural sort of (version) numbers within text

    -k, --key=POS1[,POS2]               #start a key at POS1 (origin 1), end it at POS2 (default end of line)
    -t, --field-separator=SEP           #use SEP instead of non-blank to blank transition

    -b, --ignore-leading-blanks         #ignore leading blanks
    -i, --ignore-nonprinting            #consider only printable characters
    -f, --ignore-case                   #fold lower case to upper case characters

    -d, --dictionary-order              #consider only blanks and alphanumeric characters
    -g, --general-numeric-sort          #compare according to general numerical value
    -M, --month-sort                    #compare (unknown) < 'JAN' < ... < 'DEC'
    -h, --human-numeric-sort            #compare human readable numbers (e.g., 2K 1G)

    -R, --random-sort                   #sort by random hash of keys
    --random-source=FILE                #get random bytes from FILE
    --sort=WORD                         #sort according to WORD: general-numeric -g, human-numeric -h, month -M, numeric -n, random -R, version -V

    -c, --check, --check=diagnose-first #check for sorted input; do not sort
    -C, --check=quiet, --check=silent   #like -c, but do not report first bad line

    -m, --merge                         #merge already sorted files; do not sort
    --batch-size=NMERGE                 #merge at most NMERGE inputs at once; for more use temp files
    --compress-program=PROG             #compress temporaries with PROG; decompress them with PROG -d
    --files0-from=F                     #read input from the files specified by NUL-terminated names in file F; If F is - then read names from standard input

    -o, --output=FILE                   #write result to FILE instead of standard output
    -s, --stable                        #stabilize sort by disabling last-resort comparison
    -S, --buffer-size=SIZE              #use SIZE for main memory buffer
    -T, --temporary-directory=DIR       #use DIR for temporaries, not $TMPDIR or /tmp; multiple options specify multiple directories
    -z, --zero-terminated               #end lines with 0 byte, not newline

#::::::::::::::::::::REV::::::::::::::::::::

#reverse any string:
  echo "hello world and everybody in it" | rev
    ti ni ydobyreve dna dlrow olleh
#print file in reverse:
  rev file.txt
    dlrow olleh

#::::::::::::::::::::CAT::::::::::::::::::::

#concatenate and print files
  cat file1.txt file2.txt

#::::::::::::::::::::TAC::::::::::::::::::::

#reverse print lines of file

#Mac alias:
alias tac="tail -r"

#::::::::::::::::::::ZIP::::::::::::::::::::

#compress:
tar -czvf archive.tar.gz ./directory
#decompress:
tar -zxvf filename.tgz

#::::::::::::::::::::YOUTUBE DOWNLOAD::::::::::::::::::::

#download a whole playlist and convert the audio into mp3:
youtube-dl -x -f bestaudio[ext=m4a] --audio-format mp3 https://www.youtube.com/playlist?list=OLAK5uy_m6XppHGJtFY4ISTqrGEuYDiRrBJVEnveQ