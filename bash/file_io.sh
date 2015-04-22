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

#::::::::::::::::::::CHANNELS AND ROUTING::::::::::::::::::::

#redirect STDERR to STDOUT:
script 2>&1
#redirect STDERR to file:
bash -x run 2>output.txt

#route to a null device
	> /dev/null

#print BOTH to stdout and to a file (-a means append):
	echo hello world | tee -a /tmp/column.csv.$pid | sed "s/^/  /"

#::::::::::::::::::::COMBINE COLUMNS::::::::::::::::::::

#merge lines of a file:
	pr -mts' ' file1 file2
	paste -d' ' file1 file2

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
#	(must close it or it will continue after)
#or in C:
#   	printf("\033[34m This is blue.\033[0m\n");

#   	Here are the colors:
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

#::::::::::::::::::::DETECT PROMPT::::::::::::::::::::

#if running interactively:
if tty -s <&1; then
	colorize=' --color=always'
else #running for file output or consumption, non-interactively:
	colorize=''
fi
#Only run when interactive (example when setting terminal title):
tty -s <&1 && echo -en "\033]0;TITLE\a"

#::::::::::::::::::::TERMINAL PROMPT::::::::::::::::::::

#Escape coloring effecting the buffer when changing PS1:
export PS1='\w\[\033[31m\]$\[\033[0m\] '
#WRONG: export PS1='\w\033[31m$\033[0m '
#Not escaping would cause seeminly strange buffer displacement where you are editing later on the line.
#Wrap the coloring in \[ \] to prevent it from changing the perceived length of the output.

#VARIABLES (source):
#	\d   The date, in "Weekday Month Date" format (e.g., "Tue May 26"). 
#	\h   The hostname, up to the first . (e.g. deckard) 
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

#copy boot sector (rouphly)
	dd if=/dev/hda of=WindowsXP.mbr bs=512 count=63
#copy random data to dev null for testing:
	dd if=/dev/random of=/dev/null bs=1K count=100
#copy a whole disk drive
	dd if=/dev/input of=/dev/output bs=32

#Show dd progress:
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
		#	-u, --update
		#	-v, --verbose, shows files being copied:
			‘source/being/copied.txt’ -> ‘desitnation/copied/to.txt’
		#	-R, -r, --recursive
		#	-f, --force
	#rsync (accurate)
	rsync -vrpt --append
		#	-v, --verbose           increase verbosity, shows files being copied:
			source/being/copied.txt
		#	-r, --recursive         recurse into directories
		#	-u, --update            skip files that are newer on the receiver
		#	-p, --perms             preserve permissions
		#	-t, --times             preserve times
		#	--progress              show progress during transfer
		#	--bwlimit=KBPS          limit I/O bandwidth; KBytes per second
		#	-f, --filter=RULE
		#	--inplace               don't move handle last, meaning interruptions can leave partial files
		# --append                continue where left off, assuming no changes to the src
	tar
		cd /source/path/ && tar cf - * | (cd /destination/path/ ; tar xf - )

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

#::::::::::::::::::::VIDEO ENCODING/DECODING::::::::::::::::::::

#to download files that use mms (IE asx files)
	mplayer -dumpfile somefile.wmv -dumpstream mms://somehost.com/somedirectory/somefile.wmv

#convert flv (youtube video) to mpg/vcd
	ffmpeg -i input.flv -ab 56 -ar 22050 -b 500 -s 320x240 output.mpg
	ffmpeg -i input.flv -f vcd output.mpg

#minimum for no GUI:
#	vlc -I http
#	(then comes the filename or other commands)
#exit on finishing:
#	vlc:quit
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