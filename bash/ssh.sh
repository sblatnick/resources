#!/bin/bash

#::::::::::::::::::::COPY::::::::::::::::::::

#rsync continue where left off:
  rsync --partial --progress --rsh=ssh root@shanghai01:/home/ywang/qaenv11/* /mnt/sda1/vms/qaenv11/
  rsync [options] SRC DEST

#ssh file transfer:
  scp localfile.cpp username@remote.host.com:/remote/folder
  scp username@remote.host.com:/remote/file.txt /local/directory/
  scp file1.txt file2.txt user@host:/folder/
  scp -r #(use this -r tag to copy a folder and all of its contents)

#::::::::::::::::::::SSH USAGE::::::::::::::::::::
#server IP:
  ssh steve@192.168.0.136

#remotely access GUI software over ssh:
  ssh -X user@domain.com

#options:
  -o ConnectTimeout=1 #sets timeout
  -o BatchMode=yes #keeps it from hanging with "host unknown"
  -o StrictHostKeyChecking=no #automatically adds to known_hosts
  -o PreferredAuthentications=publickey,password

#execute a local script on a remote host:
  ssh -q machine 'bash -s' < stats.sh
#execute local script with arguments:
  ssh -q machine 'cat | bash /dev/stdin arg1' < ./script.sh
  ssh -q machine 'cat | /usr/bin/perl /dev/stdin arg1' < ./script.pl
#you can direct STDOUT and it will print STDERR still:
  ssh -q machine 'cat | /usr/bin/perl /dev/stdin arg1' < ./script.pl > outfile.txt
#local function passed from script to host:
  function check() {
    echo "checking..."
  }
  ssh user@host "$(typeset -f check);check $param"
  typeset -f check | ssh user@host "$(cat);check $param"

  typeset -f #prints all local functions
  typeset -f func #prints specified function definition

#::::::::::::::::::::SSH TUNNEL::::::::::::::::::::

#connect to service through a tunnel:
ssh -L 9999:destination:8080 user@tunnel #connect to localhost:9999 to access destination:8080 through user@tunnel

#Connect from vm to qa and tell
#qa to have a localhost server listening on port 6803 and forwarding to
#the VM on port 6802:
ssh user@qa -R 6803:localhost:6802
#-R means remote connection
#-L means local connection
ssh <remoteUser>@<remoteMachine> -R <remote listening port>:<remote machine referred to as localhost>:<local port to forward to>

#UNTESTED:
#reroute internet through your server to make it secure up to your server:
  ssh -D 8080 user@hostname.com -p 2222
  ssh -D portToForward user@server.com -p portToConnectBy
#  set the browser to connect to the correct port

#tunnelling (port re-routing)
  #wrong?: ssh -N -l username -D 443 ip
  ssh -N -D severname:proxyport user@host
  #then set pidgin to use localhost:proxyport (>1024, I usually use 8081 or 8088) for the SOCKS5 proxy
  #or, save yourself some typing and write the options to ~/.ssh/config

#ssh port forwarding
  #local forwarding - forward outward: in-port-localhost:host:out-port-internal
  ssh user@jump.host -L 8080:internal.host:8080 -nNfT
  #remote forwarding - forward inward: in-port-internal:host:out-port-jump
  ssh user@jump.host -R 8080:internal.host:8080
  #forward SOCKS proxy server:
  ssh user@host -D 9999

  #copy authorized key from jumphost to internal host:
  ssh internal-host 'mkdir ~/.ssh;cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub

  #copy a file from internal host to localhost over jumphost:
  ssh -fN -L 8071:internal:22 user@jumphost
  scp -o"Port=8071" user@localhost:/remote/file /local/path/

#ssh through proxy server:
  sudo apt-get install corkscrew
  #add to: ~/.ssh/config
    ProxyCommand /usr/bin/corkscrew proxyServer proxyPort %h %p
    ProxyCommand /usr/bin/corkscrew proxyServer proxyPort %h %p [script name]

#::::::::::::::::::::SSH KEYS::::::::::::::::::::

#password-less ssh:
  ssh-keygen -t rsa
  #  then enter no password
  #add the line in LOCALHOST: ~/.ssh/id_rsa.pub (without the .pub is your private key)
  #  to the file REMOTEHOST: ~/.ssh/authorized_keys

  #change the password/passphrase:
  ssh-keygen -p
  #you can also delete id_rsa and id_rsa.pub to start over

#force no key to test using the user password:
  ssh -o PreferredAuthentications=keyboard-interactive,password host

#start agent and add keys:
  eval `ssh-agent -s`
  ssh-add

#disable agent for testing:
  ssh -a # -A means agent forwarding

#add ssh key to ssh host:
  #using default ssh key:
  ssh-copy-id user@remotehost.com
  #manualy copy if ssh-copy-id isn't present:
  cat ~/.ssh/id_rsa.pub | ssh user@remotehost.com 'mkdir .ssh;cat >> .ssh/authorized_keys'
  #specify your public key:
  ssh-copy-id -i .ssh/id_rsa.pub username:password@remotehost.com

#remove specific host from ~/.ssh/known_hosts:
  ssh-keygen -R hostname
  ssh-keygen -f "/home/user/.ssh/known_hosts" -R hostname

#::::::::::::::::::::SSH CONFIG::::::::::::::::::::
#~/.ssh/config 

#Comment out if slow for multiple connections:
#ControlMaster auto
#ControlPath /home/steve/.ssh/tmp/%h_%p_%r

KeepAlive yes
ServerAliveInterval 60
ServerAliveCountMax 30

Host alias
  ProxyCommand ssh -q user@gateway-vm nc -w0 internal-ip 22

#Examples:
Host bastion
  ProxyCommand ssh -q tc@100.64.0.128 nc -w0 intranet.domain.com 22

Host jumphost
  ProxyCommand ssh -q tc@tinycore nc -w0 internal 22

#vi /etc/ssh/sshd_config
  #Allow more connections on the ssh server:
  MaxStartups 1000
  #speed up connections:
  UseDNS no
  #disable authentication that may slow login:
  GSSAPIAuthentication no

#::::::::::::::::::::SSH CONNECTION::::::::::::::::::::

#Slow SSH initial connection? (source: http://tech.waltco.biz/2008/02/02/ssh-slow-to-connect-in-ubuntu-710-gutsy-gibbon/)
  gedit /etc/nsswitch.conf #(on the SERVER machine)

  # Change this line
  # hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4
  # To this (removed mdns4)
  hosts: files mdns4_minimal [NOTFOUND=return] dns

#::::::::::::::::::::SSH MOUNT::::::::::::::::::::

sshfs -o cache=no,allow_other,uid=0,gid=0,follow_symlinks,nonempty steve@vmhost:/home/steve/work /root/work/
#nonempty = ignore if the directory has contents on the local filesystem
#follow_symlinks = follow symbolic links

#unmount:
fusermount -u /user_bak/
#install (yum):
yum install fuse-sshfs

#::::::::::::::::::::OPENSSL::::::::::::::::::::

#create cert request from ssh key:
openssl req -new -key ~/.ssh/id_rsa -out id.csr
#self-sign cert:
openssl x509 -req -days 3650 -in id.csr -signkey ~/.ssh/id_rsa -out id.crt

#Convert formats:
  #der to pem:
    openssl x509 -inform der -in bin.crt -out bin.pem
  #pem to pkcs12:
    openssl pkcs12 -export -in id.crt -inkey id_rsa -out signature.p12 -name "Your Name"

#test CA using curl (must be pem format or silently ignored):
  curl --cacert bin.pem -v  https://website.com:443/index.html

#find missing CA in truststore:
  #Method 1: get signature for a cert to find which CA to download
    echo | openssl s_client -connect website.com:443 > pub.crt
    #then download from their site using the signature
  #Method 2: look for the crt url within the browser cert details by clicking on the padlock

#add CA to truststore:
  #Method 1: prepend to /etc/pki/tls/certs/ca-bundle.crt for curl to see it
    #It may be overwritten by future updates,
    #but the other locations seem ignored by curl
  #Method 2: add it to nss db:
    yum install /usr/bin/c_rehash
    cp bin.pem /etc/pki/tls/certs
    c_rehash
  #Method 3: add it to shared system truststore:
    update-ca-trust
    update-ca-trust enable


keytool -list -keystore cacerts -storepass changeme
#https://connect2id.com/blog/importing-ca-root-cert-into-jvm-trust-store