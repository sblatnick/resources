#!/bin/bash

#::::::::::::::::::::ANALYSIS::::::::::::::::::::

#Look for open ports and services:
  nmap domain.com

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

#check routes to see connectivity of interfaces:
  /sbin/route -n
  ip route

#use tpcdump to listen to activity on a port:
  sudo tcpdump -i eth0 host destination.com

#if you can't resolve something like google, it's probably related to the GATEWAY:
vi /etc/sysconfig/network
  NETWORKING=yes
  NETWORKING_IPV6=no
  HOSTNAME=vm
  GATEWAY=10.0.3.2
vi /etc/sysconfig/network-scripts/ifcfg-eth0
  DEVICE=eth0
  BOOTPROTO=dhcp
  ONBOOT=yes
  HWADDR=xx:xx:xx:xx:xx:xx
vi /etc/sysconfig/network-scripts/ifcfg-eth1
  DEVICE=eth1
  TYPE=Ethernet
  BOOTPROTO=static
  ONBOOT=yes
  HWADDR=xx:xx:xx:xx:xx:xx
  IPADDR=100.64.0.171
  NETMASK=255.255.255.0

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
  #save current rules for next boot:
    #sysv:
    /etc/init.d/iptables save
    #systemd:
    iptables-save > /etc/sysconfig/iptables

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
  #  Server:    192.168.1.219
  #  Address:  192.168.1.219#53
  #
  #  ** server can't find 237.132.181.107.rbl0101: NXDOMAIN

  #IN list (and therefor blocked):
  #  Server:    192.168.1.219
  #  Address:  192.168.1.219#53
  #
  #  Name:  rbl0105.sj2.proofpoint.com
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

#::::::::::::::::::::TELNET::::::::::::::::::::

#telnet:
  #IMAP:
  telnet imap.email.com 143
  x login user@email.com Password
  x LIST "" "*"
  #HTTP:
  telnet hostname.com 80
  GET / HTTP/1.1
  Host: hostname.com
  #HTTPS:
  openssl s_client -connect example.com:443
  GET / HTTP/1.1
  Host: hostname.com

#expect:
  #smtp:
  expect << EOF
set timeout 20
spawn telnet hostname 8824
expect "* ESMTP SERVER-BANNER"
EOF

for i in $(seq -f "%02g" 1 100)
do
    echo "$i attempt:"
    expect << EOF | tail -n 1 | sed 's/^/  /'
set timeout 5
spawn telnet smtp.example.com 25
expect {
  timeout {puts "timed out"; exit}
  "connection refused" {puts "connection refused"; exit}
  "unknown host" {puts "connection refused"; exit}
  "* ESMTP *" {puts "saw banner"; exit}
}
EOF
done

  #imap:
  expect << EOF
set timeout 20
spawn telnet $server $port
expect "*Welcomes You"
send "a1 LOGIN $user $password\r"
expect -re "NO|OK"
EOF

  #pop:
  expect << EOF
set timeout 20
spawn telnet $server $port
expect "OK"
send "user $user\r"
expect -re "ERR|OK"
send "pass $password\r"
expect -re "ERR|OK"
EOF

  #ssl telnet:
    #POP:
      openssl s_client -showcerts -connect mail.example.com:995
    #smtp using starttls:
      openssl s_client -showcerts -connect smtp.example.com:25 -starttls smtp


#netcat to push a binary payload to a host on a port:
  nc -vv host 8080 < exploit_payload.bin

#look at open ports and the programs using them:
  sudo netstat -ltnp

#IP netmasks work left to right, so:
127.0.0.0/8  == 127.0.0.0 - 127.255.255.255
127.0.0.0/16 == 127.0.0.0 - 127.0.255.255

#::::::::::::::::::::COMMON PORTS::::::::::::::::::::

#SERVICE  CLEARTEXT   SSL
#http     80          443
#smtp     25          465
#pop      110         995
#imap     143         993


