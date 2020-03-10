 #!/bin/bash
 #script from WangYneos

 screen_name=bds
 path=/root/bds
 map_path=/root/bds/worlds
 tmp_path=/root/bds/tmp
 SOURCE_PATH="/root/bds/tmp"
 DESTINATION_FILE="/backup/saves/MinecraftSaveBackup_`date \"+%s\"`.zip"
 SOURCE_PATH_FILES="$SOURCE_PATH/*"

 # Hanging up save
 screen -x $screen_name -p 0 -X stuff '\n'
 screen -x $screen_name -p 0 -X stuff "say 服务器正在备份，地图将被挂起，需要一分钟左右，请稍安勿躁。"
 screen -x $screen_name -p 0 -X stuff '\n'
 screen -x $screen_name -p 0 -X stuff "save hold"
 screen -x $screen_name -p 0 -X stuff '\n'
 screen -x $screen_name -p 0 -X stuff "save query"
 screen -x $screen_name -p 0 -X stuff '\n'
 # Copy save to a temp folder
 cp -a $map_path/* $tmp_path
 # Save hanged done.
 screen -x $screen_name -p 0 -X stuff "save resume"
 screen -x $screen_name -p 0 -X stuff '\n'
 screen -x $screen_name -p 0 -X stuff "say 地图备份完毕，可以继续游玩。"
 screen -x $screen_name -p 0 -X stuff '\n'


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

 # Save past 7 day's save.
 find `dirname $DESTINATION_FILE` -type f -mtime +7 -exec rm -f {} \;
 echo "Done."
