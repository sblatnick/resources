#::::::::::::::::::::OPENSSL::::::::::::::::::::
#View Cert information:
  openssl x509 -text -noout -in certificate.crt

#create passwordless cert for a ruby thin server:
  #create private key:
  openssl genrsa -out /etc/service/id.key 4096
  #self sign and generate CA.crt:
  openssl req -subj "/C=US/ST=My State/L=My City/CN=$(hostname)" -x509 -new -nodes -key /etc/service/id.key -sha256 -days 1024 -out /etc/service/CA.crt
  #as root start the server:
  thin start --ssl --ssl-key-file /etc/id.key --ssl-cert-file /etc/service/CA.crt -C /etc/service/service.yml
  #test CA:
  curl --cacert CA.crt https://127.0.0.1/

#create cert request from ssh key:
openssl req -new -key ~/.ssh/id_rsa -out id.csr
#self-sign cert:
openssl x509 -req -days 3650 -in id.csr -signkey ~/.ssh/id_rsa -out id.pem

#Convert formats:
  #der to pem:
    openssl x509 -inform der -in bin.crt -out bin.pem
  #pem to pkcs12:
    openssl pkcs12 -export -in id.crt -inkey id_rsa -out signature.p12 -name "Your Name"

  #crt to pem:
    openssl x509 -in id.crt -out id.pem -outform PEM

  #pem to crt:
    openssl x509 -outform der -in your-cert.pem -out your-cert.crt

#test CA using curl (must be pem format or silently ignored):
  curl --cacert bin.pem -v  https://website.com:443/index.html

#find missing CA in truststore:
  #Method 1: get signature for a cert to find which CA to download
    echo | openssl s_client -connect website.com:443 > pub.crt
    #then download from their site using the signature
  #Method 2: look for the crt url within the browser cert details by clicking on the padlock

#download CAs from website (source: https://unix.stackexchange.com/questions/368123/how-to-extract-the-root-ca-and-subordinate-ca-from-a-certificate-chain-in-linux) 
openssl s_client -showcerts -verify 5 -connect website.com:443 < /dev/null | \
  awk '/BEGIN/,/END/{ if(/BEGIN/){a++}; out="cert"a".pem"; print >out}'
for cert in *.pem
do
  newname=$(openssl x509 -noout -subject -in $cert | sed -nE 's/.*CN ?= ?(.*)/\1/; s/[ ,.*]/_/g; s/__/_/g; s/_-_/-/; s/^_//g;p' | tr '[:upper:]' '[:lower:]').pem
  echo "${newname}"
  mv "${cert}" "${newname}"
done

#add CA to truststore:
  #Method 1: prepend to /etc/pki/tls/certs/ca-bundle.crt for curl to see it
    #It may be overwritten by future updates,
    #but the other locations seem ignored by curl
  #Method 2: add it to nss db:
    yum install /usr/bin/c_rehash
    cp bin.pem /etc/pki/tls/certs
    c_rehash
  #Method 3: add it to shared system truststore:
    cp bin.pem /etc/pki/ca-trust/source/anchors/
    #or OpenSSL’s extended BEGIN TRUSTED CERTIFICATE format:
    cp bin.crt /etc/pki/ca-trust/source/
    update-ca-trust
    #may need to be enabled:
    update-ca-trust enable


keytool -list -keystore cacerts -storepass changeme
#https://connect2id.com/blog/importing-ca-root-cert-into-jvm-trust-store

#Read yaml stored cert (like from kubernetes like in /etc/kubernetes/bootstrap-kubelet.conf)
  echo "$CERT" | base64 --decode > tmp.crt
  openssl x509 -in tmp.crt -text -noout


#Encrypt/Decrypt String using ssh keypair:
  #Convert pub key to pem:
  openssl rsa -in ~/.ssh/id_rsa -pubout > ~/.ssh/id_rsa.pub.pem

  #Encrypt:
  echo $string | openssl rsautl -encrypt -pubin -inkey ~/.ssh/id_rsa.pub.pem > encryped.txt

  #Decrypt:
  cat encryped.txt | openssl rsautl -decrypt -inkey ~/.ssh/id_rsa

  #source: https://unix.stackexchange.com/questions/328689/how-to-encrypt-a-string-with-my-ssh-pubkey

#Authenticate using a Smart Card:

  #Pre-reqs:
  sudo apt install libpcsclite1 pcscd pcsc-tools cackey libnss3-tools

  #Enable/start service:
  sudo systemctl enable pcscd
  sudo systemctl start pcscd

  #Test the CAC card can be read:
  pcsc_scan

  #Add cert to chrome-based browsers
    #CLOSE browser first
    #cd into your home directory, ~ doesn't work for this command
    modutil -dbdir sql:~/.pki/nssdb/ -add "CAC Module" -libfile /usr/lib/pkcs11/libcackey.so
      Module "CAC Module" added to database.
    #Check the module was added:
    modutil -dbdir sql:.pki/nssdb/ -list

  #Insert card into reader
  #Open login page
  #Enter pin
  #TODO: missing CA?
