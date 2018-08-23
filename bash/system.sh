#!/bin/bash

#::::::::::::::::::::MAN PAGES::::::::::::::::::::

#view man pages when multiples:
#`man kill` says to see signals(7), so do this:
man 7 signals

#::::::::::::::::::::SUDO::::::::::::::::::::

#Act as root:
sudo su
#Act as user when running commands and pass the password in using -S:
echo "password" | sudo -S -H -u user bash -c "echo 'hello world'"

#Even fake tty via 'script':
script -q /dev/null cat << EOF
  echo "password" | sudo -S -H -u xbuild bash -c "
    cd ~/${VARIABLE}
    pwd
  "
EOF

#::::::::::::::::::::TERMINAL NAVIGATION::::::::::::::::::::

Ctrl+r   #search history, ESC to paste the currently found entry
!       #reruns last command that uses the letter after the !
  #Example:
  !l #would run ls if it is the last command used starting with l

#::::::::::::::::::::X SESSIONS::::::::::::::::::::

#start another x session
  startx -- :1 (replace with :2, etc)
  #(change file .xinitrc)
  exec /usr/bin/enlightenment
#    *  KDE = startkde
#    * Gnome = gnome-session
#    * Blackbox = blackbox
#    * FVWM = fvwm (or, for FVWM2 it's fvwm2, surprise)
#    * Window Maker = wmaker
#    * IceWM = icewm

#::::::::::::::::::::WINDOW MANAGEMENT::::::::::::::::::::

wmctrl
wmctrl -l #list windows
wmctrl -a Firefox #focus window with this string in the title, going to the desktop
wmctrl -R Firefox #focus window with this string in the title, putting it on the current desktop
xdotool windowminimize $(xdotool getactivewindow)
xdotool windowminimize $(xdotool search FreeRDP)
xdotool windowminimize --sync $(xdotool search FreeRDP) #wait until minimized to move on

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

#example toggle visibility of window (use shortcut to call this script):
#!/bin/bash

focused=$(xdotool getwindowfocus getwindowname)
case $focused in
  *FreeRDP*)
      xdotool windowminimize --sync $(xdotool search FreeRDP)
    ;;
  *)
      wmctrl -R 'FreeRDP'
    ;;
esac

#::::::::::::::::::::OPEN TERMINALS::::::::::::::::::::

#terminal with multiple tabs from command line, hold (-H) open even when commands are complete:
  xfce4-terminal -H -e "echo hello" --tab -H -e "echo world"
  xfce4-terminal -H -T "Title 1" -e "echo hello" --tab -H -T "Title 2" -e "echo world"
#gnome/mate-terminal doesn't have the hold feature:
  mate-terminal \
    --tab-with-profile=Titleable -t "Test Log" -e "ssh $user@$host \"tail -f /var/log/test.log\"" \
    --tab-with-profile=Titleable -t "Apache" -e "ssh $user@$host \"tail -f /var/log/httpd/error_log-$host\"" \


#::::::::::::::::::::GLX GRAPHIC ACCELERATION::::::::::::::::::::

#  -b bitrate: set the video bitrate in kbit/s (default = 200 kb/s)
#  -ab bitrate: set the audio bitrate in kbit/s (default = 64)
#  -ar sample rate: set the audio samplerate in Hz (default = 44100 Hz)
#  -s size: set frame size. The format is WxH (default 160×128 )

#Direct Rendering detection (glxgears)
  glxinfo | grep direct

#compiz on nvidia with direct rendering
  __GL_YEILD="NOTHING" compiz --replace --sm-disable --ignore-desktop-hints ccp&


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

#::::::::::::::::::::GRUB::::::::::::::::::::

#edit grub default settings:
  sudo vi /etc/default/grub
    GRUB_TIMEOUT=0 #set to 0 wait time in grub menu
#apply defaults:
  #CentOS/Redhat:
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
  #Debian:
  sudo update-grub
  
#/boot/grub2/grub.cfg is where new kernels are listed when installed in /boot

#::::::::::::::::::::SYSTEM INFORMATION::::::::::::::::::::

#find system info:
  lshw
  hwinfo
  lspci

#Find your distribution:
  cat /etc/issue
#Find kernel parameters passed at boot by grub:
  cat /proc/cmdline
#show system info like ram/memory bios, etc
  sudo dmidecode
#process information
  jobs
  ps -elf | grep "process"
  ps -o etime= -p $(pgrep java) #how long java process has been running in days,hrs,etc
  ps -o etimes= -p $(pgrep java) #how long java process has been running in sec
  ps auxwe | grep $pid #full command in process
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

#::::::::::::::::::::USERS::::::::::::::::::::
#list distinct users:
cut -d: -f1 /etc/passwd
#list users currently logged in:
users
who
#add user:
sudo adduser name
sudo useradd name
#delete user:
sudo userdel name
#then clear the users home if applicable:
sudo rm -Rf /home/name
#modify user name:
usermod -l new_username old_username
#update user password:
sudo passwd username
#change shell for user:
sudo chsh username
#change user details:
sudo chfn username

#::::::::::::::::::::INIT::::::::::::::::::::
#old way is via init scripts:
/etc/init.d/tomcat start
#list:
chkconfig --list

#enabling:
chkconfig tomcat on
chkconfig tomcat off

