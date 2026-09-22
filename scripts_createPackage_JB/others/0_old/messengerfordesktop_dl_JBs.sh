#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# me envie um e-mail. Ficarei Grato!
# e-mail: joao42lbatista@gmail.com
#
# Este programa é um software livre: você pode redistribuí-lo e/ou
# modificá-lo sob os termos da Licença Pública Geral GNU (GPL)
# conforme publicada pela Free Software Foundation, tanto a versão 3
# da licença, como (a seu critério) qualquer versão posterior.
#
# Este programa é distribuído na esperança de que seja útil,
# mas SEM NENHUMA GARANTIA; nem mesmo a garantia implícita de
# COMERCIABILIDADE ou ADEQUAÇÃO A UM PROPÓSITO ESPECÍFICO. Consulte a
# Licença Pública Geral do GNU para mais detalhes.
#
# Script: Create a txz from messengerfordesktop-version.rpm
#
# Last update: 19/12/2022
#
echo -e "\\n# Create a txz from messengerfordesktop-version.rpm #\\n"

if [ "$USER" != "root" ]; then
    echo -e "\\nNeed to be superuser (root)\\nExiting\\n"
else
    progName="messengerfordesktop" # last tested: "2.0.9" - beta # This is the last release of messengerfordesktop
    tag="2_JB"

    linkGetVersion="https://github.com/Aluxian/Messenger-for-Desktop/releases/"
    wget --compress=none "$linkGetVersion" -O "${progName}-latest"

    version=$(grep "Messenger-for-Desktop/releases/tag/v" $progName-latest | head -n 1 | cut -d'>' -f2 | sed 's/[^0-9,.]*//g')
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
        echo -e "\\nError: ARCH $ARCH not configured\\n"
        exit 1
    fi

    mv "${progName}-${version}-linux-${ARCH}.rpm" "${progName}-${version}-${ARCH}-${tag}.rpm"

    rpm2txz -d -c -s -r "${progName}-${version}-${ARCH}-${tag}.rpm"

    rm "${progName}-${version}-${ARCH}-${tag}.rpm"
fi
