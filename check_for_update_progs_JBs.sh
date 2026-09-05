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
# Last update: 05/09/2026
#
# Tip: Pass "win" as parameter to call the windowsPrograms
# Tip: Pass "all" as parameter to call programs updates
# Tip: Use FULL_INFO=1 ./check_for_update_progs_JBs.sh to show all info about the programs
#

# _lv => _local_version - last tested

    # GNU/Linux
#gittyup_lv="1.4.0" # Few updates
firefox_lv="155.0.1"
mangohud_lv="0.8.4"
masterpdfeditor_lv="5.9.99"
smplayer_lv="26.8.29"
virtualbox_lv="7.2.16"
tlp_lv="1.10.2"

    # AppImage
keepassxc_lv="2.7.12"
maestral_lv="1.9.6"
mkvtoolnix_lv="101.0"
opera_lv="135.0.5973.41"
opera_ffmpeg_codecs_lv="0.115.0"
qbittorrent_lv="5.2.3"
teams_for_linux_lv="2.20.0"
ventoy_lv="1.1.17"
zotero_lv="10.0.1"

    # Windows
winrar_lv="7.23"
hwmonitor_lv="1.67"
notepad_plus_plus_lv="8.9.8"
revouninstaller_lv="2.7.0"
sumatraPDFReader_lv="3.6.1"

# --------------------------------------------------------------------------- #

