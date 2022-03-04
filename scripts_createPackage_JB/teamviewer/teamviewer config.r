TeamViewer is a remote control application. TeamViewer provides easy,
fast and secure remote access to Linux, Windows PCs, and Macs.

## NOTE:
    1. Newer version of Teamviewer can establish remote control connections
    to older version (version 3 and above), but not in the opposite direction.
    The same things goes to meetings (version 7 and above).

    2. Starting from Teamviewer 13, it has come up with native 64 client package, so
    no multilib is required to use. It uses Qt as a foundation.

## Good commands
    teamviewer                  Start TeamViewer user interface (if not running)
    teamviewer help             Print this help screen
    teamviewer version          Print version information
    teamviewer info             Print version, status, id

    teamviewer daemon start     Start             TeamViewer daemon
    teamviewer daemon stop      Stop              TeamViewer daemon
    teamviewer daemon restart   Stop/Start        TeamViewer daemon

## TeamViewer needs Qt5 - Install these packages/programs for a full Qt5
    qt5
    qt5-webkit
    libxkbcommon
    libinput
    libwacom

## Start daemon
    bash /etc/rc.d/rc.teamviewerd start
