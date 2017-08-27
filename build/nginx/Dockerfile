FROM nginx:1.12.1

# 更改权限
RUN mkdir /etc/nginx/html
RUN chown -R www-data.www-data /etc/nginx/html/ /var/log/nginx/

# 设置时区 && 同步时间
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone