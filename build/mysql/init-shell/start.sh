#!/bin/bash

#保存备份个数，备份31天数据
number=10

#备份保存路径
backup_dir=/home/data/backup_mysql/mhehewan

#日期
dd=`date +%Y-%m-%d-%H-%M-%S`

#用户名
username=root

#密码
password=Hengshi2019#@!123

#将要备份的数据库
database_name=mhehewan

#如果文件夹不存在则创建
if [ ! -d $backup_dir ];
then
    mkdir -p $backup_dir;
fi

#备份
mysqldump --add-locks --add-drop-table --hex-blob --allow-keywords --extended-insert=false -u${username} -p${password} ${database_name}  > ${backup_dir}/$database_name-$dd.sql

#写创建备份日志
echo "create $backup_dir/$database_name-$dd.dupm" >> $backup_dir/log.txt

#找出需要删除的备份
delfile=`ls -l -crt  $backup_dir/*.sql | awk '{print $9 }' | head -1`

#判断现在的备份数量是否大于$number
count=`ls -l -crt  $backup_dir/*.sql | awk '{print $9 }' | wc -l`

if [ $count -gt $number ]
then
  #删除最早生成的备份，只保留number数量的备份
  rm $delfile
  #写删除文件日志
  echo "delete $delfile" >> $backup_dir/log.txt
fi