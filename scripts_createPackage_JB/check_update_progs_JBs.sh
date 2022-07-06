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
# Script: Script to check if some programs has one update
#
# Last update: 06/07/2022
#
set -e

## Color
useColor() {
    #BLACK='\e[1;30m'
    RED='\e[1;31m'
    GREEN='\e[1;32m'
    NC='\033[0m' # reset/no color
    BLUE='\e[1;34m'
    #PINK='\e[1;35m'
    CYAN='\e[1;36m'
    #WHITE='\e[1;37m'
}
useColor

## Usual functions
downloadHTML() {
    link=$1

    if [ "$link" == '' ]; then
        echo -e "\\n${RED}Error: The link: \"$link\" is not valid!$NC"
    else
        echo -e "$CYAN - wget -q $GREEN$link$CYAN -O a.html$NC"
        wget -q $link -O a.html
    fi
}

compareVersion(){
    version=$1
    installedVersion=$2

    if [ "$installedVersion" == '' ]; then
        installedVersion=$(find /var/log/packages/$progName* | rev | cut -d '-' -f3 | rev)
    fi

    if [ "$version" == "$installedVersion" ]; then
        echo -e "$BLUE   Latest version ($GREEN$version$BLUE) is ${GREEN}equal$BLUE to the installed$NC"
    else
        echo -en "\n$BLUE   Latest version ($GREEN$version$BLUE) is$RED not equal$BLUE to the installed ($GREEN$installedVersion$BLUE). "
        echo -en "Press enter to continue...$NC"
        read -r continue
    fi
}

checkVersion() {
    progName=$1
    link=$2
    command=$3
    installedVersion=$4

    echo -en "\\n$BLUE$progName"

    downloadHTML "$link"

    #set -x
    version=$(eval $command)
    #echo "version: \"$version\""

    rm a.html

    compareVersion "$version" "$installedVersion"
}

## GNU/Linux programs

MasterPDFEditor(){
    progName="MasterPDFEditor" # last tested: "5.8.70"
    link="https://code-industry.net/free-pdf-editor"
    command="grep -o 'http[^\"]*' a.html | grep \"x86.64.tar.gz\" | cut -d '-' -f5"

    checkVersion "$progName" "$link" "$command"
}

TLP(){
    progName="TLP" # last tested: "1.5.0"
    link="https://github.com/linrunner/TLP/releases/latest"
    command="grep \"Release TLP\" a.html | head -n1 | sed 's/.*Release TLP //; s/ .*//'"

    checkVersion "$progName" "$link" "$command"
}

authy(){
    progName="authy" # last tested: "2.2.0"
    link="https://builds.garudalinux.org/repos/chaotic-aur/x86_64"
    command="grep -o 'authy-[0-9].*sig' a.html | cut -d '-' -f2"

    checkVersion "$progName" "$link" "$command"
}

gitahead(){
    progName="gitahead"
    link="https://github.com/gitahead/gitahead/releases/latest"
    command="grep 'Release v' a.html | head -n1 | sed 's/.*Release v//; s/ .*//'"

    installedVersion="2.6.3"

    checkVersion "$progName" "$link" "$command" "$installedVersion"
}

maestral(){
    progName="maestral" # last tested: "1.6.3"
    link="https://github.com/samschott/maestral/releases/latest"
    command="grep 'Release v' a.html | head -n1 | sed 's/.*Release v//; s/ .*//'"

    checkVersion "$progName" "$link" "$command"
}

mkvtoolnix () {
    progName="mkvtoolnix" # last tested: "68.0.0"
    link="https://mkvtoolnix.download/index.html"
    command="grep -o 'Released v.*(' a.html | head -n1 | tr -d 'a-zA-Z ('"

    checkVersion "$progName" "$link" "$command"
}

mozilla-firefox(){
    progName="mozilla-firefox" # last tested: "102.0.1"
    link="https://www.mozilla.org/firefox/all"
    command="grep 'latest-firefox' a.html | sed 's/.*latest-firefox=\"//; s/\" .*//'"

    checkVersion "$progName" "$link" "$command"
}

opera-stable(){
    progName="opera-stable" # last tested: "88.0.4412.74"
    link="http://ftp.opera.com/ftp/pub/opera/desktop"
    #command=""

    echo -e "\\n$BLUE$progName - Checking for the last version to GNU/Linux (rpm)$NC"

    tailNumber='1'
    continue='0'
    while [ "$continue" == '0' ]; do
        echo -e "   ${CYAN}wget -q $GREEN$link$CYAN -O a.html$NC"
        wget -q "$link" -O a.html

        version=$(grep "href" a.html | grep -v "Index" | sort -V -t '.' | tail -n $tailNumber | head -n 1 | cut -d '"' -f2 | cut -d '/' -f1)
        if [ "$version" == '' ]; then
            echo -e "\\n   Not found any more version\\nJust exiting"
            exit 0
        fi

        echo -e "$BLUE      Version test: $version$CYAN - wget -q $GREEN$link/$version$CYAN -O a.html$NC"
        wget -q "$link/$version" -O a.html

        if grep -q "linux" a.html; then
            echo -e "         ${CYAN}wget -q $GREEN$link/$version/linux$CYAN -O a.html$NC"
            wget -q "$link/$version/linux" -O a.html

            if grep -q "rpm" a.html; then
                continue='1'
            else
                echo -e "            # The version \"$version\" don't have rpm version yet\\n"
            fi
        else
            echo -e "         # The version \"$version\" don't have GNU/Linux version yet\\n"
        fi

        ((tailNumber++))
    done

    compareVersion "$version"
}

