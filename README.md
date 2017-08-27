## kfkdock

> kfkdock 是由开发库社区出品。可以构建出基于 Docker 的 PHP 开发环境，其优势有在短时间内随意构建不同版本的相关服务、环境统一分布在不同服务器等，使开发者能够更专注于开发业务本身。

    # 当前版本   ：1.0
    # 默认服务   ：PHP-FPM 7.1、PHP-FPM 5.6、Nginx 1.12.1、mysql 5.6、redis 3.0、MongoDB Latest
    
    # 目录结构
        /kfkdock
            /build                  镜像构建目录
            /config                 持久化目录，包括 php 脚本、相关服务配置文件、数据库数据等
            /data                   数据目录，包括 mysql、mongo
            /logs                   日志目录，nginx
            /vhost                  项目Nginx配置文件
            /wwwroot                项目目录
            /env-example            配置文件
            /docker-compose.yml     docker-compose 配置文件

### 安装

没有安装 Docker 的同学移步 [安装教程](https://github.com/kfkme/kfkdock#安装-docker-及相关工具)

```
# 进入用户目录
cd ~/

# 下载 kfkdock 项目
git clone https://github.com/kfkme/kfkdock.git

# 进入 kfkdock 项目目录
cd kfkdock

# 复制配置文件
cp .env-example .env

# 配置 .env（应用路径、mysql密码）
APP_PATH=~/kfkdock/
MYSQL_PASSWORD=kfkdock

# 构建所有服务
sudo docker-compose up --build -d
```


#### 常用操作命令
```
# 查看当前启动的容器
sudo docker ps

# 启动部分服务在后边加服务名，不加表示启动所有，-d 表示在后台运行
sudo docker-compose up nginx php71 mysql -d

# 停止和启动类似
sudo docker-compose stop [nginx|php71|php56|mysql|redis|mongo]
```
#### 修改镜像文件怎么处理？
    
    # 比如在 php 里新增一个扩展
    # 1、更改对应的 kfkdock/build/php71/dockerfile
    # 2、重新构建镜像
    sudo docker-compose build [php71|...]

#### 如何设置开机启动服务？

    # 编辑开机启动文件，写入  cd /home/your/kfkdock && compose up -d
    # 注意这里不用 sudo，本身是使用 root 运行的
    # 另外 kfkdock 如果不在 /root/ 下，需要编辑 .env 里 APP_PATH 设置绝对路径
    sudo vim /etc/rc.local

    # 重启测试
    sudo reboot

## 安装 Docker 及相关工具

1、安装 docker 参考 daocloud 提供的文档
    
    # 注意按照文档如果执行类似 install docker-ce=17.03.1* 出错，执行 install docker-ce 即可
    https://download.daocloud.io/Docker_Mirror/Docker

2、安装 docker-compose
    
    # 注意：你如果用的是非 root 用户，执行 curl 会提示没权限写入 /usr/local/bin 目录，可以先写入当前目录，再使用 sudo mv 过去
    curl -L https://get.daocloud.io/docker/compose/releases/download/1.12.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

3、启动 Docker

    sudo service docker start
    sudo docker info    

4、配置 DockerHub 加速器（这简直是一定的）

    # 阿里云加速器
    # 每个人有对应的加速地址，访问 `https://dev.aliyun.com` ->【管理中心】-> 【DockerHub 镜像站点】配置加速器

    # DaoCloud 加速器
    # http://guide.daocloud.io/dcs/daocloud-9153151.html

    # 腾讯云加速器
    # https://www.qcloud.com/document/product/457/7207

## License
MIT
