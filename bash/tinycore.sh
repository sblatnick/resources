#!/bin/bash
###TinyCore Linux
#::::::::::::::::::::REMASTER::::::::::::::::::::

#extract gz (copied from iso):
core='corepure64' #64-bit version
cd /root/cib/img/boot
mkdir ${core}
cd ${core}
zcat ../${core}.gz | cpio -i -H newc -d

#modify contents...

#package:
cd ${core}
find | cpio -o -H newc | gzip -2 > ../${core}.gz
mkisofs -l -J -R -V TC-custom -no-emul-boot -boot-load-size 4 \
  -boot-info-table -b boot/isolinux/isolinux.bin \
  -m ${core} \
  -c boot/isolinux/boot.cat -o cib.iso img


