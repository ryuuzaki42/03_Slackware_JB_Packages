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
# Script: Script to build a Slackware package of mendeleydesktop
# Based in: https://slackbuilds.org/slackbuilds/14.2/academic/mendeleydesktop/
#
# Last update: 13/04/2018
#
echo -e "\\n# Script to build a Slackware package of mendeleydesktop #\\n"

if [ "$USER" != "root" ]; then
    echo -e "\\nNeed to be superuser (root)\\nExiting\\n"
else
    progName="mendeleydesktop" # last tested: "1.18.0"
    tag="1_JB"

    linkGetVersion="https://www.mendeley.com/release-notes/"
    wget "$linkGetVersion" -O "${progName}-latest"

    version=$(grep "/release-notes/" $progName-latest | head -n 1 | rev | cut -d ' ' -f1 | rev | sed 's/[^0-9,.]*//g')
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

    folderDest=$(pwd)
    linkDl="http://desktop-download.mendeley.com/download/linux"

    if [ -z "$ARCH" ]; then
        case "$(uname -m)" in
            i?86) ARCH="i486" ;;
            arm*) ARCH="arm" ;;
            *) ARCH=$(uname -m) ;;
        esac
    fi

    if [ "$ARCH" = "i586" ] || [ "$ARCH" = "i686" ]; then
        ARCH="i486" # mendeleydesktop doesn't have i586/i686 pre-builds.
    fi

    if [ "$ARCH" == "x86_64" ] || [ "$ARCH" == "i486" ]; then
        wget -c "$linkDl/${progName}-${version}-linux-${ARCH}.tar.bz2"
    else
        echo -e "\\nError: ARCH $ARCH not configured\\n"
        exit 1
    fi

    set -e
    folderSourceCode="$folderDest/${progName}-${version}-linux-$ARCH"
    rm -rf "$folderSourceCode" "$folderSourceCode-tmp"
    tar xvf "$folderDest/${progName}-${version}-linux-${ARCH}.tar.bz2"
    mv "$folderSourceCode" "$folderSourceCode-tmp"
    cd "$folderSourceCode-tmp" || exit

    chown -R root:root .
    find -L . \
    \( -perm 777 -o -perm 775 -o -perm 750 -o -perm 711 -o -perm 555 \
    -o -perm 511 \) -exec chmod 755 {} \; -o \
    \( -perm 666 -o -perm 664 -o -perm 640 -o -perm 600 -o -perm 444 \
    -o -perm 440 -o -perm 400 \) -exec chmod 644 {} \;

    # Using /opt for installation and prevent conflicts with QT5 applications
    mkdir -p "$folderSourceCode"/opt/mendeleydesktop
    mv ./* "$folderSourceCode"/opt/mendeleydesktop

    # Make symlinks and moving some important files
    mkdir -p "$folderSourceCode"/usr/{bin,share}
    cp -r "$folderSourceCode"/opt/mendeleydesktop/share/{applications,icons} "$folderSourceCode"/usr/share
    ln -s /opt/mendeleydesktop/bin/mendeleydesktop "$folderSourceCode"/usr/bin

    find "$folderSourceCode" -print0 | xargs -0 file | grep -e "executable" -e "shared object" | grep ELF \
    | cut -f 1 -d : | xargs strip --strip-unneeded 2> /dev/null || true

    mkdir "$folderSourceCode"/install
    echo "# HOW TO EDIT THIS FILE:
# The \"handy ruler\" below makes it easier to edit a package description.
# Line up the first '|' above the ':' following the base package name, and
# the '|' on the right side marks the last column you can put a character in.
# You must make exactly 11 lines for the formatting to be correct. It's also
# customary to leave one space after the ':' except on otherwise blank lines.

               |-----handy-ruler------------------------------------------------------|
mendeleydesktop: mendeleydesktop (managing and sharing research papers tool)
mendeleydesktop:
mendeleydesktop: Mendeley is a software to organize, share, and discover
mendeleydesktop: research papers. Before you download and use this software,
mendeleydesktop: make sure you agree with the terms and conditions located at:
mendeleydesktop: http://www.mendeley.com/terms/
mendeleydesktop:
mendeleydesktop: Homepage: https://www.mendeley.com/
mendeleydesktop:
mendeleydesktop:
mendeleydesktop:" > "$folderSourceCode"/install/slack-desc

    cd "$folderSourceCode" || exit
    /sbin/makepkg -l y -c n "$folderDest/${progName}-${version}-${ARCH}-${tag}.txz"

    rm -rf "$folderSourceCode" "${folderSourceCode}-tmp" "${folderSourceCode}.tar.bz2"
fi
