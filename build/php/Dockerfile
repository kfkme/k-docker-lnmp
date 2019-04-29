# 声明变量
ARG INSTALL_XDEBUG




FROM php:7.1.9-fpm

RUN echo "deb http://mirrors.aliyun.com/debian/ stretch main non-free contrib" > /etc/apt/sources.list \
    && echo "deb-src http://mirrors.aliyun.com/debian/ stretch main non-free contrib" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/debian-security stretch/updates main" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.aliyun.com/debian-security stretch/updates main" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib" >> /etc/apt/sources.list

# 安装基础
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    curl \
    sudo \
    iputils-ping \
    libicu-dev \
    libmemcached-dev \
    libz-dev \
    libpq-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libssl-dev \
    libmcrypt-dev \
    libxml2-dev \
    libbz2-dev \
    libjpeg62-turbo-dev \
    git \
    vim \
    openssh-server \
    openssh-client \
    subversion \
  && rm -rf /var/lib/apt/lists/*

# 安装PHP插件
RUN docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql \
    && docker-php-ext-configure pdo_pgsql --with-pgsql \
    && docker-php-ext-configure mbstring --enable-mbstring \
    && docker-php-ext-configure soap --enable-soap \
    && docker-php-ext-install \
        bcmath \
        intl \
        mbstring \
        mysqli \
        pcntl \
        pdo_mysql \
        pdo_pgsql \
        soap \
        sockets \
        zip \
  && docker-php-ext-configure gd \
    --enable-gd-native-ttf \
    --with-jpeg-dir=/usr/lib \
    --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd \
  && docker-php-ext-install opcache \
  && docker-php-ext-enable opcache

## AST
#RUN git clone https://github.com/nikic/php-ast /usr/src/php/ext/ast/ && \
#    docker-php-ext-configure ast && \
#    docker-php-ext-install ast

# ICU - intl requirements for Symfony
# Debian is out of date, and Symfony expects the latest - so build from source, unless a better alternative exists(?)
#RUN curl -sS -o /tmp/icu.tar.gz -L http://download.icu-project.org/files/icu4c/58.2/icu4c-58_2-src.tgz \
#    && tar -zxf /tmp/icu.tar.gz -C /tmp \
#    && cd /tmp/icu/source \
#    && ./configure --prefix=/usr/local \
#    && make \
#    && make install

#RUN docker-php-ext-configure intl --with-icu-dir=/usr/local \
#    && docker-php-ext-install intl

# 安装 Redis 扩展
COPY ./redis-3.1.3.tgz /home/redis.tgz
RUN pecl install /home/redis.tgz \
	&& echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini

# 安装 PHP Memcached 扩展
RUN curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz" \
  && mkdir -p memcached \
  && tar -C memcached -zxvf /tmp/memcached.tar.gz --strip 1 \
  && ( \
    cd memcached \
    && phpize \
    && ./configure \
    && make -j$(nproc) \
    && make install \
  ) \
  && rm -r memcached \
  && rm /tmp/memcached.tar.gz \
  && docker-php-ext-enable memcached


# 安装 PHP MongoDB 扩展
#RUN pecl install mongodb && \
#    docker-php-ext-enable mongodb


# 复制 opcache 配置
COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini


# 安装xDebug,如果启用
RUN if [ ${INSTALL_XDEBUG} = true ]; then \
    # 安装xdebug扩展
    pecl install xdebug && \
    docker-php-ext-enable xdebug \
;fi


# 复制xdebug信任用于远程调试
# COPY ./xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# 复制时区配置
COPY ./timezone.ini /usr/local/etc/php/conf.d/timezone.ini

# 设置时区
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/London /etc/localtime
RUN "date"


# Short open tags fix - another Symfony requirements
COPY ./custom-php.ini /usr/local/etc/php/conf.d/custom-php.ini

# Composer
ENV COMPOSER_HOME /var/www/.composer
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/bin \
    --filename=composer
RUN composer config -g repo.packagist composer https://packagist.laravel-china.org

RUN chown -R www-data:www-data /var/www/

# 用户公钥

RUN mkdir /root/.ssh \
    && chown -R www-data:www-data /root/.ssh
# RUN sudo ssh-keygen -t rsa -C "kfkdock"  -f ~/.ssh/id_dsa
#RUN ssh-keygen -t rsa -C "kfkdock" -f /root/.ssh/id_rsa


# 部署公钥
RUN mkdir /var/www/.ssh \
    && chown -R www-data:www-data /var/www/.ssh
#RUN sudo -Hu www-data ssh-keygen -t rsa  -f /var/www/.ssh/id_rsa

# coding webhook 日志
RUN mkdir /var/log/webhook \
    && chown -R www-data:www-data /var/log/webhook \
    && sudo -Hu www-data touch /var/log/webhook/coding_webhook.log

RUN mkdir -p $COMPOSER_HOME/cache

VOLUME $COMPOSER_HOME
WORKDIR /var/www