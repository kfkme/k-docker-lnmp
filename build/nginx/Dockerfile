FROM nginx:1.14

# 更改权限
RUN mkdir /var/www \
    && chown -R www-data.www-data /var/www/ /var/log/nginx/

# 设置时区 && 同步时间
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
