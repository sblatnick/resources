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

#interact after ssh then `su -` with root password within ssh connection:
  #!/usr/bin/expect -f
  spawn ssh admin@intra.net
  expect "Password:"
  send "password1\r"
  expect "*$ "
  send "su -\r"
  expect "Password:"
  send "password2\r"
  expect "*# "
  interact

#source: https://stackoverflow.com/questions/2823007/ssh-login-with-expect1-how-to-exit-expect-and-remain-in-ssh
#note: problem with heredoc EOF
#loop over passwords: https://stackoverflow.com/questions/15526132/expect-ssh-two-possible-passwords-or-how-to-jump-of-expect-block-and-still

#All together:

pw="rootpassword"
cat << EOF > ${TMP}/to_root
#!/usr/bin/expect -f
set passwords { password1 password2 }
spawn ssh -o StrictHostKeyChecking=no admin\@${node}
set try 0
expect {
  "Password:" {
    if { \$try >= [llength \$passwords] } {
      send_error ">>> wrong passwords\n"
      exit 1
    }

    send [lindex \$passwords \$try]\r
    incr try
    exp_continue
  }
  "*\$ " {
    send "su -\r"
    expect "Password:"
    send "${pw}\r"
    expect "*# "
    interact
  }
  timeout {
    send_error "time out\n"
    exit 1
  }
}
EOF
chmod a+x ${TMP}/to_root
${TMP}/to_root

