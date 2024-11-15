#!/bin/bash

function decrypt() {
  cat ~/.ssh/pw | base64 -d | openssl pkeyutl -decrypt -inkey ~/.ssh/id_rsa
}

function setting() {
  path=$1
  key=$2
  value=$3
  if [ "$(gsettings get ${path} ${key} | tr -d "'")" != "${value}" ];then
    echo "'$(gsettings get ${path} ${key})' vs '${value}'"
    echo "Setting ${path} ${key} = ${value}"
    gsettings set "${path}" "${key}" "${value}"
  fi
}

if ! grep -q 'Acquire::PDiffs "false";' /etc/apt/apt.conf 2>/dev/null;then
  echo "Disable Apt PDiffs"
  echo 'Acquire::PDiffs "false";' > /tmp/apt.conf
  decrypt | sudo -S cp /tmp/apt.conf /etc/apt/apt.conf
fi

if ! grep -q 'testing' /tmp/sources.list 2>/dev/null;then
  echo "Setup apt sources.list to point to testing"
  cat << EOF > /tmp/sources.list
deb http://deb.debian.org/debian/ testing non-free-firmware non-free contrib main
deb-src http://deb.debian.org/debian/ testing non-free-firmware non-free contrib main

deb http://security.debian.org/debian-security/ testing-security non-free-firmware main
deb-src http://security.debian.org/debian-security/ testing-security non-free-firmware main

deb http://deb.debian.org/debian/ testing-updates contrib non-free non-free-firmware main
deb-src http://deb.debian.org/debian/ testing-updates contrib non-free non-free-firmware main
EOF
  decrypt | sudo -S cp /tmp/sources.list /etc/apt/sources.list
fi

if [ ! -f /usr/bin/ag ];then
  echo "Update and Upgrade apt packages"
  decrypt | sudo -S apt update
  decrypt | sudo -S apt upgrade
  echo "Install default packages"
  decrypt | sudo -S apt install -y \
    apt-xapian-index \
    git \
    silversearcher-ag \
    net-tools \
    curl \
    vim \
    lightdm-settings \
    slick-greeter \
    vlc \
    dconf-editor \
    dconf-cli \
    colordiff \
    gdebi \
    system-config-printer \
    mozo \
    audacious \
    vlc
fi

if grep -q 'GRUB_TIMEOUT=5' /etc/default/grub 2>/dev/null;then
  echo "Set Grub timeout to 0"
  decrypt | sudo -S sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub
  decrypt | sudo -S update-grub
fi

if [ ! -d ~/projects/resources ];then
  echo "Setup Resources"
  mkdir projects
  cd projects
  git clone https://github.com/sblatnick/resources.git
  cd ~/
  echo "export SC=33
source ~/projects/resources/config/bashrc
" >> ~/.bashrc
fi

setting org.mate.caja.desktop home-icon-visible false
setting org.mate.caja.desktop volumes-visible false

setting org.mate.interface gtk-theme 'Blue-Submarine'
setting org.mate.interface icon-theme 'mate'


if grep -q '#autologin-user-timeout' /etc/lightdm/lightdm.conf 2>/dev/null;then
  echo "Set Login to be Automatic"
  decrypt | sudo -S sed -i "s/#autologin-user=/autologin-user=${USER}/" /etc/lightdm/lightdm.conf
  decrypt | sudo -S sed -i "s/#autologin-user-timeout=0/autologin-user-timeout=0/" /etc/lightdm/lightdm.conf
  decrypt | sudo -S systemctl restart lightdm
fi

if [ -z "$(which vivaldi)" ];then
  echo "Installing Vivaldi Browser"
  curl -o /tmp/dl.html https://vivaldi.com/download/
  url=$(grep -Po 'https://downloads.vivaldi.com/stable/vivaldi-stable_.*_amd64.deb' /tmp/dl.html)
  wget ${url}
  decrypt | sudo -S dpkg -i vivaldi-stable_*.deb
  rm vivaldi-stable_*.deb
fi

if ! dconf dump /org/mate/panel/ | grep -q vivaldi;then
  echo "Adding apps to mate-panel"
  dconf load /org/mate/panel/ < ~/projects/resources/config/mate-panel.conf
  killall mate-panel
fi


echo "DONE"