
# 使用 Docker 搭建 PHP 开发环境 
PHP（5.6/7.2/7.4）/ MySQL  / Nginx / Redis


 
 视频教程：
 [视频教程](https://www.bilibili.com/video/av13901414/)


目录结构：
```
build       应用
data        数据库数据存放路径（mysql,redis）
doc         文档
www         项目目录
logs        日志存放路径（mysql,nginx,php）
shell       常用shell存放路径
vhost       虚拟主机配置
www         项目目录
docker-compose.yml      docker-compose配置文件
env-example             存储一些依赖环境的变量的文件
```

## 快速开始

###### 1. 安装必要的工具
Mac  
[安装Docker、安装docker-compose、配置Docker加速器](https://github.com/kfkme/kfkdock/blob/master/build/other/README_DEPEND_MAC.md)  

Linux ubuntu  
[安装Docker、安装docker-compose、配置Docker加速器](https://github.com/kfkme/kfkdock/blob/master/build/other/README_DEPEND_LINUX_UBUNTU.md)


###### 2. 下载k-docker-lnmp源码 构建容器
```
#进入用户目录
cd ~/

#下载源码
git clone https://github.com/kfkme/k-docker-lnmp.git

#进入目录
cd kfkdock

#拷贝 配置环境变量文件
cp env-example .env

#运行你所需要的容器（也可以全部运行 sudo docker-compose up -d）
sudo docker-compose up -d nginx mysql php
```
###### 3. 测试PHP代码

```
# 启动容器
cd ~/k-docker-lnmp
sudo docker-compose up

#修改PHP文件
vi ~/k-docker-lnmp/www/localhost/index.php

#地址栏访问 localhost
http://localhost

#完成！
```

###### 4. 测试Laravel项目

```
#编辑本地host文件
vi /build/host
#加入
127.0.0.1   laravel.cc

#复制一份Laravel项目
~/k-docker-lnmp/www/laravel

#进入 php 容器
docker-compose exec php bash

#加载Composer依赖
cd /var/www/laravel
composer install --no-plugins --no-scripts

#退出容器，设置Laravel项目的nginx配置
vi ~/k-docker-lnmp/vhost/laravel.cc.conf
server {
    listen       80;
    server_name  laravel.cc;
    root   /var/www/laravel/public;
    index  index.php index.html index.htm;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass   php:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
	}
}

#退出容器
exit

#重启容器，应用配置
docker-compose restart

#访问测试域名
http://laravel.cc

#成功！
```

###### 进入前端容器
```
docker-compose exec node sh
```

###### 其他：
 [删除容器镜像、配置XDebug、docker-compose.yml语法解释、Dockerfile语法解释](https://github.com/kfkme/kfkdock/blob/master/build/other/README_OTHER.md)

###### 鸣谢
- [docker-lnmp](https://github.com/beautysoft/docker-lnmp)
- [laradock](https://github.com/laradock/laradock)