#!/bin/bash
# Create a txz from smartsynchronize-version.tar.gz

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    progName="smartsynchronize"
    version="3_4_8"
    linkDl="http://www.syntevo.com/static/smart/download/smartsynchronize"
    tag=JB-1

    wget -c $linkDl/$progName-generic-$version.tar.gz

    rm -r $progName 2> /dev/null

    tar -xvf $progName-generic-$version.tar.gz

    cd $progName

    mkdir -p usr/doc/$progName-$version
    mv licenses/ changelog.txt checksums license.html readme-linux.txt smartsynchronize.pdf smartsynchronize.url usr/doc/$progName-$version

    mkdir -p usr/share/pixmaps
    cp bin/$progName-128.png usr/share/pixmaps/$progName.png

    mkdir -p usr/share/$progName
    mv bin/ lib/ usr/share/$progName

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
MimeType=x-scheme-handler/smartgit
Icon=$progName" > usr/share/applications/$progName.desktop

    mkdir -p usr/bin
    cd usr/bin
    ln -s ../share/$progName/bin/$progName.sh $progName
    cd ../../

    folderDest=`cd ..; pwd`
    /sbin/makepkg -l y -c n $folderDest/$progName-$version-noArch-$tag.tgz

    cd ../
    rm -r $progName
    rm $progName-generic-$version.tar.gz
fi
