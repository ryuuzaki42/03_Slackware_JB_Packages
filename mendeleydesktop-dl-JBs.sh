#!/bin/sh
# Slackware build script for mendeleydesktop
# Edited from: https://slackbuilds.org/repository/14.2/academic/mendeleydesktop/

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    progName="mendeleydesktop" # last tested: 1.17.3
    tag="JB-1"

    linkGetVersion="https://www.mendeley.com/release-notes/"
    wget $linkGetVersion -O $progName-latest

    version=`cat $progName-latest | grep "Release Notes for Mendeley Desktop" | head -n 1 | sed 's/[^0-9,.]*//g'`
    rm $progName-latest

    installedVersion=`ls /var/log/packages/$progName* | cut -d '-' -f2`
    echo -e "\n   Latest version: $version\nVersion installed: $installedVersion\n"
    if [ "$installedVersion" != '' ]; then
        if [ "$version" == "$installedVersion" ]; then
            echo -e "Version installed ($installedVersion) is equal to latest version ($version)"
            echo -n "Want continue? (y)es - (n)o (hit enter to no): "
            read continue

            if [ "$continue" != 'y' ]; then
                echo -e "\nJust exiting\n"
                exit 0
            fi
        fi
    fi

    folderDest=`pwd`
    linkDl="http://desktop-download.mendeley.com/download/linux"

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
        echo -e "\nError: ARCH $ARCH not configured\n"
        exit 1
    fi

    rm -r $progName-$version-linux-$ARCH/ 2> /dev/null

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

    /sbin/makepkg -l n -c n $folderDest/$progName-$version-$ARCH-$tag.txz

    cd ../
    rm -r $progName-$version-linux-$ARCH/
    rm $progName-$version-linux-$ARCH.tar.bz2
fi
