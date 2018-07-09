## 配置宿主机
```
sudo apt-get update // 更新包管理工具
sudo apt-get install curl git // ubuntu默认不安装curl

```
## 安装 Docker
```
sudo curl -sSL https://get.docker.com/ | sh   
```
## 安装 docker-compose
```
sudo curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

docker-compose --version
```

## 配置 Docker 加速器

```
# 这是我自己账号的加速器，你也可以自己注册 https://www.daocloud.io/mirror#accelerator-doc

curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://33b39435.m.daocloud.io

#执行下上面命令，然后重启docker 以完成加速器的配置
service docker restart
```