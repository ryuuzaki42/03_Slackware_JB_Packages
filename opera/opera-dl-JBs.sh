#!/bin/bash
# Create a txz from opera-stable-version.rpm

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    progName="opera-stable"
    version="41.0.2353.56"
    tag=JB-2

    linkDl="http://download4.operacdn.com/pub/opera/desktop/$version/linux"

    if [ -z "$ARCH" ]; then
        case "$( uname -m )" in
            i?86) ARCH=i386 ;;
            arm*) ARCH=arm ;;
            x86_64) ARCH=amd64 ;;
            *) ARCH=$( uname -m ) ;;
        esac
    fi

    if [ "$ARCH" == "amd64" ] ||[ "$ARCH" == "i386" ] ; then
        wget -c "$linkDl/"$progName"_"$version"_$ARCH.rpm"
    else
        echo -e "\nError: ARCH $ARCH not configured\n"
        exit 1
    fi

    rpm2txz "$progName"_"$version"_$ARCH.rpm

    rm "$progName"_"$version"_$ARCH.rpm

    mv "$progName"_"$version"_$ARCH.txz "$progName"_"$version"_$ARCH-$tag.txz
fi
