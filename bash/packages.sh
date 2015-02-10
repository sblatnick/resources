#!/bin/bash

#see what's installed example (debian):
	dpkg --list | grep [app_name]

#rpm/fedora/yum based linux:
	yum install fuse-sshfs
	yum search package

#debian:
	apt-get install package
	apt-cache search package

#OpenGL glut libraries:
	libgl1-mesa-dev
	freeglut3-dev
	xlibmesa-gl-dev
	mesa-common-dev

#force 64 bit architecture on a x86 deb file:
	sudo dpkg -i --force-architecture nameofpackage.deb

#how to install building from source dependencies:
	sudo apt-get build-dep programName

#reinstall packages
	sudo apt-get --reinstall install packageNames
#Reinstall OpenGL:
	sudo apt-get install --reinstall libgl1-mesa-dev freeglut3-dev xlibmesa-gl-dev mesa-common-dev

#check package version:
	dpkg -l packageName

#compile ffmpeg for mp4 aac audio (psp/ipod, patent issues?) DIDN'T WORK?!
	apt-get source ffmpeg
	cd ffmpeg-*/
	./configure --enable-gpl --enable-pp --enable-pthreads --enable-libogg --enable-a52 --enable-dts --enable-dc1394 --enable-libgsm --disable-debug --enable-libmp3lame --enable-libfaad --enable-libfaac --enable-xvid --enable-x264
	#(keep running until all the dependencies are met)
	make
	sudo make install