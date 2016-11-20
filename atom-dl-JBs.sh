#!/bin/bash
# Create a txz from atom-version.rpm

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    progName="atom"
    version="1.12.4"
    linkDl="https://github.com/atom/atom/releases/download"
    tag=JB-2

    if [ -z "$ARCH" ]; then
        case "$( uname -m )" in
            i?86) ARCH=i386 ;;
            arm*) ARCH=arm ;;
            *) ARCH=$( uname -m ) ;;
        esac
    fi

    if [ "$ARCH" == "x86_64" ]; then # Only 64 bits, without 32 bits rpm in atom site
        wget -c $linkDl/v$version/$progName.$ARCH.rpm
    else
        echo -e "\nError: ARCH $ARCH not configured\n"
        exit 1
    fi

    mv $progName.$ARCH.rpm $progName-$version-$ARCH-$tag.rpm

    rpm2txz $progName-$version-$ARCH-$tag.rpm

    rm $progName-$version-$ARCH-$tag.rpm
fi
