#!/bin/bash

#::::::::::::::::::::MAN PAGES::::::::::::::::::::

#view man pages when multiples:
#`man kill` says to see signals(7), so do this:
man 7 signals

#::::::::::::::::::::TERMINAL NAVIGATION::::::::::::::::::::

Ctrl+r 	#search history, ESC to paste the currently found entry
! 			#reruns last command that uses the letter after the !
	#Example:
	!l #would run ls if it is the last command used starting with l

#::::::::::::::::::::X SESSIONS::::::::::::::::::::

#start another x session
	startx -- :1 (replace with :2, etc)
	#(change file .xinitrc)
	exec /usr/bin/enlightenment
#	  *  KDE = startkde
#    * Gnome = gnome-session
#    * Blackbox = blackbox
#    * FVWM = fvwm (or, for FVWM2 it's fvwm2, surprise)
#    * Window Maker = wmaker
#    * IceWM = icewm

#::::::::::::::::::::WINDOW MANAGEMENT::::::::::::::::::::

wmctrl
xwininfo -id <windowid> | grep "Map State" #detect visibility
#example notify-send if geany is not on the screen:
	width=1600
	geanyId=$(wmctrl -l | grep Geany)
	geanyId=${geanyId%% *}
	xPos=$(xwininfo -id $geanyId | grep "Absolute upper-left X:")
	xPos=${xPos##* }
	echo $xPos
	if [ $xPos -gt 0 ] || [ $xPos -le -$width ]; then
		notify-send "DEPLOYED $1"
	fi

#::::::::::::::::::::OPEN TERMINALS::::::::::::::::::::

#terminal with multiple tabs from command line, hold (-H) open even when commands are complete:
	xfce4-terminal -H -e "echo hello" --tab -H -e "echo world"
	xfce4-terminal -H -T "Title 1" -e "echo hello" --tab -H -T "Title 2" -e "echo world"
#gnome/mate-terminal doesn't have the hold feature:
	mate-terminal \
		--tab-with-profile=Titleable -t "CS Tools (tomcat6)" -e "ssh $user@$dcc \"tail -f /var/lcta/tomcat6/logs/lcta_log\"" \
		--tab-with-profile=Titleable -t "Apache (perl/CC)" -e "ssh $user@$cc \"tail -f /var/cc/logs/error_log-$cc\"" \


#::::::::::::::::::::GLX GRAPHIC ACCELERATION::::::::::::::::::::

#	-b bitrate: set the video bitrate in kbit/s (default = 200 kb/s)
#	-ab bitrate: set the audio bitrate in kbit/s (default = 64)
#	-ar sample rate: set the audio samplerate in Hz (default = 44100 Hz)
#	-s size: set frame size. The format is WxH (default 160×128 )

#Direct Rendering detection (glxgears)
	glxinfo | grep direct

#compiz on nvidia with direct rendering
	__GL_YEILD="NOTHING" compiz --replace --sm-disable --ignore-desktop-hints ccp&


#::::::::::::::::::::NETWORKING::::::::::::::::::::

#IPX network:
	sudo ipx_interface add -p eth0 802.2

#find my local IP address:
	ifconfig

#all interfaces:
	ifconfig -a
#take an interface down:
	ifdown eth0
#start up an interface:
	ifup eth0
#see also udev for defining interfaces:
/etc/udev/rules.d/60-net.rules

#iptables firewall/rules:
service iptables stop
chkconfig iptables off

	#flush away the 'nat' rules
		iptables -t nat -F
	#set some rules:
		iptables -t nat -A PREROUTING -p tcp -d 172.16.142.130 --dport 8443 -j DNAT --to 172.16.142.131:443
		iptables -t nat -A OUTPUT -p tcp -d 172.16.142.130 --dport 8443 -j DNAT --to 172.16.142.131:443
		#so anyone connecting to 172.16.142.130:8443 is forwarded to 172.16.142.131:443
		#note: using -d 127.0.0.1 doesn't seem to work right for these rules
	#list the 'nat' rules:
		iptables -t nat -L 
	#save rules for next boot:
		/etc/init.d/iptables save #save the current rules
		#which is like doing iptables-save > /etc/sysconfig/iptables

#see server IP address:
	host google.com

#DNS lookup utility:
	dig google.com

#Look up mx record:
	#MX = Mail Exchanger == SMTP for inbound
  nslookup -type=mx domain.com
  dig domain.com MX
  dig +trace domain.com
  host -t mx domain.com nameserver-local.com

#RBL (Real-time-blacklist DNS) lookup:
	#reverse the IP digits:
		107.181.132.237 => 237.132.181.107
	#append the rbl server and check:
		nslookup 237.132.181.107.rblservice

	#NOT in list:
	#  ~ $ nslookup 237.132.181.107.rbl0101
	#  Server:		192.168.1.219
	#  Address:	192.168.1.219#53
	#
	#  ** server can't find 237.132.181.107.rbl0101: NXDOMAIN

	#IN list (and therefor blocked):
	#  Server:		192.168.1.219
	#  Address:	192.168.1.219#53
	#
	#  Name:	rbl0105.sj2.proofpoint.com
	#  Address: 192.168.0.251

#scan for other computers (port sniff), their OSs and IP addresses:
	sudo nmap -O -sS 192.168.0.1-255

#list computers in your local network:
	sudo arp-scan --interface=eth0 --localnet

#look at traffic:
	wireshark
#set wireshark to allow non-root users:
	sudo apt-get install wireshark
	sudo dpkg-reconfigure wireshark-common #sometimes included in installation
	sudo usermod -a -G wireshark $USER
	#restart your login session

#look up my external IP:
	curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'

#telnet:
	#IMAP:
	telnet imap.email.com 143
	x login user@email.com Password
	x LIST "" "*"
	#HTTP:
	telnet hostname.com 80
	GET / HTTP/1.1
	Host: hostname.com

#look at open ports and the programs using them:
	sudo netstat -ltnp

#::::::::::::::::::::WIFI::::::::::::::::::::

#activate:
	sudo modprobe ndiswrapper
#install:
	sudo ndiswrapper -i bcmwl5.inf #(fill out your own drivers for bcmwl5.inf)
#view what's installed:
	sudo ndiswrapper -l (shows if the driver is installed)
#activate and test:
	sudo modprobe ndiswrapper
	sudo dmesg (shows that the card is installed (hopefully))
	sudo iwlist wlan0 scan (shows all APs surrounding you)
#load at bootup:
	sudo ndiswrapper -m

#::::::::::::::::::::SYSTEM INFORMATION::::::::::::::::::::

#find system info:
	lshw
	hwinfo
	lspci

#Find your distribution:
	cat /etc/issue
#show system info like ram/memory bios, etc
	sudo dmidecode
#process information
	jobs
	ps -elf | grep "process"
	top
	htop
	jobs -p #get the pids of all thread started from within this shell/script
	pgrep
	pkill
	kill -9 $pid #aggresively kill a stubborn process
	killall

#cpu speeds:
	cat /proc/cpuinfo
#cpu set to performance:
	sudo cpufreq-selector -c 0 -g performance
	sudo cpufreq-selector -c 1 -g performance
#cpu available frequencies:
	cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
#Check Soundcard for Hardware Mixing (playback >1 means it can do hardware mixing)
	cat /proc/asound/pcm

#get linux kernel version:
	uname -r

#get linux version (redhat flavors):
	cat /etc/redhat-release

#default applications are set in:
	/etc/gnome/defaults.list

#Edit gconf-editor from command line:
	#(epiphany setting as example: Loading the clipboard url on middle-click like Mozilla)
	gconftool-2 --set /apps/epiphany/general/middle_click_open_url --type bool true

#find path of an executable:
	which command_name
		which perl
		/usr/bin/perl
