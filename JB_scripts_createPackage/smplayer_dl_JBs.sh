#!/bin/bash
# Slackware build script for SMPlayer (without skins and themes)
# Based in: https://slackbuilds.org/repository/14.2/multimedia/smplayer/

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    progName="smplayer" # last tested: 17.4.0
    tag="JB"

    linkGetVersion="https://app.assembla.com/spaces/smplayer/subversion/source/HEAD/smplayer/trunk/OBS/Makefile?_format=raw"
    wget "$linkGetVersion" -O "${progName}-latest"

    version=$(cat $progName-latest | grep "VERSION" | head -n 1 | sed 's/[^0-9,.]*//g')
    rm "$progName-latest"

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
    linkDl="http://downloads.sourceforge.net/smplayer"

    if [ -z "$ARCH" ]; then
    case "$( uname -m )" in
        i?86) ARCH=i486 ;;
        arm*) ARCH=arm ;;
        *) ARCH=$( uname -m ) ;;
    esac
    fi

    initialFolder=$(pwd)
    progInstallFolder=$initialFolder/$progName-$version
    tmpFolder=$progInstallFolder-tmp

    if [ "$ARCH" = "i486" ]; then
        SLKCFLAGS="-O2 -march=i486 -mtune=i686"
    elif [ "$ARCH" = "i686" ]; then
        SLKCFLAGS="-O2 -march=i686 -mtune=i686"
    elif [ "$ARCH" = "x86_64" ]; then
        SLKCFLAGS="-O2 -fPIC"
    else
        SLKCFLAGS="-O2"
    fi

    wget -c "$linkDl/$progName-$version.tar.bz2"

    set -e

    mkdir "$tmpFolder"
    cd "$tmpFolder" || exit

    tar xvf "$initialFolder/${progName}-${version}.tar.bz2"
    cd "${progName}-$version" || exit

    chown -R root:root .

    sed -i "/^PREFIX/s/=.*$/=\/usr/;
            /^DOC_PATH/s/\/.*$/\/doc\/${progName}-$version/;
            s/share\/man/man/g;
            s/^QMAKE_OPTS=/QMAKE_OPTS+=/" Makefile

    QMAKE_OPTS="QMAKE_CXXFLAGS=\"$SLKCFLAGS\"" \
    make
    make install DESTDIR="$progInstallFolder"

    find "$progInstallFolder" -print0 | xargs -0 file | grep -e "executable" -e "shared object" | grep ELF \
    | cut -f 1 -d : | xargs strip --strip-unneeded 2> /dev/null || true

    mkdir -p "$progInstallFolder/usr/doc/${progName}-$version"
    cp -a ./*.txt Changelog "$progInstallFolder/usr/doc/${progName}-$version"

    rm "$progInstallFolder/usr/share/applications/smplayer_enqueue.desktop"

    cd "$progInstallFolder" || exit
    /sbin/makepkg -l y -c n "$initialFolder/${progName}-${version}-${ARCH}-${tag}.txz"

    cd "$initialFolder" || exit
    rm -r "$tmpFolder" "${progName}-$version" "${progName}-${version}.tar.bz2"
fi
