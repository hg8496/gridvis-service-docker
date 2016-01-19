#!/bin/bash

sudo own-volume

exec /usr/local/GridVisService/bin/server -J-Duser.timezone=$USER_TIMEZONE --locale $USER_LANG

