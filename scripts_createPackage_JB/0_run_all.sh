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
# Script: Run the scripts in this folder looking for updates and create Slackware packages (txz)
#
# Last update: 09/01/2019
#
echo -e "\\n# Run the scripts in this folder looking for updates and create Slackware packages (txz) #\\n"

if [ "$USER" != "root" ]; then
    echo -e "\\nNeed to be superuser (root)\\nExiting\\n"
else
    #./atom_dl_JBs.sh n

    ./create_ap_dl_JBs.sh n

    ./git_lfs_dl_JBs.sh n

    #./mendeleydesktop_dl_JBs.sh n

    #./messengerfordesktop_dl_JBs.sh n

    ./mozilla-firefox_preCompiled_dl_JBs.sh n "en-GB" # Create a package with language en-GB

    ./opera/opera_dl_JBs.sh n

    ./shellcheck_preCompiled_dl_JBs.sh n

    ./smartgit_and_smartsynchronize_dl_JBs.sh 1 n

    ./smartgit_and_smartsynchronize_dl_JBs.sh 2 n

    ./smplayer_dl_JBs.sh n

    cd teamviewer/ || exit # Go to teamviewer folder to create the package
    ./teamviewer_dl_JBs.sh n
    mv teamviewer*txz ../ 2> /dev/null
    cd ../ || exit

    #./wps/wps_office_dl_JBs.sh n
fi
