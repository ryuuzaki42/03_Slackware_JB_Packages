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
# Descrição: Script to download the last version of LibreOffice, made by AlienBob
#
# Last update: 25/11/2023
#
case "$(uname -m)" in
    i?86) archDL="x86" ;;
    *) archDL=$(uname -m) ;;
esac

mirrorStart="http://www.slackware.com/~alien/slackbuilds"
#mirrorStart="https://slackware.uk/people/alien/slackbuilds"
#mirrorStart="https://us.slackware.nl/people/alien/slackbuilds"
#mirrorStart="https://slackware.nl/people/alien/slackbuilds"

# Last tested - 15.0: "7.6.3"

if [ "$1" == '' ]; then
    echo -en "\n$CYAN# Most downloaded versions:$GREEN 14.2, 15.0, current$CYAN\nWith version Slackware you want? $GREEN(press enter to 15.0):$NC "
    read -r slackwareVersion

    if [ "$slackwareVersion" == '' ]; then
        slackwareVersion="15.0"
    fi
else
    slackwareVersion=$1
fi

echo -e "\nMirror: $mirrorStart\nSlackware version: $slackwareVersion\n"
wget "$mirrorStart/CHECKSUMS.md5" -O CHECKSUMS.md5

grep "/$slackwareVersion/" < CHECKSUMS.md5 > CHECKSUMS.md5.2
mv CHECKSUMS.md5.2 CHECKSUMS.md5

progName="libreoffice"
version=$(grep "$progName-[[:digit:]].*$archDL.*t*z$" < CHECKSUMS.md5 | cut -d '-' -f2)

downloadedVersion=$(find Libreoffice-* | head -n 1 | cut -d '-' -f2)
echo -e "\n    Latest version: $version\nVersion downloaded: $downloadedVersion\n"
if [ "$downloadedVersion" != '' ]; then
    if [ "$version" == "$downloadedVersion" ]; then
        echo -e "Version downloaded ($downloadedVersion) is equal to latest version ($version)"
        echo -n "Want continue? (y)es - (n)o (hit enter to no): "
        read -r continue

        if [ "$continue" != 'y' ]; then
            echo -e "\nJust exiting\n"
            rm CHECKSUMS.md5
            exit 0
        fi
    fi
fi

grep "$progName" < CHECKSUMS.md5 > CHECKSUMS.md5.2
mv CHECKSUMS.md5.2 CHECKSUMS.md5

runFile1=$(grep "$progName-[[:digit:]].*$archDL.*t*z$" < CHECKSUMS.md5 | cut -d '.' -f2-)
runFile2=$(grep "$progName-dict-pt-BR-.*$archDL.*t*z$" < CHECKSUMS.md5 | cut -d '.' -f2-)
runFile3=$(grep "$progName-dict-en-.*$archDL.*t*z$" < CHECKSUMS.md5 | cut -d '.' -f2-)
#runFile4=$(grep "$progName-kde-integration-.*$archDL.*t*z$" < CHECKSUMS.md5 | cut -d '.' -f2-)
runFile5=$(grep "$progName-l10n-pt_BR-.*$archDL.*t*z$" < CHECKSUMS.md5 | cut -d '.' -f2-)

{
    grep "$progName-[[:digit:]].*$archDL.*t*z$" < CHECKSUMS.md5
    grep "$progName-dict-pt-BR-.*$archDL.*t*z$" < CHECKSUMS.md5
    grep "$progName-dict-en-.*$archDL.*t*z$" < CHECKSUMS.md5
    #grep "$progName-kde-integration-.*$archDL.*t*z$" < CHECKSUMS.md5
    grep "$progName-l10n-pt_BR-.*$archDL.*t*z$" < CHECKSUMS.md5
} > CHECKSUMS_libreoffice.md5

rm CHECKSUMS.md5

#runFile=$(echo -e "$runFile1\n$runFile2\n$runFile3\n$runFile4\n$runFile5")
runFile=$(echo -e "$runFile1\n$runFile2\n$runFile3\n$runFile5")

echo -e "Files found:\n$runFile\n"

mkdir "Libreoffice-${version}"
cd "Libreoffice-${version}" || exit

for fileGrep in $(echo -e "$runFile"); do
    wget -c "$mirrorStart/$fileGrep"
done

echo -e "\n\n# Checking md5sum #"
mv ../CHECKSUMS_libreoffice.md5 .
sed -i 's/pkg64\/'$slackwareVersion'\///g' CHECKSUMS_libreoffice.md5
sed -i 's/.\/libreoffice\///g' CHECKSUMS_libreoffice.md5

md5sum -c CHECKSUMS_libreoffice.md5

rm CHECKSUMS_libreoffice.md5
echo -e "\n\nList of files downloaded:\n$(tree --noreport)\n"
