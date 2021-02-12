#!/bin/bash

FEATURE_PARAMS=''
if [ "$FEATURE_TOGGLES" != "NONE" ]
then
    IFS=';' read -ra ADDR <<< "$FEATURE_TOGGLES"
    for i in "${ADDR[@]}"; do
        FEATURE_PARAMS="$FEATURE_PARAMS -J-D${i}=true"
    done
fi
GROOVY_PARAM=''
if [ -n "$STARTUP_GROOVY" ] && [ "$STARTUP_GROOVY" != "NONE" ]
then                                                                           
    GROOVY_PARAM="--groovy $STARTUP_GROOVY"                         
fi

ADD_PARAMS=''
if [ -n "$START_PARAMS" ] && [ "$START_PARAMS" != "NONE" ]
then
    ADD_PARAMS="$START_PARAMS"
fi

Xvfb :1 -screen 0 800x600x24+32 -nolisten tcp -nolisten unix &
export DISPLAY=:1
export TZ=${USER_TIMEZONE:-UTC}
exec /usr/local/GridVisService/bin/server $ADD_PARAMS -J-Duser.timezone=${USER_TIMEZONE:-UTC} --locale ${USER_LANG:-en} -J-Dfile.encoding=${FILE_ENCODING:-UTF-8} $FEATURE_PARAMS $GROOVY_PARAM
