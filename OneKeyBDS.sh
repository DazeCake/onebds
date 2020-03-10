 #!/bin/bash

 ## First release of OneKeyBDS.#!/bin/sh
 ## If you have any problem using the script, open an issue then.
 ## Scriptmaker: nzbcorz.

 # See if you are loged as root
 checksu() {
  if [ $UID -ne 0 ]; then
    sudo -i
    if [ $UID -ne 0 ]; then
      dialog --title "正在安装" --no-shadow --backtitle "OneKeyBDS 一键部署脚本" --infobox " 您的用户不是root，请检查用户后再试。" 3 50
   	 sleep 1.5
    else
     check
    fi
  else
    check
  fi
  }

 # Then check if it's exists
 check() {
	 # This function only works if the path is default
	 server=/root/bds/bedrock_server
	 if [ ! -f $server ]; then
     index
   else
		 popup
   fi
 }

 index() {
   ### let's install this useless package before he realize it :p
   apt install -y dialog

   ### Starting with a cool interface
   dialog --title " OneKeyBDS 一键部署脚本" --no-shadow --ok-label 继续 --clear --msgbox "  感谢下载由DazeCake制作的一键安装BDS脚本，本脚本将会引导您完成大多数操作，\n
   请点按空格以继续。" 8 35
   result=$?
   if [ $result -eq 1 ]; then
     ending

   elif [ $result -eq 255 ]; then
     ending

   fi
     script
 }

 # Confirmation
 script() {
   dialog --title "确认安装" --no-shadow --backtitle "OneKeyBDS 一键部署脚本" --clear --yesno \
   "请确认是否要继续安装？（请用左右键进行操作）" 6 30
   ## yes equals to 0, no equals to 1 , esc is 255
   result=$?
   if [ $result -eq 1 ]; then
     ending

   elif [ $result -eq 255 ]; then
     ending

   fi
     installtion
 }


 ### and really started installing
 # Installing dependencies
 installtion() {

   # making proper path
   cd /root
   mkdir bds
   cd /root/bds
   mkdir cake
	 mkdir backup
	 mkdir tmp

   ### Nope there I failed to use gauge which means NO GUAGE at all hummm

   dialog --title "正在安装" --no-shadow --backtitle "OneKeyBDS 一键部署脚本" --infobox " 正在安装必要依赖，请稍等……" 3 50
   sleep 1.5
   clear
   apt-get update
   apt-get install -y screen curl wget unzip cron openssl nano
   clear

   # Installing Bedrock Server
   # Downloading bedrock-server-1.14.32.1.zip
   dialog --title "正在安装" --no-shadow --backtitle "OneKeyBDS 一键部署脚本" --infobox " 正在下载bedrock_server安装文件…… \n 本脚本从Mojang官网获取下载文件，国内机器可能下载速度稍慢，请稍安勿躁！" 5 50
   sleep 1.5
   clear
   BDS="https://minecraft.azureedge.net/bin-linux/bedrock-server-1.14.32.1.zip"
   wget -P /root/bds "$BDS" 2>&1 | \
   stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | \
   dialog --gauge "正在下载bedrock_server安装文件……" 7 100
   # Configuring Bedrock Server
   dialog --title "正在安装" --no-shadow --backtitle "OneKeyBDS 一键部署脚本" --infobox " 正在配置bedrock_server……" 3 50
   sleep 1.5
   clear
   cd /root/bds
   unzip bedrock-server-1.14.32.1.zip
   rm bedrock-server-1.14.32.1.zip
   clear

	 # Installing autobackup script
	 # Downloading bakdata.sh
   dialog --title "正在安装" --no-shadow --backtitle "OneKeyBDS 一键部署脚本" --infobox " 正在下载自动备份脚本……" 3 50
   sleep 1.5
   clear
   bakdata="https://raw.githubusercontent.com/DazeCake/onebds/master/bakdata.sh"
   wget -P /root "$bakdata" 2>&1 | \
   stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | \
   dialog --gauge "正在下载自动备份脚本……" 7 100

   # Configuring rcon for autobackup
   dialog --title "正在安装" --no-shadow --backtitle "OneKeyBDS 一键部署脚本" --infobox " 正在设置自动备份机制……" 3 50
   sleep 1.5
   clear
   cd /root/bds/cake
   chmod +rx bakdata.sh
   service cron start
   echo "0 5 * * * /root/bds/cake/bakdata.sh" >> /var/spool/cron/crontabs/root
   service cron restart
   clear
   # Done
   # Again try to show a coooool dialog to end
   dialog --title " OneKeyBDS 一键部署脚本" --no-shadow --ok-label 继续 --msgbox "  至此本脚本已经成功地将 Minecraft BE 服务端部署至您的服务器。" 6 50
   sleep 1.5
   clear

   # switch to next stage
   choose
 }

 # Entering second stage
 ### no descriptions annymore cuz im gonna lose my mind k
 choose() {
   RESULTC=$(dialog --title "请选择" --backtitle "OneKeyBDS 一键部署脚本" --clear --menu \
   "请选择您想要的选项" 16 51 3 \
   1 "在窗口中运行服务器（使用默认配置）" \
   2 "修改服务端配置文件 server.properties " \
   3 "安装BDL（服务器MOD启动器，不建议新手使用）" 3>&1 1>&2 2>&3)

  if [ $RESULTC = 1 ]; then
	   runbds
	fi

	if [ $RESULTC = 2 ]; then
	   modsp
	fi

	if [ $RESULTC = 3 ]; then
	 	 getbdl
	fi

  if [ ! "$RESULTC" ]; then
	   ending
	fi

	if [ $RESULTC	= 255 ]; then
	 	 ending
  fi
 }

 # runbds function to start bds
 runbds() {
	 cd /root/bds
   screen_name=$"bds"
	 # I donna what to dobut just prevent some screen comflict
	 screen -X -S $screen_name quit
	 screen -X -S $screen_name quit
	 screen -X -S $screen_name quit
   screen -dmS $screen_name
	 client=/root/bds/bdlauncher
	 ver=
	 if [ ! -f "$client" ]; then
		 cmd=$"LD_LIBRARY_PATH=. ./bedrock_server"
     screen -x -S $screen_name -p 0 -X stuff "$cmd"
     screen -x -S $screen_name -p 0 -X stuff $'\n'
     screen -Dr $screen_name
		ver=BDS
	 else
		ver=BDL
		cmd=$"LD_PRELOAD=./preload.so ./bedrock_server"
    screen -x -S $screen_name -p 0 -X stuff "$cmd"
    screen -x -S $screen_name -p 0 -X stuff $'\n'
    screen -Dr $screen_name
	 fi
 }

 # Use nano to view server.properties
 modsp() {
   cd /root/bds
	 nano server.properties
 }

 # Get latest bdl from DazeCake's Github
 getbdl() {
	 dialog --title "正在安装" --no-shadow --backtitle "OneKeyBDS 一键部署脚本" --infobox " 正在开始下载Bedrock Server Launcher 预编译安装文件……" 3 50
	 sleep 1.5
	 BDL="https://raw.githubusercontent.com/DazeCake/onebds/master/dist-RELEASE-CN.zip"
	 wget -P /root/bds "$BDL" 2>&1 | \
	 stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | \
	 dialog --gauge "正在配置Bedrock Server Launcher 安装……" 7 100
	 cd /root/bds
	 unzip dist-RELEASE-CN.zip
	 rm  dist-RELEASE-CN.zip
	 clear
	 dialog --title " OneKeyBDS 一键部署脚本" --no-shadow --ok-label 完成 --msgbox "  至此本脚本已经成功地将 Minecraft BDL 服务端部署至您的服务器。" 6 50
   sleep 1.5
   clear
	 popup
 }

 # Ends good
 ending() {
	 clear
	 dialog --title "安装结束" --no-shadow --backtitle "OneKeyBDS 一键部署脚本" --infobox " 你选择了退出。" 3 50
	 sleep 1.5
	 clear
	 dialog --title " OneKeyBDS 一键部署脚本" --no-shadow --ok-label 退出 --clear --msgbox "  感谢下载由DazeCake制作的BDS一键安装脚本，如果觉得喜欢请给本项目留下一个Star，谢谢！" 7 35
	 exit
 }

 # Menu first page after installed
 popup() {
	 # check if it have installed bdlauncher
	 client=/root/bds/bdlauncher
	 ver=
	 if [ ! -f "$client" ]; then
     ver=BDS
   else
	   ver=BDL
   fi

   action=
	 status=
   PROC_NAME=bedrock_server
   ProcNumber=`ps -ef |grep -w $PROC_NAME|grep -v grep|wc -l`

   if [ $ProcNumber -le 0 ];then
   action=在窗口中运行服务器
	 status=您已经安装$ver
   else
   action=打开运行$ver的窗口以查看日志
	 status=$ver正在运行
   fi

	 # do a dope toast
	 RESULTC=$(dialog --title "请选择" --backtitle "OneKeyBDS 一键部署脚本" --clear --menu \
   "$status，请问您需要做点什么呢？" 16 51 3 \
   1 "$action" \
   2 "更多选项 " \
   3 "卸载Minecraft BE服务端" 3>&1 1>&2 2>&3)

	 if [ $RESULTC = 1 ]; then
 		 runbds
 	 fi

 	 if [ $RESULTC = 2 ]; then
 	   popuptoo
 	 fi

 	 if [ $RESULTC = 3 ]; then
		 dialog --title "确认卸载" --no-shadow --backtitle "OneKeyBDS 一键部署脚本" --clear --yesno \
	   "请确认是否要继续卸载？（请用左右键进行操作）" 6 30
	   result=$?

	   if [ $result -eq 1 ]; then
	   popup
	   elif [ $result -eq 255 ]; then
	   ending
	   fi
 		 uninstall
 	 fi

   if [ ! "$RESULTC" ]; then
 	   ending
 	 fi

 	 if [ $RESULTC	= 255 ]; then
 		 ending
   fi
 }

 # Menu second page after installed
 popuptoo() {
	 # check if it have installed bdlauncher
   client=/root/bds/bdlauncher
	 ver=
	 response=
	 if [ ! -f "$client" ]; then
		ver=BDS
		response=安装BDL（服务器MOD启动器，不建议新手使用）
	 else
		ver=BDL
		response=修改服务端配置文件server.properties
	 fi

	 # check if it's running
	 status=
   PROC_NAME=bedrock_server
   ProcNumber=`ps -ef |grep -w $PROC_NAME|grep -v grep|wc -l`
   if [ $ProcNumber -le 0 ];then
	 status=您已经安装$ver
   else
	 status=$ver正在运行
   fi

	# do a dope toast one more time
	RESULTC=$(dialog --title "请选择（Cancel返回上级目录）" --backtitle "OneKeyBDS 一键部署脚本" --clear --menu \
	"$status，请问您需要做点什么呢？" 16 51 3 \
	1 "$response" \
	2 "手动备份服务器地图 " \
	3 "更多选项" 3>&1 1>&2 2>&3)
	if [ $RESULTC = 1 ]; then
		if [ "$response" = "安装BDL（服务器MOD启动器，不建议新手使用）" ]; then
			getbdl
		else
			modsp
		fi

	fi

	if [ $RESULTC = 2 ]; then
		manualbak
	fi

	if [ $RESULTC = 3 ]; then
		popuptree
	fi

	if [ ! "$RESULTC" ]; then
		popup
	fi

	if [ $RESULTC	= 255 ]; then
		ending
	fi
 }

 # Menu third page after installed
 popuptree() {
	 # check if it have installed bdlauncher
   client=/root/bds/bdlauncher
	 ver=
	 if [ ! -f "$client" ]; then
		ver=BDS
	 else
		ver=BDL
	 fi

	 # check if it's running
	 status=
   PROC_NAME=bedrock_server
   ProcNumber=`ps -ef |grep -w $PROC_NAME|grep -v grep|wc -l`
   if [ $ProcNumber -le 0 ]; then
	 status=您已经安装$ver
   else
	 status=$ver正在运行
   fi

	# do a dope toast one more time
	RESULTC=$(dialog --title "请选择" --backtitle "OneKeyBDS 一键部署脚本" --clear --menu \
	"$status，请问您需要做点什么呢？" 16 51 3 \
	1 "强行停止$ver服务端 " \
	2 "尝试修复cron自动备份失效 " \
	3 "返回上级" 3>&1 1>&2 2>&3)
	if [ $RESULTC = 1 ]; then
    terminate
	fi

	if [ $RESULTC = 2 ]; then
	  rconfix
	fi

	if [ $RESULTC = 3 ]; then
		popuptoo
	fi

	if [ ! "$RESULTC" ]; then
		popup
	fi

	if [ $RESULTC	= 255 ]; then
		ending
	fi
 }

 # Fix rcontab issue
 rconfix() {
	 cd /root/bds/cake
	 chmod +rx bakdata.sh
	 service cron start
	 sed -e '/bakdata/d' /var/spool/cron/crontabs/root > /var/spool/cron/crontabs/root
	 echo "0 5 * * * /root/bds/cake/bakdata.sh" >> /var/spool/cron/crontabs/root
	 service cron restart
	 clear
	 dialog --title "正在处理" --no-shadow --backtitle "OneKeyBDS 一键部署脚本" --infobox " 已经尝试修复cron自动备份，若仍然出现问题请前往Github提交issue。" 4 50
	 sleep 1.5
	 clear
 }

 #Manually terminate procrss in case of emergency situation.
 terminate() {
	 PROC_NAME=bedrock_server
   ProcNumber=`ps -ef |grep -w $PROC_NAME|grep -v grep|wc -l`
     if [ $ProcNumber -le 0 ]; then
		  dialog --title "正在处理" --no-shadow --backtitle "OneKeyBDS 一键部署脚本" --infobox " 您的机器上并没有运行BDS/BDL!" 3 50
		  sleep 1.5
		  clear
     else
	    killall -9 bedrock_server
			dialog --title "正在处理" --no-shadow --backtitle "OneKeyBDS 一键部署脚本" --infobox " 已经尝试杀死您机器上的BDS/BDL服务端，您可以重新手动开启服务器。!" 4 50
			sleep 1.5
			clear
     fi
 }

 # Manually backup save data
 manualbak() {
 bakscript=/root/bds/cake/mapbak.sh
 bash $bakscript
 }

 # fuck the script idc
 uninstall() {
	 # Terminating screen in a peaceful way
	 screen_name=$"bds"
   cmd=$"exit&&exit"
   killall -9 bedrock_server
	 screen -x -S $screen_name -p 0 -X stuff "$cmd"
	 # Removing files
	 rm -rf /root/bds
	 # Removing crontab autobackup task
	 sed -e '/bakdata/d' /var/spool/cron/crontabs/root > /var/spool/cron/crontabs/root
	 service cron restart
   sleep 0.5
	 # Pause on purpose otherwise it's too god damn fast
	 sleep 2
	 # Gently say goodbye
	 dialog --title " OneKeyBDS 一键部署脚本" --no-shadow --ok-label 继续 --clear --msgbox "  至此本脚本已经成功卸载Minecraft BE 服务端。感谢下载由DazeCake制作的一键安装BDS脚本。若想获得彻底清除，请在脚本运行完毕后执行如下命令：rm /root/onekeybds.sh " 9 40
	 dialog --title "正在卸载" --no-shadow --backtitle "OneKeyBDS 一键部署脚本" --infobox " 再见！" 3 50
   sleep 2.5
   clear
	 exit
 }

 checksu
