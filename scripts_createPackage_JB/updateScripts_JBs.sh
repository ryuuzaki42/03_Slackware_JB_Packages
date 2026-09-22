#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# me envie um e-mail. Ficarei Grato!
# e-mail: joao42lbatista@gmail.com
#
# Este programa é um software livre: você pode redistribuí-lo e/ou
# modificá-lo sob os termos da Licença Pública Geral GNU (GPL)
# conforme publicada pela Free Software Foundation, tanto a versão 3
# da licença, como (a seu critério) qualquer versão posterior.
#
# Este programa é distribuído na esperança de que seja útil,
# mas SEM NENHUMA GARANTIA; nem mesmo a garantia implícita de
# COMERCIABILIDADE ou ADEQUAÇÃO A UM PROPÓSITO ESPECÍFICO.
# Consulte a Licença Pública Geral do GNU para mais detalhes.
#
# Script: Scripts to update the scripts with "last tested" and "Last update" from Slackware packages (txz) updates
#
# Last update: 19/06/2023
#
for filePackage in $(find . | grep ".*.txz" | grep -v "opera-ffmpeg-codecs" | grep -v "opera-beta-ffmpeg-codecs"); do
    echo

    programName=$(rev <<< "$filePackage" | cut -d '-' -f4- | rev)
    scriptNamePlace=$(find . | grep "${programName}.*_JBs.sh$")
    fileFinal=$(rev <<< "$scriptNamePlace" | cut -d '/' -f1- | rev)".new"

    echo "programName: $programName | filePackage: $filePackage | scriptNamePlace: $scriptNamePlace | fileFinal: $fileFinal"

    dateNew=$(date +%d\\/%m\\/%Y)
    echo -n "New date: $dateNew | "

    versionNew=$(rev <<< "$filePackage" | cut -d '-' -f3 | rev)
    echo "New version: $versionNew"

    sed 's/^# Last update: .*/# Last update: '"$dateNew"'/1' "$scriptNamePlace" | sed 's/last tested: .*/last tested: '\""$versionNew"\"'/1' > "$fileFinal"

    echo -e "\nsdiff -s $scriptNamePlace $fileFinal\n"
    sdiff -s "$scriptNamePlace" "$fileFinal"

    mv "$fileFinal" "$scriptNamePlace"
    chmod +x "$scriptNamePlace"
done
