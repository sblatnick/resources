#!/bin/bash

#::::::::::::::::::::LINUX::::::::::::::::::::

#see what's installed example (debian):
  dpkg --list | grep [app_name]

#rpm/fedora/yum based linux:
  yum install fuse-sshfs
  yum search package
  yum check-update         #like apt-get update, updates the package definitions without installing anything
  yum clean expire-cache   #clear cache to see recent changes to the repos
  yum clean all            #delete cached packages
  yum update               #will actually update packages
  yum list --showduplicates mariadb #show all versions and indicate the one installed (if any)
  yum whatprovides package
  rpm -ql tomcat           #show installed files
  rpm -qR tomcat           #find dependencies
  rpm -qpR tomcat.rpm      # -p means from the package file
  rpm -qip packagename.rpm #show information about the package not installed like signature
  rpm -qf log4j.properties #find rpm package that installed the file
  #install rpm:
  rpm -ivh packagename.rpm
  #install rpm with repo-based dependencies:
  yum --nogpgcheck localinstall package.rpm
  #re-install same package version:
    rpm -e ${pkg%%.rpm} && rpm -ivh $pkg
    #>=4.12.0
    rpm --reinstall package.rpm
  #uninstall rpm:
  rpm -e package
  #upgrade rpm:
  rpm -Uvh packagename.rpm
  #downgrade rpm:
  rpm -Uvh --oldpackage packagename.rpm
  #install group:
  yum groupinstall "Development Tools"
  #uninstall group:
  yum groupremove "Development Tools"
  #install dependencies:
  yum-builddep kernel-devel
  #uninstall/remove:
  yum remove package
  rpm -e package
  
  #see changes since install from the package/rpm (https://www.novell.com/coolsolutions/feature/16238.html)
  rpm -V package
  # S file Size differs
  # M Mode differs (includes permissions and file type)
  # 5 MD5 sum differs
  # D Device major/minor number mis-match
  # L readLink(2) path mis-match
  # U User ownership differs
  # G Group ownership differs
  # T mTime differs

  # c %config configuration file.
  # d %doc documentation file.
  # g %ghost file (i.e. the file contents are not included in the package payload).
  # l %license license file.
  # r %readme readme file.

  #see install scripts:
  rpm -qp --scripts package.prm
  rpm -q --scripts package

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
  yum history info 56

  yum history list #list is default, same as list history
  yum history list package #list package changes
  yum history info package #details of package history
  rpm -qa --last | head #last packages installed and when

  #Make sure the rpmdb is up-to-date for yum commands
  yum history sync

  #download rpm (requires yum-utils):
  yum install --downloadonly --downloaddir=/home/$USER/ package

  #download url (requires yum-utils):
  yumdownloader --urls package

  #extract rpm contents:
  rpm2cpio package.rpm | cpio -idmv
  #extract on mac:
  tar -xvzf package.rpm
  #delete file from jar/zip:
  zip -d file.jar path/to/file.txt

  #Script to Update/Downgrade in yum with a package list:
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

  #Check for security remediation:
  yum install --downloadonly --downloaddir=./ tomcat
  rpm -pq --changelog tomcat-7.0.76-3.el7_4.noarch.rpm | head

  #get repo urls for importing elsewhere:
  grep baseurl /etc/yum.repos.d/*

  #change repos:
  yum-config-manager --disable
  yum-config-manager --add-repo http://example.repo.com/yum/centos/7_latest/os/x86_64/
  rpm --import http://example.repo.com/yum/centos/7_latest/os/x86_64/RPM-GPG-KEY-CentOS-7
  yum clean all

  #remove repo:
  rm -f /etc/yum.repos.d/name.repo

  #list repos:
  yum repolist #just enabled
  yum repolist enabled
  yum repolist disabled
  yum repolist all #enabled and disabled

#debian:
  apt-get install package
  apt-cache search package

  #add repo:
    apt-get update
    apt-get install -y software-properties-common
    add-apt-repository 'deb http://site.example.com/debian distribution component1 component2 component3'
    #find the keys you need for Debian on: https://ftp-master.debian.org/keys.html
    wget -qO - https://ftp-master.debian.org/keys/release-10.asc | sudo apt-key add -

  #install custom java:
  sudo update-alternatives --install /usr/bin/java java /opt/jre1.7.0_40/bin/java 1
  #choose version of java to use:
  sudo update-alternatives --config java

  #force 64 bit architecture on a x86 deb file:
  sudo dpkg -i --force-architecture nameofpackage.deb

  #how to install all build dependencies for a package:
  sudo apt-get build-dep programName

  #OpenGL glut libraries:
    libgl1-mesa-dev
    freeglut3-dev
    xlibmesa-gl-dev
    mesa-common-dev

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

#TinyCore Linux:
  tce #install packages
  backup #make persistent after reboot

  #setup ssh server and static IP: (see: https://firewallengineer.wordpress.com/2012/04/01/how-to-install-and-configure-openssh-ssh-server-in-tiny-core-linux/)
  # after installed to device: http://distro.ibiblio.org/tinycorelinux/install_manual.html
  $ tce-load -wi openssh
  $ cp /usr/local/etc/ssh/sshd_config.example sshd_config
  $ vi /opt/.filetool.lst
    /usr/local/etc/ssh
    /etc/passwd
    /etc/shadow
    /etc/motd
  $ vi /opt/bootlocal.sh
    #!/bin/sh
    # put other system startup commands here
    /usr/local/etc/init.d/openssh start
    ifconfig eth1 100.64.0.128 netmask 255.255.255.0
  $ backup

#::::::::::::::::::::MAC::::::::::::::::::::

#Homebrew:
  #list installed packages:
  brew list
  #install
  brew install package
  #update:
  brew upgrade package

#MacPorts:
  #list installed packages:
  port installed
  #install package
  port install package
  #update:
  port upgrade package

#DMG failing to install:
  #System Preferences -> Security & Privacy -> General
  #Then click on “Allow” next to the app warned about

#::::::::::::::::::::RPM CREATION::::::::::::::::::::

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

#Test how the macros are expanded:
rpm --eval "$(cat service.spec)"
rpmspec -P service.spec

#::::::::::::::::::::RPM SPEC FILE::::::::::::::::::::

#--------------------SECTIONS/ORDER--------------------

#built time:
  %prep
  %install
#install time:
  %pre
  %files #installed
  %post
#uninstall time:
  %preun
  %files #removed
  %postun

#Yum Upgrade Package order:
  #   PKG    SECTION
  1.  new    %pretrans
  2.  new    %pre
  3.  new    %files #INSTALLED
  4.  new    %post
  5.  other  %triggerin
  5.  new    %triggerin
  7.  old    %triggerun
  8.  other  %triggerun
  9.  old    %preun
  10. old    %files #REMOVED
  11. old    %postun
  12. old    %triggerpostun
  13. other  %triggerpostun
  14. new    %posttrans

#source: https://docs.fedoraproject.org/en-US/packaging-guidelines/Scriptlets/


#--------------------%files %macros--------------------
%config file
%attr(755, user, group) file                  #set file attributes
  %attr(-, -, -) file                         #dash means use existing
%defattr(755, user, group, dir_mode) file     #set default attributes
%ghost file                                   #owned by package, but not installed
                                              #(only removed) like log files
%doc file
%verify(mode md5) file                        #verify specified attributes                      
%verify(not owner group) file                 #verify everything but specified
  #attributes:
    owner
    grpu
    mode
    md5
    size
    maj
    min
    symlink
    mtime
%docdir
%dir                                          #include directory but not built files within
%files -f files.txt                           #load from file
#source: http://ftp.rpm.org/max-rpm/s1-rpm-inside-files-list-directives.html


#--------------------%systemd--------------------

%systemd_requires
%systemd_ordering #not required, use only if available

%post
%systemd_post %{name}.service
  #rpm --eval "%systemd_post %{name}.service"
    if [ $1 -eq 1 ] ; then
      # Initial installation
      systemctl preset %{name}.service >/dev/null 2>&1 || :
    fi
%systemd_user_post %{name}.service

%preun
%systemd_preun %{name}.service
  #rpm --eval "%systemd_preun %{name}.service"
    if [ $1 -eq 0 ] ; then
      # Package removal, not upgrade
      systemctl --no-reload disable %{name}.service > /dev/null 2>&1 || :
      systemctl stop %{name}.service > /dev/null 2>&1 || :
    fi
%systemd_user_preun %{name}.service
  #rpm --eval "%systemd_user_preun %{name}.service"
    if [ $1 -eq 0 ] ; then
      # Package removal, not upgrade
      systemctl --no-reload --user --global disable %{name}.service > /dev/null 2>&1 || :
    fi

%postun
%systemd_postun_with_restart %{name}.service
  #rpm --eval "%systemd_postun_with_restart %{name}.service"
    systemctl daemon-reload >/dev/null 2>&1 || :
    if [ $1 -ge 1 ] ; then
      # Package upgrade, not uninstall
      systemctl try-restart %{name}.service >/dev/null 2>&1 || :
    fi
%systemd_postun %{name}.service
  #rpm --eval "%systemd_postun %{name}.service"
    systemctl daemon-reload >/dev/null 2>&1 || :

#--------------------%setup--------------------

%setup
  -n <name>   #name of build directory
  -c          #create dir and cd to it before unpacking
  -D          #don't delete before unpacking
  -T          #don't unpack source0
  -b <n>      #unpack nth source
  -a <n>      #unpack nth source after cd

#source: http://ftp.rpm.org/max-rpm/s1-rpm-inside-macros.html


#--------------------%patch--------------------

%patch
  -p <n>      #strip n leading slashes from filenames
  -b <ext>    #backup file extension
  -E          #rm empty output files

#source: http://ftp.rpm.org/max-rpm/s1-rpm-inside-macros.html

#::::::::::::::::::::RPM CREATION from CPAN::::::::::::::::::::

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

#::::::::::::::::::::RPM SIGNING::::::::::::::::::::

#Sign an RPM with a gpgkey:
function rpmSign() {
  echo "signing $1..."
  local pw=$(<~/.PW)
  expect << EOF
spawn bash -c "rpm --define=\"%_gpg_name <cert@example.com>\" --resign $1"
expect -exact "Enter pass phrase: "
send -- "$pw\r"
expect eof
EOF
}

#::::::::::::::::::::RPM EDIT SPEC FILE::::::::::::::::::::

rpmrebuild -e -p package.rpm #opens in vi
Do you want to continue ? (y/N) y
result: /root/rpmbuild/RPMS/x86_64/package.rpm

#::::::::::::::::::::RPM UPDATE/PATCH::::::::::::::::::::

#Install tools:
sudo yum install -y yum-utils rpmdevtools

#prepare directories:
mkdir -p ~/.rpm/{RPMS,SRPMS,BUILD,SOURCES,SPECS,tmp}
mkdir ~/.rpm/RPMS/{x86_64,noarch}

#Find dependencies (you may need to modify multiple packages):
yum deplist tomcat
#Install dependencies:
yum-builddep tomcat
#or:
repoquery --requires --resolve tomcat

#Download/install source rpms:
yumdownloader --source tomcat
rpm -ivh tomcat-7.0.76.src.rpm

#find top directory:
rpm --showrc | grep topdir #installing src rpm adds the spec file to ${_topdir:-~/rpmbuild}/SPEC/

#Modify:
cd ${_topdir:-~/rpmbuild}/SOURCES
tar zxf tomcat-7.0.76.tar.gz
mv tomcat-7.0.76 tomcat-7.0.82
vi ${_topdir:-~/rpmbuild}/SPECS/tomcat.spec

#Rebuild:
rpmbuild -bb ${_topdir:-~/rpmbuild}/SPECS/tomcat.spec
rpmbuild -bp ${_topdir:-~/rpmbuild}/SPEC/package.spec

# -ba    Build binary and source  packages  (after  doing  the  %prep,  %build,  and  %install stages)
# -bb    Build a binary package (after doing the %prep, %build, and %install stages).
# -bp    Executes  the  "%prep" stage from the spec file. Normally this involves unpacking the sources and applying any patches.
# -bc    Do the "%build" stage from the spec file (after doing the %prep stage).  This  generally involves the equivalent of a "make".
# -bi    Do the "%install" stage from the spec file (after doing the %prep and %build stages).  This generally involves the equivalent of a "make install".
# -bl    Do a "list check".  The "%files" section from the spec file is  macro  expanded,  and checks are made to verify that each file exists.
# -bs    Build just the source package.

#::::::::::::::::::::RPM MOCK::::::::::::::::::::

sudo yum install -y yum-utils epel-release mock rpm-build
sudo usermod -a -G mock $USER

#mock create source rpm:
  mock -r epel-7-x86_64 --buildsrpm --sources rpms/SOURCES/ --spec rpms/SPECS/package.spec --resultdir result
  #essentially runs this within chroot:
  rpmbuild -bs package.spec
#mock create rpm from srpm:
  mock -r epel-7-x86_64 --no-clean --resultdir result result/package-0.1-0.el7.src.rpm

#Find the config file matching the kernel and architecture:
ll /etc/mock/

#initialize chroot to improve build time of future runs:
mock -r epel-6-x86_64 --init
#delete:
mock -r epel-6-x86_64 --clean

#rebuild rpm:
mock -r epel-6-x86_64 rebuild package-1.1-1.src.rpm
mock -r epel-6-x86_64 --resultdir ./ rebuild kernel-2.6.32-696.30.1.el6.src.rpm

/var/lib/mock/epel-6-x86_64/result #build logs
#mock
# -r config
# --resultdir = change output rpm directory

#Creates a chroot for building
  #Eample for CentOS7:
  #chroot:
    /var/lib/mock/epel-7-x86_64/root/
  #config:
    /etc/mock/epel-7-x86_64.cfg

  #prevent from %clean in spec:
  mock -r epel-7-x86_64 --no-clean --no-cleanup-after --resultdir result result/example.src.rpm

#Set env variables:
  vi /etc/mock/epel-7-x86_64.cfg
    config_opts['files']['etc/profile.d/environment.sh'] = """
    export BUILD_ID=0
    """

#::::::::::::::::::::PYTHON PIP::::::::::::::::::::

pip install package

pip install cqlsh #Cassandra Query Language Shell
pip install 'cqlsh>=5.0.1' --force-reinstall

  #On mac:
  sudo easy_install pip
  sudo python -m pip install packages
  sudo python -m pip install -r requirements.txt

  #requirements file example:
    requests==2.21.0
    scp==0.13.2
    pexpect
    pyyaml

