
## KFKDock
Docker容器化应用，快速搭建PHP环境。  
包含PHP5.6，PHP7.1，Nginx，Mysql5.6，Mysql5.7，MongoDB，Redis，Memcached等服务。  

> 视频教程  

[使用KFKDock搭建PHP项目环境](https://www.bilibili.com/video/av13901414/)

## 包含的软件
1. PHP5.6
1. PHP7.1
1. Nginx
1. Mysql5.6（默认密码:kfkdock）
1. Mysql5.7（默认密码:kfkdock）
1. MongoDB
1. Redis
1. Memcached

## 目录结构
```
/kfkdock
    /data                   数据库数据（mysql,redis,mongo）
    /etc                    应用配置项
    /logs                   各种日志（mysql,nginx,php）
    /vhost                  虚拟主机配置
    /www                    项目目录
    /docker-compose.yml     docker-compose配置文件
```


> 使用之前，请安装必要的工具

[docker/docker-compose/加速器](README_DEPEND.md)


## 构建
```
#进入用户目录
cd ~/

#下载源码
git clone https://github.com/kfkme/kfkdock.git

#进入目录
cd kfkdock

#构建\重建容器
sudo docker-compose build

#启动容器
sudo docker-compose up -d
```
## 测试PHP代码

```
# 启动容器
cd ~/kfkdock
sudo docker-compose up

#修改PHP文件
vi ~/kfkdock/www/index.php

#地址栏访问 localhost
http://localhost

#完成！
```
## 测试Laravel项目

```
#编辑本地host文件
vi /etc/host
#加入
127.0.0.1   laravel.cc

#复制一份Laravel项目
~/kfkdock/www/laravel

#进入 php71 容器
docker-compose exec php71 bash

#加载Composer依赖
cd /var/www/laravel
composer install --no-plugins --no-scripts

#退出容器，设置Laravel项目的nginx配置
vi ~/kfkdock/vhost/laravel.cc.conf
server {
    listen       80;
    server_name  laravel.cc;
    root   /var/www/laravel/public;
    index  index.php index.html index.htm;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass   php71:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
	}
}

#退出容器
exit

#重启容器，应用配置
docker-composer restart

#访问测试域名
http://laravel.cc

#成功！
```

> 其他

[快捷键/配置XDebug/docker-compose.yml语法解释/Dockerfile语法解释](README_OTHER.md)

## 参考
- [docker-lnmp](https://github.com/beautysoft/docker-lnmp)
- [LaraDock](https://github.com/laradock/laradock)

