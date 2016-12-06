#!/bin/bash

#see what's installed example (debian):
  dpkg --list | grep [app_name]

#rpm/fedora/yum based linux:
  yum install fuse-sshfs
  yum search package
  yum check-update #like apt-get update, updates the package definitions without installing anything
  yum update #will actually update packages
  yum list --showduplicates mariadb #show all versions and indicate the one installed (if any)
  yum whatprovides package
  rpm -ql tomcat #show installed files
  rpm -qR tomcat #find dependencies
  #install rpm:
  rpm -ivh packagename.rpm
  #upgrade rpm:
  rpm -Uvh packagename.rpm

  #find perl module (install yum-utils first):
  repoquery -a --whatprovides 'perl(Net::HTTP)'

  #check if perl is installed and visible from path:
  perl -e 'use Net::HTTP;'
  #check where the module is installed:
  perl -e'my $module = shift;s/::/\//g, s/$/.pm/ for $module;print $INC{"$module"} . "\n" if require $module' Net::HTTP
  #check perl module version:
  perl -MNet::ParseWhois -le 'print $Net::ParseWhois::VERSION'

  #check installed packages:
  yum list installed | grep drbd
  rpm -qa | grep drbd

  #find installed version:
  yum list installed kernel-headers -q | tail -n 1 | awk '{print $2}'

  #revert install:
  yum history #find the id
  yum history undo 56 #undo the install by id

#debian:
  apt-get install package
  apt-cache search package

  #install custom java:
  sudo update-alternatives --install /usr/bin/java java /opt/jre1.7.0_40/bin/java 1
  #choose version of java to use:
  sudo update-alternatives --config java

#OpenGL glut libraries:
  libgl1-mesa-dev
  freeglut3-dev
  xlibmesa-gl-dev
  mesa-common-dev

#force 64 bit architecture on a x86 deb file:
  sudo dpkg -i --force-architecture nameofpackage.deb

#how to install building from source dependencies:
  sudo apt-get build-dep programName

#reinstall packages
  sudo apt-get --reinstall install packageNames
#Reinstall OpenGL:
  sudo apt-get install --reinstall libgl1-mesa-dev freeglut3-dev xlibmesa-gl-dev mesa-common-dev

#check package version:
  dpkg -l packageName

#compile ffmpeg for mp4 aac audio (psp/ipod, patent issues?) DIDN'T WORK?!
  apt-get source ffmpeg
  cd ffmpeg-*/
  ./configure --enable-gpl --enable-pp --enable-pthreads --enable-libogg --enable-a52 --enable-dts --enable-dc1394 --enable-libgsm --disable-debug --enable-libmp3lame --enable-libfaad --enable-libfaac --enable-xvid --enable-x264
  #(keep running until all the dependencies are met)
  make
  sudo make install

#create an rpm installing binaries (minimalistic):
sudo yum install -y rpmdevtools
mkdir -p ~/.rpm/{RPMS,SRPMS,BUILD,SOURCES,SPECS,tmp}
mkdir ~/.rpm/RPMS/{x86_64,noarch}
cat << EOF > ~/.rpmmacros
%_signature gpg
%_gpg_name Name
%debug_package %{nil}
%__os_install_post %{nil}
%_topdir   %(echo $HOME)/.rpm
%_tmppath  %{_topdir}/tmp
EOF

##move binaries to the build directory:
cp -a ${bin}/* ~/.rpm/BUILD
##define variables:
requires="requires: package"
base="/path/to/install"
package="package"
version="1.0"
release="custom"
##generate the spec:
cat << EOF > ~/.rpm/SPECS/${package}.spec
Name: ${package}
Version: ${version}
Release: ${release}
Summary: Example Package
BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}
AutoReqProv: no
License: All rights reserved
Group: System Environment/Daemons
URL: http://w3schools.com
${requires}

%description
${package} package.

%prep
#n/a

%build
#n/a

%install
mkdir -p %{buildroot}${base}
cp -a * %{buildroot}${base}

%clean
if [ -n "%{buildroot}" ];then
  rm -Rf %{buildroot}
fi

%files
/*

%changelog
* Fri Jun 10 2016 Engineering
- Initial build
EOF
rpmbuild -ba ~/.rpm/SPECS/${package}.spec

#Build perl modules from CPAN as rpms (see http://perlhacks.com/2015/10/build-rpms-of-cpan-modules/):
  #install the necessary build/PM software:
  yum install -y rpm-build cpanspec
  #Download the source from CPAN.org:
  wget http://search.cpan.org/CPAN/authors/id/V/VI/VIPUL/Crypt-TripleDES-0.24.tar.gz
  #create the spec file:
  cpanspec --packager "Your Name email@example.com" Crypt::TripleDES
  #or:
  cpanspec --packager "Your Name email@example.com" Crypt-TripleDES-0.24.tar.gz
  #move the source to where expected:
  mv Crypt-TripleDES-0.24.tar.gz ~/rpmbuild/SOURCES/
  #build the rpm:
  rpmbuild -ba perl-Crypt-TripleDES.spec
  #move the resulting rpm into your directory:
  mv ~/rpmbuild/RPMS/noarch/perl-Crypt-TripleDES-0.24-1.el7.centos.noarch.rpm ./

#Update/Downgrade in yum with a package list:

#!/bin/bash

packages="ack,package-1.0,etc" #comma separated
IFS=',' read -ra PACKAGES <<< "$packages"

check_package() {
  package=$1
  echo "looking for $package ..."
  rpm -qa | grep "$package" && echo "correct version already installed" && return
  base_package=$(yum list --showduplicates "$package" | tail -n 1 | sed 's/[\. ].*$//g')
  if rpm -qa | grep -q "${base_package}";then
    echo "already installed, attempting to downgrade..."
    yum downgrade -y "$package" 2>&1 | perl -pe "END { exit \$status } \$status=1 if /Only Upgrade/;"

    if [ 0 -eq "$?" ];then
      echo "downgrade successful"
      return
    else
      echo "downgrade failed, attempting upgrade"
    fi
  fi
  yum install -y "$package" | perl -pe "END { exit \$status } \$status=1 if /Only Upgrade/;"
  if [ 1 -eq "$?" ];then
    echo "install failed, exiting early"
    exit 1
  fi
}

for package in ${PACKAGES[@]}
do
  echo "package: $package"
  check_package "$package" 2>&1 | sed 's/^/  /'
done
echo "DONE"
exit 0