#::::::::::::::::::::SYSTEMD::::::::::::::::::::
#systemd replaces SysV init.d:
systemctl start tomcat
#list:
systemctl #no arguments
systemctl list-units

#enabling:
systemctl enable tomcat
systemctl disable tomcat
systemctl is-enabled tomcat

#the script it runs is:
/usr/lib/systemd/system/tomcat.service
#logs are now stored via:
journalctl -u tomcat
#tail the log by the follow option:
journalctl -fu tomcat

#enable logs from previous boots:
mkdir /var/log/journal
systemd-tmpfiles --create --prefix /var/log/journal
systemctl restart systemd-journald

#look at previous logs:
journalctl -o short-precise -k -b -1
# -b means what boot relative to 0
# -k means dmesg
# -o means improves the readability to show human readable time

#Instead of modifying the script in /usr/lib/systemd/system/
#I found this note in mariadb.service:

  # It's not recommended to modify this file in-place, because it will be
  # overwritten during package upgrades.  If you want to customize, the
  # best way is to create a file "/etc/systemd/system/mariadb.service",
  # containing
  #  .include /lib/systemd/system/mariadb.service
  #  ...make your changes here...
  # or create a file "/etc/systemd/system/mariadb.service.d/foo.conf",
  # which doesn't need to include ".include" call and which will be parsed
  # after the file mariadb.service itself is parsed.

#Then reload after modifying:
systemctl daemon-reload

#NOTE: I couldn't get it to work through those other files

#See also:
# http://www.dynacont.net/documentation/linux/Useful_SystemD_commands/
# https://blog.hqcodeshop.fi/archives/93-Handling-varrun-with-systemd.html

#remove service:
systemctl stop service
systemctl disable service
rm /usr/lib/systemd/system/service.service /usr/libexec/service
systemctl daemon-reload
systemctl reset-failed #clear failures

#::::::::::::::::::::LIMITS::::::::::::::::::::
#limits on file handles, processes, etc:

#USER:
  #list:
  ulimit -a
  #see a user that can't be logged in:
  sudo -i -u mysql ulimit -a
  #configured in:
  /etc/security/limits.conf
  /etc/security/limits.d/

#SYSTEM:
  #list:
  sysctl -a

  #configured in:
  /etc/sysctl.conf
  /etc/sysctl.d/

  #get one:
  /sbin/sysctl net.ipv4.tcp_challenge_ack_limit

  #flush updates:
  sysctl -p

#::::::::::::::::::::KVM::::::::::::::::::::
virt-manager
virsh list --all
virsh shutdown name
virsh start name
virsh destroy name #shutdown by power off
virsh undefine #delete the vm definition (does not delete volumes, `lvremove /dev/vol0/hostname`)

#::::::::::::::::::::PROXY::::::::::::::::::::

#Setup named/bind as a service:
yum install -y bind bind-utils
systemctl start named
systemctl enable named
named-checkconf /etc/named.conf #test configuration
yum install -y checkzone
named-checkzone example.com example.com #test zone file
yum install -y httpd mod_proxy_html

vi /etc/resolv.conf:
  nameserver 127.0.0.1

vi /etc/named.conf:
  options {
    directory "/var/named";
    forward only;
    forwarders { 8.8.8.8; 8.8.4.4; }; #replace with auth DNS IPs
  };

  zone "." {
    type hint;
    file "named.ca";
  };

  zone "example.com" {
    type master;
    file "example.com";
  };

vi /etc/httpd/conf/httpd.conf
  ServerTokens OS
  ServerSignature On
  TraceEnable On

  ServerName "host.com"
  ServerRoot "/etc/httpd"
  PidFile run/httpd.pid
  Timeout 120
  KeepAlive Off
  MaxKeepAliveRequests 100
  KeepAliveTimeout 15
  LimitRequestFieldSize 8190

  User nobody
  Group nobody

  AccessFileName .htaccess
  <FilesMatch "^\.ht">
      Require all denied
  </FilesMatch>

  <Directory />
    Options FollowSymLinks
    AllowOverride None
  </Directory>

  HostnameLookups Off
  ErrorLog "/var/log/httpd/error_log"
  EnableSendfile On

  Listen 8085
  UseCanonicalName On
  ServerSignature On

  LoadModule proxy modules/mod_proxy.so
  Include "/etc/httpd/conf.modules.d/*.load"
  Include "/etc/httpd/conf.modules.d/*.conf"
  Include "/etc/httpd/conf/ports.conf"

  #Concise log format, but verbose lines:
  LogLevel trace8
  ErrorLogFormat "%t[%m]: %M"

  #This is just a proxy, so don't include other configs:
  #IncludeOptional "/etc/httpd/conf.d/*.conf"

  #Set up a local proxy using /etc/named DNS:
  ProxyRequests On
  ProxyVia On
  RewriteEngine on
  RewriteOptions AllowAnyURI

  #Allow port override seamlessly (not redirected in browser) in the proxy:
  AllowConnect 443 8443

  RewriteCond %{HTTP_HOST} ^example.com$
  RewriteCond %{SERVER_PORT} ^80$
  RewriteRule example\.com/(.*)$ http://example.com:8080/$1 [L,P]

  RewriteCond %{REQUEST_METHOD} CONNECT
  RewriteRule example\.com:443$ example.com:8443 [L,P]
