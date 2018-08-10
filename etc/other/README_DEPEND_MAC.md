## 安装 docker
```
https://www.docker.com/docker-mac
```
## 安装 docker-compose
```
# 注意：你如果用的是非 root 用户，执行 curl 会提示没权限写入 /usr/local/bin 目录，可以先写入当前目录，再使用 sudo mv 过去
curl -L https://get.daocloud.io/docker/compose/releases/download/1.12.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```
## 配置 Docker 加速器
由于在国内下载Docker资源异常缓慢，所以配置加速器非常有必要！
自己注册 [DaoCloud 加速器](https://www.daocloud.io/mirror#accelerator-doc) 获取
或用我的
```
http://33b39435.m.daocloud.io
```
#### [返回](https://github.com/kfkme/kfkdock/blob/master/README.md#%E6%9E%84%E5%BB%BA)