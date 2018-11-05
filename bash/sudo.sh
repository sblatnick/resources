

#::::::::::::::::::::SUDO::::::::::::::::::::

#Act as root:
  sudo su
#Act as user when running commands and pass the password in using -S:
  echo "password" | sudo -S -H -u user bash -c "echo 'hello world'"

#Even fake tty via 'script':
script -q /dev/null cat << EOF
  echo "password" | sudo -S -H -u xbuild bash -c "
    cd ~/${VARIABLE}
    pwd
  "
EOF

#run command as user
  su user -c command

#sudo append to file:
  echo "text" | sudo tee -a /path/to/file