#!/bin/bash

# Create a txz from wps-office-version.rpm

progName="wps-office"
version="10.1.0.5672-1.a21"
linkDl="http://kdl.cc.ksosoft.com/wps-community/download/a21"
tag=JB-2


if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    if [ -z "$ARCH" ]; then
        case "$( uname -m )" in
            i?86) ARCH=i686 ;;
            arm*) ARCH=arm ;;
            *) ARCH=$( uname -m ) ;;
        esac
    fi

    if [ "$ARCH" == "x86_64" ] ||[ "$ARCH" == "i686" ] ; then
        wget -c "$linkDl/$progName-$version.$ARCH.rpm"
    else
        echo -e "\nError: $ARCH not configured\n"
    fi

    rpm2txz $progName-$version.$ARCH.rpm

    rm $progName-$version.$ARCH.rpm

    mv $progName-$version.$ARCH.txz $progName-$version.$ARCH-$tag.txz
fi