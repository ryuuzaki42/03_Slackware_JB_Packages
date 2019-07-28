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
# Script: Script to create a Slackware package from the shellcheck pre-compiled
#
# Last update: 28/07/2019
#
echo -e "\\n# Script to create a Slackware package from the shellcheck pre-compiled #\\n"

if [ "$USER" != "root" ]; then
    echo -e "\\nNeed to be superuser (root)\\nExiting\\n"
else
    archDL=$(uname -m)
    if [ "$archDL" != "x86_64" ]; then
        echo "# Only 64 bits, without 32 bits precompiled package in the $progName repository/release"
        exit 1
    fi

    progName="shellcheck" # last tested: "0.6.0_gitf9c8a25"
    tag="1_JB"
    folderDest=$(pwd)

    linkGetVersion="https://github.com/koalaman/shellcheck/releases"
    wget --compress=none "$linkGetVersion" -O "${progName}-latest"

    versionNumber=$(grep "Stable version" < "${progName}-latest" | head -n 1 | cut -d ' ' -f9)
    rm "${progName}-latest"

    linkDl="https://shellcheck.storage.googleapis.com"
    wget --compress=none "$linkDl/README.txt" -O "${progName}_latest"

    checkStableVersion=$(head -n 25 "${progName}_latest" | sed -n '/^Date/,/^commit/p')
    if echo "$checkStableVersion" | grep -q "Stable version"; then
        version=$versionNumber

        fileName="${progName}-v${versionNumber}.linux.x86_64.tar.xz"
        folderName="${progName}-v$versionNumber"
    else
        versionCommit=$(grep "commit " < "${progName}_latest" | head -n 1 | cut -d ' ' -f2 | tr -d "\\r" | cut -c1-7)
        version="${versionNumber}_git${versionCommit}"

        fileName="${progName}-latest.linux.x86_64.tar.xz"
        folderName="${progName}-latest"
    fi
    rm "${progName}_latest"

    installedVersion=$(find /var/log/packages/ | grep "$progName" | cut -d '-' -f2)
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

    wget -c "$linkDl/$fileName" -O "$fileName"

    tar -xvf "$fileName"
    rm "$fileName"

    cd "$folderName" || exit

    mkdir -p usr/bin/
    mv "$progName" usr/bin/

    mkdir -p "usr/doc/$progName/"
    rm LICENSE.txt
    mv README.txt "usr/doc/$progName/"

    mkdir install
    echo "# HOW TO EDIT THIS FILE:
# The \"handy ruler\" below makes it easier to edit a package description.
# Line up the first '|' above the ':' following the base package name, and
# the '|' on the right side marks the last column you can put a character in.
# You must make exactly 11 lines for the formatting to be correct. It's also
# customary to leave one space after the ':' except on otherwise blank lines.

          |-----handy-ruler------------------------------------------------------|
shellcheck: shellcheck (A shell script static analysis tool)
shellcheck:
shellcheck: ShellCheck is a GPLv3 tool that gives warnings and
shellcheck: suggestions for bash/sh shell scripts.
shellcheck:
shellcheck: On the web: http://www.shellcheck.net
shellcheck: Paste a shell script on for instant feedback.
shellcheck:
shellcheck: Homepage: https://github.com/koalaman/shellcheck
shellcheck:
shellcheck:" > install/slack-desc

    /sbin/makepkg -l y -c n "$folderDest/${progName}-${version}-${archDL}-${tag}.txz"

    cd .. || exit
    rm -r "$folderName"
fi