useColor(){ # Color
    RED='\e[1;31m'
    GREEN='\e[1;32m'
    NC='\033[0m' # reset/no color
    BLUE='\e[1;34m'
    CYAN='\e[1;36m'
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
    prog_name=$1
    link=$2
    command=$3
    local_version=$4

    echo -en "\n$BLUE$prog_name"

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

# GNU/Linux programs
masterpdfeditor(){
    link="https://code-industry.net/downloads/"
    command="grep -o 'Version .* now available for Linux' | cut -d ' ' -f2"

    checkVersion "MasterPDFEditor" "$link" "$command" "$masterpdfeditor_lv"
}

tlp(){
    link="https://github.com/linrunner/TLP/releases"
    command="grep '/linrunner/TLP/tree/' | grep -v 'beta' | head -n 1 | cut -d '\"' -f2 | cut -d '/' -f5"
    checkVersion "TLP" "$link" "$command" "$tlp_lv"
}

gittyup(){
    link="https://github.com/Murmele/Gittyup/releases/latest"
    command="grep '<title>Release ' | sed 's/.*Release //; s/ .*//'"

    checkVersion "Gittyup" "$link" "$command" "$gittyup_lv"
}

maestral(){
    link="https://github.com/samschott/maestral/tags"
    command="grep 'tags/v' | grep -v 'dev' | head -n 1 | sed 's/.*v//; s/.zip.*//'"

    checkVersion "Maestral" "$link" "$command" "$maestral_lv"
}

keepassxc(){
    link="https://github.com/keepassxreboot/keepassxc/releases/latest"
    command="grep 'Release ' | head -n1 | sed 's/.*Release //; s/ .*//'"

    checkVersion "KeePassXC" "$link" "$command" "$keepassxc_lv"
}

teams_for_linux(){
    link="https://github.com/IsmaelMartinez/teams-for-linux/releases"
    command="grep 'tree/v' | head -n1 | sed 's/.*tree\/v//; s/\".*//'"

    checkVersion "Teams-for-Linux" "$link" "$command" "$teams_for_linux_lv"
}

mangohud(){
    link="https://github.com/flightlessmango/MangoHud/releases/latest"
    command="grep '<title>Release' | sed 's/.*v//; s/ .*//' | sed 's/-/./'"

    checkVersion "MangoHud" "$link" "$command" "$mangohud_lv"
}

mkvtoolnix (){
    link="https://mkvtoolnix.download/source.html"
    command="grep 'sources/mkvtoolnix.* release' | sed 's/.*mkvtoolnix-//g;s/.tar.*//g'"

    checkVersion "MKVToolNix" "$link" "$command" "$mkvtoolnix_lv"
}

qbittorrent (){
    link="https://www.qbittorrent.org/download"
    command="grep 'Latest: v' | sed 's/.*Latest: v//g;s/<.*//g'"

    checkVersion "qBittorrent" "$link" "$command" "$qbittorrent_lv"
}

firefox(){
    #link="https://www.mozilla.org/firefox/notes/"
    #command="grep 'release-version' | sed 's/.*release-version\">//; s/<.*//'"

    link="https://www.mozilla.org/firefox/all/"
    command="grep 'latest-firefox' | sed 's/.*latest-firefox=\"//; s/\".*//'"

    checkVersion "Firefox" "$link" "$command" "$firefox_lv"
}

opera(){
    link="https://deb.opera.com/opera-stable/pool/non-free/o/opera-stable/"
    command="grep -o -P '(?<=>opera-stable_).*(?=_amd64.deb)'"

    checkVersion "Opera" "$link" "$command" "$opera_lv"
}

opera_ffmpeg_codecs(){
    #link="https://github.com/nwjs-ffmpeg-prebuilt/nwjs-ffmpeg-prebuilt/releases/latest"
    #command="grep '<title>Release ' | sed 's/.*Release //; s/ .*//' | cut -d ':' -f1"

    link="https://github.com/Ld-Hagen/nwjs-ffmpeg-prebuilt/releases/latest" # Mirror that works with GLIBC < 2.34
    command="grep '<title>Release '| sed 's/.*Release nwjs-ffmpeg-//; s/ .*//' | cut -d ':' -f1"

    checkVersion "Opera-ffmpeg-codecs" "$link" "$command" "$opera_ffmpeg_codecs_lv"
}

smplayer(){
    link="https://www.smplayer.info/downloads/"
    command="grep -o '\">smplayer.*tar.bz2' | cut -d '.' -f1-3 | cut -d '-' -f2"

    checkVersion "SMPlayer" "$link" "$command" "$smplayer_lv"
}

ventoy(){
    link="https://github.com/ventoy/Ventoy/releases/latest"
    command="grep '<title>Release Ventoy' | sed 's/.*Release Ventoy //; s/ .*//'"

    checkVersion "Ventoy" "$link" "$command" "$ventoy_lv"
}

virtualbox(){
    link="https://www.virtualbox.org/wiki/Downloads"
    command="grep 'VirtualBox.* platform packages' | sed 's/ .*VirtualBox //; s/ .*//'"

    checkVersion "VirtualBox" "$link" "$command" "$virtualbox_lv"
}

zotero(){
    #link="https://github.com/zotero/zotero/tags"
    #command="grep 'zotero/releases/tag' | head -n 1 | sed 's/.*tag\///; s/\".*//'"

    link="https://www.zotero.org/support/changelog"
    command="grep 'Changes in [0-9]' | head -n 1 | sed 's/.*in //g; s/ .*//'"

    checkVersion "Zotero" "$link" "$command" "$zotero_lv"
}

GNU_Linux_Programs(){
    echo -e "\n$RED# GNU/Linux$NC"

    masterpdfeditor
    firefox
    smplayer
    virtualbox

    if [ "$1" == "all" ]; then # if "all" call programs with fewer updates
        tlp
        #gittyup
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

# Windows programs
hwmonitor(){
    link="https://www.cpuid.com/softwares/hwmonitor.html"
    command="grep -o 'href.*hwmonitor_.*.exe' | head -n1 | grep -o '[0-9].[0-9][0-9]'"

    checkVersion "HWMonitor" "$link" "$command" "$hwmonitor_lv"
}

notepad_plus_plus(){
    link="https://notepad-plus-plus.org/downloads/"
    command="grep 'Current Version' | cut -d 'v' -f2 | cut -d '/' -f1"

    checkVersion "Notepad++" "$link" "$command" "$notepad_plus_plus_lv"
}

revouninstaller(){
    link="https://www.revouninstaller.com/version-history/"
    command="grep -o -E '> Version (.{4}|.{5}|.{6}) <' | head -n 1 | tr -d 'a-zA-Z : <>'"

    checkVersion "RevoUninstaller" "$link" "$command" "$revouninstaller_lv"
}

sumatraPDFReader(){
    link="https://www.sumatrapdfreader.org/download-free-pdf-viewer"
    command="grep -o 'SumatraPDF-.*-64-install.exe\"' | cut -d '-' -f2"

    checkVersion "SumatraPDF" "$link" "$command" "$sumatraPDFReader_lv"
}

winrar(){
    link="https://www.win-rar.com/latestnews.html"
    command="grep -o '>WinRAR [0-9].* Final' | head -n 1 | tr -d 'a-zA-Z <>'"

    checkVersion "WinRAR" "$link" "$command" "$winrar_lv"
}

windows_Programs(){
    echo -e "\n\n$RED# Windows$NC"

    hwmonitor
    notepad_plus_plus
    revouninstaller
    winrar

    if [ "$1" == "all" ]; then # if "all" call programs with fewer updates
        sumatraPDFReader
    fi
}

# Call to check version
GNU_Linux_Programs "$s1"

AppImage

if [ "$s1" == "win" ] || [ "$s1" == "all" ]; then # if "win" or "all" call the windowsPrograms
    windows_Programs "$s1"
fi

# Default function
default(){
    link=""
    command=""

    checkVersion "Prog_Name" "$link" "$command" "$prog_name_lv" # lv - local version
}

echo -e "\n"
