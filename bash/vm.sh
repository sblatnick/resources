#!/bin/bash

#::::::::::::::::::::KVM::::::::::::::::::::

#Modification:
  virsh dumpxml hostname #print host definition xml
  virsh edit hostname    #edit host definition xml

#Management:
  virsh reboot hostname  #reboot host
  virsh net-list --all   #networks
  virsh list             #list hosts

#::::::::::::::::::::VirtualBox::::::::::::::::::::
#source: https://www.virtualbox.org/manual/ch08.html

vm='name'
VMS="${HOME}/VirtualBox VMs/"

#Creation/Modification:
  VBoxManage createvm --name $vm --ostype "Linux_64" --register
  VBoxManage createhd --filename $VMS/$vm/$vm.vdi --size 32768

  VBoxManage storagectl $vm --name "SATA Controller" --add sata --controller IntelAHCI --portcount 1
  VBoxManage storageattach $vm --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $VMS/$vm/$vm.vdi

  VBoxManage modifyvm $vm --memory 2048 --boot1 net --boot2 dvd
  VBoxManage modifyvm $vm --nic1 hostonly --hostonlyadapter1 vboxnet0
  VBoxManage modifyvm $vm --nic1 nat --nat-network1 vboxnet0

#Boot to installer:
  #PXE:
  VBoxManage modifyvm $vm --nattftpfile1 pxelinux.0
  ln -s ${project}/img ${HOME}/Library/Virtualbox/TFTP #Mac OSX path

  #ISO:
    VBoxManage storagectl $vm --name "IDE Controller" --add ide

    #FIXME (invalid image, create iso using other tools):
      size=$(bc <<< "$(du -sx ${project}/img | cut -d$'\t' -f 1)/1000 + 1")
      VBoxManage createmedium dvd --filename ${project}/img --size "$size"

    VBoxManage storageattach $vm --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium ${project}/img.iso

#Management:

  #list vms:
  VBoxManage list vms
  
  #Start vm in headless mode
  VBoxManage startvm $vm --type headless 

  #Poweroff vm
  VBoxManage controlvm $vm poweroff

  #Destroy vm
  VBoxManage unregistervm $vm --delete



