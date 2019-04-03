#!/bin/sh
#Created by Vasiliks 22.03.2015
#last edited 11.2015
LANG='en'
if grep -qs 'config.osd.language=ru_RU' /etc/enigma2/settings ; then LANG='ru' ; fi
MESSAGE(){ if [ $LANG = "ru" ] ; then echo "$2" ; else echo "$1" ; fi }

  if  [[ `echo $3 | grep ".img$"` ]] ; then
  # install img to /dev/sdXY
    if [ ! -f $2uImage ] ; then
      MESSAGE "no uImage!\nto install Enigma\n" "отсутствует uImage!\nдля установки Энигмы\n"
      MESSAGE "copy uImage in the folder /hdd/enigma2\n" "скопируйте uImage в папку /hdd/enigma2\n"
      exit
    fi
  rm -rf /media/jffs2
  mkdir -p /media/jffs2
  rm -rf /tmp/copy
  mkdir -p /tmp/copy
  mount $1 /tmp/copy
  MESSAGE "Please wait, is cleaning partition $1\n" "Подождите, идет очистка раздела $1\n "
  rm -rf /tmp/copy/*
  rm -rf /tmp/root
  mkdir -p /tmp/root
  mknod /media/jffs2/mtdblock7 b 31 7
  modprobe block2mtd
  losetup /dev/loop0 $2$3
  echo "/dev/loop0,128KiB" > /sys/module/block2mtd/parameters/block2mtd
  MESSAGE "Mount image\n$2$3\n" "Монтирование образа\n$2$3\n"
  mount -t jffs2 /media/jffs2/mtdblock7 /tmp/root
  MESSAGE "Copy image files to the partition\n" "Копирование файлов образа на раздел\n"
  cp -rf -p /tmp/root/* /tmp/copy
  umount -l /media/jffs2/mtdblock7
  [[ ! -f /tmp/copy/boot/uImage ]] && cp -rf $2uImage /tmp/copy/boot
  umount -l $1  2>/dev/null
  modprobe -r block2mtd
  losetup -d /dev/loop0
  rm -rf /tmp/copy
  rm -rf /tmp/root
  rm -rf /media/jffs2
  /sbin/tune2fs -L $4 $1 2>&1 | tee >/dev/null
  MESSAGE "Partition $1 renamed to $4\n" "Раздел $1 переименован в $4\n"
  MESSAGE "Image  $2e2jffs2.img\ninstalled on partition $1!\n" "Имидж $2e2jffs2.img\nустанавлен на раздел $1!\n"
    exit
  fi
  # install tar or tar.gz to /dev/sdXY
  rm -rf /tmp/copy
  mkdir -p /tmp/copy
  mount $1 /tmp/copy
  MESSAGE "Please wait, is cleaning partition $1\n" "Подождите, идет очистка раздела $1\n "
  rm -rf /tmp/copy/*
  MESSAGE "Copying    $3 from $2   >>>   $1\n"  "Копируется  $3 из $2   >>>   $1\n"
  cp $2$3 /tmp/copy/
  cd /tmp/copy/
  MESSAGE "Unpacking  $3\n"  "Идет распаковка  $3\n"
  echo ""
  if  [[ `echo $3 | grep ".tar$"` ]] ; then
    tar -xf $3
    LABEL=`echo $3 | sed "s;.tar;;"`
  elif [[ `echo $3 | grep ".tar.gz$"` ]] ; then
    tar -xzf $3
    LABEL=`echo $3 | sed "s;.tar.gz;;"`
  fi
  cd /
  rm /tmp/copy/$3 # удаление образа
  umount -l $1  2>/dev/null
  # Rename partition
  /sbin/tune2fs -L $LABEL $1 2>&1 | tee >/dev/null
  MESSAGE "Partition $1 renamed to $LABEL\n" "Раздел $1 переименован в $LABEL\n"
rm -rf /tmp/copy
exit