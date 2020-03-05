#！/bin/sh
echo ”开始执行自动备份==============================================“
mkdir /backup/mc
cp -r /root/bds/worlds /backup/mc
tar -zcPvf /backup/backup$(date +%Y%m%d).tar /backup/mc
rm -rf /backup/mc/
echo "开始删除过于陈旧的备份========================================"
find ./ -mtime +7 -name "*.tar" -exec rm -rf {} \;
echo "已删除过于陈旧的备份 所有备份工作已完成======================="