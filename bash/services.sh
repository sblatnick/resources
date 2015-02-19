#!/bin/bash
#::::::::::::::::::::EDITING STARTUP::::::::::::::::::::

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
Run Level		Mode 															Action
0 					Halt 															Shuts down system
1 					Single-User Mode 									Does not configure network interfaces, start daemons, or allow non-root logins
2 					Multi-User Mode 									Does not configure network interfaces or start daemons.
3 					Multi-User Mode with Networking 	Starts the system normally.
4 					Undefined 												Not used/User-definable
5 					X11 															As runlevel 3 + display manager(X)
6 					Reboot 														Reboots the system

#::::::::::::::::::::STARTUP::::::::::::::::::::

#startup scripts:
	/etc/rc.local/
	/etc/init.d/

#::::::::::::::::::::MYSQL::::::::::::::::::::

#mysql:
	#to edit mysql:
		mysql -u root -p mysql
	#restart mysql:
		sudo /etc/init.d/mysql restart
	#run mysql script (p = database/schema):
		mysql -u root -p steve8track < sqlDEMO.sql


#::::::::::::::::::::APACHE::::::::::::::::::::

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

#::::::::::::::::::::OTHER::::::::::::::::::::

#mailserver:
	sudo vim /etc/postfix/main.cfg
	sudo /etc/init.d/postfix restart

#power:
	restart=	reboot
	restart=	shutdown -r
	shutdown=	shutdown -h

#restart networking service:
	sudo /etc/init.d/networking restart
