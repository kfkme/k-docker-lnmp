
## KFKDock
> Docker容器化应用，根据自定义配置文件快速搭建PHP环境。简化一步步手动配置服务器的过程。

###### GitHub地址
> [https://github.com/kfkme/kfkdock](https://github.com/kfkme/kfkdock)

###### 视频教程  
> [使用KFKDock搭建PHP项目环境](https://www.bilibili.com/video/av13901414/)

###### 包含的软件
- [x] PHP5.6/7.1
- [x] Nginx
- [x] Mysql5.6/5.7（默认密码:kfkdock）
- [x] MongoDB
- [x] Redis
- [x] Memcached

###### 目录结构
```
/kfkdock
    /data                   数据库数据（mysql,redis,mongo）
    /etc                    应用配置项
    /logs                   各种日志（mysql,nginx,php）
    /vhost                  虚拟主机配置
    /www                    项目目录
    /docker-compose.yml     docker-compose配置文件
```


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

###### 数据库配置

```
DB_CONNECTION=mysql
DB_HOST=mysql57
DB_PORT=3306
DB_DATABASE=shop
DB_USERNAME=root
DB_PASSWORD=kfkdock
```

###### 其他
> [删除容器镜像/配置XDebug/docker-compose.yml语法解释/Dockerfile语法解释](https://github.com/kfkme/kfkdock/blob/master/etc/other/README_OTHER.md)

###### QQ交流群

> 群号: 259937756 <a target="_blank" href="https://shang.qq.com/wpa/qunwpa?idkey=a593151f7e27a4cb7041db186f09f9727d6af2184737637d52f23d2431372065"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="KFKDock" title="KFKDock"></a>

![群号: 259937756](http://ww1.sinaimg.cn/large/750f80a1ly1fp2b1kky0qj208e08e747.jpg)

###### 参考
- [docker-lnmp](https://github.com/beautysoft/docker-lnmp)
- [laradock](https://github.com/laradock/laradock)

