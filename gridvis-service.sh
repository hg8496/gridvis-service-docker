#!/bin/bash

sudo own-volume

FEATURE_PARAMS=''
if [ $FEATURE_TOGGLES != "NONE" ]
then
    IFS=';' read -ra ADDR <<< "$FEATURE_TOGGLES"
    for i in "${ADDR[@]}"; do
        FEATURE_PARAMS="$FEATURE_PARAMS -J-D${i}=true"
    done
fi
exec /usr/local/GridVisService/bin/server -J-Duser.timezone=$USER_TIMEZONE --locale $USER_LANG -J-Dfile.encoding=$FILE_ENCODING $FEATURE_PARAMS 

