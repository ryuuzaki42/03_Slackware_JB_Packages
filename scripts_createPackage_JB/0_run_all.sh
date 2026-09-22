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
# COMERCIABILIDADE ou ADEQUAÇÃO A UM PROPÓSITO ESPECÍFICO. Consulte a
# Licença Pública Geral do GNU para mais detalhes.
#
# Script: Run the scripts in this folder looking for updates and create Slackware packages (txz)
#
# Last update: 31/12/2023
#
echo -e "\n# Run the scripts in this folder looking for updates and create Slackware packages (txz) #\n"

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    #./others/atom_dl_JBs.sh n

    #./others/create_ap_dl_JBs.sh n

    #./others/git-lfs_dl_JBs.sh n

    #./others/mendeleydesktop_dl_JBs.sh n

    #./others/messengerfordesktop_dl_JBs.sh n

    ./mozilla-firefox_preCompiled_dl_JBs.sh n "en-US" # Create a package with language en-US

    #./others/opera_dl_JBs.sh n

    #./others/shellcheck_preCompiled_dl_JBs.sh n

    #./others/smartgit_and_smartsynchronize_dl_JBs.sh 1 n

    #./others/smartgit_and_smartsynchronize_dl_JBs.sh 2 n

    #./others/0_old/smplayer_dl_JBs.sh n

    #cd others/0_old/teamviewer/ || exit # Go to teamviewer folder to create the package
    #./teamviewer_dl_JBs.sh n
    #mv teamviewer*txz ../ 2> /dev/null
    #cd ../ || exit

    #./others/wps/wps_office_dl_JBs.sh n

    #./others/skypeforlinux_dl_JBs.sh n
fi
