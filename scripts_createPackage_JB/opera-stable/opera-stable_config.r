## Opera to Slackwre ##

## Run the script
./opera_dl_JBs.sh

    ## Or
    # Download:
    http://www.opera.com/download/get/?partner=www&opsys=Linux&package=RPM

    # Create the txz package
    rpm2txz opera-stable*.rpm

## Install
installpkg opera-stable*.txz

## Add the MSE & H.264 plugins
    Compile the "opera-ffmpeg-codecs" form Slackbuilds
    https://slackbuilds.org/repository/14.2/multimedia/opera-ffmpeg-codecs/

    # For 64 bits install compiled package opera-ffmpeg-codecs-*-x86_64-1_SBo.tgz

    # For tests, go to:
    https://www.youtube.com/html5
    https://html5test.com
    http://www.quirksmode.org/html5/tests/video.html
