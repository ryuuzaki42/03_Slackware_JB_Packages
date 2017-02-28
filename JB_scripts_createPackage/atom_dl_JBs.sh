#!/bin/bash
# Create a txz from atom-version.rpm

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    progName="atom" # last tested: 1.14.4
    tag="JB"

    linkGetVersion="https://github.com/atom/atom/releases/latest"
    wget $linkGetVersion -O $progName-latest

    version=`cat $progName-latest | grep "Release.*[[:digit:]].*" | sed 's/[^0-9,.]*//g'`
    rm $progName-latest

    installedVersion=`ls /var/log/packages/$progName* | cut -d '-' -f2`
    echo -e "\n   Latest version: $version\nVersion installed: $installedVersion\n"
    if [ "$installedVersion" != '' ]; then
        if [ "$version" == "$installedVersion" ]; then
            echo -e "Version installed ($installedVersion) is equal to latest version ($version)"
            echo -n "Want continue? (y)es - (n)o (hit enter to no): "

            continue=$1
            if [ "$continue" == '' ]; then
                read continue
            fi

            if [ "$continue" != 'y' ]; then
                echo -e "\nJust exiting\n"
                exit 0
            fi
        fi
    fi
    linkDl="https://github.com/atom/atom/releases/download"

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
