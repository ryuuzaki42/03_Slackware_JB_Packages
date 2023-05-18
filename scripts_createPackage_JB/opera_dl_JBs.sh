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
# Script: Create a txz from opera-stable-version.deb
#
# Last update: 18/05/2023
#
echo -e "\\n# Create a txz from opera-stable-version.deb #\\n"

if [ "$USER" != "root" ]; then
    echo -e "\\nNeed to be superuser (root)\\nExiting\\n"
else
    progName="opera" # last tested: "99.0.4788.13"
    SRCNAM="$progName-stable"

    linkGetVersion="http://ftp.opera.com/ftp/pub/opera/desktop"
    linkSlackbuilds150Prog="https://slackbuilds.org/slackbuilds/15.0/network/opera.tar.gz"

    tailNumber='1'
    continue='0'
    while [ "$continue" == '0' ]; do
        wget "$linkGetVersion" -O "${progName}-latest"

        version=$(grep "href" ${progName}-latest | grep -v "Index" | sort -V -t '.' | tail -n $tailNumber | head -n 1 | cut -d '"' -f2 | cut -d '/' -f1)
        if [ "$version" == '' ]; then
            echo -e "\\nNot found any more version\\nJust exiting"
            exit 0
        fi

        echo -e "\\n Version test: $version\\n"
        linkGetVersionLinux="$linkGetVersion/$version/"
        wget "$linkGetVersionLinux" -O "${progName}-latest"

        if grep -q "linux" "${progName}-latest"; then
            wget "$linkGetVersion/$version/linux" -O "${progName}-latest"
            if grep -q "deb" "${progName}-latest"; then
                continue='1'
            else
                echo -e "\\t# The version \"$version\" don't have deb version yet\\n"
            fi
        else
            echo -e "\\t# The version \"$version\" don't have GNU/Linux version yet\\n"
        fi

        ((tailNumber++))
    done
    rm "${progName}-latest"

    installedVersion=$(find /var/log/packages/$progName-[0-9]* | rev | cut -d '-' -f3 | rev)
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

    ARCH=$(uname -m)
    if [ "$ARCH" != "x86_64" ]; then
        echo -e "\\nError: arch: $ARCH - This package is currently only available for 64bit.\\n"
        exit 1
    fi

    rm -r "$progName"
    mkdir "$progName"
    cd "$progName" || exit

    linkDl="$linkGetVersion/$version/linux"
    wget -c "$linkSlackbuilds150Prog"
    wget -c "$linkDl/${SRCNAM}_${version}_amd64.deb"

    if [ -e "opera.tar.gz" ] && [ -e "$SRCNAM"*".deb" ]; then
        rm -r $progName/
        tar zvxf "opera.tar.gz"
        mv "${SRCNAM}_"*".deb" "$progName"
    else
        echo -e "\\nError: files not found\\n"
        exit 1
    fi

    cd "$progName" || exit

    versionProg=$(find "${SRCNAM}_"*"deb" | cut -d '_' -f2)
    sed -i "s/VERSION:-.*/VERSION:-$versionProg}/g" $progName.SlackBuild
    sed -i "s/PKGTYPE:-tgz/PKGTYPE:-txz/g" $progName.SlackBuild
    sed -i "s/TAG:-_SBo/TAG:-_JB/g" $progName.SlackBuild

    ./"$progName.SlackBuild"

    cd ../../ || exit
    rm -r "$progName"

    mv /tmp/$progName-"$version"*txz .
    echo -e "File moved to: $(pwd)\\n"
fi
