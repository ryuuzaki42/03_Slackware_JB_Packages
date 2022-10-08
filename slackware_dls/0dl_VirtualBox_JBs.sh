#!/bin/bash
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
# Descrição: Script to download the last version VirtualBox
#
# Last update: 08/10/2022
#
set -eE
trap 'echo -e "\\n\\n${RED}Error at line $LINENO$NC - Command:\\n$RED$BASH_COMMAND\\n"' ERR

case "$(uname -m)" in
    i?86) archDL="x86" ;;
    x86_64) archDL="amd64" ;;
    *) archDL=$(uname -m) ;;
esac

progName="virtualbox" # last tested: "6.1.38"

linkGetVersion="https://www.virtualbox.org/wiki/Downloads"
wget "$linkGetVersion" -O "${progName}_latest"

version=$(grep "VirtualBox.* platform packages" ${progName}_latest | cut -d '>' -f4 | cut -d ' ' -f2)
rm "${progName}_latest"

downloadedVersion=$(find VirtualBox-* | head -n 1 | cut -d '-' -f2)
echo -e "\\n    Latest version: $version\nVersion downloaded: $downloadedVersion\\n"
if [ "$downloadedVersion" != '' ]; then
    if [ "$version" == "$downloadedVersion" ]; then
        echo -e "Version downloaded ($downloadedVersion) is equal to latest version ($version)"
        echo -n "Want continue? (y)es - (n)o (hit enter to no): "
        read -r continue

        if [ "$continue" != 'y' ]; then
            echo -e "\\nJust exiting\\n"
            exit 0
        fi
    fi
fi

mirrorDl="http://download.virtualbox.org/virtualbox/$version"
wget "$mirrorDl/MD5SUMS" -O MD5SUMS

runFileMd5=$(grep "VirtualBox-$version.*-Linux_$archDL.run" < MD5SUMS)
extpackFileMd5=$(grep "Oracle_VM_VirtualBox_Extension_Pack-$version.*vbox-extpack" < MD5SUMS | head -n 1)

runFile=$(echo "$runFileMd5" | cut -d '*' -f2)
extpackFile=$(echo "$extpackFileMd5" | cut -d '*' -f2)
rm MD5SUMS

mkdir "VirtualBox-${version}"
cd "VirtualBox-${version}" || exit

wget -c "$mirrorDl/$runFile"
wget -c "$mirrorDl/$extpackFile"
#wget -c "$mirrorDl/UserManual.pdf"

echo -e "\\nCheck md5sum files downloaded\\n"
tmpFile=$(mktemp)
echo "$runFileMd5" > "$tmpFile"
echo "$extpackFileMd5" >> "$tmpFile"

md5sum -c "$tmpFile"
rm "$tmpFile"
