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
# Last update: 26/12/2021
#
echo -e "\\nScript to download the last version of Slackware Live (made by Alien Bob)\\n"

# last tested: "1.5.1"

repoLink="https://repo.ukdw.ac.id/slackware-live"
#repoLink="https://download.liveslak.org"
#repoLink="http://bear.alienbase.nl/mirrors/slackware-live"
#repoLink="https://slackware.nl/slackware-live"

wget "$repoLink" -O "latestVersion"

versionOnRepo=$(grep "href=\"[0-9]\.[0-9]\.[0-9]" < latestVersion | cut -d 'h' -f2 | cut -d '"' -f2 | cut -d '/' -f1 | tail -n 1)
rm latestVersion

versionLocal=$(find Slackware-Live-* | head -n 1 | cut -d '-' -f3)
echo -e "\\n   Version Downloaded: $versionLocal\\nVersion Online (repo): $versionOnRepo\n"

if [ "$versionLocal" == "$versionOnRepo" ]; then
    echo -e "# No new version found #\n"

    continue=$2
    if [ "$continue" == '' ]; then
        echo "Want continue and maybe download more one ISO?"
        echo -n "(y)es - (n)o (hit enter to no): "
        read -r continue
    fi

    if [ "$continue" != 'y' ]; then
        echo -e "\nJust exiting\n"
        exit 0
    fi
fi

mkdir "Slackware-Live-$versionOnRepo"
cd "Slackware-Live-$versionOnRepo" || exit

wget "$repoLink/$versionOnRepo" -O "latestVersion"

infoISO=$(grep ".iso\"" < latestVersion | sed 's/.* href="//g')
rm latestVersion

nameISO=$(echo "$infoISO" | sed 's/">.*//g')
dateISO=$(echo "$infoISO" | cut -d '>' -f5 | cut -d ' ' -f1-2)
sizeISO=$(echo "$infoISO" | cut -d '>' -f7 | cut -d '<' -f1)

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
    echo -n " #-------------------------------------"
    echo "-----------------------------------------#"
}

count1="40"
count2="20"
count3='7'

printTrace
echo -n " # N"
alinPrint "Name" "$count1"
alinPrint "Last modified" "$count2"
alinPrint "Size" "$count3"
echo "#"

countLine=$(echo -e "$nameISO" | wc -l)
((countLine++))
countTmp='1'

while [ "$countTmp" -lt "$countLine" ]; do
    printTrace

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

printTrace

echo -e "\\nWant download with one of them?"
echo -n "Insert the matching number separated by one space: "
read -r downloadIsoNumbers

countTmp='1'
linkDlFiles=${repoLink}/$versionOnRepo
while [ "$countTmp" -lt "$countLine" ]; do
    tmpInfo=$(echo "$nameISO" | sed -n "${countTmp}p")
    if echo "$downloadIsoNumbers" | grep -q "$countTmp"; then
        echo "Download: $countTmp - $tmpInfo"

        echo -e "\\n wget -c \"$linkDlFiles/$tmpInfo\"\\n"
        wget -c "$linkDlFiles/$tmpInfo"

        echo -e "\\n wget -c \"$linkDlFiles/$tmpInfo.md5\"\\n"
        wget -c "$linkDlFiles/$tmpInfo.md5"

        echo -e "\\n wget -c \"$linkDlFiles/$tmpInfo.asc\"\\n"
        wget -c "$linkDlFiles/$tmpInfo.asc"
    fi

    ((countTmp++))
done

wget -c "https://download.liveslak.org/README" -O changelog.txt

echo "Downloading \"iso2usb.sh\" (to create usbboot), \"upslak.sh\" (to update kernel and configs) and the \"README\" (slackware-live changelog)?"
#echo -n "(y)es - (n)o (hit enter to yes): "
#read -r downloadOrNot

#if [ "$downloadOrNot" != 'n' ];then
    repoLinkConfig="http://www.slackware.com/~alien/liveslak"
    files="README iso2usb.sh upslak.sh"
    for file in $files; do
        echo -e "\\n wget -c \"$repoLinkConfig/$file\"\\n"
        wget -c "$repoLinkConfig/$file"
    done
#fi

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
