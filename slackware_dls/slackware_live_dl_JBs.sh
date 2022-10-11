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
# Descrição: Script to download the last version of Slackware Live, made by AlienBob
#
# Last update: 11/10/2022
#
# My dls:
#     Live    - LEAN 64 bits - ./slackware_live_dl_JBs.sh 1 . 1 4 y
#     Stable  - only one option - ./slackware_live_dl_JBs.sh 1 . 2 1 y
#     Current - only one option - ./slackware_live_dl_JBs.sh 1 . 3 1 y
#
echo -e "\\nScript to download the last version of Slackware Live (made by Alien Bob)\\n"

# Last tested:
    # 1 slackware-live/           - version 1.6.0
    # 2 slackware64-15.0-live/    - day 2022-08-14
    # 3 slackware64-current-live/ - day 2022-08-16

help() {
    echo -e "$(basename "$0") \$mirror_choose \$pathDl \$versionDownload \$downloadIsoNumbers \$continueOrNot
    \$mirror_choose      - which mirror use to download (with -h show this message)
    \$pathDl             - path to download the files (with -h show this message)
    \$versionDownload    - which version download
    \$downloadIsoNumbers - ISO numbers to download
    \$continueOrNot      - continue or not if already has downloaded the same version in the repo

    my personal use:
        ./$(basename "$0") 1 . 1 4 y\\n"
}

mirror_choose=$1
pathDl=$2
versionDownload=$3
downloadIsoNumbers=$4
continueOrNot=$5

## Test
echo "mirror_choose=$mirror_choose - pathDl=$pathDl versionDownload=$versionDownload downloadIsoNumbers=$downloadIsoNumbers continueOrNot=$continueOrNot"

downloadLive="slackware-live"
downloadStable="slackware64-15.0-live"
downloadCurrent="slackware64-current-live"

if [ "$mirror_choose" == "-h" ] || [ "$mirror_choose" == "--help" ]; then
    help
    exit 0
fi

linkPrintAndDl() {
    linkDlFunction=$1
    fileName=$2

    echo -en "\\n wget -c \"$linkDlFunction\""
    if [ "$fileName" == '' ]; then
        echo -e "\\n"
        wget -c "$linkDlFunction"
    else
        echo -e " -O \"$fileName\"\\n"
        wget -c "$linkDlFunction" -O "$fileName"
    fi
}

