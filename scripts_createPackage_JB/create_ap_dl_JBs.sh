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
# Script: Script to build a Slackware package of create_ap
#
# Link: https://github.com/oblique/create_ap
#
# Last update: 12/12/2017
#
echo -e "\\n# Script to build a Slackware package of create_ap #\\n"

if [ "$USER" != "root" ]; then
    echo -e "\\nNeed to be superuser (root)\\nExiting\\n"
else
    progName="create_ap"
    versionNumber="0.4.6"
    arch="noArch"
    tag="1_JB"

    linkGetLastRealease="https://github.com/oblique/create_ap/releases"
    linkGetLastCommit="https://github.com/oblique/create_ap/commits/master"

    wget "$linkGetLastRealease" -O "${progName}-latest"
    versionNumber=$(grep "/oblique/create_ap/tree/" "${progName}-latest" | head -n 1 | cut -d 'v' -f2 | cut -d '"' -f1)
    rm "${progName}-latest"

    wget "$linkGetLastCommit" -O "${progName}-latest"
    versionCommit=$(grep "https://github.com/oblique/create_ap/commit/" "${progName}-latest" | head -n 1 | cut -d '/' -f7 | cut -d '"' -f1 | cut -c1-7)
    rm "${progName}-latest"

    version="${versionNumber}_git$versionCommit"
    echo "version: $version"

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

    git clone https://github.com/oblique/create_ap.git
    cd create_ap || exit

    folderName="${progName}-${version}-${arch}-${tag}"

    echo "folderName: $folderName"
    mkdir "../$folderName"

    make install DESTDIR="../$folderName"

    cd .. || exit
    rm -r create_ap

    cd "$folderName" || exit
    mkdir install/

    echo "# HOW TO EDIT THIS FILE:
# The \"handy ruler\" below makes it easier to edit a package description.
# Line up the first '|' above the ':' following the base package name, and
# the '|' on the right side marks the last column you can put a character in.
# You must make exactly 11 lines for the formatting to be correct.  It's also
# customary to leave one space after the ':' except on otherwise blank lines.

         |-----handy-ruler------------------------------------------------------|
create_ap: create_ap - this script creates a NATed or Bridged WiFi Access Point
create_ap:
create_ap: Features:
create_ap: Create an AP (Access Point) at any channel.
create_ap: Choose one of the following encryptions: WPA, WPA2, WPA/WPA2,
create_ap: Open (no encryption). Hide your SSID.
create_ap: Disable communication between clients (client isolation).
create_ap: IEEE 802.11n & 802.11ac support
create_ap: Can create an AP with the same interface you are getting your Internet
create_ap: Site: https://github.com/oblique/create_ap
create_ap:" > install/slack-desc

    /sbin/makepkg -l y -c n "$folderDest/$folderName.txz"

    cd .. || exit
    rm -r "$folderName"
fi
