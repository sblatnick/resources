#!/bin/bash

telnet hostname.com 80
nc -Cv hostname.com 80
openssl s_client -showcerts -connect hostname.com:443

#HTTP:
telnet hostname.com 80
  GET / HTTP/1.1
  Host: hostname.com
#HEAD:
telnet hostname.com 80
  HEAD / HTTP/1.1
  Host: hostname.com
#HTTPS:
openssl s_client -connect example.com:443
  GET / HTTP/1.1
  Host: hostname.com

