![](http://upload-images.jianshu.io/upload_images/424321-3335005c8f02ea3d.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

# 视频地址
> 学徒卡夫 - 卡夫的Mac 07 - 使用 `KFKDock` 搭建PHP项目环境  
https://www.bilibili.com/video/av13901414/

## KFKDock 介绍
> KFKDock 致力于简化创建开发环境过程，能够帮你在Docker上快速搭建PHP项目环境。 

支持的软件
```
数据库引擎: 
    MySQL、MongoDB
    
缓存引擎: 
    Redis、Memcached
    
PHP服务器: 
    NGINX

PHP编译工具: 
    PHP-FPM
```
目录结构
```
/kfkdock
    /data                   数据
    /logs                   日志
    /vhost                  Nginx 项目配置文件
    /www                    项目目录
    /docker-compose.yml     docker-compose 配置文件
```


## 1、依赖

> 安装之前，需要确保系统已经安装以下软件：
- Git
- Docker
- docker-compose

安装 docker
```
https://www.docker.com/docker-mac
```
安装 docker-compose
```
# 注意：你如果用的是非 root 用户，执行 curl 会提示没权限写入 /usr/local/bin 目录，可以先写入当前目录，再使用 sudo mv 过去
curl -L https://get.daocloud.io/docker/compose/releases/download/1.12.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

## 2、安装
下面我们进入实战，开始基于 `KFKDock` 在本地安装开发环境。

```
# 进入用户目录
cd ~/

# 下载源码
git clone https://github.com/kfkme/kfkdock.git

# 进入目录
cd kfkdock

# 构建\重建容器
sudo docker-compose build

# 启动容器
sudo docker-compose up -d php71 nginx mysql
```
## 3、测试

```


# 启动容器
cd ~/kfkdock
sudo docker-compose up

# 修噶PHP文件
vi ~/kfkdock/www/index.php

# 地址栏访问 localhost
http://localhost

# 成功！
```
## 4、配置一个Laravel项目测试

```
vi /etc/host
# 加入
127.0.0.1   laravel.cc

# 复制一份Laravel项目
~/kfkdock/wwwroot/laravel

# 进入 php71 容器
docker-compose exec php71 bash

# 加载Composer依赖
cd /var/www/laravel
composer install --no-plugins --no-scripts

# 退出容器，设置Laravel项目的nginx配置
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

# 退出容器
exit

# 重启容器，应用配置
docker-composer restart

# 访问测试域名
http://laravel.cc

# 成功！
```

## 其他

#### 一键删除容器、镜像

```
# 关闭容器
docker stop 容器ID/Name

# 删除所有容器
docker rm `docker ps -a -q`

# 删除所有的镜像
docker rmi $(docker images -q)
```

#### 配置 DockerHub 加速器
```
# 阿里云加速器
# 每个人有对应的加速地址，访问 `https://dev.aliyun.com` ->【管理中心】-> 【DockerHub 镜像站点】配置加速器

# DaoCloud 加速器
# http://guide.daocloud.io/dcs/daocloud-9153151.html

# 腾讯云加速器
# https://www.qcloud.com/document/product/457/7207
```
#### 配置 DockerHub 配置 xdebug
```
# 修改 php71/xdebug.ini 文件
xdebug.remote_host = 本机IP
```


## docker-compose.yml 语法

```
# 设置环境变量 INSTALL_XDEBUG
version: '2'
services:
  php71:
      build:
        context: ./php71
        dockerfile: Dockerfile
        args:
          - INSTALL_XDEBUG=true
      privileged: true
      ports:
        - "9071:9000"
```

## Dockerfile 语法

```
写入（覆盖写入） >
RUN pecl install /home/redis.tgz \
	&& echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini
追加 >>
RUN pecl install /home/xdebug.tgz \
    && echo "[xdebug]" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "zend_extension=xdebug.so" >> /usr/local/etc/php/conf.d/xdebug.ini \

使用环境变量
ARG INSTALL_XDEBUG=false
COPY ./ext/xdebug-2.5.5.tgz /home/xdebug.tgz
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
RUN if [ ${INSTALL_XDEBUG} = true ]; then \
    pecl install /home/xdebug.tgz \
;fi

```


## KFKDock参考过以下项目，非常感谢。
- [docker-lnmp](https://github.com/beautysoft/docker-lnmp)
- [LaraDock](https://github.com/laradock/laradock)

