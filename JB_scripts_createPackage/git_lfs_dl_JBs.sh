#!/bin/bash
# Slackware build script for git-lfs
# Based in: https://slackbuilds.org/repository/14.2/development/git-lfs/

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    progName="git-lfs" # last tested: 2.1.0
    tag="JB"

    linkGetVersion="https://github.com/git-lfs/git-lfs/releases/latest"
    wget "$linkGetVersion" -O "${progName}-latest"

    version=$(cat $progName-latest | grep "/git-lfs/git-lfs/tree/v" | head -n 1 | cut -d "v" -f2 | cut -d "\"" -f1)
    rm "${progName}-latest"

    installedVersion=$(find /var/log/packages/$progName* | cut -d '-' -f3)
    echo -e "\n   Latest version: $version\nVersion installed: $installedVersion\n"
    if [ "$installedVersion" != '' ]; then
        if [ "$version" == "$installedVersion" ]; then
            echo -e "Version installed ($installedVersion) is equal to latest version ($version)"
            echo -n "Want continue? (y)es - (n)o (hit enter to no): "

            continue=$1
            if [ "$continue" == '' ]; then
                read -r continue
            fi

            if [ "$continue" != 'y' ]; then
                echo -e "\nJust exiting\n"
                exit 0
            fi
        fi
    fi

    if [ -z "$ARCH" ]; then
        case "$(uname -m)" in
            i?86) ARCH="i586" ;;
            arm*) ARCH="arm" ;;
            *) ARCH=$(uname -m) ;;
        esac
    fi

    if [ "$ARCH" = "i586" ]; then
        SRCARCH="386"
    elif [ "$ARCH" = "i686" ]; then
        SRCARCH="386"
    elif [ "$ARCH" = "x86_64" ]; then
        SRCARCH="amd64"
    else
        SRCARCH="386"
    fi

    folderDest=$(pwd)
    linkDl="https://github.com/git-lfs/git-lfs/releases/download"

    wget -c "$linkDl/v$version/${progName}-linux-${SRCARCH}-${version}.tar.gz"

    tar xvf "${progName}-linux-${SRCARCH}-${version}.tar.gz"
    rm "${progName}-linux-${SRCARCH}-${version}.tar.gz"

    cd "${progName}-$version" || exit

    mkdir -p usr/bin
    install -m0755 "$progName" usr/bin

    mkdir -p "usr/doc/${progName}-$version"
    mv ./*.md "usr/doc/${progName}-$version"

    rm git-lfs install.sh

    /sbin/makepkg -l y -c n "$folderDest/${progName}-${version}-${ARCH}-${tag}.txz"

    cd .. || exit
    rm -r "${progName}-$version"
fi
