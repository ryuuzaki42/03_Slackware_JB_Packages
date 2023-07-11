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
# Last update: 11/07/2023
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
    TEXT=$1

    if [ "$FULL_INFO" == 1 ]; then
        echo -e "$TEXT"
    fi
}

# Usual functions
downloadHTML(){
    link=$1

    if [ "$link" == '' ]; then
        echo -e "\n${RED}Error: The link: \"$link\" is not valid!$NC"
    else
        echo_FULL_INFO "$CYAN - wget -q $GREEN$link$CYAN -O a.html$NC"
        wget -q "$link" -O a.html
    fi
}

compareVersion(){
    version=$1
    installedVersion=$2
    link=$3

    if [ "$installedVersion" == '' ]; then
        installedVersion=$(find /var/log/packages/"$progName"-[0-9]* 2> /dev/null | rev | cut -d '-' -f3 | rev)
    fi

    if [ "$version" == "$installedVersion" ]; then
        if [ "$FULL_INFO" == 1 ]; then
            echo -e "$BLUE   Latest version ($GREEN$version$BLUE) is ${GREEN}equal$BLUE to the installed$NC"
        else
            echo -en "$GREEN $version$NC"
        fi
    else
        if [ "$FULL_INFO" == 0 ]; then
            echo -en "$CYAN - wget -q $GREEN$link$CYAN -O a.html$NC"
        fi

        echo -en "\n$BLUE   Latest version ($GREEN$version$BLUE) is$RED not equal$BLUE to the installed ($GREEN$installedVersion$BLUE). "
        echo -en "Press enter to continue...$NC"
        read -r continue
    fi
}

checkVersion(){
    progName=$1
    link=$2
    command=$3
    installedVersion=$4

    echo -en "\n$BLUE$progName"

    downloadHTML "$link"

    #set -x
    version=$(eval "$command")
    #echo "version: \"$version\""
    #set +x

    rm a.html

    compareVersion "$version" "$installedVersion" "$link"
}

## GNU/Linux programs
MasterPDFEditor(){
    progName="MasterPDFEditor" # last tested: "5.9.50"
    link="https://code-industry.net/downloads"
    command="grep -o 'Version .* now available for Linux' a.html | cut -d ' ' -f2"

    checkVersion "$progName" "$link" "$command"
}

TLP(){
    progName="TLP" # last tested: "1.5.0"
    link="https://github.com/linrunner/TLP/releases/latest"
    command="grep \"Release TLP\" a.html | head -n1 | sed 's/.*Release TLP //; s/ .*//'"

    checkVersion "$progName" "$link" "$command"
}

authy(){
    progName="authy" # last tested: "2.3.0"
    #link="https://builds.garudalinux.org/repos/chaotic-aur/x86_64"
    #command="grep -o 'authy-[0-9].*sig' a.html | cut -d '-' -f2"

    link="https://aur.archlinux.org/packages/authy"
    command="grep 'Package Details' a.html | sed 's/.*authy //g' | cut -d '-' -f1"

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
    progName="maestral" # last tested: "1.7.3"
    #link="https://github.com/samschott/maestral/releases/latest"
    #command="grep 'Release v' a.html | head -n1 | sed 's/.*Release v//; s/ .*//'"

    link="https://pypi.org/project/maestral"
    command="grep 'release__card' a.html | grep -v 'dev' | head -n 1 | sed 's/.*maestral\///; s/\/\">//'"

    checkVersion "$progName" "$link" "$command"
}

mangohud(){
    progName="mangohud" # last tested: "0.6.9.1"
    link="https://github.com/flightlessmango/MangoHud/releases/latest"
    command="grep 'href=.*/tree/v.*' a.html | head -n 1 | sed 's/.*tree\/v//' | cut -d '\"' -f1 | sed 's/-/./'"

    checkVersion "$progName" "$link" "$command"
}

mkvtoolnix (){
    progName="mkvtoolnix"
    link="https://mkvtoolnix.download/source.html"
    command="grep 'sources/mkvtoolnix' a.html | head -n 1 | sed 's/.*mkvtoolnix-//g;s/.tar.*//g'"

    installedVersion="78.0"

    checkVersion "$progName" "$link" "$command" "$installedVersion"
}

mozilla-firefox(){
    progName="mozilla-firefox" # last tested: "115.0.1"
    #link="https://www.mozilla.org/firefox/notes/"
    #command="grep 'release-version' a.html | sed 's/.*release-version\">//; s/<.*//'"

    link="https://www.mozilla.org/firefox/all/"
    command="grep 'latest-firefox' a.html | sed 's/.*latest-firefox=\"//; s/\" .*//'"

    checkVersion "$progName" "$link" "$command"
}

