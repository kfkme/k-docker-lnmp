#!/bin/bash
#作为crontab运行的脚本,需特别注意环境变量问题,指令写成绝对路径

#读取环境变量
. /etc/profile
#路径
#DIR=/var/lib/mysql/backup_mysql
DIR=/data/backup/db
#还原哪天的数据
DATE=2019-03-15
#还原数据库的名称
db_name=mhehewan

/usr/bin/mysql -uroot -p"$MYSQL_ROOT_PASSWORD" $db_name < $DIR/$DATE/$db_name.sql