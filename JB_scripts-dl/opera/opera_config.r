## Opera to Slackwre ## 

## Download:
http://www.opera.com/download/get/?partner=www&opsys=Linux&package=RPM

## Create the txz package
rpm2txz opera*.rpm

## Install
installpkg opera*.txz

## Add the MSE & H.264 plugins
    Compile the "vivaldi-codecs-ffmpeg-extra"
    ## or just install final_package/opera*_amd64_JB.txz (*for now, only 64 bits)

    ## form Slackbuilds
    https://slackbuilds.org/repository/14.2/multimedia/vivaldi-codecs-ffmpeg-extra/

    ## or download form pkgs.org
    https://pkgs.org/search/codecs-ffmpeg

    ## extract the *codecs-ffmpeg*.txz and copy the 
        ## backup
        mv /usr/lib64/opera/libffmpeg.so /usr/lib64/opera/libffmpeg.so2

        ## copy the new libffmpeg
        mv libffmpeg.so /usr/lib64/opera/

    ## For tests, go to:
    https://html5test.com
    https://www.youtube.com/html5
    http://www.quirksmode.org/html5/tests/video.html
