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

#::::::::::::::::::::RENDER ENV::::::::::::::::::::

#render template with shell environment variables:
  #prep:
    #maven directory
    cd .m2/
    cp settings.xml settings.xml.bak settings.xml.tpl
    #tpl has "env." removed from variables:
    sed 's/env\.//g' settings.xml.tpl

  #substitute out variables:
    envsubst < settings.xml.tpl > settings.xml.filled

#::::::::::::::::::::LINKS::::::::::::::::::::

#symbolic link:
  ln -s target link #(use -t for a directory)
  ln -s /path/to/real/file /path/to/non-existant/file
  #get target path from link:
  readlink -f /path/to/link
#hard link
  ln target link

#::::::::::::::::::::COPYING::::::::::::::::::::

#copy one file into many:
  tee <oldFile newFile1 newFile2 >/dev/null

#copy boot sector (rouphly)
  dd if=/dev/hda of=WindowsXP.mbr bs=512 count=63 status=progress
#copy random data to dev null for testing:
  dd if=/dev/random of=/dev/null bs=1K count=100 status=progress
#copy a whole disk drive
  dd if=/dev/input of=/dev/output bs=32 status=progress
#write an image to a drive
  dd bs=4M if=file.img of=/dev/sdb status=progress

#Show dd progress (just add status=progress to the dd command instead):
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
#dump hex from binary by piping to xxd or passing it in as a file:
  ~ $ base64 -D <<< "aGVsbG8gd29ybGQK" | xxd
  00000000: 6865 6c6c 6f20 776f 726c 640a            hello world.

#::::::::::::::::::::COMPRESSION/DECOMPRESSION::::::::::::::::::::

  #INPLACE:
    #view list of contained files:
      less archive.tgz
    #print contents of a file:
      tar xfO archive.tgz README.txt
    #delete file from jar/zip:
      zip -d file.jar path/to/file.txt

  #Extract:
    tar xvzf archive.tar.gz
      -x  extract
      -v  verbose
      -z  uncompress
      -f  filename
      -C  ./output/path

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
