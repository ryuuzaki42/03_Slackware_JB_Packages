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
# Last update: 23/08/2023
#
# Tip: Pass "win" as parameter to call the windowsPrograms
# Tip: Pass "all" as parameter to call programs updates
# Tip: Use FULL_INFO=1 ./check_for_update_progs_JBs.sh to show all info about the programs
#
FULL_INFO=${FULL_INFO-0} # 1 to show all info or 0 to more clean output

useColor(){ # Color
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

s1=$1 # To check if is win or all

echo_FULL_INFO(){
    if [ "$FULL_INFO" == 1 ]; then
        echo -e "$1"
    fi
}

# Usual functions
compareVersion(){
    version=$1
    local_version=$2
    link=$3

    if [ "$local_version" == '' ]; then
        local_version=$(find /var/log/packages/"$progName"-[0-9]* 2> /dev/null | rev | cut -d '-' -f3 | rev)
    fi

    if [ "$version" == "$local_version" ]; then
        if [ "$FULL_INFO" == 1 ]; then
            echo -e "$BLUE   Online version ($GREEN$version$BLUE) is ${GREEN}equal$BLUE to Local version$NC"
        else
            echo -en "$GREEN $version$NC"
        fi
    else
        if [ "$FULL_INFO" == 0 ]; then
            echo -en "$CYAN - wget -q -O - $GREEN$link$NC"
        fi

        echo -e "\n$BLUE Online: $GREEN\"$version\"$NC\n $BLUE Local: $RED\"$local_version\"$NC"
        #echo -en " Press enter to continue...$NC"; read -r continue
    fi
}

checkVersion(){
    progName=$1
    link=$2
    command=$3
    local_version=$4

    echo -en "\n$BLUE$progName"

#     if [ "$link" == '' ]; then
#         echo -e "\n${RED}Error: The link: \"$link\" is not valid!$NC"
#     else
        echo_FULL_INFO "$CYAN - wget -q -O - $GREEN$link$NC"
        web_site=$(wget -q -O - "$link")
        #echo "$web_site"
#     fi

    #set -x
    version=$(echo "$web_site" | eval "$command")
    #echo "version: \"$version\""
    #set +x

    compareVersion "$version" "$local_version" "$link"
}

## GNU/Linux programs
MasterPDFEditor(){
    progName="MasterPDFEditor" # last tested: "5.9.60"
    link="https://code-industry.net/downloads"
    command="grep -o 'Version .* now available for Linux' | cut -d ' ' -f2"

    checkVersion "$progName" "$link" "$command"
}

TLP(){
    progName="TLP" # last tested: "1.5.0"
    link="https://github.com/linrunner/TLP/releases/latest"
    command="grep \"Release TLP\" | head -n1 | sed 's/.*Release TLP //; s/ .*//'"

    checkVersion "$progName" "$link" "$command"
}

authy(){
    progName="authy" # last tested: "2.4.0"
    #link="https://builds.garudalinux.org/repos/chaotic-aur/x86_64"
    #command="grep -o 'authy-[0-9].*sig' | cut -d '-' -f2"

    link="https://aur.archlinux.org/packages/authy"
    command="grep 'Package Details' | sed 's/.*authy //g' | cut -d '-' -f1"

    checkVersion "$progName" "$link" "$command"
}

gitahead(){
    progName="gitahead"
    link="https://github.com/gitahead/gitahead/releases/latest"
    command="grep 'Release v' | head -n1 | sed 's/.*Release v//; s/ .*//'"

    local_version="2.6.3"
    checkVersion "$progName" "$link" "$command" "$local_version"
}

maestral(){
    progName="maestral" # last tested: "1.8.0"
    #link="https://github.com/samschott/maestral/releases/latest"
    #command="grep 'Release v' | head -n1 | sed 's/.*Release v//; s/ .*//'"

    link="https://pypi.org/project/maestral"
    command="grep 'release__card' | grep -v 'dev' | head -n 1 | sed 's/.*maestral\///; s/\/\">//'"

    checkVersion "$progName" "$link" "$command"
}

mangohud(){
    progName="mangohud" # last tested: "0.6.9.1"
    link="https://github.com/flightlessmango/MangoHud/releases/latest"
    command="grep 'href=.*/tree/v.*' | head -n 1 | sed 's/.*tree\/v//' | cut -d '\"' -f1 | sed 's/-/./'"

    checkVersion "$progName" "$link" "$command"
}

mkvtoolnix (){
    progName="mkvtoolnix"
    link="https://mkvtoolnix.download/source.html"
    command="grep 'sources/mkvtoolnix' | head -n 1 | sed 's/.*mkvtoolnix-//g;s/.tar.*//g'"

    local_version="79.0"
    checkVersion "$progName" "$link" "$command" "$local_version"
}

mozilla-firefox(){
    progName="mozilla-firefox" # last tested: "116.0.3"
    #link="https://www.mozilla.org/firefox/notes/"
    #command="grep 'release-version' | sed 's/.*release-version\">//; s/<.*//'"

    link="https://www.mozilla.org/firefox/all/"
    command="grep 'latest-firefox' | sed 's/.*latest-firefox=\"//; s/\" .*//'"

    checkVersion "$progName" "$link" "$command"
}

opera(){
    progName="opera"
    link="https://deb.opera.com/opera-stable/pool/non-free/o/opera-stable/"
    command="grep 'deb' | grep -o -P '(?<=>opera-stable_).*(?=_amd64.deb)'"

    local_version="102.0.4880.16"
    checkVersion "$progName" "$link" "$command" "$local_version"
}

opera-ffmpeg-codecs(){
    progName="opera-ffmpeg-codecs" # last tested:
    link="https://github.com/nwjs-ffmpeg-prebuilt/nwjs-ffmpeg-prebuilt/releases/latest"
    command="grep \"Release \" | head -n1 | sed 's/.*Release //; s/ .*//'"

    local_version="0.79.0"
    checkVersion "$progName" "$link" "$command" "$local_version"
}

smplayer(){
    progName="smplayer" # last tested: "23.6.0"
    link="https://www.smplayer.info/downloads"
    command="grep -o '\">smplayer.*tar.bz2' | cut -d '.' -f1-3 | cut -d '-' -f2"

    checkVersion "$progName" "$link" "$command"
}

teamviewer(){
    progName="teamviewer" # last tested: "15.45.3"
    link="https://www.teamviewer.com/en/download/linux"
    command="grep 'Current version' | tr -d 'Ca-z :<\->/'"

    checkVersion "$progName" "$link" "$command"
}

ventoy(){
    progName="ventoy"
    link="https://github.com/ventoy/Ventoy/releases/latest"
    command="grep 'Release Ventoy' | head -n 1 | sed 's/.*Release Ventoy //; s/ .*//'"

    local_version="1.0.95"
    checkVersion "$progName" "$link" "$command" "$local_version"
}

virtualbox(){
    progName="virtualbox"
    link="https://www.virtualbox.org/wiki/Downloads"
    command="grep 'VirtualBox.* platform packages' | cut -d '>' -f4 | cut -d ' ' -f2"

    local_version="7.0.10"
    checkVersion "$progName" "$link" "$command" "$local_version"
}

zotero(){
    progName="zotero" # last tested: "6.0.26"
    link="https://www.zotero.org/download"
    command="grep 'linux-x86_64' | sed 's/.*linux-x86_64//' | tr -d '\":}),'"

    checkVersion "$progName" "$link" "$command"
}

GNULinuxPrograms(){
    echo -e "\n$RED# GNU/Linux$NC"

    MasterPDFEditor
    authy
    maestral
    mozilla-firefox
    smplayer
    teamviewer
    virtualbox
    zotero

    if [ "$1" == "all" ]; then # if "all" call programs with fewer updates
        TLP
        gitahead # GitAhead is no longer under active development
        mangohud
    fi
}

AppImage(){
    echo -e "\n\n$RED# AppImage$NC"

    mkvtoolnix
    opera
    opera-ffmpeg-codecs
    ventoy
}

# Windows programs
hwmonitor(){
    progName="hwmonitor"
    link="https://www.cpuid.com/softwares/hwmonitor.html"
    command="grep -o 'href.*hwmonitor_.*.exe' | head -n1 | grep -o \"[0-9].[0-9][0-9]\""

    local_version="1.51"
    checkVersion "$progName" "$link" "$command" "$local_version"
}

nettraffic(){
    progName="nettraffic"
    link="https://www.venea.net/web/downloads"
    command="grep -o '>Version: [0-9].*<' | head -n1 | tr -d 'a-zA-Z <>:'"

    local_version="1.68.2"
    checkVersion "$progName" "$link" "$command" "$local_version"
}

notepad-plus-plus(){
    progName="notepad-plus-plus"
    link="https://notepad-plus-plus.org/downloads"
    command="grep 'Current Version' | cut -d 'v' -f2 | cut -d '/' -f1"

    local_version="8.5.6"
    checkVersion "$progName" "$link" "$command" "$local_version"
}

revouninstaller(){
    progName="revouninstaller"
    link="https://www.revouninstaller.com/products/revo-uninstaller-free"
    command="grep -o -E '>Version: (.{4}|.{5}|.{6})<' | tr -d 'a-zA-Z : <>'"

    local_version="2.4.5"
    checkVersion "$progName" "$link" "$command" "$local_version"
}

sumatraPDFReader(){
    progName="sumatraPDFReader"
    link="https://www.sumatrapdfreader.org/download-free-pdf-viewer"
    command="grep -o 'SumatraPDF-.*-64-install.exe\"' | cut -d '-' -f2"

    local_version="3.4.6"
    checkVersion "$progName" "$link" "$command" "$local_version"
}

winrar(){
    progName="winrar"
    link="https://www.win-rar.com/start.html"
    command="grep -o '>WinRAR [0-9].*<' | tr -d 'a-zA-Z <>'"

    local_version="6.23"
    checkVersion "$progName" "$link" "$command" "$local_version"
}

windowsPrograms(){
    echo -e "\n\n$RED# Windows$NC"

    hwmonitor
    notepad-plus-plus
    revouninstaller
    winrar

    if [ "$1" == "all" ]; then # if "all" call programs with fewer updates
        nettraffic
        sumatraPDFReader
    fi
}

# Call to check version
GNULinuxPrograms "$s1"

AppImage

if [ "$s1" == "win" ] || [ "$s1" == "all" ]; then # if "win" or "all" call the windowsPrograms
    windowsPrograms "$s1"
fi

# Default function
default(){
    progName="" # last tested: ""
    link=""
    command=""

    local_version=""

    checkVersion "$progName" "$link" "$command" "$local_version"
}

echo -e "\n"
