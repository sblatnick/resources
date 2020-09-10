#!/bin/bash
#::::::::::::::::::::SYSV::::::::::::::::::::

#list services and their current status:
service --status-all
chkconfig | sed 's/\s\s*/ /g' | cut -d' ' -f1

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

#Exit codes: https://unix.stackexchange.com/questions/226484/does-an-init-script-always-return-a-proper-exit-code-when-running-status
0         program is running or service is OK
1         program is dead and /var/run pid file exists
2         program is dead and /var/lock lock file exists
3         program is not running
4         program or service status is unknown
5-99      reserved for future LSB use
100-149   reserved for distribution use
150-199   reserved for application use
200-254   reserved

#::::::::::::::::::::SYSTEMD::::::::::::::::::::

#List services:
systemctl status #verbose showing of each
systemctl status | grep '.service$' | sed 's/^ *[├│└─ ]*//' | sort -u

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

#vender preset (start at boot or enabled by default)
vi /usr/lib/systemd/system-preset/98-service_name.preset
  #Enable by default:
  enable service_name.service
systemctl reenable queue
systemctl status queue

#after modifying:
  systemctl daemon-reload

#actions:
  systemctl enable service

  systemctl
    #Unit Commands
      #State:
      start PATTERN...                  #Start (activate) one or more units specified on the command line.
      stop PATTERN...                   #Stop (deactivate) one or more units specified on the command line.

      reload PATTERN...                 #Reload service-specific configuration, not the unit configuration file of systemd.
      restart PATTERN...                #Restart/start units.

      try-restart PATTERN...            #Only restart running units.
      reload-or-restart PATTERN...      #Reload units if supported, else restart/start instead
      reload-or-try-restart PATTERN...  #Reload units if supported, else restart running units instead

      isolate NAME                      #Start unit and dependencies and stop all others
      kill PATTERN...                   #Send a signal to one or more processes of the unit
        --kill-who=PROCESS
        --signal=SIGNAL

      #Enablement Settings:
      enable NAME...                    #Enable, creating symlinks
      disable NAME...                   #Disables, removing symlinks

      reenable NAME...                  #Reenable, disable then enable, or reset the symlinks
      preset NAME...                    #Reset default enabled/disabled configured in the preset policy files.
      preset-all                        #Resets all enabled/disabled configured in the preset policy files.

      mask NAME...                      #/dev/null link service unit files, hard disable, can be used with --runtime until next boot, --now to stop service
      unmask NAME...                    #undo the effect of mask

      #Edit:
      link FILEPATH...                  #Link absolute path of unit file that into unit file search path
      add-wants TARGET NAME...          #Adds "Wants=" dependency to the specified TARGET for one or more units.
      add-requires TARGET NAME...       #Adds "Requires=" dependency to the specified TARGET for one or more units.
      edit NAME...                      #Edit a drop-in snippet or a whole replacement file if --full is specified, to extend or override the specified unit.

      reset-failed [PATTERN...]         #Reset the "failed" state of units, or all units.
      set-property NAME ASSIGNMENT...   #Set the specified unit properties at runtime where this is supported.

      get-default                       #Return the default target to boot into. This returns the target unit name default.target is aliased (symlinked) to.
      set-default NAME                  #Set the default target to boot into. This sets (symlinks) the default.target alias to the given target unit.

    #Snapshot of running services:
      snapshot [NAME]                   #If no snapshot name, an automatic snapshot name is generated.
      delete PATTERN...                 #Remove a snapshot previously created with snapshot.
    #Unit Information:
      status [PATTERN...|PID...]]       #status and recent logs
      is-active PATTERN...              #running? return 0 exit code if any one is running (unless --quiet)
      is-failed PATTERN...              #failed? exit code 0 if any one failed (unless --quiet)
      is-enabled NAME...                #enabled? exit code 0 if enabled (unless --quiet)
        String              Return
        "enabled"           0
        "enabled-runtime"   0
        "linked"            1             #available via symlink
        "linked-runtime"    1
        "masked"            1             #/dev/null link
        "masked-runtime"    1
        "static"            0             #not enableable (no [Install] section)
        "indirect"          0             #not enabled, but [Install] has Also= of other units
        "disabled"          1
        "bad"               >0            #invalid unit file or error
      show [PATTERN...|JOB...]          #Show properties of one or more units, jobs, or the manager.
      cat PATTERN...                    #Show backing files with "fragment" and "drop-ins" (source files) preceded by a comment which includes the file name.
      help PATTERN...|PID...            #Show manual pages for one or more units, if available.

      list-units [PATTERN...]           #List known units
      list-unit-files [PATTERN...]      #List installed unit files and is-enabled
      list-dependencies [NAME]          #Recursively shows units required and wanted by the unit
    #Environment Commands
      show-environment                  #Dump environment suitable for sourcing in a shell script
      set-environment VARIABLE=VALUE... #Set environment variables
      unset-environment VARIABLE...     #Unset environment variables. If a value is specified, only unset if the variable has that value.
      import-environment [VARIABLE...]  #Import environment variables. If no arguments are passed, import all
    #Manager Lifecycle Commands
      daemon-reload                     #Reload systemd manager configuration: rerun all generators, reload all unit files, and recreate the entire dependency tree
      daemon-reexec                     #Reexecute the systemd manager: serialize the manager state, reexecute the process and deserialize the state again (for debugging)
    #System Commands
      is-system-running
        Stages:
          "initializing"                  #Early boot
          "starting"                      #Late boot, before job queue first idle
          "running"                       #exit code: 0
          "degraded"                      #>0 units failed
          "maintenance"                   #rescue/emergency target active
          "stopping"                      #shutting down
      suspend                           #Suspend the system.
      hibernate                         #Hibernate the system.
      hybrid-sleep                      #Hibernate and suspend the system.

      default                           #Enter default mode
        isolate default.target
      #with wall messages to all users:
      rescue                            #Enter rescue mode
        isolate rescue.target
      emergency                         #Enter emergency mode
        isolate emergency.target
      halt                              #Shut down and halt the system.
        start halt.target --irreversible
      poweroff                          #Shut down and power-off the system.
        start poweroff.target --irreversible
      reboot [arg]                      #Shut down and reboot the system.
        start reboot.target --irreversible
      kexec                             #Shut down and reboot the system via kexec.
        start kexec.target --irreversible
    #Jobs:
      list-jobs [PATTERN...]            #List jobs that are in progress.
      cancel JOB...                     #Cancel one or more jobs specified on the command line by their numeric job IDs. If no job ID is specified, cancel all pending jobs.
    #Misc:
      switch-root ROOT [INIT]           #Switches to a different root directory and executes a new system manager process below it. This is intended for usage in initial RAM disks ("initrd")
      list-sockets [PATTERN...]         #List socket units ordered by listening address
      list-timers [PATTERN...]          #List timer units ordered by the time they elapse next
      list-machines [PATTERN...]        #List the host and all running local containers with their state.

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
