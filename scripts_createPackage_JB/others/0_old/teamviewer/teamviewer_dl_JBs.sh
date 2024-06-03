#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# me envie um e-mail. Ficarei Grato!
# e-mail: joao42lbatista@gmail.com
#
# Este programa é um software livre; você pode redistribui-lo e/ou
# modifica-lo dentro dos termos da Licença Pública Geral GNU como
# publicada pela Fundação do Software Livre (FSF); na versão 2 da
# Licença, ou (na sua opinião) qualquer versão.
#
# Este programa é distribuído na esperança que possa ser útil,
# mas SEM NENHUMA GARANTIA; sem uma garantia implícita de ADEQUAÇÃO a
# qualquer MERCADO ou APLICAÇÃO EM PARTICULAR.
#
# Veja a Licença Pública Geral GNU para mais detalhes.
# Você deve ter recebido uma cópia da Licença Pública Geral GNU
# junto com este programa, se não, escreva para a Fundação do Software
#
# Livre(FSF) Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
#
# Script: Script to build a Slackware package of teamviewer
# Based in: http://slackbuilds.org/repository/15.0/network/teamviewer/
#
# Last update: 29/06/2023
#
echo "This script create a txz version from teamviewer_arch.deb"

# teamviewer now ("15.19.3" and up) need libminizip
# https://slackbuilds.org/repository/15.0/libraries/libminizip/

