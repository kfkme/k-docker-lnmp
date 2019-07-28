FROM php:5.6-fpm

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
    curl \
    git \
    subversion \
  && rm -rf /var/lib/apt/lists/*


# 安装PHP插件
RUN docker-php-ext-install \
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


# Short open tags fix - another Symfony requirements
COPY ./custom-php.ini /usr/local/etc/php/conf.d/custom-php.ini



RUN chown -R www-data:www-data /var/www/


WORKDIR /var/www