alinPrint() {
    inputValue=$1
    countSpaces=$2

    echo -en " # $inputValue"
    spacesUsed=${#inputValue}
    while [ "$spacesUsed" -lt "$countSpaces" ]; do
        echo -n " "
        ((spacesUsed++))
    done
}

printTrace() {
    countTraceTmp=$1
    echo -n " #"

    countTmpPrint='1'
    while [ "$countTmpPrint" -lt "$countTraceTmp" ]; do
        echo -n "-"
        ((countTmpPrint++))
    done

    echo "#"
}

mirros_link=("https://slackware.uk/people/alien-slaklive"
"https://download.liveslak.org" # Netherlands (Alien BOB)
"https://bear.alienbase.nl/mirrors/slackware-live"
"https://slackware.uk/liveslak" # United Kingdom (Tadgy)
"https://us.liveslak.org" # USA (Alien BOB)
"https://mirrors.slackware.devl.club/slackware-live" # Brazil (DrBeco)
"https://slackware.nl/slackware-live")

i=1
count_mirror=${#mirros_link[*]}
while [ "$i" -le "$count_mirror" ]; do
    echo "$i - ${mirros_link[$i - 1]}"
    ((i++))
done

if [ "$mirror_choose" == '' ]; then
echo -en "\\nUse with mirror to download (enter to first one): "
    read -r mirror_choose
fi

if [ "$mirror_choose" == '' ]; then
    mirror_choose=1
fi

if [ "$mirror_choose" -lt "$count_mirror" ]; then
    repoLink=${mirros_link[$mirror_choose - 1]}
else
    repoLink=${mirros_link[0]}
fi

echo -e "\\nrepoLink: $repoLink"

if [ "$pathDl" == '' ]; then
    echo -en "\\nPath to download (enter to local folder): "
    read -r pathDl
fi

echo -en "\\npathDl: "
if [ "$pathDl" == '' ]; then
    echo "\"$(pwd)\""
else
    echo "\"$pathDl\""
    cd "$pathDl/" || exit
fi

linkPrintAndDl "$repoLink" "latest_version"

infoLatest=$(grep "href=" latest_version | grep -E "\[DIR\]|\[   \]|\[!!!\]|\[directory\]" | sed 's/.* href="//g')
infoName=$(echo "$infoLatest" | sed 's/">.*//g')
infoDate=$(echo "$infoLatest" | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}")

count1="30"
count2="17"
countTrace="52"

countLine=$(echo -e "$infoName" | wc -l)
((countLine++))
countTmp='1'

while [ "$countTmp" -lt "$countLine" ]; do
    printTrace "$countTrace"

    tmpInfo=$(echo "$infoName" | sed -n "${countTmp}p")
    alinPrint "$tmpInfo" "$count1"

    tmpInfo=$(echo "$infoDate" | sed -n "${countTmp}p")
    alinPrint "$tmpInfo" "$count2"

    echo "#"
    ((countTmp++))
done
printTrace "$countTrace"

versionRepoLive=$(grep -o "href=\"[0-9]\.[0-9]\.[0-9]" < latest_version | cut -d '"' -f2)
versionRepoStable=$(grep "href=" < latest_version | grep $downloadStable | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}")
versionRepoCurrent=$(grep "href=" < latest_version | grep $downloadCurrent | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}")
rm latest_version

versionLocalLive=$(find ${downloadLive}-* 2> /dev/null | sort | head -n 1 | cut -d '-' -f3-)
versionLocalStable=$(find ${downloadStable}_day-* 2> /dev/null | sort | head -n 1 | cut -d '-' -f4-)
versionLocalCurrent=$(find ${downloadCurrent}_day-* 2> /dev/null | sort | head -n 1 | cut -d '-' -f4-)

echo -e "\\n # Take a look in the folders \"bonus/\" and \"secureboot/\" for more goodies! #"

echo -e "\\n$downloadLive/           - Version online (repo): \"$versionRepoLive\" Version downloaded: \"$versionLocalLive\"
$downloadStable/    - Version online (repo): \"$versionRepoStable\" Version downloaded: \"$versionLocalStable\"
$downloadCurrent/ - Version online (repo): \"$versionRepoCurrent\" Version downloaded: \"$versionLocalCurrent\""

echo -e "\\n\\n # The Lives ISO has all update until the day of release #\\n
1) \"$downloadLive/\"           - Live from Slackware Current (32 and 64 bits) with more flavors (like MATE, DAW, LEAN)
2) \"$downloadStable/\"    - Live from Slackware Stable 15.0 64 bits
3) \"$downloadCurrent/\" - Live from Slackware Current 64 bits"

echo -en "\\nWant download 1, 2 or 3: "
if [ "$versionDownload" == '' ]; then
    read -r versionDownload
else
    echo -e "\\nversionDownload: \"$versionDownload\""
fi

if [ "$versionDownload" == '1' ]; then # Live
    versionLocal=$versionLocalLive
    versionRepo=$versionRepoLive

    folderCreate=$downloadLive"-"
    linkDl="$repoLink/$versionRepo"

elif [ "$versionDownload" == '2' ]; then # Stable
    versionLocal=$versionLocalStable
    versionRepo=$versionRepoStable

    folderCreate=$downloadStable"_day-"
    linkDl="$repoLink/$downloadStable"

else # Current
    versionDownload=3

    versionLocal=$versionLocalCurrent
    versionRepo=$versionRepoCurrent

    folderCreate=$downloadCurrent"_day-"
    linkDl="$repoLink/$downloadCurrent"
fi

if [ "$versionLocal" == "$versionRepo" ]; then
    echo -e "\\n# No new version found #\\n"
    echo "Version online (repo) is equal to version downloaded: \"$versionLocal\""

    echo -n "Want continue and maybe download more one ISO? (y)es - (n)o (hit enter to no): "
    if [ "$continueOrNot" == '' ]; then
        read -r continueOrNot
    else
        echo -e "\\ncontinueOrNot: \"$continueOrNot\""
    fi

    if [ "$continueOrNot" != 'y' ]; then
        echo -e "\nJust exiting\n"
        exit 0
    fi
fi

echo -e "\\nfolderCreate: \"$folderCreate$versionRepo\"\\n"

mkdir "$folderCreate$versionRepo"
cd "$folderCreate$versionRepo" || exit

