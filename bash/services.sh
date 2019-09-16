#!/bin/bash
#::::::::::::::::::::SYSV STARTUP::::::::::::::::::::

#list services and their current status:
service --status-all
#add a service (debian):
update-rc.d apache2 defaults
#Redhat/CentOS:
  #list runlevel settings:
  chkconfig --list
  #add service:
  chkconfig --add iptables
  #delete service:
  chkconfig --del ip6tables
  #edit runlevels:
  chkconfig --level 5 nfsserver off
  #edit multiple runlevels at once:
  chkconfig --level 35 nfsserver off
  #edit general on/off:
  chkconfig iptables on

#Run levels:
Run Level    Mode                               Action
0           Halt                               Shuts down system
1           Single-User Mode                   Does not configure network interfaces, start daemons, or allow non-root logins
2           Multi-User Mode                   Does not configure network interfaces or start daemons.
3           Multi-User Mode with Networking   Starts the system normally.
4           Undefined                         Not used/User-definable
5           X11                               As runlevel 3 + display manager(X)
6           Reboot                             Reboots the system

/etc/rc.local/
#SysV startup scripts:
  /etc/init.d/

#write your own:
  #!/bin/bash
  # chkconfig: 2345 20 80
  # description: Description...

  case "$1" in 
      start)
         ;;
      stop)
         ;;
      restart)
         $0 stop
         $0 start
         ;;
      status)
         ;;
      *)
         echo "Usage: $0 {start|stop|status|restart}"
         ;;
  esac

#chkconfig line:
  # chkconfig: 2345 20 80
  # chkconfig: [runlevels] [start priority] [stop priority]
  # chkconfig: - 20 80 #default off

#source: https://unix.stackexchange.com/questions/20357/how-can-i-make-a-script-in-etc-init-d-start-at-boot


#Utilizing functions:

  #/etc/init.d/${service}:
    #!/bin/bash
    # chkconfig: 2345 20 80
    # description: Description...

    service=${0##*/}
    . /etc/init.d/functions

    LOCK=/var/run/${service}.lock
    PID=/var/run/${service}.pid
    LOG=/var/log/${service}.log
    SERVICE=/bin/${service}.sh

    start() {
      echo -n "Starting ${service} server: "
      if [ -f $PID ] && [ $(checkpid $(<$PID);echo $?) ];then
        failure $"${service} already running"
        echo
        return 1
      fi
      $SERVICE >/dev/null 2>&1 &
      touch $LOCK
      success "${service} server startup"
      echo
    }

    stop() {
      echo -n "Stopping ${service} server: "
      killproc ${service}.sh
      rm -f $LOCK
      echo
    }

    case "$1" in 
      start|stop)
          $1
        ;;
      restart)
          $0 stop
          $0 start
        ;;
      status)
          status -p ${PID} ${service}
          tail ${LOG}
        ;;
      *)
          echo "Usage: $0 {start|stop|status|restart}"
        ;;
    esac

  #service.sh:

    #!/bin/bash

    LOCK=/var/run/${service}.lock
    PID=/var/run/${service}.pid
    LOG=/var/log/${service}.log

    exec 1> >(tee $LOG) 2>&1

    echo $$ > $PID

    function cleanup
    {
      echo "closing service"
      rm -f $LOCK $PID
      kill -- -$$
      exit
    }
    trap cleanup SIGHUP SIGINT SIGTERM EXIT

#source: https://www.cyberciti.biz/tips/linux-write-sys-v-init-script-to-start-stop-service.html

#::::::::::::::::::::SYSTEMD STARTUP::::::::::::::::::::


#systemd startup script as a setup service:
  /usr/lib/systemd/system/setup.service:
    [Unit]
    Description=Setup Script at Boot
    After=syslog.target network.target systemd-tmpfiles-setup.target
    Before=httpd.service tomcat.service mysql.service mariadb.service

    [Service]
    Type=oneshot
    ExecStart=/usr/libexec/setup

    [Install]
    WantedBy=multi-user.target
#service:
  /usr/lib/systemd/system/service.service:
    [Unit]
    Description=Service

    [Service]
    Type=forking
    ExecStart=/usr/libexec/service start
    ExecStop=/usr/libexec/service stop

    [Install]
    WantedBy=multi-user.target

#install file:
  install -m 644 -o root -g root service.service /usr/lib/systemd/system/service.service

#after modifying:
  systemctl daemon-reload

#::::::::::::::::::::MYSQL::::::::::::::::::::

#mysql:
  #to edit mysql:
    mysql -u root -p mysql
  #restart mysql:
    sudo /etc/init.d/mysql restart
  #run mysql script (p = database/schema):
    mysql -u$USER -p$PASSWORD < sqlDEMO.sql
  #run mysql inline:
    /usr/bin/mysql -h$SERVER -u$USER -p$PASSWORD -BNe "SELECT now()"
    #B = batch results, using tab as column separator
    #N = skip column names
    #e = execute statements

#::::::::::::::::::::APACHE/HTTPD::::::::::::::::::::

#restart apache2
  sudo /etc/init.d/apache2 restart
  sudo service apache2 restart

