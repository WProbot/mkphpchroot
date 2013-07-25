#!/bin/bash

if [ -z $1 ]
then
	echo Usage: mkphpchroot.sh target/direc/tory
	echo Creates the directory, if it doesn\'t exist
	exit
fi

target=$1

if [ -d /lib64/ ]
then
	bits=64
else
	bits=32
fi

if [ $bits = 64 ]
then
	libdir=/lib64
	usrlibdir=/usr/lib64
	chrootlibdir=lib64
	chrootusrlibdir=usr/lib64
else
	libdir=/lib
	usrlibdir=/usr/lib
	chrootlibdir=lib
	chrootusrlibdir=usr/lib
fi	

if [ ! -e $target ]
then
	mkdir $target
fi

cd $target

workdir=`pwd`

mkdir bin dev etc $workdir/$chrootlibdir run tmp usr var usr/bin usr/include $workdir/$chrootusrlibdir usr/share usr/var
ln -s ../tmp $workdir/usr/tmp
chmod 1777 tmp

function cp2wd() {
	cp -R $1 $workdir$1
}

cp2wd /bin/bash
ln -s /bin/bash $workdir/bin/sh

touch $workdir/dev/random $workdir/dev/urandom $workdir/dev/zero $workdir/dev/null


echo "#hosts" > $workdir/etc/hosts
echo 127.0.0.1 localhost > $workdir/etc/hosts
echo ::1       localhost > $workdir/etc/hosts

cp2wd /etc/resolv.conf

cp $libdir/libnss* $workdir/$chrootlibdir/

cp2wd $usrlibdir/php5
cp2wd $usrlibdir/locale

cp2wd /usr/share/zoneinfo
