#!/bin/bash

menu(){
      echo "==================================="
	  echo "1.在窗口中运行服务器（使用默认配置）"
	  echo "==================================="
	  echo "2.自行修改配置文件（将会退出）"
	  echo "==================================="
}
echo "安装必要程序========================================================"
apt-get update
apt-get install screen
apt-get install weget
apt-get install unzip
apt-get install cron

echo "正在安装自动备份脚本================================================"
wget -P /root https://raw.githubusercontent.com/DazeCake/onebds/master/bakdata.sh
cd /root
chmod +rx bakdata.sh
service cron start
echo "0 5 * * * /root/bakdata.sh" >> /var/spool/cron/crontabs/root
service cron restart

echo "正在安装启动脚本===================================================="
wget -P /root https://raw.githubusercontent.com/DazeCake/onebds/master/start.sh
cd /root
chmod +rx start.sh

echo "安装bds============================================================="
cd /root
mkdir bds
cd bds
echo "开始下载bds官方开服包==============================================="
wget -P /root/bds https://minecraft.azureedge.net/bin-linux/bedrock-server-1.14.32.1.zip
unzip bedrock-server-1.14.32.1.zip
echo "基本安装已完成======================================================"
clear
echo "所有安装已完成，系统将会在每天凌晨5点自动备份地图文件到/backup 文件夹下"
echo "如果您觉得这个脚本对您有所帮助，请在github给我star,这是对我最大的鼓励"
echo "窗口已经创建为bds"
echo "您可以输入./start.sh来手动启动您的服务器"
echo "by: DazeCake qq : 1936260102"
while true
do
       menu
	   read -p "请输入选项：" n
	   
	   case $n in
	   1)cd /root/bds
	     screen_name=$"bds"
         screen -dmS $screen_name
		 cmd=$"LD_PRELOAD=./preload.so ./bedrock_server";
         screen -x -S $screen_name -p 0 -X stuff "$cmd"
         screen -x -S $screen_name -p 0 -X stuff $'\n'
         screen -r
         break
	   ;;
	   2)
	     screen_name=$"bds"
         screen -dmS $screen_name
		 break
	   ;;
	   esac
	   echo "==================================="
done

