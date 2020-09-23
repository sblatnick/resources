#!/bin/bash

telnet smtp.email.com 25
nc -Cv smtp.email.com 25
sendmail -bs -d64.5
  #-bs single SMTP session in the foreground w/ STDIN/OUT, then exit
  #   source: http://etutorials.org/Server+Administration/Sendmail/Part+II+Administration/Chapter+15.+The+sendmail+Command+Line/bs/
  #-d debug category.level (Default/unspecified: 0-99.1)
  #   category = what part of sendmail
  #   level = verbosity, where level > 100 modifies behavior
  #   source: http://etutorials.org/Server+Administration/Sendmail/Part+II+Administration/Chapter+16.+Debug+sendmail+with+-d/16.1+The+Syntax+of+-d/
openssl s_client -showcerts -connect smtp.email.com:25 -starttls smtp
  HELO smtp.email.com

  MAIL FROM: example@email.com
  RCPT TO: example@email.com
  DATA
  Subject: Sample Message
  message contents
  .

sendemail \
  -o "tls=no" \
  -f "$email" \
  -t "$to" \
  -u "Subject $i" \
  -m "$content" \
  -s "$server:$port"
  #-xu "$email" \
  #-xp 'password'
swaks \
  -s "$server" \
  -t "${to}" \
  -f "${from}" \
  --header "Subject: Sample Message" \
  -S


expect << EOF
  set timeout 20
  spawn telnet smtp.email.com 25
  expect "Connected to*"
  send "HELO test.net\r"
  expect "250"
  send "MAIL FROM:test@test.net\r"
  expect "250"
  send "RCPT TO:test@${domain}\r"
  expect "250" {
    exit 0
  }
  expect "550" {
    exit 1
  }
  exit 2
EOF

expect << EOF
  set timeout 20
  spawn telnet hostname 8824
  expect "* ESMTP SERVER-BANNER"
EOF

for i in $(seq -f "%02g" 1 100)
do
  echo "$i attempt:"
  expect << EOF | tail -n 1 | sed 's/^/  /'
    set timeout 5
    spawn telnet smtp.example.com 25
    expect {
      timeout {puts "timed out"; exit}
      "connection refused" {puts "connection refused"; exit}
      "unknown host" {puts "connection refused"; exit}
      "* ESMTP *" {puts "saw banner"; exit}
    }
EOF
done
