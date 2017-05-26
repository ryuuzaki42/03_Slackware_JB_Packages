#!/bin/bash
# Slackware build script for mendeleydesktop
# Based in: https://slackbuilds.org/slackbuilds/14.2/academic/mendeleydesktop/mendeleydesktop.SlackBuild

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    progName="mendeleydesktop" # last tested: "1.17.9"
    tag="JB"

    linkGetVersion="https://www.mendeley.com/release-notes/"
    wget "$linkGetVersion" -O "${progName}-latest"

    version=$(cat $progName-latest | grep "Release Notes for Mendeley Desktop" | head -n 1 | sed 's/[^0-9,.]*//g')
    rm "${progName}-latest"

    installedVersion=$(find /var/log/packages/$progName* | cut -d '-' -f2)
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

    folderDest=$(pwd)
    linkDl="http://desktop-download.mendeley.com/download/linux"

    if [ -z "$ARCH" ]; then
        case "$(uname -m)" in
            i?86) ARCH="i486" ;;
            arm*) ARCH="arm" ;;
            *) ARCH=$(uname -m) ;;
        esac
    fi

    if [ "$ARCH" = "i486" ]; then
        LIBDIRSUFFIX=''
    elif [ "$ARCH" = "i586" ] || [ "$ARCH" = "i686" ]; then
        ARCH="i486" # mendeleydesktop doesn't have i586/i686 pre-builds
        LIBDIRSUFFIX=''
    elif [ "$ARCH" = "x86_64" ]; then
        LIBDIRSUFFIX="64"
    else
        LIBDIRSUFFIX=''
    fi

    if [ "$ARCH" == "x86_64" ] || [ "$ARCH" == "i486" ]; then
        wget -c "$linkDl/${progName}-${version}-linux-${ARCH}.tar.bz2"
    else
        echo -e "\nError: ARCH $ARCH not configured\n"
        exit 1
    fi

    set -e
    folderSourceCode="$folderDest/${progName}-${version}-linux-$ARCH"

    rm -rf "$folderSourceCode" "$folderSourceCode-tmp"

    tar xvf "$folderDest/${progName}-${version}-linux-${ARCH}.tar.bz2"
    mv "${progName}-${version}-linux-$ARCH" "${progName}-${version}-linux-${ARCH}-tmp"

    cd "${progName}-${version}-linux-${ARCH}-tmp" || exit
    chown -R root:root .
    find -L . \
    \( -perm 777 -o -perm 775 -o -perm 750 -o -perm 711 -o -perm 555 \
    -o -perm 511 \) -exec chmod 755 {} \; -o \
    \( -perm 666 -o -perm 664 -o -perm 640 -o -perm 600 -o -perm 444 \
    -o -perm 440 -o -perm 400 \) -exec chmod 644 {} \;

    # Remove the bundled qt since it should be present in the system already
    rm -rf lib/qt bin/qt.conf lib/mendeleydesktop/plugins

    [ "$ARCH" = "x86_64" ] && mv lib "lib$LIBDIRSUFFIX"

    rm bin/mendeleydesktop
    ln -s ../lib${LIBDIRSUFFIX}/mendeleydesktop/libexec/mendeleydesktop.$ARCH bin/mendeleydesktop

    # Some docs lay on the top folder, so install them first
    mkdir -p "$folderSourceCode/usr/doc"
    mv share/doc/mendeleydesktop "$folderSourceCode/usr/doc/${progName}-$version"
    mv LICENSE README "$folderSourceCode/usr/doc/${progName}-$version"

    rm INSTALL
    rmdir share/doc

    mv ./* "$folderSourceCode/usr"

    find "$folderSourceCode" -print0 | xargs -0 file | grep -e "executable" -e "shared object" | grep ELF \
    | cut -f 1 -d : | xargs strip --strip-unneeded 2> /dev/null || true

    cd "$folderSourceCode" || exit
    /sbin/makepkg -l y -c n "$folderDest/${progName}-${version}-${ARCH}-${tag}.txz"

    rm -rf "$folderSourceCode" "${folderSourceCode}-tmp" "${folderSourceCode}.tar.bz2"
fi
