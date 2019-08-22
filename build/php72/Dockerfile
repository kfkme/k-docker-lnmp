FROM php:7.2.19-fpm

RUN echo "deb http://mirrors.aliyun.com/debian/ stretch main non-free contrib" > /etc/apt/sources.list \
    && echo "deb-src http://mirrors.aliyun.com/debian/ stretch main non-free contrib" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/debian-security stretch/updates main" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.aliyun.com/debian-security stretch/updates main" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib" >> /etc/apt/sources.list


# 复制时区配置
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

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
    wget \
    net-tools \
    zip \
    unzip \
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
    && docker-php-ext-install \
        bcmath \
        intl \
        mbstring \
        mysqli \
        pcntl \
        pdo_mysql \
        pdo_pgsql \
        sockets \
        zip \
  && docker-php-ext-configure gd \
    --enable-gd-native-ttf \
    --with-jpeg-dir=/usr/lib \
    --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd \
  && docker-php-ext-install opcache \
  && docker-php-ext-enable opcache


# PHP.INI
COPY ./php72.ini /usr/local/etc/php/conf.d/custom-php.ini

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

# 安装 gcc4.9.0（swoole需要4.4版本以上）(系统默认装了6.3.0 所以这里注释掉了)
#RUN cd /tmp \
#    && wget ftp://ftp.gnu.org/gnu/gcc/gcc-4.9.0/gcc-4.9.0.tar.gz \
#    && tar xvf gcc-4.9.0.tar.gz \
#    && cd gcc-4.9.0 \
#    && ./contrib/download_prerequisites \
#    && ./configure --enable-checking=release --enable-languages=c,c++ --disable-multilib  \
#    && make -j2 && make install \
#	&& mv /usr/bin/gcc /usr/bin/gcc-old \
#	&& ln -s /usr/local/bin/gcc /usr/bin/gcc \
#    && rm -rf /tmp/gcc-4.9.0 \
#    && rm /tmp/gcc-4.9.0.tar.gz


# 安装 cmake-3.15.2（swoole需要2.4版本以上）
RUN cd /tmp \
    && wget https://github.com/Kitware/CMake/releases/download/v3.15.2/cmake-3.15.2.tar.gz \
    && tar xvf cmake-3.15.2.tar.gz \
    && cd cmake-3.15.2 \
    && ./bootstrap \
    && make -j8 && make install \
    && rm -rf /tmp/cmake-3.15.2 \
    && rm /tmp/cmake-3.15.2.tar.gz



# 安装 Redis 扩展
RUN cd /tmp \
    && wget https://github.com/edtechd/phpredis/archive/php7.zip \
    && unzip php7.zip \
    && cd phpredis-php7 \
    && phpize \
    && ./configure --with-php-config=/usr/local/bin/php-config  \
    && make && make install \
	&& echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini \
	&& rm -rf /tmp/phpredis-php7 \
	&& rm /tmp/php7.zip

# 安装 PHP Memcached 扩展
#RUN curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz" \
#  && mkdir -p memcached \
#  && tar -C memcached -zxvf /tmp/memcached.tar.gz --strip 1 \
#  && ( \
#    cd memcached \
#    && phpize \
#    && ./configure \
#    && make -j$(nproc) \
#    && make install \
#  ) \
#  && rm -r memcached \
#  && rm /tmp/memcached.tar.gz \
#  && docker-php-ext-enable memcached

# 安装 Swoole
RUN cd /tmp \
    && wget https://pecl.php.net/get/swoole-4.4.3.tgz \
    && tar zxvf swoole-4.4.3.tgz \
    && cd swoole-4.4.3 \
    && phpize \
    && ./configure --enable-coroutine --enable-openssl --enable-http2 --enable-async-redis --enable-sockets --enable-mysqlnd -with-php-config=/usr/local/bin/php-config \
    && make && make install \
    && echo "extension=swoole.so" > /usr/local/etc/php/conf.d/swoole.ini \
	&& rm -rf /tmp/swoole-4.4.3 \
	&& rm /tmp/swoole-4.4.3.tgz


# 安装 xDebug 插件
#RUN curl -fsSL 'https://xdebug.org/files/xdebug-2.6.1.tgz' -o xdebug.tar.gz \
#    && mkdir -p xdebug \
#    && tar -xf xdebug.tar.gz -C xdebug --strip-components=1 \
#    && rm xdebug.tar.gz \
#    && ( \
#    cd xdebug \
#    && phpize \
#    && ./configure --enable-xdebug \
#    && make -j$(nproc) \
#    && make install \
#    ) \
#    && rm -r xdebug \
#    && docker-php-ext-enable xdebug
##配置 debugger
#RUN echo "xdebug.enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "xdebug.remote_host=192.168.1.2" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "xdebug.remote_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# 安装 PHP MongoDB 扩展
#RUN pecl install mongodb && \
#    docker-php-ext-enable mongodb

# 安装 Composer
ENV COMPOSER_HOME /var/www/.composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ \
    && composer self-update

RUN chown -R www-data:www-data /var/www/

# 用户公钥

#RUN mkdir /root/.ssh \
#    && chown -R www-data:www-data /root/.ssh
# RUN sudo ssh-keygen -t rsa -C "kfkdock"  -f ~/.ssh/id_dsa
#RUN ssh-keygen -t rsa -C "kfkdock" -f /root/.ssh/id_rsa


# 部署公钥
#RUN mkdir /var/www/.ssh \
#    && chown -R www-data:www-data /var/www/.ssh
#RUN sudo -Hu www-data ssh-keygen -t rsa  -f /var/www/.ssh/id_rsa



RUN mkdir -p $COMPOSER_HOME/cache

VOLUME $COMPOSER_HOME
WORKDIR /var/www