opera(){
    progName="opera" # last tested: "100.0.4815.47"
    link="http://ftp.opera.com/ftp/pub/opera/desktop"
    #command=""

    echo -en "\n$BLUE$progName"
    echo_FULL_INFO " - Checking for the last version to GNU/Linux (deb)$NC"

    tailNumber=1
    continue=0
    while [ "$continue" == 0 ]; do
        echo_FULL_INFO "   ${CYAN}wget -q $GREEN$link$CYAN -O a.html$NC"
        wget -q "$link" -O a.html

        version=$(grep "href" a.html | grep -v "Index" | sort -V -t '.' | tail -n $tailNumber | head -n 1 | cut -d '"' -f2 | cut -d '/' -f1)
        if [ "$version" == '' ]; then
            echo -e "\n   Not found any more version\nJust exiting"
            exit 0
        fi

        echo_FULL_INFO "$BLUE      Version test: $version$CYAN - wget -q $GREEN$link/$version$CYAN -O a.html$NC"
        wget -q "$link/$version" -O a.html

        if grep -q "linux" a.html; then
            echo_FULL_INFO "        $CYAN wget -q $GREEN$link/$version/linux$CYAN -O a.html$NC"
            wget -q "$link/$version/linux" -O a.html

            if grep -q "deb" a.html; then
                continue=1
            else
                echo -e "            # The version \"$version\" don't have deb version yet\n"
            fi
        else
            echo -e "         # The version \"$version\" don't have GNU/Linux version yet\n"
        fi

        ((tailNumber++))
    done

    compareVersion "$version" "" "$link"
}

opera-ffmpeg-codecs(){
    progName="opera-ffmpeg-codecs" # last tested: "0.77.0"
    link="https://github.com/nwjs-ffmpeg-prebuilt/nwjs-ffmpeg-prebuilt/releases/latest"
    command="grep \"Release \" a.html | head -n1 | sed 's/.*Release //; s/ .*//'"

    checkVersion "$progName" "$link" "$command"
}

smplayer(){
    progName="smplayer" # last tested: "22.7.0"
    link="https://www.smplayer.info/downloads"
    command="grep -o '\">smplayer.*tar.bz2' a.html | cut -d '.' -f1-3 | cut -d '-' -f2"

    checkVersion "$progName" "$link" "$command"
}

teamviewer(){
    progName="teamviewer" # last tested: "15.43.7"
    link="https://www.teamviewer.com/en/download/linux"
    command="grep 'Current version' a.html | tr -d 'Ca-z :<\->/'"

    checkVersion "$progName" "$link" "$command"
}

ventoy(){
    progName="ventoy"
    link="https://github.com/ventoy/Ventoy/releases/latest"
    command="grep 'Release Ventoy' a.html | head -n 1 | sed 's/.*Release Ventoy //; s/ .*//'"

    installedVersion="1.0.93"

    checkVersion "$progName" "$link" "$command" "$installedVersion"
}

virtualbox(){
    progName="virtualbox"
    link="https://www.virtualbox.org/wiki/Downloads"
    command="grep 'VirtualBox.* platform packages' a.html | cut -d '>' -f4 | cut -d ' ' -f2"

    installedVersion="7.0.8"

    checkVersion "$progName" "$link" "$command" "$installedVersion"
}

zotero(){
    progName="zotero" # last tested: "6.0.26"
    link="https://www.zotero.org/download"
    command="grep 'linux-x86_64' a.html | sed 's/.*linux-x86_64//' | tr -d '\":}),'"

    checkVersion "$progName" "$link" "$command"
}

# GNU/Linux calls
GNULinuxPrograms(){
    MasterPDFEditor
    authy
    maestral
    mkvtoolnix
    mozilla-firefox
    opera
    opera-ffmpeg-codecs
    smplayer
    teamviewer
    ventoy
    virtualbox
    zotero

    if [ "$1" == "all" ]; then # if "all" call programs with fewer updates
        TLP
        gitahead # GitAhead is no longer under active development
        mangohud
    fi
}

# Windows programs
hwmonitor(){
    progName="hwmonitor"
    link="https://www.cpuid.com/softwares/hwmonitor.html"
    command="grep -o 'href.*hwmonitor_.*.exe' a.html | head -n1 | grep -o \"[0-9].[0-9][0-9]\""

    installedVersion="1.51"

    checkVersion "$progName" "$link" "$command" "$installedVersion"
}

nettraffic(){
    progName="nettraffic"
    link="https://www.venea.net/web/downloads"
    command="grep -o '>Version: [0-9].*<' a.html | head -n1 | tr -d 'a-zA-Z <>:'"

    installedVersion="1.68.2"

    checkVersion "$progName" "$link" "$command" "$installedVersion"
}

notepad-plus-plus(){
    progName="notepad-plus-plus"
    link="https://notepad-plus-plus.org/downloads"
    command="grep 'Current Version' a.html | cut -d 'v' -f2 | cut -d '/' -f1"

    installedVersion="8.5.4"

    checkVersion "$progName" "$link" "$command" "$installedVersion"
}

revouninstaller(){
    progName="revouninstaller"
    link="https://www.revouninstaller.com/products/revo-uninstaller-free"
    command="grep -o -E '>Version: (.{4}|.{5}|.{6})<' a.html | tr -d 'a-zA-Z : <>'"

    installedVersion="2.4.5"

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

    installedVersion="6.22"

    checkVersion "$progName" "$link" "$command" "$installedVersion"
}

# Windows calls
windowsPrograms(){
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

if [ "$s1" == "win" ] || [ "$s1" == "all" ]; then # if "win" or "all" call the windowsPrograms
    windowsPrograms "$s1"
fi

# Default function
default(){
    progName="" # last tested: ""
    link=""
    command=""

    installedVersion=""

    checkVersion "$progName" "$link" "$command" "$installedVersion"
}

echo -e "\n"
