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
# Script: Script to build a Slackware package of git-lfs
# Based in: https://slackbuilds.org/repository/14.2/development/git-lfs/
#
# Last update: 19/11/2023
#
echo -e "\n# Script to build a Slackware package of git-lfs #\n"

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    progName="git-lfs" # last tested: "3.4.0"
    tag="1_JB"

    linkGetVersion="https://github.com/git-lfs/git-lfs/releases/latest"
    wget --compress=none "$linkGetVersion" -O "${progName}-latest"

    version=$(grep "/git-lfs/git-lfs/tree/v" $progName-latest | head -n 1 | cut -d "/" -f5 | cut -d 'v' -f2 | cut -d "\"" -f1)
    rm "${progName}-latest"

    installedVersion=$(find /var/log/packages/$progName* | cut -d '-' -f3)
    echo -e "\n   Latest version: $version\nVersion installed: $installedVersion\n"
    if [ "$installedVersion" != '' ]; then
        if [ "$version" == "$installedVersion" ]; then
            echo -e "Version installed ($installedVersion) is equal to latest version ($version)"

            continue=$1
            if [ "$continue" == '' ]; then
                echo -n "Want continue? (y)es - (n)o (hit enter to no): "
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

    fileName="${progName}-linux-${SRCARCH}-v${version}"
    wget -c "$linkDl/v$version/${fileName}.tar.gz"

    rm -r "$fileName"
    mkdir "$fileName"
    mv "${fileName}.tar.gz" "$fileName"
    cd "$fileName" || exit

    tar xvf "${fileName}.tar.gz"
    rm "${fileName}.tar.gz"

    mkdir -p usr/bin
    mv "$progName-$version/"* .
    rmdir "$progName-$version/"
    install -m0755 "$progName" usr/bin

    mkdir install
    echo "# HOW TO EDIT THIS FILE:
# The \"handy ruler\" below makes it easier to edit a package description.
# Line up the first '|' above the ':' following the base package name, and
# the '|' on the right side marks the last column you can put a character in.
# You must make exactly 11 lines for the formatting to be correct. It's also
# customary to leave one space after the ':' except on otherwise blank lines.

       |-----handy-ruler------------------------------------------------------|
git-lfs: git-lfs (Git extension)
git-lfs:
git-lfs: Git LFS is a command line extension and specification for managing
git-lfs: large files with Git. The client is written in Go, with pre-compiled
git-lfs: binaries available for Mac, Windows, Linux, and FreeBSD.
git-lfs:
git-lfs:
git-lfs: Project URL: https://git-lfs.github.com/
git-lfs:
git-lfs:
git-lfs:" > install/slack-desc

    mkdir -p "usr/doc/${progName}-$version"
    mv *.md man/ "usr/doc/${progName}-$version"

    rm git-lfs install.sh

    /sbin/makepkg -l y -c n "$folderDest/${progName}-${version}-${ARCH}-${tag}.txz"

    cd .. || exit
    rm -r "$fileName"
fi
