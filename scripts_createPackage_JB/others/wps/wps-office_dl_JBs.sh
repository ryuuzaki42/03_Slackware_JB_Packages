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
# Script: Create a txz from wps-office-version.rpm
#
# Last update: 20/11/2023
#
echo -e "\\n# Create a txz from wps-office-version.rpm #\\n"

if [ "$USER" != "root" ]; then
    echo -e "\\nNeed to be superuser (root)\\nExiting\\n"
else
    progName="wps-office"
    VERSION="11.1.0.11708.XA-1"
    TAG="1_JB"

    installedVersion=$(find /var/log/packages/$progName* | cut -d '-' -f3-4 | cut -d '.' -f1-4)
    echo -e "\\n   Latest version: $VERSION\\nVersion installed: $installedVersion\\n"
    if [ "$installedVersion" != '' ]; then
        if [ "$VERSION" == "$installedVersion" ]; then
            echo -e "Version installed ($installedVersion) is equal to latest version ($VERSION)"

            continue=$1
            if [ "$continue" == '' ]; then
                echo -n "Want continue? (y)es - (n)o (hit enter to no): "
                read -r continue
            fi

            if [ "$continue" != 'y' ]; then
                echo -e "\\nJust exiting\\n"
                exit 0
            fi
        fi
    fi

    folderTmpDl=$(echo $VERSION | rev | cut -d '.' -f2 | rev | cut -d '-' -f1)
    linkDl="http://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/$folderTmpDl"

    if [ -z "$ARCH" ]; then
        case "$(uname -m)" in
            i?86) ARCH="i686" ;;
            arm*) ARCH="arm" ;;
            *) ARCH=$(uname -m) ;;
        esac
    fi

    if [ "$ARCH" == "x86_64" ] || [ "$ARCH" == "i686" ] ; then
        wget -c "$linkDl/$progName-$VERSION.$ARCH.rpm"
    else
        echo -e "\\nError: ARCH $ARCH not configured\\n"
        exit 1
    fi

    rpm2txz -d -c -s -r "$progName-$VERSION.$ARCH.rpm"

    rm "$progName-$VERSION.$ARCH.rpm"

    mv "$progName-$VERSION.$ARCH.txz" "$progName-$VERSION-$ARCH-$TAG.txz"
fi
