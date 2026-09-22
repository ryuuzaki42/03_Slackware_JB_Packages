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
# Script: Create a txz from atom-version.rpm
#
# Last update: 19/22/2022
#
echo -e "\\n# Create a txz from atom-version.rpm #\\n"

if [ "$USER" != "root" ]; then
    echo -e "\\nNeed to be superuser (root)\\nExiting\\n"
else
    if [ -z "$ARCH" ]; then
        case "$(uname -m)" in
            i?86) ARCH="i386" ;;
            arm*) ARCH="arm" ;;
            *) ARCH=$(uname -m) ;;
        esac
    fi

    if [ "$ARCH" != "x86_64" ]; then
        echo "# Only 64 bits, without 32 bits precompiled package in the $progName repository/release"
        exit 1
    fi

    progName="atom" # last tested: "1.63.1" # This is the last release of Atom
    tag="1_JB"

    linkGetVersion="https://github.com/atom/atom/releases/latest"
    wget --compress=none "$linkGetVersion" -O "${progName}-latest"

    version=$(grep "Release.*[[:digit:]].*" < "${progName}-latest" | sed 's/[^0-9,.]*//g' | head -n 1)
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

    linkDl="https://github.com/atom/atom/releases/download"
    wget -c "$linkDl/v$version/${progName}.${ARCH}.rpm"

    mv "${progName}.${ARCH}.rpm" "${progName}-${version}-${ARCH}-${tag}.rpm"

    rpm2txz -d -c -r "${progName}-${version}-${ARCH}-${tag}.rpm"

    rm "${progName}-${version}-${ARCH}-${tag}.rpm"
fi
