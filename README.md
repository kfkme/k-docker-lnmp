![](http://static.laravelacademy.org/wp-content/uploads/2016/12/docker-banner2.jpg)

# 视频地址
> 学徒卡夫 - 卡夫的Mac 07 - 使用 `KFKDock` 搭建PHP项目环境  
https://www.bilibili.com/video/av13901414/

以后应该用不到之前的镜像与容器，所以建议清空下

```
docker stop 容器ID/Name

# 删除所有容器
docker rm `docker ps -a -q`

# 删除所有的镜像
docker rmi $(docker images -q)
```

## 1、开始之前
> KFKDock 致力于简化创建开发环境过程，能够帮你在Docker上快速搭建PHP项目环境。 

支持的软件
```
数据库引擎:
    MySQL
    MongoDB
    
缓存引擎:
    Redis
    Memcached
    
PHP 服务器:
    NGINX

PHP 编译工具:
    PHP-FPM
```
目录结构
```
/kfkdock
    /data                   数据
    /logs                   日志
    /nginx/vhost            Nginx 项目配置文件
    /wwwroot                项目目录
    /docker-compose.yml     docker-compose 配置文件
```


## 2、依赖

> 安装之前，需要确保系统已经安装以下软件：
- Git
- Docker
- docker-compose

1、安装 docker
```
https://www.docker.com/docker-mac
```
2、安装 docker-compose
```
# 注意：你如果用的是非 root 用户，执行 curl 会提示没权限写入 /usr/local/bin 目录，可以先写入当前目录，再使用 sudo mv 过去
curl -L https://get.daocloud.io/docker/compose/releases/download/1.12.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

## 3、安装
下面我们进入实战，开始基于 `KFKDock` 在本地安装开发环境。

```
# 进入用户目录
cd ~/

# 下载
git clone https://github.com/kfkme/kfkdock.git

# 进入目录
cd kfkdock

# 构建\重建容器
sudo docker-compose build

# 启动容器
sudo docker-compose up -d php71 nginx mysql
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

# 更换composer源
composer config -g repo.packagist composer https://packagist.phpcomposer.com

# 进入项目目录
cd /var/www/laravel

# composer 更新项目
composer install --no-plugins --no-scripts

# 退出容器，添加 laravel项目的nginx配置文件
# vi ~/kfkdock/vhost/deflat.cc.conf
server {
    listen       80;
    server_name  deflat.cc;
    root   /etc/nginx/html/laravel/public;
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
```



## 其他
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

## 特别鸣谢
- [docker-lnmp](https://github.com/beautysoft/docker-lnmp)
- LaraDock

