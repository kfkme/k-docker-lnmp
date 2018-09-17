
# 基于Docker快速搭建Web服务
根据自定义配置文件快速搭建Web环境。

## 目录
- [此项目能做什么](https://github.com/kfkme/kfkdock#此项目能做什么)
- [GItHub地址、视频教程](https://github.com/kfkme/kfkdock#github地址、视频教程)
- [包含软件](https://github.com/kfkme/kfkdock#包含软件)
- [项目目录结构](https://github.com/kfkme/kfkdock#项目目录结构)
- [快速运行KFKDock](https://github.com/kfkme/kfkdock#快速运行kfkdock)
    - [运行PHP服务](https://github.com/kfkme/kfkdock#运行php服务)
    - [运行Laravel项目](https://github.com/kfkme/kfkdock#运行laravel项目)
    - [运行前端服务](https://github.com/kfkme/kfkdock#运行前端服务)

## 此项目能做什么
1. 搭建PHP开发/生产环境。
2. 搭建Node开发/生产环境。
    
## GItHub地址、视频教程
> [GitHub地址](https://github.com/kfkme/kfkdock)
> [视频教程](https://www.bilibili.com/video/av13901414/)

## 包含软件
PHP / Nginx / MySQL / MongoDB / Redis / Memcached

## 项目目录结构
```
/kfkdock
    /data                   数据库数据（mysql,redis,mongo）
    /etc                    应用配置项
    /logs                   各种日志（mysql,nginx,php）
    /vhost                  虚拟主机配置
    /www                    项目目录
    /docker-compose.yml     docker-compose配置文件
```

## 快速运行KFKDock
### 运行PHP服务
###### 1. 安装必要的工具
> [[Mac] docker/docker-compose/加速器](https://github.com/kfkme/kfkdock/blob/master/etc/other/README_DEPEND_MAC.md)  
> [[Linux ubuntu] docker/docker-compose/加速器](https://github.com/kfkme/kfkdock/blob/master/etc/other/README_DEPEND_LINUX_UBUNTU.md)


###### 2. 下载KFKDock源码 构建容器
```
#进入用户目录
cd ~/

#下载源码
git clone https://github.com/kfkme/kfkdock.git

#进入目录
cd kfkdock

#构建容器
sudo docker-compose build

#启动容器
sudo docker-compose up -d
```
###### 3. 测试PHP代码

```
# 启动容器
cd ~/kfkdock
sudo docker-compose up

#修改PHP文件
vi ~/kfkdock/www/localhost/index.php

#地址栏访问 localhost
http://localhost

#完成！
```

### 运行Laravel项目
###### 4. 测试Laravel项目

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
docker-compose restart

#访问测试域名
http://laravel.cc

#成功！
```
### 运行前端服务

###### 数据库配置

```
DB_CONNECTION=mysql
DB_HOST=mysql57
DB_PORT=3306
DB_DATABASE=shop
DB_USERNAME=root
DB_PASSWORD=kfkdock
```

### 运行前端服务
###### 进入前端容器
```
docker-compose exec node sh
```

###### 其他
> [删除容器镜像/配置XDebug/docker-compose.yml语法解释/Dockerfile语法解释](https://github.com/kfkme/kfkdock/blob/master/etc/other/README_OTHER.md)

###### QQ交流群

> 群号: 259937756 <a target="_blank" href="https://shang.qq.com/wpa/qunwpa?idkey=a593151f7e27a4cb7041db186f09f9727d6af2184737637d52f23d2431372065"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="KFKDock" title="KFKDock"></a>

![群号: 259937756](http://ww1.sinaimg.cn/large/750f80a1ly1fp2b1kky0qj208e08e747.jpg)

###### 参考
- [docker-lnmp](https://github.com/beautysoft/docker-lnmp)
- [laradock](https://github.com/laradock/laradock)

