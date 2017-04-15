#!/bin/bash
# Create a txz from wps-office-version.rpm

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    progName="wps-office"
    version="10.1.0.5672-1.a21"
    tag="JB"

    installedVersion=$(find /var/log/packages/$progName* | cut -d '-' -f3-4 | cut -d '.' -f1-5)
    echo -e "\n   Latest version: $version\nVersion installed: $installedVersion\n"
    if [ "$installedVersion" != '' ]; then
        if [ "$version" == "$installedVersion" ]; then
            echo -e "Version installed ($installedVersion) is equal to latest version ($version)"
            echo -n "Want continue? (y)es - (n)o (hit enter to no): "

            continue=$1
            if [ "$continue" == '' ]; then
                read -r continue
            fi

            if [ "$continue" != 'y' ]; then
                echo -e "\nJust exiting\n"
                exit 0
            fi
        fi
    fi

    linkDl="http://kdl.cc.ksosoft.com/wps-community/download/a21"

    if [ -z "$ARCH" ]; then
        case "$(uname -m)" in
            i?86) ARCH="i686" ;;
            arm*) ARCH="arm" ;;
            *) ARCH=$(uname -m) ;;
        esac
    fi

    if [ "$ARCH" == "x86_64" ] || [ "$ARCH" == "i686" ] ; then
        wget -c "$linkDl/${progName}-${version}.${ARCH}.rpm"
    else
        echo -e "\nError: ARCH $ARCH not configured\n"
        exit 1
    fi

    rpm2txz "${progName}-${version}.${ARCH}.rpm"

    rm "${progName}-${version}.${ARCH}.rpm"

    mv "${progName}-${version}.${ARCH}.txz" "${progName}-${version}.${ARCH}-${tag}.txz"
fi
