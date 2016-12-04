#!/bin/bash

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    ./atom-dl-JBs.sh

    ./git-lfs-dl-JBs.sh

    ./mendeleydesktop-dl-JBs.sh

    ./smartgit_and_smartsynchronize-dl-JBs.sh 1

    ./smartgit_and_smartsynchronize-dl-JBs.sh 2

    ./smplayer-dl-JBs.sh

    ./opera/opera-dl-JBs.sh
    #./opera/cp_lib_opera-JBs.sh

    #./wps/wps-office-dl-JBs.sh
fi
