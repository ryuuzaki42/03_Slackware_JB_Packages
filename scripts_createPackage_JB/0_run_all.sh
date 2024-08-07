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
