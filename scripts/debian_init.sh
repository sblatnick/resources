#!/bin/bash

if [ ! -f ~/.ssh/id_rsa ];then
  echo "Generate RSA key"
  ssh-keygen -m PEM -t rsa -f ~/.ssh/id_rsa
  openssl rsa -in ~/.ssh/id_rsa -pubout > ~/.ssh/id_rsa.pub.pem
  eval `ssh-agent -s`
  ssh-add
fi

