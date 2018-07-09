## 快捷键
```
# 关闭容器
docker stop 容器ID/Name
```
## 删除容器镜像
```
# 删除所有容器
docker rm `docker ps -a -q`

# 删除所有的镜像
docker rmi $(docker images -q)
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