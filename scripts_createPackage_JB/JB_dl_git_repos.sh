#!/bin/bash
#
# Clone some of my repositories
# https://github.com/ryuuzaki42
#
# Last update: 01/06/2024
#
set -x

cd ../../
#cd /media/sda2/git_clone/

git clone https://ryuuzaki42@github.com/ryuuzaki42/01_Cool_Things.git

git clone https://ryuuzaki42@github.com/ryuuzaki42/02_Scripts_Linux.git
cd 02_Scripts_Slackware/ || exit
./0install_scripts_JBi.sh
cd ../

git clone https://ryuuzaki42@github.com/ryuuzaki42/03_Slackware_JB_Packages.git

git clone https://ryuuzaki42@github.com/ryuuzaki42/04_AppImage_Shortcut_Desktop.git

git clone https://ryuuzaki42@github.com/ryuuzaki42/05_Estrutura_Dados.git

## not dl
#git clone https://ryuuzaki42@github.com/ryuuzaki42/12_clone_Slackware_repo_rsync.git

#git clone https://ryuuzaki42@github.com/ryuuzaki42/13_clone_multilib_Slackware_repo.git

#git clone https://ryuuzaki42@github.com/ryuuzaki42/14_Nvidia_Driver_Slackware/

## Rename repo
git clone https://ryuuzaki42@github.com/ryuuzaki42/26_DL_PVANet_files.git

## Old
#git clone https://ryuuzaki42@github.com/ryuuzaki42/25_Security_Wi-Fi

#git clone https://ryuuzaki42@github.com/99_Old_Files.git
