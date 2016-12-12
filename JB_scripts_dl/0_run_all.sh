#!/bin/bash

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    ./atom_dl_JBs.sh

    ./git_lfs_dl_JBs.sh

    ./mendeleydesktop_dl_JBs.sh

    ./smartgit_and_smartsynchronize_dl_JBs.sh 1

    ./smartgit_and_smartsynchronize_dl_JBs.sh 2

    ./smplayer_dl_JBs.sh

    ./opera/opera_dl_JBs.sh
    #./opera/cp_lib_opera_JBs.sh

    #./wps/wps_office_dl_JBs.sh
fi
