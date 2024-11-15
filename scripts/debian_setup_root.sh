#!/bin/bash

function decrypt() {
  cat ~/.ssh/pw | base64 -d | openssl pkeyutl -decrypt -inkey ~/.ssh/id_rsa
}

if ! groups | grep -q 'sudo';then
  echo "Setup Root"
  decrypt | su root -c "/usr/sbin/usermod -aG sudo ${USER}"
fi
