#!/bin/sh
# Slackware build script for mendeleydesktop

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    progName=mendeleydesktop
    version=1.17.2
    linkDl="http://desktop-download.mendeley.com/download/linux"
    tag=JB-3

    if [ -z "$ARCH" ]; then
        case "$( uname -m )" in
            i?86) ARCH=i486 ;;
            arm*) ARCH=arm ;;
            *) ARCH=$( uname -m ) ;;
        esac
    fi

    if [ "$ARCH" == "x86_64" ] || [ "$ARCH" == "i486" ]; then
        wget -c "$linkDl/$progName-$version-linux-$ARCH.tar.bz2"
    else
        echo -e "\nError: $ARCH not configured\n"
    fi

    rm -r $progName-$version-linux-$ARCH/ # delete old version compiled

    tar -xvf $progName-$version-linux-$ARCH.tar.bz2

    cd $progName-$version-linux-$ARCH/

    mkdir $progName-$version
    mv INSTALL LICENSE README bin lib share $progName-$version/

    mkdir opt
    mv $progName-$version/ opt/

    mkdir -p usr/bin

    echo -e "#!/bin/bash\npython /opt/$progName-$version/bin/mendeleydesktop" > usr/bin/mendeleydesktop
    chmod +x usr/bin/mendeleydesktop

    mkdir -p usr/share/applications/

    sed -i 's/Icon=mendeleydesktop/Icon=\/usr\/share\/applications\/mendeleydesktop.png/g' opt/$progName-$version/share/applications/mendeleydesktop.desktop

    cp opt/$progName-$version/share/applications/mendeleydesktop.desktop usr/share/applications/
    cp opt/$progName-$version/share/icons/hicolor/128x128/apps/mendeleydesktop.png usr/share/applications/

    /sbin/makepkg -l n -c n ../$progName-$version-$ARCH-$tag.txz

    cd ..
    rm -r $progName-$version-linux-$ARCH/
    rm $progName-$version-linux-$ARCH.tar.bz2
fi
