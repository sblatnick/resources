#!/bin/bash

telnet pop.email.com 110
nc -Cv pop.email.com 110
openssl s_client -showcerts -connect pop.email.com:995
  USER someone
  PASS password
  LIST
  RETR 2 #get message
  DELE 2 #mark for deletion at QUIT
  RSET 2 #unmark deletion
  QUIT

expect << EOF
  set timeout 20
  spawn telnet $server $port
  expect "OK"
  send "user $user\r"
  expect -re "ERR|OK"
  send "pass $password\r"
  expect -re "ERR|OK"
EOF
