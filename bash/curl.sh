#!/bin/bash

#JSON rest API:
curl -q -X POST -H "Content-Type: application/json" -d "@${DATA}" https://${DESTINATION}/api/endpoint

#Default config in ~/.curlrc
#example:
  tlsv1.2
  ciphers=AES256-SHA256

#Auth:
  curl -n           #use ~/.netrc for basic auth:
    machine hostname.intra.net login username password P@$$W0rd
  curl -u ${USER}   #ask for the password for basic auth
  curl -c ~/.cookie #store session in a cookie file


#OPTIONS:
    -q #ignore ~/.curlrc
    -X #request type, like GET, POST, SET
    -k #insecure
    -u user:password #basic auth
    -c ~/.cookie #store session in cookie file
  #INPUT:
    -H #headers
    -d #data
    -d "@filename" #file containing data
    -d "@-" #stdin containing data
  #OUTPUT:
    -s #silent (no progress bar)
    -D #dump headers into file
    -D - #dump headers into stdout
    -o #dump response contents to file (no headers)

#curl: (60) Peer's Certificate issuer is not recognized.
  #Download public cert:
    echo | openssl s_client -connect myserver.com:8080 > pub.crt
  #Convert to PEM:
    openssl x509 -in pub.crt -out pub.pem #x509 to PEM
    openssl x509 -inform der -in pub.crt -out pub.pem #DER to PEM
    #Note: You must use the pem version of the cert or curl's --cacert is silently ignored, and you may erroneously think you have the wrong cert.
    #More formats: https://knowledge.digicert.com/solution/SO26449.html
  #Try again using the cert:
    curl --cacert pub.pem -v  https://myserver.com:8080/api.cgi