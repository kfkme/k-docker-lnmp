## 快捷键
```
# 关闭容器
docker stop 容器ID/Name
```
## 删除容器镜像
```
# 删除所有容器
sudo docker rm `sudo docker ps -a -q`

# 删除所有的镜像
sudo docker rmi $(docker images -q)

# 删除docker-compose所有的镜像
sudo docker-compose rm
```

## 配置XDebug
```
# 修改 php71/xdebug.ini
xdebug.remote_host = 本机IP
```
配置phpstrom

```text
Run>Edit Conf
左侧添加新项目PHP Web Appliation
    Name: yijiu
    Server: 新建Serviers
                真实路径：Languges&..>PHP>Serviers
                新建
                    Name: yijiu
                    Host: yijiu.cc
                    选中Use path..
                        项目真实目录：/Users/kafu/kfkdock/www/AcPlatform
                        docker对应目录：/var/www/AcPlatform
    Start URL: /admin/body/export 测试路径
    完成。
```

```
配置端口
    Languges&..>PHP>Debug
        xdebug
            Debug port: 90001
    完成。
```

```
启动调试
    Run>Debug'yijiu'
```


## docker-compose.yml语法解释

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

## Dockerfile语法解释

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
```
Docker 常用指令笔记
update@20170212

运行
docker run
--name 指定容器名

-p 指定端口映射

-v 挂载数据卷或者本地目录映射 :ro 挂载为只读

-d 后台持续运行

-i 交互式操作

-t 终端

-rm 容器退出后随之将其删除(与-d 冲突)

eg:

docker run --name ghost1 -p 80:2368 -v /c/Dev/server/blogtest2:/var/lib/ghost ghost

docker run -it --rm ubuntu:14.04 bash

sudo docker run ubuntu:14.04 /bin/echo 'Hello world'

docker run --name webserver -d -p 80:80 nginx

管理容器
docker ps 列出正在运行的容器
docker kill $(docker ps -q) 停止所有正在运行的容器
docker ps -a 查看停止状态的容器
docker start 启动一个已有容器
docker stop 终止一个运行中的容器
docker restart 重启某个容器
docker rm xxxx 删除容器 -f 删除运行中的
docker rm $(docker ps -a -q) 删除所有终止的容器
docker logs [container id or names] 获取输出log
docker diff 容器名 查看我们定制以及修改
docker volume ls 列出所有本机的数据卷

管理镜像
docker pull [option] [url] 获取镜像
eg: docker pull ubuntu:14.04
docker images 列出本地镜像
docker build -t nginx:v3 .
在当前目录构建镜像,-t 是指定镜像名称 tag

docker rmi xxxxxx
删除本地镜像

docker commit 选项 容器名/id 仓库名 tag
可以把修改定制过的容器保存为镜像

docker images -f dangling=true
列出所有虚悬镜像(dangling image)

docker rmi $(docker images -q -f dangling=true)
删除所有虚悬镜像

docker histroy 镜像名:标签 查看镜像修改的历史纪录

Dockerfile
COPY 原路径 目标路径
ADD 性质基本与COPY类似，但支持自动解压
VOLUME 可以定义匿名卷，执行时可被覆盖
EXPOSE 声明端口
WORKDIR 指定工作目录
USER 指定当前用户
HEALTHCHECK 健康检查
ONBUILD 被作为基础镜像时才执行

docker-compose
-p 指定项目名称
build 构建项目中的服务容器 --force-rm 删除构建过程中的临时容器
--no-cache 构建过程中不使用 cache
--pull 始终通过 pull 来获取更新版本的镜像
docker-compose kill 强制停止服务容器
docker-compose logs 查看容器的输出 调试必备
docker-compose pause 暂停一个服务容器
docker-compose unpause 恢复暂停
docker-compose port 打印某个容器端口所映射的公共端口
docker-compose ps 列出项目中目前的所有容器 -q 只打印容器 id
docker-compose pull 拉取服务依赖的镜像
docker-compose restart -t 指定重启前停止容器的超时默认10秒
docker-compose rm 删除所有停止状态的容器先执行 stop
docker-compose run 指定服务上执行一个命令
docker-compose start 启动已经存在的服务容器
docker-compose stop
docker-compose up 自动构建、创建服务、启动服务，关联一系列，运行在前台，ctrl c 就都停止运行。如果容器已经存在，将会尝试停止容器，重新创建。如果不希望重新创建，可以 --no-recreate 就只启动处于停止状态的容器，如果只想重新部署某个服务，可以使用
docker-compose up --no-deps -d ，不影响其所依赖的服务
docker-compose up -d 后台启动运行，生产环境必备

Tips
容器在运行时，以镜像为基础层，在其上创建一个当前容器的存储层，使用 go 语言开发的应用更多的会使用 FROM scratch 来做空白镜像为基础

Dockerfile 中，RUN 执行命令，直接写需要在bash中执行的命令。如果每条命令都作为一个 RUN 单独存在，就相当于每个指令都建立一层，很多不需要的东西都被装进了镜像里，比如编译环境，更新的软件包等等，最终会产生出非常臃肿，非常多层的镜像，增加了构建部署的时间。也很容易出错。正确的写法是把每一大块，或者说每一个软件环境的相关命令集成在一个 RUN 里。
```