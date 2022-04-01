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

#::::::::::::::::::::DIRECTORY STACK::::::::::::::::::::

#Instead of using cd within a script, consider using:
pushd #push directory built-in
popd  #pop  directory built-in
  -n    #don't actually change directories

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
#zip files:
zip file.zip file1 file2 file3
#delete file from jar/zip:
zip -d file.jar path/to/file.txt
#add file:
gzip -dc archive.tar.gz | tar -r internal/path/to/.external/path/to/file.txt | gzip > archive_new.tar.gz –

#::::::::::::::::::::REGEX SEARCH/REPLACE::::::::::::::::::::

Increase indent on inline comments:
  Search:
    ^(\s+.+\s+)#
  Replace:
    \1  #

#::::::::::::::::::::FORMAT CODE::::::::::::::::::::
  #Debian: sudo apt-get install astyle
  #OSX:    brew install astyle

  astyle
    #Tabs ($number = 4 by default)
      --indent=spaces=$number      | -s$number
      --indent=tab=$number         | -t$number
      --indent=force-tab=$number   | -T$number  #use tabs even where spaces are sometimes used
      --indent=force-tab-x=$number | -xT$number #length in spaces, mix tabs/spaces
    #Brace style
      --style=
        #Common:
          allman              #-A1
            while (x == y)
            {
              something();
              somethingelse();
            }
          java                #-A2
            class Example {
              while (x == y) {
                something();
                somethingelse();
              }
            }
          kr                  #-A3
            int main(int argc, char *argv[])
            {
              while (x == y) {
                something();
                somethingelse();
              }
            }
          stroustrup          #-A4 FAVORITE: k&r with "else" on newline
            if (x < 0) {
              puts("Negative");
              negative(x);
            }
            else {
              puts("Non-negative");
              nonnegative(x);
            }
        #Other:
          whitesmith          #-A5
            while (x == y)
              {
              something();
              }
          vtk                 #-A15
          ratliff | banner    #-A6
            while (x == y) {
              }
          gnu                 #-A7
            while (x == y)
              {
                something ();
                somethingelse ();
              }
          linux | knf         #-A8
            int power(int x, int y)
            {
              int result;

              if (y < 0) {
                result = 0;
              } else {
                result = 1;
                while (y-- > 0)
                  result *= x;

              }
              return result;
            }
          horstmann | run-in  #-A9
            while (x == y)
            {   something();
                somethingelse();
            }
          1tbs | otbs         #-A10
          google              #-A14
          mozilla             #-A16
          pico                #-A11
            while (x == y)
            {   something();
                somethingelse(); }
          lisp                #-A12
            while (x == y)
              { something();
                somethingelse(); }
    #Brace Modification
      --attach-namespaces         | -xn
      --attach-classes            | -xc
      --attach-inlines            | -xl
      --attach-extern-c           | -xk
      --attach-closing-while      | -xV
    #Indentation:
      --indent-classes            | -C
      --indent-modifiers          | -xG
      --indent-switches           | -S
      --indent-cases              | -K
      --indent-namespaces         | -N
      --indent-after-parens       | -xU
      --indent-continuation=#     | -xt#
      --indent-labels             | -L
      --indent-preproc-block      | -xW
      --indent-preproc-cond       | -xw
      --indent-preproc-define     | -w
      --indent-col1-comments      | -Y
      --min-conditional-indent=#  | -m# # 0:none, 1:one additional, 2 (default): two additional, 3: one-half additional
      --max-continuation-indent=# | -M# # spaces in a continuation line, 40 (default) - 120
    #Padding:
      --break-blocks              | -f
      --break-blocks=all          | -F #around else/catch
      --pad-oper                  | -p
      --pad-comma                 | -xg
      --pad-paren                 | -P
      --pad-paren-out             | -d
      --pad-first-paren-out       | -xd
      --pad-paren-in              | -D
      --pad-header                | -H
      --unpad-paren               | -U
      --delete-empty-lines        | -xd
      --fill-empty-lines          | -E
      --align-pointer=type        | -k1
      --align-pointer=middle      | -k2
      --align-pointer=name        | -k3
      --align-reference=none      | -W0
      --align-reference=type      | -W1
      --align-reference=middle    | -W2
      --align-reference=name      | -W3
    #Formatting:
      --break-closing-braces      | -y
      --break-elseifs             | -e
      --break-one-line-headers    | -xb
      --add-braces                | -j
      --add-one-line-braces       | -J
      --remove-braces             | -xj
      --break-return-type         | -xB
      --break-return-type-decl    | -xD
      --attach-return-type        | -xf
      --attach-return-type-decl   | -xh
      --keep-one-line-blocks      | -O
      --keep-one-line-statements  | -o
      --convert-tabs              | -c
      --close-templates           | -xy
      --remove-comment-prefix     | -xp
      --max-code-length=#         | -xC#
      --break-after-logical       | -xL
      --style=linux | 1tbs.
      --mode=c | java | cs

    #Objective-C:
      --pad-method-prefix         | -xQ
      --unpad-method-prefix       | -xR
      --pad-return-type           | -xq
      --unpad-return-type         | -xr
      --pad-param-type            | -xS
      --unpad-param-type          | -xs
      --align-method-colon        | -xM
      --pad-method-colon=none     | -xP
      --pad-method-colon=all      | -xP1
      --pad-method-colon=after    | -xP2
      --pad-method-colon=before   | -xP3

    #Misc:
      --suffix                          #Append suffix instead of '.orig' to original filename.
      --suffix=none               | -n  #Do not retain a backup of the original file.
      --recursive                 | -r | -R
      --dry-run
      --exclude
      --ignore-exclude-errors     | -i
      --ignore-exclude-errors-x   | -xi #don't display unmatched --exclude
      --errors-to-stdout          | -X
      --preserve-date             | -Z
      --verbose                   | -v
      --formatted                 | -Q
      --quiet                     | -q
      --lineend=windows           | -z1
      --lineend=linux             | -z2
      --lineend=macold            | -z3

    #Command line:
      --options=$path
      --project=.astylerc
      --ascii                     | -I
      --version                   | -V
      --help                      | -h | -?
      --html                      | -! #HTML help
      --stdin=$path
      --stdout=$path

#::::::::::::::::::::YOUTUBE DOWNLOAD::::::::::::::::::::

youtube-dl https://www.youtube.com/watch?v=XXXXX

#install:
  sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
  sudo chmod a+rx /usr/local/bin/youtube-dl

#download a whole playlist and convert the audio into mp3:
  youtube-dl -x -f bestaudio[ext=m4a] --audio-format mp3 https://www.youtube.com/playlist?list=OLAK5uy_m6XppHGJtFY4ISTqrGEuYDiRrBJVEnveQ

#ERROR: unable to download video data: HTTP Error 403: Forbidden
  youtube-dl --rm-cache-dir


#::::::::::::::::::::WINDOWS REGISTRY::::::::::::::::::::

#Install:
  sudo apt install libhivex-bin
#Read edition of OS:
  hivexget /media/$USER/volume/Windows/System32/config/SOFTWARE 'Microsoft\Windows NT\CurrentVersion'
#Get Product Activation Key:
  sudo strings /sys/firmware/acpi/tables/MSDM | tail -1
