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
	#install rpm:
	rpm -ivh packagename.rpm
	#upgrade rpm:
	rpm -Uvh packagename.rpm

  #find perl module (install yum-utils first):
  repoquery -a --whatprovides 'perl(Net::HTTP)'
#debian:
	apt-get install package
	apt-cache search package

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
sudo yum install rpmdevtools #needed?
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

##define variables, then generate the spec:
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