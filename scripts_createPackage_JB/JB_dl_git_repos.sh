#!/bin/bash
#
# Clone some of my repositories
# https://github.com/ryuuzaki42
#
# Last update: 31/05/2024
#
set -x

#cd ../../
cd /media/sda2/git_clone/

git clone https://ryuuzaki42@github.com/ryuuzaki42/01_Cool_Things.git

git clone https://ryuuzaki42@github.com/ryuuzaki42/02_Scripts_Slackware.git
cd 02_Scripts_Slackware/ || exit
./0install_scripts_JBi.sh
cd ../

git clone https://ryuuzaki42@github.com/ryuuzaki42/03_Slackware_JB_Packages.git

git clone https://ryuuzaki42@github.com/ryuuzaki42/04_AppImage_shortcut_desktop.git

git clone https://ryuuzaki42@github.com/ryuuzaki42/05_Estrutura_Dados.git

## not dl
#git clone https://ryuuzaki42@github.com/ryuuzaki42/12_clone_Slackware_repo_rsync.git

#git clone https://ryuuzaki42@github.com/ryuuzaki42/13_clone_multilib_Slackware_repo.git

#git clone https://ryuuzaki42@github.com/ryuuzaki42/14_Nvidia_Driver_Slackware_Laptop/

## Rename repo
git clone https://ryuuzaki42@github.com/ryuuzaki42/26_dl_PVANet_files.git

## Old
#git clone https://ryuuzaki42@github.com/ryuuzaki42/25_security_Wi-Fi

#git clone https://ryuuzaki42@github.com/99_Old_Files.git
