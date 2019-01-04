#!/bin/bash

#Pass a password to McAfee Application Control:
expect << EOF
spawn sadmin updaters list
expect "Password:*"
send "password\r"
expect eof
EOF

#Handle escaping of special characters:
expect << EOF
  set password {${PASSWORD}}
  spawn sadmin passwd
  expect "New Password:"
  send "\${password}\r"
  expect "Retype Password:"
  send "\${password}\r"
  expect eof
EOF

#Only pass the password if prompted:
expect << EOF | grep -vF 'Password:'
  log_user 0
  spawn sadmin $@
  log_user 1
  expect {
    "Password:" {
      send "password\r"
      expect eof
    }
    timeout {
      exit
    }
  }
EOF

#generate script for you:
autoexpect commands to run

#write expect script:

  #!/usr/bin/expect -f
  set timeout -1
  spawn sadmin updaters list
  match_max 100000
  expect -exact "Password:"
  send -- "test\r"
  expect eof

#execute script:
  expect script.exp


#see: https://likegeeks.com/expect-command/
#see also network.sh