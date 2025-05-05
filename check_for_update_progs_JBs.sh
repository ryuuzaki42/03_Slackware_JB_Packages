#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# me envie um e-mail. Ficarei Grato!
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
# Last update: 05/05/2025
#
# Tip: Pass "win" as parameter to call the windowsPrograms
# Tip: Pass "all" as parameter to call programs updates
# Tip: Use FULL_INFO=1 ./check_for_update_progs_JBs.sh to show all info about the programs
#

## _lv => _local_version - last tested

    ## GNU/Linux
MasterPDFEditor_lv="5.9.61"
TLP_lv="1.8.0"
#gitahead_lv="2.6.3"
gittyup_lv="1.4.0"
mangohud_lv="0.8.1"
mozilla_firefox_lv="138.0.1"
smplayer_lv="24.5.0"
teamviewer_lv="15.64.3"
virtualbox_lv="7.1.8"

    ## AppImage
maestral_lv="1.9.4"
mkvtoolnix_lv="92.0"
opera_lv="118.0.5461.60"
opera_ffmpeg_codecs_lv="0.99.0"
ventoy_lv="1.1.05"
zotero_lv="7.0.15"
keepassxc_lv="2.7.10"
teams_for_linux_lv="2.0.11"
qbittorrent_lv="5.1.0"

    ## Windows
WinRAR_lv="7.11"
hwmonitor_lv="1.57"
nettraffic_lv="1.71.0"
notepad_plus_plus_lv="8.8.1"
revouninstaller_lv="2.5.8"
sumatraPDFReader_lv="3.5.2"

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

FULL_INFO=${FULL_INFO-0} # 1 to show all info or 0 to more clean output
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

#    if [ "$local_version" == '' ]; then
#        local_version=$(find /var/log/packages/"$progName"-[0-9]* 2> /dev/null | rev | cut -d '-' -f3 | rev)
#    fi

    if [ "$version" == "$local_version" ]; then
        if [ "$FULL_INFO" == 1 ]; then
            echo -e "$BLUE  Online version ($GREEN$version$BLUE) is ${GREEN}equal$BLUE to Local version$NC"
        else
            echo -en "$GREEN $version$NC"
        fi
    else
        if [ "$FULL_INFO" == 0 ]; then
            echo -en "$CYAN - wget -q -O - $GREEN$link$NC"
        fi

        echo -e "\n$BLUE Online: $GREEN$version$NC\n $BLUE Local: $RED$local_version$NC"
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
    progName="MasterPDFEditor"
    link="https://code-industry.net/downloads/"
    command="grep -o 'Version .* now available for Linux' | cut -d ' ' -f2"

    checkVersion "$progName" "$link" "$command" "$MasterPDFEditor_lv"
}

TLP(){
    progName="TLP"
    #link="https://github.com/linrunner/TLP/releases/latest"
    #command="grep '<title>Release ' | sed 's/.*Release //; s/ .*//'"

    link="https://github.com/linrunner/TLP/releases"
    command="grep '/linrunner/TLP/tree/' | grep -v 'beta' | head -n 1 | cut -d '\"' -f2 | cut -d '/' -f5"
    checkVersion "$progName" "$link" "$command" "$TLP_lv"
}

gitahead(){
    progName="GitAhead"
    link="https://github.com/gitahead/gitahead/releases/latest"
    command="grep '<title>Release v' | sed 's/.*Release v//; s/ .*//'"

    checkVersion "$progName" "$link" "$command" "$gitahead_lv"
}

gittyup(){
    progName="Gittyup"
    link="https://github.com/Murmele/Gittyup/releases/latest"
    command="grep '<title>Release ' | sed 's/.*Release //; s/ .*//'"

    checkVersion "$progName" "$link" "$command" "$gittyup_lv"
}

maestral(){
    progName="Maestral"
    link="https://github.com/samschott/maestral/releases/latest"
    command="grep 'Release v' | head -n1 | sed 's/.*Release v//; s/ .*//'"

    #link="https://pypi.org/project/maestral"
    #command="grep 'release__card' | grep -v 'dev' | head -n 1 | sed 's/.*maestral\///; s/\/\">//'"

    checkVersion "$progName" "$link" "$command" "$maestral_lv"
}

keepassxc(){
    progName="KeePassXC"
    link="https://github.com/keepassxreboot/keepassxc/releases/latest"
    command="grep 'Release ' | head -n1 | sed 's/.*Release //; s/ .*//'"

    checkVersion "$progName" "$link" "$command" "$keepassxc_lv"
}

teams_for_linux(){
    progName="teams-for-linux"
    link="https://github.com/IsmaelMartinez/teams-for-linux/releases"
    command="grep 'tree/v' | head -n1 | sed 's/.*tree\/v//; s/\".*//'"

    checkVersion "$progName" "$link" "$command" "$teams_for_linux_lv"
}

mangohud(){
    progName="MangoHud"
    link="https://github.com/flightlessmango/MangoHud/releases/latest"
    command="grep '<title>Release' | sed 's/.*Version //; s/ .*//' | sed 's/-/./'"

    checkVersion "$progName" "$link" "$command" "$mangohud_lv"
}

mkvtoolnix (){
    progName="MKVToolNix"
    link="https://mkvtoolnix.download/source.html"
    command="grep 'sources/mkvtoolnix.* release' | sed 's/.*mkvtoolnix-//g;s/.tar.*//g'"

    checkVersion "$progName" "$link" "$command" "$mkvtoolnix_lv"
}

qbittorrent (){
    progName="qBittorrent"
    link="https://www.qbittorrent.org/download"
    command="grep 'Latest: v' | sed 's/.*Latest: v//g;s/<.*//g'"

    checkVersion "$progName" "$link" "$command" "$qbittorrent_lv"
}

