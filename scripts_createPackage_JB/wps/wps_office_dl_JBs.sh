#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# Mande me um e-mail. Ficarei Grato!
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
# Last update: 11/09/2017
#
echo -e "\\n# Create a txz from wps-office-version.rpm #\\n"

if [ "$USER" != "root" ]; then
    echo -e "\\nNeed to be superuser (root)\\nExiting\\n"
else
    progName="wps-office"
    version="10.1.0.6757-1"
    tag="1_JB"

    installedVersion=$(find /var/log/packages/$progName* | cut -d '-' -f3-4 | cut -d '.' -f1-4)
    echo -e "\\n   Latest version: $version\\nVersion installed: $installedVersion\\n"
    if [ "$installedVersion" != '' ]; then
        if [ "$version" == "$installedVersion" ]; then
            echo -e "Version installed ($installedVersion) is equal to latest version ($version)"

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

    linkDl="http://kdl.cc.ksosoft.com/wps-community/download/6757"

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
        echo -e "\\nError: ARCH $ARCH not configured\\n"
        exit 1
    fi

    rpm2txz -d -c -s -r "${progName}-${version}.${ARCH}.rpm"

    rm "${progName}-${version}.${ARCH}.rpm"

    mv "${progName}-${version}.${ARCH}.txz" "${progName}-${version}.${ARCH}-${tag}.txz"
fi
