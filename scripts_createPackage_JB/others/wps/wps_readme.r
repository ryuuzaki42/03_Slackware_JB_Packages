
## Add dictionaries - as root:
    # http://wps-community.org/download/dicts

    ## unzip the dictionaries
        unzip pt_BR.zip
        unzip en_GB.zip

    ## Move to spellcheck folder
        mv pt_BR/ en_GB/ /opt/kingsoft/wps-office/office6/dicts/spellcheck/

    ## Set permission
        chmod u=rx -R /opt/kingsoft/wps-office/office6/dicts/spellcheck/

    ## Open the WPS, in "Review", select "Spell Check" and "Select the Language"
