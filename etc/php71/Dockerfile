FROM php:7.1-fpm


#####################################
# 更换 apt-get 源
#####################################
# 备份 Ubuntu初始软件更新源
RUN mv /etc/apt/sources.list /etc/apt/source.list.bak
# 切换 网易163 Ubuntu软件更新源
COPY sources.list /etc/apt/sources.list
RUN apt-get -y upgrade \
    && apt-get update



#####################################
# 安装基础组件以及常用扩展
#####################################
RUN apt-get update && apt-get install -y \
      libicu-dev \
      libpq-dev \
      libpng-dev \
      libjpeg-dev \
      libfreetype6-dev \
      libmcrypt-dev \
      libmhash-dev \
      mysql-client \
      libmysqlclient-dev \
      ruby-full \
      nodejs \
      ntpdate \
      wget \
      cron \
      unzip \
      git \
      libxml++2.6-dev \
    && rm -r /var/lib/apt/lists/* \
    # GD依赖
    && docker-php-ext-configure gd --with-freetype-dir --with-jpeg-dir \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-install \
      intl \
      mbstring \
      mcrypt \
      mysqli \
      pcntl \
      pdo_mysql \
      pdo_pgsql \
      pgsql \
      zip \
      gd \
      opcache


#####################################
# 安装 Redis 扩展
#####################################
COPY ./ext/redis-3.1.3.tgz /home/redis.tgz
RUN pecl install /home/redis.tgz \
	&& echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini


#####################################
# 安装 Mcrypt 加密扩展
#####################################
# COPY ./ext/mcrypt-1.0.0.tgz /home/mcrypt.tgz
# RUN pecl install /home/mcrypt.tgz \
	# && echo "extension=mcrypt.so" > /usr/local/etc/php/conf.d/mcrypt.ini


#####################################
# 安装 xDebug 扩展
#####################################
ARG INSTALL_XDEBUG=false
COPY ./ext/xdebug-2.5.5.tgz /home/xdebug.tgz
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
RUN if [ ${INSTALL_XDEBUG} = true ]; then \
    pecl install /home/xdebug.tgz \
;fi


#####################################
# PHP设置 #这里应该没生效 有时间弄下
#####################################
RUN	echo "[Date]" >> /usr/local/etc/php/php.ini \
	&& echo "date.timezone = 'Asia/Taipei'" >> /usr/local/etc/php/php.ini \
	&& echo "upload_max_filesize = 50M" >> /usr/local/etc/php/php.ini \
	&& echo "post_max_size = 50M" >> /usr/local/etc/php/php.ini \
	&& echo "max_execution_time = 0" >> /usr/local/etc/php/php.ini \
	&& echo "memory_limit = -1" >> /usr/local/etc/php/php.ini


#####################################
# 安装 composer 并设置中国源
#####################################
ADD ./ext/composer.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer
RUN composer config -g repo.packagist composer https://packagist.laravel-china.org
RUN composer self-update


#####################################
# 设置时区 && 同步时间
#####################################
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
	&& ntpdate 182.92.12.11

WORKDIR /var/www