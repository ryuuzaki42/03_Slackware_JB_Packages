#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# Mande me um e-mail. Ficarei Grato!
# e-mail: joao42lbatista@gmail.com
#
# Este programa é um software livre; você pode redistribui-lo e/ou
# modifica-lo dentro dos termos da Licença Pública Geral GNU como
# publicada pela Fundação do Software Livre (FSF); na versão 2 da
# Licença, ou (na sua opinião) qualquer versão.
#
# Este programa é distribuído na esperança que possa ser útil,
# mas SEM NENHUMA GARANTIA; sem uma garantia implícita de ADEQUAÇÃO a
# qualquer MERCADO ou APLICAÇÃO EM PARTICULAR.
#
# Veja a Licença Pública Geral GNU para mais detalhes.
# Você deve ter recebido uma cópia da Licença Pública Geral GNU
# junto com este programa, se não, escreva para a Fundação do Software
#
# Livre(FSF) Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
#
# Script: Script to build a Slackware package of smplayer
# Based in: https://slackbuilds.org/repository/14.2/multimedia/smplayer/
#
# Last update: 02/11/2019
#
# Tip: To build against Qt5 rather than Qt4
# Use: USE_QT5=yes ./smplayer_dl_JBs.sh
#
echo -e "\\n# Script to build a Slackware package of smplayer (without skins and themes) #\\n"

if [ "$USER" != "root" ]; then
    echo -e "\\nNeed to be superuser (root)\\nExiting\\n"
else
    progName="smplayer" # last tested: "19.10.0"
    tag="1_JB"

    linkGetVersion="https://app.assembla.com/spaces/smplayer/subversion/source/HEAD/smplayer/trunk/OBS/Makefile?_format=raw"
    wget "$linkGetVersion" -O "${progName}-latest"

    version=$(cat $progName-latest | grep "VERSION" | head -n 1 | sed 's/[^0-9,.]*//g')
    rm "${progName}-latest"

    installedVersion=$(find /var/log/packages/$progName* | cut -d '-' -f2)
    echo -e "\\n   Latest version: $version\\nVersion installed: $installedVersion\\n"
    if [ "$installedVersion" != '' ]; then
        if [ "$version" == "$installedVersion" ]; then
            echo -e "Version installed ($installedVersion) is equal to latest version ($version)"

            continue=$1
            if [ "$continue" == '' ]; then
                echo -n "Want continue? (y)es - (n)o (hit enter to no): "
                read -r continue
            fi

            if [ "$continue" != 'y' ]; then
                echo -e "\\nJust exiting\\n"
                exit 0
            fi
        fi
    fi

    linkDl="http://downloads.sourceforge.net/smplayer"

    if [ -z "$ARCH" ]; then
        case "$(uname -m)" in
            i?86) ARCH="i586" ;;
            arm*) ARCH="arm" ;;
            *) ARCH=$(uname -m) ;;
        esac
    fi

    folderDest=$(pwd)
    progInstallFolder="$folderDest/${progName}-$version"
    tmpFolder="${progInstallFolder}-tmp"

    if [ "$ARCH" = "i586" ]; then
        SLKCFLAGS="-O2 -march=i586 -mtune=i686"
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
    mkdir "$tmpFolder"
    cd "$tmpFolder" || exit

    tar xvf "$folderDest/${progName}-${version}.tar.bz2"
    cd "${progName}-$version" || exit

    chown -R root:root .

    find -L . \
    \( -perm 777 -o -perm 775 -o -perm 750 -o -perm 711 -o -perm 555 \
    -o -perm 511 \) -exec chmod 755 {} \; -o \
    \( -perm 666 -o -perm 664 -o -perm 640 -o -perm 600 -o -perm 444 \
    -o -perm 440 -o -perm 400 \) -exec chmod 644 {} \;

    # Fix man page path.
    sed -i "s/share\\/man/man/g" Makefile

    if [ "$USE_QT5" = "yes" ]; then
        QMAKE="qmake-qt5"
        LRELEASE="lrelease-qt5"
    else
        QMAKE="qmake"
        LRELEASE="lrelease"
    fi

    make \
        QMAKE=$QMAKE \
        LRELEASE=$LRELEASE \
        PREFIX=/usr \
        DOC_PATH="\\\"/usr/doc/$progName-$version/\\\"" \
        QMAKE_OPTS="QMAKE_CXXFLAGS=\"$SLKCFLAGS\""

    make install \
        PREFIX=/usr \
        DOC_PATH=/usr/doc/$progName-"$version" \
        DESTDIR="$progInstallFolder"

    find "$progInstallFolder" -print0 | xargs -0 file | grep -e "executable" -e "shared object" | grep ELF \
    | cut -f 1 -d : | xargs strip --strip-unneeded 2> /dev/null || true

    mkdir -p "$progInstallFolder/usr/doc/${progName}-$version"
    cp -a ./*.txt Changelog "$progInstallFolder/usr/doc/${progName}-$version"

    rm "$progInstallFolder/usr/share/applications/smplayer_enqueue.desktop"

    mkdir "$progInstallFolder/install"
    echo "# HOW TO EDIT THIS FILE:
# The \"handy ruler\" below makes it easier to edit a package description.
# Line up the first '|' above the ':' following the base package name, and
# the '|' on the right side marks the last column you can put a character in.
# You must make exactly 11 lines for the formatting to be correct. It's also
# customary to leave one space after the ':' except on otherwise blank lines.

        |-----handy-ruler------------------------------------------------------|
smplayer: smplayer (GUI front-end to mplayer)
smplayer:
smplayer: SMPlayer intends to be a complete front-end for MPlayer, from
smplayer: basic features like playing videos, DVDs, and VCDs to more
smplayer: advanced features like support for MPlayer filters and more.
smplayer:
smplayer: Homepage: http://smplayer.sourceforge.net
smplayer:
smplayer:
smplayer:
smplayer:" > "$progInstallFolder/install/slack-desc"

    cd "$progInstallFolder" || exit
    /sbin/makepkg -l y -c n "$folderDest/${progName}-${version}-${ARCH}-${tag}.txz"

    cd "$folderDest" || exit
    rm -r "$tmpFolder" "${progName}-$version" "${progName}-${version}.tar.bz2"
fi
