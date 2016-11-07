#!/bin/bash
# Create a txz from opera-stable-version.rpm

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    progName="opera-stable"
    version="41.0.2353.46"
    linkDl="http://download4.operacdn.com/pub/opera/desktop/$version/linux"
    tag=JB-2

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
        echo -e "\nError: $ARCH not configured\n"
    fi

    rpm2txz "$progName"_"$version"_$ARCH.rpm

    rm "$progName"_"$version"_$ARCH.rpm

    mv "$progName"_"$version"_$ARCH.txz "$progName"_"$version"_$ARCH-$tag.txz
fi
