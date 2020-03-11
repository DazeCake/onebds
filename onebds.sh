#!/bin/bash

menu(){
      echo "==============================================="
	  echo "1.在窗口中运行服务器（使用默认配置）"
	  echo "==============================================="
	  echo "2.退出，自行修改配置文件手动启动（推荐）"
	  echo "==============================================="
	  }
cd /root
echo "安装必要程序========================================================"
apt-get update
apt-get install -y screen wget unzip cron openssl curl

echo "正在下载启动脚本===================================================="
wget -P /root https://raw.githubusercontent.com/DazeCake/onebds/master/start.sh
cd /root
chmod +rx start.sh

echo "正在安装bds============================================================="
cd /root
mkdir bds
cd bds
echo "正在下载官方bds开服包==============================================="
wget -P /root/bds https://minecraft.azureedge.net/bin-linux/bedrock-server-1.14.32.1.zip
unzip bedrock-server-1.14.32.1.zip
rm bedrock-server-1.14.32.1.zip
cp /root/start.sh /root/bds
echo "基本安装已完成======================================================"
clear
echo "所有安装已完成"
echo "如果您觉得这个脚本对您有所帮助，请在github给我star,这是对我最大的鼓励"
echo "窗口将被创建为bds 你可以使用screen -R bds来手动重连窗口"
echo "您可以输入sh start.sh来手动启动您的服务器（如果您是root账号的话）"
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
         screen -Dr
         break
	   ;;
	   2)cd /root/bds
	     screen_name=$"bds"
             screen -dmS $screen_name
	     break
	   ;;
	   esac
	   echo "==================================="
done
