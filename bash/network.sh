#!/bin/bash

#::::::::::::::::::::ANALYSIS::::::::::::::::::::

#Look for open ports and services:
  nmap domain.com
  netstat -pant | grep LISTEN

#Check connectivity A => B
  #Listen on port:
    nc -l ${port}
    nc -l localhost ${port}
      nc: Address already in use #shows if a service is using the port
  #Find hosts on network:
    nmap -sn 192.168.0.0/24 | grep -Po 'scan report for .*$' | cut -d' ' -f5-
  #Find hosts listening to 8080:
    nmap -sV -p 8080 192.168.0.0/24 -open
    host 192.168.0.10
  #Check connection:
    nc -v localhost ${port}
      Connection to localhost 5000 port [tcp/*] succeeded!
      nc: connect to localhost port 5000 (tcp) failed: Connection refused
    netstat -tulpen | grep nc
    netstat -an | grep :25
  #source: https://unix.stackexchange.com/questions/214471/how-to-create-a-tcp-listener

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
  /sbin/route -n #gives default gateway
  ip route

#traceroute:
traceroute example.com
  -w 5  # wait 5 seconds (default)
  -q 1  # 1 query (default)
  -m 30 # max 30 hops (default)

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
  #list rules:
    iptables -L
  #list the 'nat' rules:
    iptables -t nat -L 
  #save current rules for next boot:
    #sysv:
    /etc/init.d/iptables save
    #systemd:
    iptables-save > /etc/sysconfig/iptables

  #Options:
    -t #table
    -A --append
    -C --check
    -D --delete
    -I --insert
    -R --replace
    -L --list
    -S --list-rules
    -F --flush #delete all
    -Z --zero #reset counters
    -N --new-chain chain
    -X --delete-chain [chain] #If no argument is given, it will attempt to delete every non-builtin chain in the table.
    -P --policy chain target
    -E --rename-chain old-chain new-chain
    -h #Help

    -v --verbose
    -w --wait [seconds] #wait (indefinitely or for optional seconds) until the exclusive xtables lock can be obtained
    -W --wait-interval microseconds #make each iteration take the amount of time specified (default 1 second, only works with -w)
    -n --numeric #IP addresses and port numbers will be printed in numeric format
    -x --exact #No rounding packet/byte counters to K/M/G
    --line-numbers #rule order displayed
    --modprobe=command #use command to load any necessary modules

  #Parameters:
    #allows to put both IPv4 and IPv6 rules in a single file for both iptables-restore and ip6tables-restore
      -4, --ipv4
      -6, --ipv6=
    ! #invert test
    -p, --protocol protocol #tcp, udp, udplite, icmp, icmpv6,esp, ah, sctp, mh, all, 0 (all), or numeric
    -s, --source address[/mask][,...] #network name, a hostname, a network IP address (with /mask), or a plain IP address
    -d, --dst, --destination address[/mask][,...]
    -m, --match match
    -j, --jump target
    -g, --goto chain
    -i, --in-interface name
    -o, --out-interface name
    -f, --fragment
    -c, --set-counters packets bytes #initialize the packet and byte counters of a rule (during INSERT, APPEND, REPLACE operations)

  #Tables -t:
    nat    #address translation
    filter #packet filtering
    mangle #special-purpose processing
    raw
    security

  #filter table chains:
    INPUT
    OUTPUT
    FORWARD
  #policies:
    ACCEPT
    DROP

  #EXAMPLES:
    #Set default rules (everything open):
      iptables -P INPUT ACCEPT
      iptables -P OUTPUT ACCEPT
      iptables -P FORWARD ACCEPT
    #Allow ssh:
      iptables -A INPUT -i eth0 -p tcp --dport 22 -j ACCEPT
      iptables -A OUTPUT -o eth0 -p tcp --sport 22 -j ACCEPT

    #DNS requests:
      #If you have OUTPUT set to DROP by default, but allow dns:
        iptables -P OUTPUT DROP
        iptables -A OUTPUT -o eth0 -p udp --dport 53 -j ACCEPT
      #But curl hangs on certain hosts:
        curl -sD - -o /dev/null https://example.com/path/
      #It could be because of DNS via UDP getting truncated, resulting in TCP:
        systemctl stop iptables #systemd
        service iptables stop #SysV
        host example.com
          ;; Truncated, retrying in TCP mode.
          example.com has address 10.20.20.20
      #So you will need to allow TCP too:
        iptables -A OUTPUT -o eth0 -p tcp --dport 53 -j ACCEPT

  #source: http://linux-training.be/networking/ch14.html

#see server IP address:
  host google.com

#see IP's hostname:
  host 127.0.0.1

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
  #  Name:  rbl0105.intra.net
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
  telnet host.com 80
  nc -Cv host.com 80

#no telnet? can't install? use /dev/tcp:
(echo > /dev/tcp/hostname/22) >/dev/null 2>&1 \
    && echo "It's up" || echo "It's down"
It's up

(echo > /dev/tcp/hostname/222) >/dev/null 2>&1 && \
    echo "It's up" || echo "It's down"
It's down
#source: https://superuser.com/questions/621870/test-if-a-port-on-a-remote-system-is-reachable-without-telnet


#netcat to push a binary payload to a host on a port:
  nc -vv host 8080 < exploit_payload.bin

#look at open ports and the programs using them:
  sudo netstat -ltnp

#IP netmasks work left to right, so:
127.0.0.0/8  == 127.0.0.0 - 127.255.255.255
127.0.0.0/16 == 127.0.0.0 - 127.0.255.255

#ss: socket statistics - is similar to netstat
  ss -tlpn

#::::::::::::::::::::COMMON PORTS::::::::::::::::::::

#SERVICE  CLEARTEXT   SSL
#http     80          443
#smtp     25          465
#pop      110         995
#imap     143         993


#::::::::::::::::::::OTHER::::::::::::::::::::

#download public cert
openssl s_client -connect website.com:443 </dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > website.cer
