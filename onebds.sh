#!/bin/sh

menu(){
      echo "==================================="
	  echo "1.在窗口中运行服务器（使用默认配置）"
	  echo "==================================="
	  echo "2.自行修改配置文件（将会退出）"
}

echo "安装必要程序========================================================"
apt-get update
apt-get install screen
apt-get install weget

echo "安装bds============================================================="
cd /root
mkdir bds
cd bds
echo "开始下载bds官方开服包==============================================="
wget -P /root/bds https://minecraft.azureedge.net/bin-linux/bedrock-server-1.14.32.1.zip
unzip bedrock-server-1.14.32.1.zip
echo "基本安装已完成======================================================"
while ：
do
       menu
	   read -p "请输入选项："n
	   
	   case $n in
	   1)cd /root/bds
	     screen_name=$"bds"
         screen -dmS $screen_name
		 cmd=$"LD_PRELOAD=./preload.so ./bedrock_server";
         screen -x -S $screen_name -p 0 -X stuff "$cmd"
         screen -x -S $screen_name -p 0 -X stuff $'\n'
	   ;;
	   2)break
	   ;;
	   esac
	   echo "==================================="
done
