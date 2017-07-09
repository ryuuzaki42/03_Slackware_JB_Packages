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
# Script: Create a txz from messengerfordesktop-version.rpm
#
# Last update: 08/07/2017
#
echo -e "\n# Create a txz from messengerfordesktop-version.rpm #\n"

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    progName="messengerfordesktop" # last tested: "2.0.9" - beta
    tag="2_JB"

    linkGetVersion="https://github.com/Aluxian/Messenger-for-Desktop/releases/"
    wget "$linkGetVersion" -O "${progName}-latest"

    version=$(cat $progName-latest | grep "Messenger-for-Desktop/releases/tag/v" | head -n 1 | cut -d'>' -f2 | sed 's/[^0-9,.]*//g')
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
    linkDl="https://github.com/Aluxian/Messenger-for-Desktop/releases/download"

    if [ -z "$ARCH" ]; then
        case "$(uname -m)" in
            i?86) ARCH="i386" ;;
            arm*) ARCH="arm" ;;
            *) ARCH=$(uname -m) ;;
        esac
    fi

    if [ "$ARCH" == "x86_64" ] || [ "$ARCH" == "i386" ]; then
        wget -c "$linkDl/v$version/${progName}-${version}-linux-${ARCH}.rpm"
    else
        echo -e "\nError: ARCH $ARCH not configured\n"
        exit 1
    fi

    mv "${progName}-${version}-linux-${ARCH}.rpm" "${progName}-${version}-${ARCH}-${tag}.rpm"

    rpm2txz -d -c -s -r "${progName}-${version}-${ARCH}-${tag}.rpm"

    rm "${progName}-${version}-${ARCH}-${tag}.rpm"
fi
