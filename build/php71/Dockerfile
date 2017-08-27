FROM php:7.1-fpm

# 更换 apt-get 源
RUN mv /etc/apt/sources.list /etc/apt/source.list.bak
COPY sources.list /etc/apt/sources.list
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5 \
	&& gpg -a --export 40976EAF437D05B5 | apt-key add - \
	&& apt-get update \
	&& apt-get -y upgrade

# 安装基础组件
RUN apt-get install -y ntpdate cron vim unzip git

# 设置时区 && 同步时间
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
	&& ntpdate 182.92.12.11

# 安装 PDO_MYSQL 扩展
RUN docker-php-ext-install pdo_mysql

# 安装 Redis 扩展
COPY redis-3.1.3.tgz /home/redis.tgz
RUN pecl install /home/redis.tgz \
	&& echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini

# 安装 Mcrypt 加密扩展
COPY mcrypt-1.0.0.tgz /home/mcrypt.tgz
RUN apt-get install -y libmcrypt-dev libmhash-dev \
	&& pecl install /home/mcrypt.tgz \
	&& echo "extension=mcrypt.so" > /usr/local/etc/php/conf.d/mcrypt.ini




# 安装 composer 并设置中国源
ADD composer.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer
RUN composer config -g repo.packagist composer https://packagist.laravel-china.org