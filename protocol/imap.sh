#!/bin/bash

telnet imap.email.com 143
nc -Cv imap.email.com 143
openssl s_client -showcerts -connect imap.email.com:993
  x login user@email.com Password
  x LIST "" "*"
    * LIST (\HasChildren) "." "INBOX"
    * LIST (\HasNoChildren) "." "INBOX.Drafts"
    * LIST (\HasNoChildren) "." "Sent"
    * LIST (\HasNoChildren) "." "Drafts"
    * LIST (\HasNoChildren) "." "Trash"
  x EXAMINE INBOX.Sent
  x SELECT "INBOX"
  x LIST "INBOX" "*"
  x UID SEARCH ALL
  x FETCH 117 BODY
  x FETCH 117 BODY.PEEK #not marked as read
  x LOGOUT

expect << EOF
  set timeout 20
  spawn telnet $server $port
  expect "*Welcomes You"
  send "a1 LOGIN $user $password\r"
  expect -re "NO|OK"
EOF