#apache setup
  sudo apt-get install apache2 php5 libapache2-mod-perl2 php5-sqlite
  sudo a2ensite 000-default
  sudo service apache2 reload

  sudo a2enmod cgi
  sudo a2enmod rewrite
  sudo service apache2 restart

  #change site directory in:
  grep -r 'var/www' . #find the spots
  sudo nano /etc/apache2/sites-available/000-default.conf 
  sudo nano /etc/apache2/sites-available/default-ssl.conf 
  sudo nano /etc/apache2/apache2.conf #include trailing /, none of the others have the trailing /
  #add ExecCGI to the Options list and AddHandler in /etc/apache2/apache2.conf
  #also add overrides for htaccess:
  AddHandler cgi-script .cgi .pl
  <Directory /home/steve/work/www/>
    Options Indexes FollowSymLinks ExecCGI
    AllowOverride All
    Order allow,deny
    allow from all
    Require all granted
  </Directory>
  #apache logs:
  tail -f /var/log/apache2/error.log

  #add ssl:
  sudo a2enmod ssl
  sudo a2ensite a2enmod default-ssl
  sudo openssl genrsa -out /etc/ssl/private/steve8track.key 1024
  sudo openssl req -new -key /etc/ssl/private/steve8track.key -x509 -out /etc/ssl/certs/steve8track.crt
  #Update certificate paths in /etc/apache2/sites-enabled/default-ssl.conf
  sudo service apache2 reload

  #localhost only:
    /etc/apache2/sites-available/default
    #find the line that says "allow from all" and change it to "allow from localhost"
    #also you can change the site's path from /var/www/ in two places

#apache install mod_rewrite
  sudo a2enmod rewrite
  #also in sites-enabled, allow overrides from all

#apache2 history of visitors:
  /var/log/apache2/access.log

#::::::::::::::::::::CASSANDRA::::::::::::::::::::

#install client (centos7):
yum install -y epel-release python2-pip
pip install --upgrade pip
pip install cqlsh

#connect to server:
cqlsh cassandra.intra.net
cqlsh --cqlversion 3.4.4 cassandra.intra.net 9042

#::::::::::::::::::::PHP::::::::::::::::::::

#php.ini file location:
  /etc/php5/apache2/php.ini
  #you can turn magic quotes on and off here

  #noteworthy:
  magic_quotes_gpc = On
  magic_quotes_runtime = Off
  magic_quotes_sybase = On

#::::::::::::::::::::X SERVER::::::::::::::::::::

#video settings:
  /etc/X11/xorg.conf

#restart/stop/start X examples:
  sudo /etc/init.d/gdm stop
  sudo /etc/init.d/mdm restart

#::::::::::::::::::::MAC OSX::::::::::::::::::::
sudo su #if you want root services
launchctl list | less #show running services
launchctl unload -w /Library/LaunchDaemons/com.mcafee.agent.ma.plist #remove service from startup

#plist locations:
  /System/Library/LaunchDaemons/  #System-wide daemons provided by Mac OS X
  /System/Library/LaunchAgents/   #Per-user agents provided by Mac OS X.
  ~/Library/LaunchAgents/         #Per-user agents provided by the user.
  /Library/LaunchAgents/          #Per-user agents provided by the administrator.
  /Library/LaunchDaemons/         #System-wide daemons provided by the administrator.

#source: https://www.cyberciti.biz/faq/disabling-unnecessary-mac-osx-services/

#::::::::::::::::::::OTHER::::::::::::::::::::

#mailserver:
  sudo vim /etc/postfix/main.cfg
  sudo /etc/init.d/postfix restart

#power:
  restart=  reboot
  restart=  shutdown -r
  shutdown=  shutdown -h

#restart networking service:
  sudo /etc/init.d/networking restart

#wireshark setup for non-root users:
  sudo dpkg-reconfigure wireshark-common
  sudo usermod -a -G wireshark steve

#check bluetooth service status:
  systemctl status bluetooth.service
#if bluetoothctl hangs, try disabling sixad (ps3 support):
  sixad --stop
#bluetoothctl is for bluez5 (commands mentioning bluez-simple-agent are for bluez4)
  $ bluetoothctl 
  [NEW] Controller 00:02:72:AF:C7:C2 retropie [default]
  [bluetooth]# power on
  Changing power on succeeded
  [bluetooth]# devices
  [bluetooth]# scan on
  Discovery started
  [CHG] Controller 00:02:72:AF:C7:C2 Discovering: yes
  [NEW] Device 01:06:B2:96:61:07 01-06-B2-96-61-07
  [bluetooth]# agent on
  Agent registered
  [CHG] Device 01:06:B2:96:61:07 LegacyPairing: no
  [CHG] Device 01:06:B2:96:61:07 Name: 8Bitdo NES30 Pro
  [CHG] Device 01:06:B2:96:61:07 Alias: 8Bitdo NES30 Pro
  [CHG] Device 01:06:B2:96:61:07 LegacyPairing: yes
  [bluetooth]# pair 01:06:B2:96:61:07
  Attempting to pair with 01:06:B2:96:61:07
  [CHG] Device 01:06:B2:96:61:07 Connected: yes
  Request PIN code
  [agent] Enter PIN code: 0000
  [CHG] Device 01:06:B2:96:61:07 Modalias: usb:v3820p0009d0100
  [CHG] Device 01:06:B2:96:61:07 UUIDs:
    00001124-0000-1000-8000-00805f9b34fb
    00001200-0000-1000-8000-00805f9b34fb
  [CHG] Device 01:06:B2:96:61:07 Paired: yes
  Pairing successful
  [CHG] Device 01:06:B2:96:61:07 Connected: no
  [bluetooth]# connect 01:06:B2:96:61:07
  Attempting to connect to 01:06:B2:96:61:07
  [CHG] Device 01:06:B2:96:61:07 Connected: yes
  Connection successful
  [bluetooth]#
