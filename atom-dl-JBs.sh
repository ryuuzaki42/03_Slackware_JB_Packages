#!/bin/bash
# Create a txz from atom-version.rpm

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    progName="atom"
    linkDl="https://github.com/atom/atom/releases/download"
    tag=JB-2

    wget https://github.com/atom/atom/releases/latest -O latest
    version=`cat latest | grep "Release.*[[:digit:]].*atom" | sed 's/[^0-9,.]*//g'`
    rm latest

    echo -e "\nLatest version: $version\n"
    installedVersion=`ls /var/log/packages/atom-* | cut -d '-' -f2`
    if [ "$installedVersion" != '' ]; then
        if [ "$version" == "$installedVersion" ]; then
            echo -e "\nVersion installed ($installedVersion) is equal to latest version ($version)"
            echo -n "Want continue? (y)es - (n)o (hit enter to no): "
            read continue

            if [ "$continue" == 'n' ] || [ "$continue" == '' ]; then
                echo -e "\nJust exiting\n"
                exit 0
            fi
        fi
    fi

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
