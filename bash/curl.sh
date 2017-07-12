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
