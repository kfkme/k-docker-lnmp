#!/bin/bash
#作为crontab运行的脚本,需特别注意环境变量问题,指令写成绝对路径

#读取环境变量
. /etc/profile
#如果目录不存在则新建

USERNAME=root #备份的用户名
PASSWORD=$MYSQL_ROOT_PASSWORD  #备份的密码

DATE=`date +%Y-%m-%d`  #用来做备份文件名字的一部分
OLDDATE=`date +%Y-%m-%d -d '-10 days'`  #本地保存天数

#创建备份的目录和文件
DIR=/data/backup/db

[ -d ${DIR} ] || mkdir -p ${DIR}
[ -d ${DIR}/${DATE} ] || mkdir -p ${DIR}/${DATE}


 DBS=`mysql -u$USERNAME -p$PASSWORD -Bse "show databases"|grep -v "information_schema" |grep -v "test"`
 for db_name in $DBS
   do
     /usr/bin/mysqldump -uroot -p"$MYSQL_ROOT_PASSWORD" $db_name  > $DIR/$DATE/$db_name.sql
   done
#/usr/bin/find $DIR -mtime +7  -name "data_[1-9]*" -exec rm -rf {} \;

[ ! -d ${DIR}/${OLDDATE} ] || rm -rf ${DIR}/${OLDDATE} #保存10天 多余的删除最前边的