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
# Script: Create a txz from smartsynchronize and/or smartgit from "program"-version.tar.gz
# Based in: https://slackbuilds.org/repository/14.2/development/smartgit/
#
# Last update: 18/11/2023
#
set -e
echo -e "\n# Create a txz from smartsynchronize and/or smartgit from \"program\"-version.tar.gz #\n"

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    progBuild=$1
    if [ "$progBuild" == '' ]; then
        echo -en "You want build SmartGit or SmartSynchronize?\n1 to SmartGit or - 2 to SmartSynchronize: "
        read -r progBuild
    fi

    if [ "$progBuild" == '1' ]; then
        progName="smartgit" # last tested: "22.1.7"
    elif [ "$progBuild" == '2' ]; then
        progName="smartsynchronize" # last tested: "4.5.0"
    else
        echo -e "\nError: The chosen program ($progBuild) is unknown\n"
        exit 1
    fi

    echo
    linkGetVersion="https://www.syntevo.com/$progName/download/"
    wget --no-check-certificate "$linkGetVersion" -O "${progName}-latest.txt"

    version=$(grep -o "Version .*" ${progName}-latest.txt | head -n 1 | cut -d ' ' -f2)
    versionDL=${version//./_}
    rm "${progName}-latest.txt"

    countUnderscore=$(grep -o "_" <<< "$versionDL" | wc -l)
    if [ "$countUnderscore" -lt '2' ]; then # IF the version has only one "_" will added "_0" to the end
        versionDL="${versionDL}_0"
        version="${version}.0"
    fi

    installedVersion=$(find /var/log/packages/$progName* | cut -d '-' -f2)
    echo -e "\n   Latest version: $version\nVersion installed: $installedVersion\n"
    if [ "$installedVersion" != '' ]; then
        if [ "$version" == "$installedVersion" ]; then
            echo -e "Version installed ($installedVersion) is equal to latest version ($version)"

            continue=$2
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
    echo -e "\nWill build $progName, please wait\n"

    linkDl="https://www.syntevo.com/downloads/$progName"
    folderDest=$(pwd)
    TAG="1_JB"
    ARCH=noarch

    wget -c "$linkDl/${progName}-linux-${versionDL}.tar.gz"

    rm -r "$progName/" 2> /dev/null || true

    tar -xvf "${progName}-linux-${versionDL}.tar.gz"

    cd "$progName" || exit
    mkdir -p "usr/doc/${progName}-$version/"
    mv licenses/ changelog.txt readme-linux.txt checksums license.html "$progName.url" "usr/doc/${progName}-$version/"

    if [ "$progBuild" == '2' ]; then
        mv ./*.pdf "usr/doc/${progName}-$version/" || true

        lnFile="ss"
    else
        lnFile="sg"
    fi

    mkdir -p usr/share/pixmaps/
    cp "bin/${progName}-128.png" "usr/share/pixmaps/${progName}.png"

    mkdir -p "usr/share/$progName/"
    mv bin/ lib/ jre/ "usr/share/$progName/"
    cp "usr/doc/${progName}-$version/license.html" "usr/share/$progName/"

    if [ "$progBuild" == '1' ]; then
        mv dictionaries/ git/ opt/ "usr/share/$progName/"
        mv known-issues.txt "usr/doc/${progName}-$version/"
    fi

    if [ "$progBuild" == '2' ]; then
        mv filemanager-themes/ "usr/share/$progName/"
    fi

    mkdir -p usr/share/applications/
    echo "[Desktop Entry]
Version=1.0
Encoding=UTF-8
Name=$progName
Keywords=git;hg;svn;mercurial;subversion
GenericName=Git&Hg-Client + SVN-support
Type=Application
Categories=Development;RevisionControl
Terminal=false
StartupNotify=true
Exec=\"/usr/share/$progName/bin/$progName.sh\" %u
MimeType=x-scheme-handler/$progName
Icon=$progName" > "usr/share/applications/${progName}.desktop"

    mkdir install
    echo "# HOW TO EDIT THIS FILE:
# The \"handy ruler\" below makes it easier to edit a package description.
# Line up the first '|' above the ':' following the base package name, and
# the '|' on the right side marks the last column you can put a character in.
# You must make exactly 11 lines for the formatting to be correct. It's also
# customary to leave one space after the ':' except on otherwise blank lines.
" > install/slack-desc

if [ "$progName" == "smartgit" ]; then
    echo "        |-----handy-ruler------------------------------------------------------|
$progName: $progName (Desktop Git Client)
$progName:
$progName: SmartGit is a commercial desktop git client that provides
$progName: a free non-commercial use license. " >> install/slack-desc
else
    echo "                |-----handy-ruler------------------------------------------------------|
$progName: $progName (file and directory compare tool)
$progName:
$progName: SmartSynchronize is a commercial desktop directory compare tool
$progName: that provides a free non-commercial use license. " >> install/slack-desc
fi

echo "$progName:
$progName: Homepage: http://www.syntevo.com/$progName/
$progName:
$progName:
$progName:
$progName:
$progName:" >> install/slack-desc

    mkdir -p usr/bin/
    cd usr/bin/ || exit
    ln -s "../share/$progName/bin/$progName.sh" "$progName"
    ln -s "../share/$progName/bin/$progName.sh" "$lnFile"
    cd ../.. || exit

    /sbin/makepkg -l y -c n "$folderDest/$progName-$version-$ARCH-$TAG.txz"

    cd ../ || exit
    rm -r "$progName/" || true
    rm "${progName}-linux-${versionDL}.tar.gz"
fi