linkPrintAndDl "$linkDl" "latest_version"

infoISO=$(grep ".iso\"" < latest_version | sed 's/.* href="//g')
rm latest_version

nameISO=$(echo "$infoISO" | sed 's/">.*//g')
dateISO=$(echo "$infoISO" | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}")
sizeISO=$(echo "$infoISO" | grep -oE "...M|...G")

count1="40"
count2="20"
count3='6'
countTrace="78"

printTrace "$countTrace"
echo -n " # N"
alinPrint "Name" "$count1"
alinPrint "Last modified" "$count2"
alinPrint "Size" "$count3"
echo "#"

countLine=$(echo -e "$nameISO" | wc -l)
((countLine++))
countTmp='1'

while [ "$countTmp" -lt "$countLine" ]; do
    printTrace "$countTrace"
    echo -n " # $countTmp"

    tmpInfo=$(echo "$nameISO" | sed -n "${countTmp}p")
    alinPrint "$tmpInfo" "$count1"

    tmpInfo=$(echo "$dateISO" | sed -n "${countTmp}p")
    alinPrint "$tmpInfo" "$count2"

    tmpInfo=$(echo "$sizeISO" | sed -n "${countTmp}p")
    alinPrint "$tmpInfo" "$count3"

    echo "#"
    ((countTmp++))
done

printTrace "$countTrace"

echo -e "\\nWant download with one of them?"
echo -n "Insert the matching number separated by one space: "
if [ "$downloadIsoNumbers" == '' ]; then
    read -r downloadIsoNumbers
else
    echo -e "\\ndownloadIsoNumbers \"$downloadIsoNumbers\"\\n"
fi

if [ "$downloadIsoNumbers" != "" ]; then
    countTmp='1'
    while [ "$countTmp" -lt "$countLine" ]; do
        tmpInfo=$(echo "$nameISO" | sed -n "${countTmp}p")
        if echo "$downloadIsoNumbers" | grep -q "$countTmp"; then
            echo "Download: $countTmp - $tmpInfo"

            linkPrintAndDl "$linkDl/$tmpInfo"

            linkPrintAndDl "$linkDl/$tmpInfo.md5"

            if [ "$versionDownload" == '1' ]; then
                linkPrintAndDl "$linkDl/$tmpInfo.asc"
            fi
        fi

        ((countTmp++))
    done
else
    echo -e "\\nNot downloading any ISO file!\\n"
fi

linkPrintAndDl "$repoLink/README" "ChangeLog.txt"

if [ "$versionDownload" == '1' ]; then
    linkPrintAndDl "$repoLink/slackware64-current-live/README"

else # "$versionDownload" == 2 or 3
    linkPrintAndDl "$linkDl/liveslak.log"

    linkPrintAndDl "$linkDl/README"

    if [ "$versionDownload" == '2' ]; then
        linkPrintAndDl "$linkDl/LATEST_ADDITION_TO_150"
    else
        linkPrintAndDl "$linkDl/LATEST_ADDITION_TO_CURRENT"
    fi
fi

folderScriptsAlien="alien_scripts/"
echo -e "\\nDownloading some good script from alien to the folder \"$folderScriptsAlien\""
repoLinkConfig="https://www.slackware.com/~alien/liveslak"

files="iso2usb.sh isocomp.sh make_slackware_live.sh make_slackware_live.conf makemod upslak.sh"

linkPrintAndDl "$repoLinkConfig/README.txt"

mkdir $folderScriptsAlien
cd $folderScriptsAlien || exit

for file in $files; do
    linkPrintAndDl "$repoLinkConfig/$file"
done
cd .. || exit

echo " # Md5sum check #"
md5sum -c *.md5

cd .. || exit

if [ "$versionLocal" != '' ] && [ "$versionLocal" != "$versionRepo" ]; then
    echo "Delete the old version ($versionLocal)?"
    echo -n "(y)es - (n)o (hit enter to yes): "
    read -r deleteOldVersion

    if [ "$deleteOldVersion" == 'y' ]; then
        rm -r "$versionLocal"
    fi
fi

echo -e "\\nUseful links:
    1 https://git.liveslak.org/liveslak/about/
    2 https://download.liveslak.org/
    3 https://alien.slackbook.org/blog/slackware-live-edition/
    4 https://docs.slackware.com/slackware:liveslak"

echo -e "\\nEnd of script!\\n"