if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    progName="teamviewer" # last tested: "15.42.4"
    tag="2_JB"

    folderDest=$(pwd)
    folderTmp="$folderDest/${progName}_tmp"

    arch=$(uname -m)
    case "$arch" in
        i?86)
            archDl="i386" ;;
        x86_64)
            arch="x86_64"
            archDl="amd64" ;;
        *)
            echo "$arch is not supported."
            exit 1 ;;
    esac

    linkVersion="https://www.teamviewer.com/en/download/linux/"
    wget "$linkVersion" -O "${progName}-latest"

    version=$(grep 'Current version' "${progName}-latest" | tr -d 'Ca-z :<\->/')
    rm "${progName}-latest"

    installedVersion=$(find /var/log/packages/$progName* | cut -d '-' -f2)
    echo -e "\n   Latest version: $version\nVersion installed: $installedVersion\n"
    if [ "$installedVersion" != '' ]; then
        if [ "$version" == "$installedVersion" ]; then
            echo -e "Version installed ($installedVersion) is equal to latest version ($version)"

            continue=$1
            if [ "$continue" == '' ]; then
                echo -n "Want continue? (y)es - (n)o (hit enter to no): "
                read -r continue
            fi

            if [ "$continue" != 'y' ]; then
                echo -e "\nJust exiting\n"
                exit 0
            fi
        fi
    fi

    set -eu

    linkDl="https://download.teamviewer.com/download/linux"
    fileDl="teamviewer_${archDl}.deb"

    wget -c "$linkDl/$fileDl"

    rm -r "$folderTmp" 2> /dev/null || true
    mkdir -p "$folderTmp"
    cd "$folderTmp" || exit

    if [ -f "$folderDest/teamviewer_${archDl}.deb" ]; then
        ar p "$folderDest/teamviewer_${archDl}.deb" data.tar.xz | tar -xvJ
    else
        ar p "$folderDest/teamviewer_${version}_${archDl}.deb" data.tar.xz | tar -xvJ
    fi


    # make all symbolic links relative
    # (code from https://unix.stackexchange.com/a/100955/16829)
    ( cd "$folderDest"
    for link in $(find . -lname '/*'); do
        target=$(readlink "$link")
        link=${link#./}
        root=$(echo "$link" | sed -E 's|[^/](.[^/]*)|..|g'); root=${root#/}; root=${root%..}
        rm "$link"
        ln -s "$root${target#/}" "$link"
    done
    )

    chown -R root:root .
    find -L . \
    \( -perm 777 -o -perm 775 -o -perm 750 -o -perm 711 -o -perm 555 \
    -o -perm 511 \) -exec chmod 755 {} \; -o \
    \( -perm 666 -o -perm 664 -o -perm 640 -o -perm 600 -o -perm 444 \
    -o -perm 440 -o -perm 400 \) -exec chmod 644 {} \;

    # we do not strip te libicudata library as it prevents the package from working.
    find "$folderTmp" -print0 | xargs -0 file | grep -v -e 'libicudata' | grep -e "executable" -e "shared object" | grep ELF \
        | cut -f 1 -d : | xargs strip --strip-unneeded 2> /dev/null || true

#     # Remove the dangling symlink first
#     rm -f $folderTmp/usr/bin/teamviewer

#     # Re-create the generic executable
#     ( cd $folderTmp/usr/bin; ln -s /opt/teamviewer/tv_bin/script/teamviewer teamviewer )

    # Link icon to /usr/share/pixmaps
    mkdir -p "$folderTmp"/usr/share/pixmaps
    ln -s /opt/teamviewer/tv_bin/desktop/teamviewer_256.png "$folderTmp"/usr/share/pixmaps/TeamViewer.png

    # Delete deb "legacy" - We don't need apt
    rm -rf "$folderTmp/etc/apt"

    mv "$folderTmp"/usr/share/applications/com.teamviewer.TeamViewer.desktop "$folderTmp"/usr/share/applications/TeamViewer.desktop

    # Copy docs to official/usual place
    mkdir -p "$folderTmp"/usr/doc/$progName/
    cp -r "$folderTmp"/opt/teamviewer/doc/* "$folderTmp/usr/doc/$progName/"
    #rm -r "$folderTmp/opt/teamviewer/doc/" # Was given error "EULA failed to load"

    cat "$folderDest"/teamviewer_dl_JBs.sh > "$folderTmp"/usr/doc/$progName/teamviewer_dl_JBs.sh

    mkdir -p "$folderTmp"/etc/rc.d/
    install -m 0644 "$folderDest"/rc.teamviewerd "$folderTmp"/etc/rc.d/rc.teamviewerd.new

    mkdir -p "$folderTmp/install"
    echo "# HOW TO EDIT THIS FILE:
# The \"handy ruler\" below makes it easier to edit a package description.
# Line up the first '|' above the ':' following the base package name, and
# the '|' on the right side marks the last column you can put a character in.
# You must make exactly 11 lines for the formatting to be correct. It's also
# customary to leave one space after the ':' except on otherwise blank lines.

          |-----handy-ruler------------------------------------------------------|
teamviewer: teamviewer (remote control application)
teamviewer:
teamviewer: TeamViewer is a remote control application. TeamViewer provides easy,
teamviewer: fast, and secure remote access to Linux, Windows PCs, and Macs.
teamviewer:
teamviewer: TeamViewer is free for personal use. You can use TeamViewer completely
teamviewer: free of charge to access your private computers or to help your
teamviewer: friends with their computer problems.
teamviewer:
teamviewer: Homepage: https://www.teamviewer.com/
teamviewer:" > "$folderTmp/install/slack-desc"

echo -en 'config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  # If there'"'"'s no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
    # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}

preserve_perms() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  if [ -e $OLD ]; then
    cp -a $OLD ${NEW}.incoming
    cat $NEW > ${NEW}.incoming
    mv ${NEW}.incoming $NEW
  fi
  config $NEW
}

preserve_perms etc/rc.d/rc.teamviewerd.new

if [ -x /usr/bin/update-desktop-database ]; then
  /usr/bin/update-desktop-database -q usr/share/applications >/dev/null 2>&1
fi

# If other icon themes are installed, then add to/modify this as needed
if [ -e usr/share/icons/hicolor/icon-theme.cache ]; then
  if [ -x /usr/bin/gtk-update-icon-cache ]; then
    /usr/bin/gtk-update-icon-cache -f usr/share/icons/hicolor >/dev/null 2>&1
  fi
fi

#chmod 753 /etc/teamviewer/ # Change folder permission - Not need
' > "$folderTmp/install/doinst.sh"

    cd "$folderTmp" || exit
    /sbin/makepkg -l y -c n "$folderDest/${progName}-${version}-${arch}-${tag}.txz"

    cd "$folderDest" || exit
    rm -r "$folderTmp" "$fileDl"
fi
