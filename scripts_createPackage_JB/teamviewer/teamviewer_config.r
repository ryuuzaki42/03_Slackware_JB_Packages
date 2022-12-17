
TeamViewer is a remote control application. TeamViewer provides easy,
fast and secure remote access to Linux, Windows PCs, and Macs.

You must give execute permission on /etc/rc.d/rc.teamviewerd and run
/etc/rc.d/rc.teamviewerd start prior launching TeamViewer application

To make this process repeated on every boot sequence, add this line in
your /etc/rc.d/rc.local:

if [ -x /etc/rc.d/rc.teamviewerd ]; then
    /etc/rc.d/rc.teamviewerd start
fi

## NOTE:
    1. Newer version of Teamviewer can establish remote control connections
    to older version (version 3 and above), but not in the opposite direction.
    The same things goes to meetings (version 7 and above).

    2. Always stop teamviewerd service and remove the old version before
    attempting to upgrade as the path and configs may change on each major release.

    3. Starting from Teamviewer 13, it has come up with native 64 client
    package, so no multilib is required to use. It uses Qt as a foundation.

    4. The GUI client only seems to work in runlevel 4. Using runlevel 3 +
    startx/startwayland does not work.


## Requires: libminizip

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

## Error

## Teamviewer not starting GUI
    ## Edit the file
        nano ~/.config/kded5rc

        ## And enable statusnotifierwatcher:
            [Module-statusnotifierwatcher]
            autoload=false

            ## > to
                autoload=true

    ## Or delete the file
        rm ~/.config/kded5rc

    ## Need logout and relogin to work

## TeamViewer easy remote access
    > Login

    > Contatc > Add Remote Computer
        ID, Password, Alias

    > Extras > Options
        > General
            > Account to assignment > Assign

        > Security
            > Grant $USER Easy Access > accept

        > Advanced
            > Personal password > Add one
