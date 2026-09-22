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
# COMERCIABILIDADE ou ADEQUAÇÃO A UM PROPÓSITO ESPECÍFICO.
# Consulte a Licença Pública Geral do GNU para mais detalhes.
#
# Description: Script to download the latest version of VirtualBox
#
# Last update: 15/09/2026
#

case "$(uname -m)" in
    i?86) archDL="x86" ;;
    x86_64) archDL="amd64" ;;
    *) archDL=$(uname -m) ;;
esac

progName="virtualbox" # last tested: "7.2.18"

linkGetVersion="https://www.virtualbox.org/wiki/Downloads"
wget "$linkGetVersion" -O "${progName}_latest"

version=$(grep "VirtualBox.* platform packages" ${progName}_latest | sed 's/.*VirtualBox //; s/ .*//')
rm "${progName}_latest"

downloadedVersion=$(find VirtualBox-* | head -n 1 | cut -d '-' -f2)
echo -e "\n    Latest version: $version\nVersion downloaded: $downloadedVersion\n"
if [ "$downloadedVersion" != '' ]; then
    if [ "$version" == "$downloadedVersion" ]; then
        echo -e "Version downloaded ($downloadedVersion) is equal to latest version ($version)"
        echo -n "Want continue? (y)es - (n)o (hit enter to no): "
        read -r continue

        if [ "$continue" != 'y' ]; then
            echo -e "\nJust exiting\n"
            exit 0
        fi
    fi
fi

mirrorDl="http://download.virtualbox.org/virtualbox/$version"
wget "$mirrorDl/MD5SUMS" -O MD5SUMS

runFileMd5=$(grep "VirtualBox-$version.*-Linux_$archDL.run" < MD5SUMS)
extpackFileMd5=$(grep "Oracle_VirtualBox_Extension_Pack-.*vbox-extpack" < MD5SUMS | head -n 1)

runFile=$(echo "$runFileMd5" | cut -d '*' -f2)
extpackFile=$(echo "$extpackFileMd5" | cut -d '*' -f2)
rm MD5SUMS

mkdir "VirtualBox-${version}"
cd "VirtualBox-${version}/" || exit

wget -c "$mirrorDl/$runFile"
wget -c "$mirrorDl/$extpackFile"
#wget -c "$mirrorDl/UserManual.pdf"

echo -e "\nCheck md5sum files"
tmpFile=$(mktemp)
echo "$runFileMd5" > "$tmpFile"
echo "$extpackFileMd5" >> "$tmpFile"
md5sum -c "$tmpFile"
rm "$tmpFile"

chmod +x VirtualBox-"$version"-*-Linux_"$archDL".run
echo
