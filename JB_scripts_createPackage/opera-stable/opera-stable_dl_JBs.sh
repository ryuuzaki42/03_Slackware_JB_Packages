#!/bin/bash
# Create a txz from opera-stable-version.rpm

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    progName="opera-stable" # last tested: "46.0.2597.32"
    tag="JB"

    linkGetVersion="http://ftp.opera.com/ftp/pub/opera/desktop/"

    tailNumber='1'
    continue='0'
    while [ "$continue" == '0' ]; do
        wget "$linkGetVersion" -O "${progName}-latest"

        version=$(cat ${progName}-latest | grep "href" | tail -n $tailNumber | head -n 1 | cut -d '"' -f2 | cut -d '/' -f1)
        rm "${progName}-latest"

        if [ "$version" == '' ]; then
            echo -e "Not found any more version\nJust exiting"
            exit 0
        fi

        echo -e "\n Version test: $version\n"
        linkGetVersionLinux="http://ftp.opera.com/ftp/pub/opera/desktop/$version/"
        wget "$linkGetVersionLinux" -O "${progName}-downloads"

        if cat ${progName}-downloads | grep "href" | grep -q "linux"; then
            continue='1'
        else
            echo "The version $version don't have Linux version yet"
        fi
        rm "${progName}-downloads"

        ((tailNumber++))
    done

    installedVersion=$(find /var/log/packages/$progName* | cut -d '_' -f2)
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
    linkDl="http://ftp.opera.com/ftp/pub/opera/desktop/$version/linux"

    if [ -z "$ARCH" ]; then
        case "$(uname -m)" in
            i?86) ARCH="i386" ;;
            arm*) ARCH="arm" ;;
            x86_64) ARCH="amd64" ;;
            *) ARCH=$(uname -m) ;;
        esac
    fi

    if [ "$ARCH" == "amd64" ] || [ "$ARCH" == "i386" ]; then
        wget -c "$linkDl/${progName}_${version}_${ARCH}.rpm"
    else
        echo -e "\nError: ARCH $ARCH not configured\n"
        exit 1
    fi

    rpm2txz "${progName}_${version}_${ARCH}.rpm"

    rm "${progName}_${version}_${ARCH}.rpm"

    mv "${progName}_${version}_${ARCH}.txz" "${progName}_${version}_${ARCH}-${tag}.txz"
fi
