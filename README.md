
## KFKDock
Docker容器化应用，根据自定义配置文件快速搭建PHP环境。简化一步步手动配置服务器的过程。
![](http://ww1.sinaimg.cn/large/750f80a1ly1fqpzttoimnj20vl0j4dk6.jpg)

## 为什么使用 Docker
1. 文件系统隔离：每个容器有自己的Root文件系统，假设你的服务器被入侵，服务器本身不受影响
2. 进程隔离：每个容器都运行在自己的进程环境中
3. 网络隔离：容器间的虚拟网络接口和IP地址都是分开的
4. 资源隔离和分组：使用cgroups将CPU、内存之类的资源独立分配给每个Docker容器
5. 写时复制：文件系统是分层的、都是通过写操作进行复制创建，占用空间更小

## GitHub地址
[https://github.com/kfkme/kfkdock](https://github.com/kfkme/kfkdock)

## 视频教程  
[使用KFKDock搭建PHP项目环境](https://www.bilibili.com/video/av13901414/)

## 包含的软件
- [x] PHP5.6/7.1
- [x] Nginx
- [x] Mysql5.6/5.7（默认密码:kfkdock）
- [x] MongoDB
- [x] Redis
- [x] Memcached

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


## 使用之前，请安装必要的工具
[[Mac] docker/docker-compose/加速器](https://github.com/kfkme/kfkdock/blob/master/README_DEPEND_MAC.md)

[[Linux ubuntu] docker/docker-compose/加速器](https://github.com/kfkme/kfkdock/blob/master/README_DEPEND_LINUX_UBUNTU.md)


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
docker-compose restart

#访问测试域名
http://laravel.cc

#成功！
```

> 数据库配置

```
DB_CONNECTION=mysql
DB_HOST=mysql57
DB_PORT=3306
DB_DATABASE=shop
DB_USERNAME=root
DB_PASSWORD=kfkdock
```

> 其他

[删除容器镜像/配置XDebug/docker-compose.yml语法解释/Dockerfile语法解释](https://github.com/kfkme/kfkdock/blob/master/README_OTHER.md)

## QQ交流群

群号: 259937756 <a target="_blank" href="https://shang.qq.com/wpa/qunwpa?idkey=a593151f7e27a4cb7041db186f09f9727d6af2184737637d52f23d2431372065"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="KFKDock" title="KFKDock"></a>

![群号: 259937756](http://ww1.sinaimg.cn/large/750f80a1ly1fp2b1kky0qj208e08e747.jpg)

## 参考
- [docker-lnmp](https://github.com/beautysoft/docker-lnmp)
- [laradock](https://github.com/laradock/laradock)

