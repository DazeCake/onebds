#!/bin/bash

ZIP="/usr/bin/zip"
RM="/bin/rm"

SOURCE_PATH="/root/bds/worlds"
DESTINATION_FILE="/backup/mc/MinecraftSaveBackup_`date \"+%s\"`.zip"

SOURCE_PATH_FILES="$SOURCE_PATH/*"


if [ -f $DESTINATION_FILE ];then
    echo "The file $DESTINATION_FILE EXIST! Terminate."
    exit -1
fi

if [ "`ls -A $SOURCE_PATH`" = "" ]; then
    echo "The path $SOURCE_PATH is empty! Terminate."
    exit 0
fi

cd $SOURCE_PATH && $ZIP -r $DESTINATION_FILE *
RET=$?

if [ $RET -ne 0 ];then
    echo "zip Error. Abort!"
    exit -2
fi

cd -


echo "Cleanning $SOURCE_PATH_FILES"
$RM -rf $SOURCE_PATH_FILES

find `dirname $DESTINATION_FILE` -type f -mtime +30 -exec rm -f {} \;
echo "Done."

# idk what i've done i just write a script for some reasons then boom
# sry bruh i took down your codes :p
