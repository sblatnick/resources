#!/bin/bash

#::::::::::::::::::::WINDOWS/MAC NEWLINES::::::::::::::::::::

#check for windows newlines:
  od -c /tmp/work.tmp
#remove windows newlines:
  ex -sc $'%s/\r$//e|x' "$file"
  data=${data//$'\r'/} #all
  data=${data%$'\r'} #at end of string
  tr -d '\r' < file
  echo $variable | tr -d '\r'

#::::::::::::::::::::FILE READING/WRITING::::::::::::::::::::

#read file line by line:
while read -r line
do
  echo $line
done < $path

#overwrite to a file:
echo "hello" > /tmp/filename
#append to the file:
echo "world" >> /tmp/filename

#store contents to variable:
contents=$(</tmp/filename)

#::::::::::::::::::::CHANNELS AND ROUTING::::::::::::::::::::

#redirect STDERR to STDOUT:
script 2>&1
#redirect STDERR to file:
bash -x run 2>output.txt

#route to a null device
  > /dev/null

#print BOTH to stdout and to a file (-a means append):
  echo hello world | tee -a /tmp/column.csv.$pid | sed "s/^/  /"

#tee and append to a log from within the script:
  exec > >(tee -ai /tmp/script.log) 2>&1
  

#::::::::::::::::::::COMBINE COLUMNS::::::::::::::::::::

#merge lines of a file:
  pr -mts' ' file1 file2
  paste -d' ' file1 file2

#::::::::::::::::::::JOIN::::::::::::::::::::
#source: https://stackoverflow.com/questions/1527049/join-elements-of-an-array

foo=('foo bar' 'foo baz' 'bar baz')
bar=$(printf ",%s" "${foo[@]}")
bar=${bar:1}

echo $bar

#::::::::::::::::::::LINKS::::::::::::::::::::

#symbolic link:
  ln -s target link #(use -t for a directory)
  ln -s /path/to/real/file /path/to/non-existant/file
#hard link
  ln target link

#::::::::::::::::::::COLORED OUTPUT::::::::::::::::::::

#Colored console text:
  echo -e "\033[32mThis is green.\033[0m"
#view the file in less with coloring:
  less -R file.txt

#watch with color using -c, also print logs indenting different files and removing the pid part of log name [pid].[service]:
  watch -c "tail -n+1 13662.* | sed 's/^/  /' | sed 's/  ==> [0-9]*\.\([^ ]*\) <==/\1/'"

#  (must close it or it will continue after)
#or in C:
#     printf("\033[34m This is blue.\033[0m\n");

#     Here are the colors:
#   30    black foreground
#   31    red foreground
#   32    green foreground
#   33    yellow foreground
#   34    blue foreground
#   35    magenta (purple) foreground
#   36    cyan (light blue) foreground
#   37    gray foreground

#   40    black background
#   41    red background
#   42    green background
#   43    yellow background
#   44    blue background
#   45    magenta background
#   46    cyan background
#   47    white background

#   0     reset all attributes to their defaults
#   1     set bold
#   5     set blink
#   7     set reverse video
#   22    set normal intensity
#   25    blink off
#   27    reverse video off

#(the 1 after the ; is for bold in: echo -e "\033[32;1mThis is green.\033[0m")

#::::::::::::::::::::FORMATTING::::::::::::::::::::

echo -e "text" #allows escape sequences like colors (see COLORED OUTPUT)
echo -n "text" #skips newline at end

#printf:
  printf $FORMAT parameters
  #types:
  # %s    string
  # %d    digit, same as %i
  # %f    float
  # %b    string containing escape sequences
  # %q    shell quoted

  #padding (works for %s and %f):
  # %-4s  left aligned, reserving 4 spaces for a column
  # %4s   right aligned, reserving 4 spaces for a column
  # %.3s  %s: truncated to 3 characters/digits
  #       %f: precision after decimal

  #* means take the argument before as the length:
  printf "%*s\n" 10 "10 width"

  #0 first means pad with 0s (doesn't work with - for left alignment):
  printf "%06.2f\n" 56.1
    056.10
    #meaning:
      #6 chars counting decimial
      #padded with 0s to the left
      #accuracy of 2 decimal points

  #add commas to numbers:
  printf "%'d\n" "1000000000"
    1,000,000,000

  #coloring (see COLORED OUTPUT):
    #be sure to separate color tags from strings if you don't want
    #the escape sequences to effect the string length for creating columns:
    FORMAT="%b%-4.4s%b\n"
    printf "$FORMAT" "\033[31m" "in red left aligned reserving a minimum of 4 chars, truncated to 4 chars" "\033[0m"

  #see also: http://wiki.bash-hackers.org/commands/builtin/printf

#::::::::::::::::::::WHITESPACE::::::::::::::::::::

#trim down the leftmost tab-space to 2 spaces in your usage documentation:
  echo "Usage: ${PROG} [--parameter arg]
  Parameters:
    --option [value]                           Specify value
    --help|-h                                  Print this help information
  " | expand -i -t 2

#::::::::::::::::::::DETECT PROMPT::::::::::::::::::::

#if running interactively:
if tty -s <&1; then
  colorize=' --color=always'
else #running for file output or consumption, non-interactively:
  colorize=''
fi
#Only run when interactive (example when setting terminal title):
tty -s <&1 && echo -en "\033]0;TITLE\a"
#Set title when wanting it to update on each prompt:
PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
PROMPT_COMMAND='echo -ne "\033]0;YOUR TITLE GOES HERE\007"'

#::::::::::::::::::::TERMINAL PROMPT::::::::::::::::::::

#Escape coloring effecting the buffer when changing PS1:
export PS1='\w\[\033[31m\]$\[\033[0m\] '
#WRONG: export PS1='\w\033[31m$\033[0m '
#Not escaping would cause seeminly strange buffer displacement where you are editing later on the line.
#Wrap the coloring in \[ \] to prevent it from changing the perceived length of the output.

#VARIABLES (source):
#  \d   The date, in "Weekday Month Date" format (e.g., "Tue May 26"). 
#  \h   The hostname, up to the first . (e.g. deckard) 
# \H   The hostname. (e.g. deckard.SS64.com)
# \j   The number of jobs currently managed by the shell. 
# \l   The basename of the shell's terminal device name. 
# \s   The name of the shell, the basename of $0 (the portion following the final slash). 
# \t   The time, in 24-hour HH:MM:SS format. 
# \T   The time, in 12-hour HH:MM:SS format. 
# \@   The time, in 12-hour am/pm format. 
# \u   The username of the current user. 
# \v   The version of Bash (e.g., 2.00) 
# \V   The release of Bash, version + patchlevel (e.g., 2.00.0) 
# \w   The current working directory. 
# \W   The basename of $PWD. 
# \!   The history number of this command. 
# \#   The command number of this command. 
# \$   If you are not root, inserts a "$"; if you are root, you get a "#"  (root uid = 0) 
# \nnn   The character whose ASCII code is the octal value nnn. 
# \n   A newline. 
# \r   A carriage return. 
# \e   An escape character. 
# \a   A bell character.
# \\   A backslash. 

# \[   Begin a sequence of non-printing characters. (like color escape sequences).
  #This allows bash to calculate word wrapping correctly.
# \]   End a sequence of non-printing characters.

#Change the terminal title (or tab title) using this syntax:
echo -en "\033]0;title\a"

#::::::::::::::::::::COPYING::::::::::::::::::::

#copy one file into many:
  tee <oldFile newFile1 newFile2 >/dev/null

#copy boot sector (rouphly)
  dd if=/dev/hda of=WindowsXP.mbr bs=512 count=63
#copy random data to dev null for testing:
  dd if=/dev/random of=/dev/null bs=1K count=100
#copy a whole disk drive
  dd if=/dev/input of=/dev/output bs=32
#write an image to a drive
  dd bs=4M if=file.img of=/dev/sdb

#Show dd progress:
  pkill -USR1 -n -x dd
  #find process id:
  pgrep -l '^dd$'
  #send signal to print:
  kill -USR1  8789
  #or run every 2 seconds:
  watch pkill -USR1 dd

#copy a file:
  cp src dest
  cp -R src dest
  #cp recursively, force (no prompt), update (files missed before only), verbose (prints files as copying them)

  #for many small files:
    #start with cp (speed) = can leave partial files if interrupted
    #switch to rsync (accuracy) = performance hit for checking files

  #cp (fast)
  cp -Rfuv src dest
    #  -u, --update
    #  -v, --verbose, shows files being copied:
      ‘source/being/copied.txt’ -> ‘desitnation/copied/to.txt’
    #  -R, -r, --recursive
    #  -f, --force
  #rsync (accurate)
  rsync -vrpt --append
    #  -v, --verbose           increase verbosity, shows files being copied:
      source/being/copied.txt
    #  -r, --recursive         recurse into directories
    #  -u, --update            skip files that are newer on the receiver
    #  -p, --perms             preserve permissions
    #  -t, --times             preserve times
    #  --progress              show progress during transfer
    #  --bwlimit=KBPS          limit I/O bandwidth; KBytes per second
    #  -f, --filter=RULE
    #  --inplace               don't move handle last, meaning interruptions can leave partial files
    # --append                continue where left off, assuming no changes to the src
  #tar (very fast)
    cd /source/path/ && tar cf - * | (cd /destination/path/ ; tar xf - )
    #order matters with -C (so you can include the path in the process, but not in the archive:
    tar cf - -C /source/path/ . | (cd /destination/path/ ; tar xf - )
#rename in bulk:
  rename 's/kimiKiss([^P])/kimiKissPureRouge\1/' *.flv

#Change ubuntu menu icon:
  sudo cp /usr/share/icons/UbuntuStudio/32x32/places/gnome-main-menu.png /usr/share/icons/gnome/32x32/places/gnome-main-menu.png
  #(change 32x32 to other sizes to get all of them, I think the main one is 22x22 or 24x24, this changes ubuntu to ubuntu-studio)

#force empty trash:
  cd ~/.local/share/
  chmod -R 700 Trash/
  #(then use the GUI)

#Transfer files over network (untested):
  #sender (run receiver first):
  tar cf - * | netcat otherhost 7000
  #receiver:
  netcat -l -p 7000 | tar x

#::::::::::::::::::::IMAGES::::::::::::::::::::

#use image magick to reduce image file size without changing the size of the image (no scale, only quality but it's still good quality)
  convert -density 36 -geometry 50% *.JPG image_.jpg

#convert jpg to ascii:
  jp2a Untitled.jpg > alien.txt

#::::::::::::::::::::ENCODING/DECODING::::::::::::::::::::

#encode binary to base64 plain text:
  base64 file.bin > file.txt
#convert base64 text into binary:
  base64 -d <<< "aGVsbG8gd29ybGQK" > file.bin
  base64 -d < file.txt > file.bin

#::::::::::::::::::::VIDEO ENCODING/DECODING::::::::::::::::::::

#to download files that use mms (IE asx files)
  mplayer -dumpfile somefile.wmv -dumpstream mms://somehost.com/somedirectory/somefile.wmv

#convert flv (youtube video) to mpg/vcd
  ffmpeg -i input.flv -ab 56 -ar 22050 -b 500 -s 320x240 output.mpg
  ffmpeg -i input.flv -f vcd output.mpg

#re-container MOD to MP4:
  ffmpeg -i video.MOD -c:copy video.mp4
#find and convert all of the MOD files:
  find ./ -type f -name "*.MOD" -exec ffmpeg -i "{}" -c:copy "{}.mp4" \;

#convert using mencoder (mplayer) from MTS to AVI:
  mencoder "$1" -o "${1%.*}.avi" -oac copy -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=10000 -fps 50 -vf scale=1920:1080

#minimum for no GUI:
#  vlc -I http
#  (then comes the filename or other commands)
#exit on finishing:
#  vlc:quit
#example of a mms stream:
vlc -I http $location :demux=dump :demuxdump-file=out.wma vlc:quit
#example of encoding for rockbox:
vlc -I http "$1" --sout="#transcode{vcodec=mp2v,vb=600,width=320,height=240, acodec=mpga,ab=128,samplerate=44100,audio-sync}:std{access=file,mux=ps,url=$1.mpg}" vlc:quit


#::::::::::::::::::::AUDIO ENCODING/DECODING::::::::::::::::::::

#Test 5.1 Surround Sound:
  speaker-test -b 8192 -Dplug:surround51 -c6

#change volume from the command line:
  amixer -q set Master 1- unmute
  amixer -q set Master 1+ unmute


#::::::::::::::::::::MUSIC TAGGING::::::::::::::::::::
id3v2 -t "Paranoid" -a "Garbage" Paranoid.mp3 
id3v2 -l Paranoid.mp3 
  id3v1 tag info for Paranoid.mp3:
  Title  : Paranoid                        Artist: Garbage                       
  Album  :                                 Year:     , Genre: Unknown (255)
  Comment:                                 Track: 0
  id3v2 tag info for Paranoid.mp3:
  TIT2 (Title/songname/content description): Paranoid
  TPE1 (Lead performer(s)/Soloist(s)): Garbage
