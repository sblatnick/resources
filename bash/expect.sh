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

#Print expect to stdout for post processing:
expect << EOF | sed 's/^/EDIT: /'
  set timeout -1
  log_user 0
  spawn update-script.pl
  expect -re {
    "^Would you like to run update right now *" {
      send "Y\r"
      exp_continue
    }
    "\r" {
      set line \$expect_out(buffer)
      if {[string trim \$line] ne ""} {
        puts \$line
      }
      exp_continue
    }
    eof {
      puts \$expect_out(buffer)
      exit 0
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

  #set up local script:
  function tea() {
    file="$1"
    shift
    line="$@"
    cnt=$(grep -cF "${line}" "${file}" 2>/dev/null)
    if [ "$?" -gt 1 ]; then
      cnt=$(sudo grep -cF "$line" "${file}")
    fi
    if [ "$cnt" -eq 0 ];then
      tee -a "${file}" <<< "${line}" 2>/dev/null
      if [ "$?" -gt 0 ]; then
        sudo tee -a "${file}" <<< $(printf "\n${line}") 2>/dev/null
      fi
    else
      echo -e "\033[33mskipping\033[0m ${file}"
    fi
  }

  function run_init() {
    server="$1"
    shift

    mkdir ~/.ssh
    touch ~/.ssh/authorized_keys
    chmod 700 ~/.ssh ~/.ssh/authorized_keys

    tea ~/.ssh/authorized_keys "$@"
    if [[ "$(whoami)" == "root" ]];then
      tea ~/.bashrc "PS1='[${server} \w]\[\033[31m\] #\[\033[0m\] '"
    else
      tea ~/.bashrc "PS1='[${server} \w]\[\033[35m\] \$\[\033[0m\] '"
    fi
    tea ~/.bashrc "PROMPT_COMMAND='printf \"\033]0; ${server}\007\"'"
    tea ~/.bashrc "unset TMOUT"
  }

  cat <<- EOF > ${TMP}/commands
    sed -i -e 's/PermitRootLogin no/PermitRootLogin yes/' /etc/ssh/sshd_config
    service sshd restart
    $(typeset -f tea run_init)
    run_init name $(<~/.ssh/id_rsa.pub)
    echo "DONE"
EOF

#Optionally pass a local script path or run interactive:
#$1 should be ${TMP}/commands
if [ -z "$1" ];then
  todo="interact"
else
  todo="
    set fh [open $1]
    set contents [read \$fh]
    close \$fh
    send -- \$contents
    expect \"DONE\"
    exit 0
  "
fi

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
    expect {
      "Password:" {
        send "${pw}\r"
        exp_continue
      }
      "su: incorrect password" {
        send "sudo su\r"
        expect "password for admin:"
        send "${pw}\r"
        exp_continue
      }
      "*#* " {
        ${todo}
      }
      timeout {
        send_error "time out\n"
        exit 1
      }
    }
  }
  timeout {
    send_error "time out\n"
    exit 1
  }
}
EOF
chmod a+x ${TMP}/to_root
${TMP}/to_root

