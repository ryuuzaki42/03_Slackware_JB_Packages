#!/bin/sh
# Slackware build script for SMPlayer ( without skins and themes)
# Edited from: https://slackbuilds.org/repository/14.2/multimedia/smplayer/

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    PRGNAM="smplayer"
    VERSION="16.11.0"
    TAG="JB-1"

    link="http://downloads.sourceforge.net/smplayer"

    if [ -z "$ARCH" ]; then
    case "$( uname -m )" in
        i?86) ARCH=i486 ;;
        arm*) ARCH=arm ;;
        *) ARCH=$( uname -m ) ;;
    esac
    fi

    CWD=$(pwd)
    TMP=tmp_`date +%s`
    PKG=$TMP/package-$PRGNAM

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

    wget -c "$link/$PRGNAM-$VERSION.tar.bz2"

    set -e

    rm -rf $PKG
    mkdir -p $TMP $PKG
    cd $TMP
    rm -rf $PRGNAM-$VERSION

    tar xvf $CWD/$PRGNAM-$VERSION.tar.bz2
    cd $PRGNAM-$VERSION

    chown -R root:root .

    sed -i "/^PREFIX/s/=.*$/=\/usr/;
            /^DOC_PATH/s/\/.*$/\/doc\/$PRGNAM-$VERSION/;
            s/share\/man/man/g;
            s/^QMAKE_OPTS=/QMAKE_OPTS+=/" Makefile

    QMAKE_OPTS="QMAKE_CXXFLAGS=\"$SLKCFLAGS\"" \
    make
    make install DESTDIR=$PKG

    find $PKG -print0 | xargs -0 file | grep -e "executable" -e "shared object" | grep ELF \
    | cut -f 1 -d : | xargs strip --strip-unneeded 2> /dev/null || true

    mkdir -p $PKG/usr/doc/$PRGNAM-$VERSION
    cp -a *.txt Changelog $PKG/usr/doc/$PRGNAM-$VERSION

    cd $PKG
    /sbin/makepkg -l y -c n $CMD/$PRGNAM-$VERSION-$ARCH-$TAG.tgz

    cd $CWD
    rm -r $TMP
    rm $PRGNAM-$VERSION.tar.bz2
fi