mozilla_firefox(){
    progName="Mozilla-Firefox"
    #link="https://www.mozilla.org/firefox/notes/"
    #command="grep 'release-version' | sed 's/.*release-version\">//; s/<.*//'"

    link="https://www.mozilla.org/firefox/all/"
    command="grep 'latest-firefox' | sed 's/.*latest-firefox=\"//; s/\" .*//'"

    checkVersion "$progName" "$link" "$command" "$mozilla_firefox_lv"
}

opera(){
    progName="Opera"
    link="https://deb.opera.com/opera-stable/pool/non-free/o/opera-stable/"
    command="grep 'deb' | grep -o -P '(?<=>opera-stable_).*(?=_amd64.deb)'"

    checkVersion "$progName" "$link" "$command" "$opera_lv"
}

opera_ffmpeg_codecs(){
    progName="Opera-ffmpeg-codecs"
    link="https://github.com/nwjs-ffmpeg-prebuilt/nwjs-ffmpeg-prebuilt/releases/latest"
    command="grep '<title>Release ' | sed 's/.*Release //; s/ .*//' | cut -d ':' -f1"

    checkVersion "$progName" "$link" "$command" "$opera_ffmpeg_codecs_lv"
}

smplayer(){
    progName="SMPlayer"
    link="https://www.smplayer.info/downloads/"
    command="grep -o '\">smplayer.*tar.bz2' | cut -d '.' -f1-3 | cut -d '-' -f2"

    checkVersion "$progName" "$link" "$command" "$smplayer_lv"
}

teamviewer(){
    progName="TeamViewer"
    link="https://www.teamviewer.com/en/download/portal/linux/"
    command="grep 'Current version' | tr -d 'Ca-z :<\->/'"

    checkVersion "$progName" "$link" "$command" "$teamviewer_lv"
}

ventoy(){
    progName="Ventoy"
    link="https://github.com/ventoy/Ventoy/releases/latest"
    command="grep '<title>Release Ventoy' | sed 's/.*Release Ventoy //; s/ .*//'"

    checkVersion "$progName" "$link" "$command" "$ventoy_lv"
}

virtualbox(){
    progName="VirtualBox"
    link="https://www.virtualbox.org/wiki/Downloads"
    command="grep 'VirtualBox.* platform packages' | sed 's/ .*VirtualBox //; s/ .*//'"

    checkVersion "$progName" "$link" "$command" "$virtualbox_lv"
}

zotero(){
    progName="Zotero"
    link="https://github.com/zotero/zotero/tags"
    command="grep 'zotero/releases/tag' | head -n 1 | sed 's/.*tag\///; s/\".*//'"

    checkVersion "$progName" "$link" "$command" "$zotero_lv"
}

GNULinuxPrograms(){
    echo -e "\n$RED# GNU/Linux$NC"

    MasterPDFEditor
    mozilla_firefox
    smplayer
    teamviewer
    virtualbox

    if [ "$1" == "all" ]; then # if "all" call programs with fewer updates
        TLP
        #gitahead # GitAhead is no longer under active development
        gittyup
        mangohud
    fi
}

AppImage(){
    echo -e "\n\n$RED# AppImage$NC"

    maestral
    mkvtoolnix
    opera
    opera_ffmpeg_codecs
    ventoy
    zotero
    keepassxc
    teams_for_linux
    qbittorrent
}

## Windows programs
hwmonitor(){
    progName="HWMonitor"
    link="https://www.cpuid.com/softwares/hwmonitor.html"
    command="grep -o 'href.*hwmonitor_.*.exe' | head -n1 | grep -o '[0-9].[0-9][0-9]'"

    checkVersion "$progName" "$link" "$command" "$hwmonitor_lv"
}

nettraffic(){
    progName="NetTraffic"
    link="https://www.venea.net/web/downloads"
    command="grep -o '>Version: [0-9].*<' | head -n1 | tr -d 'a-zA-Z <>:'"

    checkVersion "$progName" "$link" "$command" "$nettraffic_lv"
}

notepad_plus_plus(){
    progName="Notepad++"
    link="https://notepad-plus-plus.org/downloads/"
    command="grep 'Current Version' | cut -d 'v' -f2 | cut -d '/' -f1"

    checkVersion "$progName" "$link" "$command" "$notepad_plus_plus_lv"
}

revouninstaller(){
    progName="RevoUninstaller"
    link="https://www.revouninstaller.com/version-history/"
    command="grep -o -E '>version (.{4}|.{5}|.{6})<' | head -n 1 | tr -d 'a-zA-Z : <>'"

    checkVersion "$progName" "$link" "$command" "$revouninstaller_lv"
}

sumatraPDFReader(){
    progName="SumatraPDF"
    link="https://www.sumatrapdfreader.org/download-free-pdf-viewer"
    command="grep -o 'SumatraPDF-.*-64-install.exe\"' | cut -d '-' -f2"

    checkVersion "$progName" "$link" "$command" "$sumatraPDFReader_lv"
}

WinRAR(){
    progName="WinRAR"
    link="https://www.win-rar.com/start.html"
    command="grep -o '>WinRAR [0-9].*<' | tr -d 'a-zA-Z <>'"

    checkVersion "$progName" "$link" "$command" "$WinRAR_lv"
}

windowsPrograms(){
    echo -e "\n\n$RED# Windows$NC"

    hwmonitor
    notepad_plus_plus
    revouninstaller
    WinRAR

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

#   local_version=""
    checkVersion "$progName" "$link" "$command" "$local_version"
}

echo -e "\n"
