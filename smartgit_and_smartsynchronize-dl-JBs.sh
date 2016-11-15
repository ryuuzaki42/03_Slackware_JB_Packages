#!/bin/bash
# Create a txz from smartsynchronize and/or smartgit from "program"-version.tar.gz
# Edited from: https://slackbuilds.org/repository/14.2/development/smartgit/

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    echo -en "\nYou want build SmartGit or SmartSynchronize?\n1 to SmartGit or - 2 to SmartSynchronize: "
    read progBuild

    if [ "$progBuild" == '1' ]; then
        progName="smartgit"
        version="8_0_3"
        partFile="-linux"
    elif [ "$progBuild" == '2' ]; then
        progName="smartsynchronize"
        version="3_4_8"
        partFile="-generic"
    else
        echo -e "\nError: The chosen program ($progBuild) is unknown\n"
        exit 1
    fi

    echo -e "\n\nWill build $progName, please wait\n\n"

    linkDl="http://www.syntevo.com/static/smart/download/$progName"
    folderDest=`pwd`
    tag=JB-1

    wget -c $linkDl/$progName$partFile-$version.tar.gz

    rm -r $progName 2> /dev/null

    tar -xvf $progName$partFile-$version.tar.gz

    cd $progName
    mkdir -p usr/doc/$progName-$version
    mv licenses/ *.txt checksums *.html *.url usr/doc/$progName-$version

    if [ "$progBuild" == '2' ]; then
        mv *.pdf usr/doc/$progName-$version
    fi

    mkdir -p usr/share/pixmaps
    cp bin/$progName-128.png usr/share/pixmaps/$progName.png

    mkdir -p usr/share/$progName
    mv bin/ lib/ usr/share/$progName

    if [ "$progBuild" == '1' ]; then
        mv dictionaries/ usr/share/$progName
    fi

    mkdir -p usr/share/applications
    echo "[Desktop Entry]
Version=1.0
Encoding=UTF-8
Name=$progName
Keywords=git;hg;svn;mercurial;subversion
GenericName=Git&Hg-Client + SVN-support
Type=Application
Categories=Development;RevisionControl
Terminal=false
StartupNotify=true
Exec=\"/usr/share/$progName/bin/$progName.sh\" %u
MimeType=x-scheme-handler/$progName
Icon=$progName" > usr/share/applications/$progName.desktop

    mkdir -p usr/bin
    cd usr/bin
    ln -s ../share/$progName/bin/$progName.sh $progName
    cd ../../

    /sbin/makepkg -l y -c n $folderDest/$progName-$version-noArch-$tag.tgz

    cd ../
    rm -r $progName
    rm $progName$partFile-$version.tar.gz
fi
