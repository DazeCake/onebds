#!/bin/bash

menu(){
      echo "==================================="
	  echo "1.�ڴ��������з�������ʹ��Ĭ�����ã�"
	  echo "==================================="
	  echo "2.�����޸������ļ��������˳���"
}
wget -p /root https://raw.githubusercontent.com/DazeCake/onebds/master/onebds.sh
echo "��װ��Ҫ����========================================================"
apt-get update
apt-get install screen
apt-get install weget

echo "��װbds============================================================="
cd /root
mkdir bds
cd bds
echo "��ʼ����bds�ٷ�������==============================================="
wget -P /root/bds https://minecraft.azureedge.net/bin-linux/bedrock-server-1.14.32.1.zip
unzip bedrock-server-1.14.32.1.zip
echo "������װ�����======================================================"
while ��
do
       menu
	   read -p "������ѡ�"n
	   
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
