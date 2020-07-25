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
# Script: Scripts to update the scripts with "last tested" and "Last update" from Slackware packages (txz) updates
#
# Last update: 25/07/2020
#
for filePackage in *.txz; do
    echo

    programName=$(cut -d '-' -f1 <<< "$filePackage")
    scriptNamePlace=$(find . | grep "${programName}.*_JBs.sh$")
    fileFinal=$(rev <<< "$scriptNamePlace" | cut -d '/' -f1- | rev)".new"

    echo "programName: $programName | filePackage: $filePackage | scriptNamePlace: $scriptNamePlace | fileFinal: $fileFinal"

    dateNew=$(date +%d\\/%m\\/%Y)
    echo -n "New date: $dateNew | "

    versionNew=$(cut -d '-' -f2 <<< "$filePackage")
    echo "New version: $versionNew"

    sed 's/Last update: .*/Last update: '"$dateNew"'/1' "$scriptNamePlace" | sed 's/last tested: .*/last tested: '\""$versionNew"\"'/1' > "$fileFinal"

    echo -e "\\nsdiff -s $scriptNamePlace $fileFinal\\n"
    sdiff -s "$scriptNamePlace" "$fileFinal"

    mv "$scriptNamePlace" "$scriptNamePlace".back
    mv "$fileFinal" "$scriptNamePlace"

    trash-put "$scriptNamePlace".back
    chmod +x "$scriptNamePlace"
done
