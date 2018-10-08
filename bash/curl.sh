#!/bin/bash

#JSON rest API:
curl -q -X POST -H "Content-Type: application/json" -d "@${DATA}" https://${DESTINATION}/api/endpoint

#Default config in ~/.curlrc
#example:
  tlsv1.2
  ciphers=AES256-SHA256

#OPTIONS:
  -q #ignore ~/.curlrc
  -X #request type, like GET, POST, SET
  -H #headers
  -d #data
  -d "@filename" #file containing data
  -d "@-" #stdin containing data


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