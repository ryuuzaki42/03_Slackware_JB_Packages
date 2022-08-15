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
# Last update: 14/08/2022
#
set -e

echo -e "\\nScript to download the last version of Slackware Live (made by Alien Bob)"

# Last tested:
    # 1 slackware64-15.0-live/    - day 2022-07-31
    # 2 slackware64-current-live/ - day 2022-08-14
    # 3 slackware-live/           - version 1.5.3

#repoLink="https://download.liveslak.org/"
#repoLink="https://bear.alienbase.nl/mirrors/slackware-live/"
#repoLink="https://slackware.nl/slackware-live/"
repoLink="https://slackware.uk/people/alien-slacklive/"

help() {
    echo -e "\\n$(basename "$0") \$pathDl \$versionDownload \$downloadIsoNumbers \$continueOrNot
    \$pathDl             - path to download files (with -h show this message)
    \$versionDownload    - Live version to download
    \$downloadIsoNumbers - ISO numbers to download
    \$continueOrNot      - continue or not if already has downloaded the same version in the repo\\n"
}

pathDl=$1
versionDownload=$2
downloadIsoNumbers=$3
continueOrNot=$4

if [ "$pathDl" == "-h" ]; then
    help
    exit 0
fi

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
echo

wget "$repoLink" -O "latestVersion"

infoLatest=$(grep "href=" latestVersion | grep -E "\[DIR\]|\[   \]|\[!!!\]" | sed 's/.* href="//g')
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

versionSlackwareLive=$(grep -o "href=\"[0-9]\.[0-9]\.[0-9]" < latestVersion | cut -d '"' -f2)
versionSlackwareCurrentLive=$(grep "href=" < latestVersion | grep "slackware64-current" | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}")
versionSlackwareStableLive=$(grep "href=" < latestVersion | grep "slackware64-15.0-live" | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}")
rm latestVersion

versionLocalLive=$(find slackware-live-* 2> /dev/null | sort | head -n 1 | cut -d '-' -f3-)
versionLocalCurrent=$(find slackware64-15.0-live_day* 2> /dev/null | sort | head -n 1 | cut -d '-' -f4-)
versionLocalStableLive=$(find slackware64-current-live_day* 2> /dev/null | sort | head -n 1 | cut -d '-' -f4-)

echo -e "\\nTake a look in the folders \"bonus/\" and \"secureboot/\" for more goodies!"

echo -e "\\nslackware-live/           Version Online (repo): \"$versionSlackwareLive\" Version Downloaded: \"$versionLocalLive\"
slackware64-15.0-live/    Version Online (repo): \"$versionSlackwareCurrentLive\" Version Downloaded: \"$versionLocalCurrent\"
slackware64-current-live/ Version Online (repo): \"$versionSlackwareStableLive\" Version Downloaded: \"$versionLocalStableLive\""

echo -e "\\n\\n Live with all update until the day of release of the ISO\\n
1) \"slackware-live/\"           - Live from Slackware Current (32 and 64 bits) with more flavors (kde, xfce, cinnamon, mate, daw, lean)
2) \"slackware64-15.0-live/\"    - Live from Slackware Stable 15.0 64 bits
3) \"slackware64-current-live/\" - Live from Slackware Current 64 bits"

echo -en "\\nWant download 1, 2 or 3: "
if [ "$versionDownload" == '' ]; then
    read -r versionDownload
else
    echo -e "\\nversionDownload: \"$versionDownload\""
fi

if [ "$versionDownload" == '1' ]; then # slackware-live/
    versionLocal=$versionLocalLive
    versionOnRepo=$versionSlackwareLive

    folderCreate="slackware-live-$versionOnRepo"
    linkDl="$repoLink/$versionOnRepo/"

elif [ "$versionDownload" == '2' ]; then #slackware64-15.0-live/
    versionLocal=$versionLocalCurrent
    versionOnRepo=$versionSlackwareCurrentLive

    folderCreate="slackware64-15.0-live_day-$versionOnRepo"
    linkDl="$repoLink/slackware64-15.0-live/"

else # slackware64-current-live/
    versionDownload=3

    versionLocal=$versionLocalStableLive
    versionOnRepo=$versionSlackwareStableLive

    folderCreate="slackware64-current-live_day-$versionOnRepo"
    linkDl="$repoLink/slackware64-current-live/"
fi

if [ "$versionLocal" == "$versionOnRepo" ]; then
    echo -e "\\n# No new version found #"
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

mkdir "$folderCreate" || true
cd "$folderCreate" || exit

wget "$linkDl" -O "latestVersion"

infoISO=$(grep ".iso\"" < latestVersion | sed 's/.* href="//g')
rm latestVersion

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

countTmp='1'
while [ "$countTmp" -lt "$countLine" ]; do
    tmpInfo=$(echo "$nameISO" | sed -n "${countTmp}p")
    if echo "$downloadIsoNumbers" | grep -q "$countTmp"; then
        echo "Download: $countTmp - $tmpInfo"

        echo -e "\\n wget -c \"$linkDl/$tmpInfo\"\\n"
        wget -c "$linkDl/$tmpInfo"

        echo -e "\\n wget -c \"$linkDl/$tmpInfo.md5\"\\n"
        wget -c "$linkDl/$tmpInfo.md5"

        if [ "$versionDownload" == '1' ]; then
            echo -e "\\n wget -c \"$linkDl/$tmpInfo.asc\"\\n"
            wget -c "$linkDl/$tmpInfo.asc"
        fi
    fi

    ((countTmp++))
done

if [ "$versionDownload" == '1' ]; then
    wget -c "$repoLink/README" -O changelog.txt
    wget -c "$repoLink/slackware64-15.0-live/README"

else # "$versionDownload" == 2 or 3
    wget -c "$linkDl/liveslak.log"
    wget -c "$linkDl/README"

    if [ "$versionDownload" == '2' ]; then
        wget -c "$linkDl/LATEST_ADDITION_TO_150"
    else
        wget -c "$linkDl/LATEST_ADDITION_TO_CURRENT"
    fi
fi

echo "Downloading some good script from alien to the \"foldeer script_alien/\""
repoLinkConfig="https://www.slackware.com/~alien/liveslak"

files="README.txt make_slackware_live.sh makemod setup2hd iso2usb.sh upslak.sh"

mkdir script_alien/ || true
cd script_alien/ || exit
for file in $files; do
    echo -e "\\n wget -c \"$repoLinkConfig/$file\"\\n"
    wget -c "$repoLinkConfig/$file"
done
cd .. || exit

echo " # Md5sum check #"
md5sum -c slackware*.md5

cd .. || exit

if [ "$versionLocal" != '' ] && [ "$versionLocal" != "$versionOnRepo" ]; then
    echo "Delete the old version ($versionLocal)?"
    echo -n "(y)es - (n)o (hit enter to yes): "
    read -r deleteOldVersion

    if [ "$deleteOldVersion" == 'y' ]; then
        rm -r "$versionLocal"
    fi
fi

echo -e "\\nUseful links:
    1 https://download.liveslak.org/
    2 https://alien.slackbook.org/blog/slackware-live-edition/
    3 https://docs.slackware.com/slackware:liveslak
    4 https://git.liveslak.org/liveslak/about/"

echo -e "\\nEnd of script!\\n"
