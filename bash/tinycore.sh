#!/bin/bash
###TinyCore Linux
#::::::::::::::::::::REMASTER::::::::::::::::::::

core='corepure64' #64-bit version

mkdir tc
mv corepure64.iso tc/
cd tc

#extract iso (-aos means skip overwrites):
7z x ${core}.iso -aos

#extract gz (extracted from iso):
cd boot
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
  -c boot/isolinux/boot.cat -o tc.iso img


