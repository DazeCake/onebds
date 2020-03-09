#!/bin/bash
menu(){
      echo "======================"
	  echo "1.安装完成后在窗口中运行服务器"
	  echo "======================"
	  echo "2.完成安装后退出"
	  echo "======================"
	  }
cd /root/bds
echo "开始下载预编译文件========================================="
wget -p /root/bds https://raw.githubusercontent.com/DazeCake/onebds/master/dist-RELEASE-CN.zip
echo "开始解压预编译文件========================================="
unzip dist-RELEASE-CN.zip
rm  dist-RELEASE-CN.zip
echo "解压完成==================================================="
clear
cd /root
echo "BDL安装已完成，运行start.sh即可连带启动器启动服务器"
while true
do     
        menu
	   read -p "请输入选项：" n
	   
	   case $n in
	   1)sh start.sh
	   ;;
	   2)break
	   ;;
	   esac
	   echo "==================================="
done