opera-ffmpeg-codecs(){
    progName="opera-ffmpeg-codecs" # last tested: "0.66.0"
    link="https://github.com/nwjs-ffmpeg-prebuilt/nwjs-ffmpeg-prebuilt/releases/latest"
    command="grep \"Release \" a.html | head -n1 | sed 's/.*Release //; s/ .*//'"

    checkVersion "$progName" "$link" "$command"
}

smplayer(){
    progName="smplayer" # last tested: "22.2.0"
    link="https://www.smplayer.info/en/downloads"
    command="grep -o '/smplayer.*-x64.exe\"' a.html | cut -d '-' -f2"

    checkVersion "$progName" "$link" "$command"
}

teamviewer(){
    progName="teamviewer" # last tested: "15.31.5"
    link="https://www.teamviewer.com/en/download/linux"
    command="grep -o 'deb package .*' a.html | head -n1 | tr -d 'a-z <>/'"

    checkVersion "$progName" "$link" "$command"
}

ventoy(){
    progName="ventoy"
    link="https://github.com/ventoy/Ventoy/releases/latest"
    command="grep 'Release Ventoy' a.html | head -n1 | sed 's/.*Release Ventoy //; s/ .*//'"

    installedVersion="1.0.78"

    checkVersion "$progName" "$link" "$command" "$installedVersion"
}

virtualbox(){
    progName="virtualbox"
    link="https://www.virtualbox.org/wiki/Linux_Downloads"
    command="grep -o 'http.*run' a.html | cut -d '-' -f2-3"

    installedVersion="6.1.34-150636"

    checkVersion "$progName" "$link" "$command" "$installedVersion"
}

zotero(){
    progName="zotero" # last tested: "6.0.9"
    link="https://www.zotero.org/download/"
    command="grep 'linux-x86_64' a.html | sed 's/.*linux-x86_64//' | tr -d '\":}),'"

    checkVersion "$progName" "$link" "$command"
}

## GNU/Linux calls
GNULinuxPrograms(){
    MasterPDFEditor
    TLP
    authy
    gitahead
    maestral
    mkvtoolnix
    mozilla-firefox
    opera-stable
    opera-ffmpeg-codecs
    smplayer
    teamviewer
    ventoy
    virtualbox
    zotero
}

## Windows programs

hwmonitor(){
    progName="hwmonitor"
    link="https://www.cpuid.com/softwares/hwmonitor.html"
    command="grep -o 'href.*hwmonitor_.*.exe' a.html | head -n1 | grep -o \"[0-9].[0-9][0-9]\""

    installedVersion="1.46"

    checkVersion "$progName" "$link" "$command" "$installedVersion"
}

nettraffic(){
    progName="nettraffic"
    link="https://www.venea.net/web/downloads"
    command="grep -o '>Version: [0-9].*<' a.html | head -n1 | tr -d 'a-zA-Z <>:'"

    installedVersion="1.66.2"

    checkVersion "$progName" "$link" "$command" "$installedVersion"
}

notepad-plus-plus(){
    progName="notepad-plus-plus"
    link="https://notepad-plus-plus.org/downloads"
    command="grep \"Download Notepad\" a.html | head -n1 | cut -d 'v' -f2 | tr -d '\r'"

    installedVersion="8.4.2"

    checkVersion "$progName" "$link" "$command" "$installedVersion"
}

revouninstaller(){
    progName="revouninstaller"
    link="https://www.revouninstaller.com/products/revo-uninstaller-free"
    command="grep -o -E '>Version: (.{4}|.{5})<' a.html | tr -d 'a-zA-Z : <>'"

    installedVersion="2.3.9"

    checkVersion "$progName" "$link" "$command" "$installedVersion"
}

sumatraPDFReader(){
    progName="sumatraPDFReader"
    link="https://www.sumatrapdfreader.org/download-free-pdf-viewer"
    command="grep -o 'SumatraPDF-.*-64-install.exe\"' a.html | cut -d '-' -f2"
    installedVersion="3.4.6"

    checkVersion "$progName" "$link" "$command" "$installedVersion"
}

winrar(){
    progName="winrar"
    link="https://www.win-rar.com/start.html"
    command="grep -o '>WinRAR [0-9].*<' a.html | tr -d 'a-zA-Z <>'"

    installedVersion="6.11"

    checkVersion "$progName" "$link" "$command" "$installedVersion"
}

## Windows calls
windowsPrograms(){
    hwmonitor
    nettraffic
    notepad-plus-plus
    revouninstaller
    sumatraPDFReader
    winrar
}

## Call to check version
GNULinuxPrograms
windowsPrograms

# Default function
default(){
    progName="" # last tested: ""
    link=""
    command=""

    installedVersion=""

    checkVersion "$progName" "$link" "$command" "$installedVersion"
}
