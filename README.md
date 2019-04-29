
# 基于Docker快速搭建Web服务
根据自定义配置文件快速搭建Web环境。
使用Docker搭建PHP开发/生产环境。
    
GItHub地址：
 [GitHub地址](https://github.com/kfkme/kfkdock)
 
 视频教程：
 [视频教程](https://www.bilibili.com/video/av13901414/)

包含软件：
PHP / Nginx / MySQL / MongoDB / Redis / Memcached

目录结构：
```
build       应用
data        数据库数据存放路径（mysql,redis,mongo）
logs        日志存放路径（mysql,nginx,php）
shell       常用shell存放路径
ssh-key     SSH Key
ssl-key     SSL Key存放路径（用于HTTPS协议）
vhost       虚拟主机配置
www         项目目录
docker-compose.yml      docker-compose配置文件
env-example             存储一些依赖环境的变量的文件
```

## 快速开始

###### 1. 安装必要的工具
> [[Mac] docker/docker-compose/加速器](https://github.com/kfkme/kfkdock/blob/master/build/other/README_DEPEND_MAC.md)  
> [[Linux ubuntu] docker/docker-compose/加速器](https://github.com/kfkme/kfkdock/blob/master/build/other/README_DEPEND_LINUX_UBUNTU.md)


###### 2. 下载KFKDock源码 构建容器
```
#进入用户目录
cd ~/

#下载源码
git clone https://github.com/kfkme/kfkdock.git

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
cd ~/kfkdock
sudo docker-compose up

#修改PHP文件
vi ~/kfkdock/www/localhost/index.php

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
~/kfkdock/www/laravel

#进入 php 容器
docker-compose exec php bash

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

###### QQ交流群

> 群号: 259937756 <a target="_blank" href="https://shang.qq.com/wpa/qunwpa?idkey=a593151f7e27a4cb7041db186f09f9727d6af2184737637d52f23d2431372065"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="KFKDock" title="KFKDock"></a>

![群号: 259937756](http://ww1.sinaimg.cn/large/750f80a1ly1fp2b1kky0qj208e08e747.jpg)

###### 参考
- [docker-lnmp](https://github.com/beautysoft/docker-lnmp)
- [laradock](https://github.com/laradock/laradock)

