#!/bin/sh
# Slackware build script for SMPlayer ( without skins and themes)
# Edited from: https://slackbuilds.org/repository/14.2/multimedia/smplayer/

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    progName="smplayer"
    version="16.11.0"
    tag="JB-1"

    linkDl="http://downloads.sourceforge.net/smplayer"

    if [ -z "$ARCH" ]; then
    case "$( uname -m )" in
        i?86) ARCH=i486 ;;
        arm*) ARCH=arm ;;
        *) ARCH=$( uname -m ) ;;
    esac
    fi

    initialFolder=$(pwd)
    tmpFolder=$initialFolder/tmpFolder_`date +%s`
    progInstallFolder=$tmpFolder/$progName

    if [ "$ARCH" = "i486" ]; then
        SLKCFLAGS="-O2 -march=i486 -mtune=i686"
        LIBDIRSUFFIX=""
    elif [ "$ARCH" = "i686" ]; then
        SLKCFLAGS="-O2 -march=i686 -mtune=i686"
        LIBDIRSUFFIX=""
    elif [ "$ARCH" = "x86_64" ]; then
        SLKCFLAGS="-O2 -fPIC"
        LIBDIRSUFFIX="64"
    else
        SLKCFLAGS="-O2"
        LIBDIRSUFFIX=""
    fi

    wget -c "$linkDl/$progName-$version.tar.bz2"

    set -e

    mkdir $tmpFolder
    cd $tmpFolder

    tar xvf $initialFolder/$progName-$version.tar.bz2
    cd $progName-$version

    chown -R root:root .

    sed -i "/^PREFIX/s/=.*$/=\/usr/;
            /^DOC_PATH/s/\/.*$/\/doc\/$progName-$version/;
            s/share\/man/man/g;
            s/^QMAKE_OPTS=/QMAKE_OPTS+=/" Makefile

    QMAKE_OPTS="QMAKE_CXXFLAGS=\"$SLKCFLAGS\"" \
    make
    make install DESTDIR=$progInstallFolder

    find $progInstallFolder -print0 | xargs -0 file | grep -e "executable" -e "shared object" | grep ELF \
    | cut -f 1 -d : | xargs strip --strip-unneeded 2> /dev/null || true

    mkdir -p $progInstallFolder/usr/doc/$progName-$version
    cp -a *.txt Changelog $progInstallFolder/usr/doc/$progName-$version

    rm $progInstallFolder/usr/share/applications/smplayer_enqueue.desktop

    cd $progInstallFolder
    /sbin/makepkg -l y -c n $initialFolder/$progName-$version-$ARCH-$tag.tgz

    cd $initialFolder
    rm -r $tmpFolder
    rm $progName-$version.tar.bz2
fi
