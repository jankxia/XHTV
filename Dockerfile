FROM fabiocicerchia/nginx-lua:1.27.5-alpine3.21.3
LABEL maintainer="LibreTV Team"
LABEL description="LibreTV - 免费在线视频搜索与观看平台"

# 复制应用文件
COPY . /usr/share/nginx/html

# 复制Nginx配置文件
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 添加执行权限并设置为入口点脚本
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# 安装 gettext 用于 envsubst
RUN apk add --no-cache gettext

# 暴露端口
EXPOSE 80

# 设置入口点
ENTRYPOINT ["/bin/sh", "-c", "envsubst < /usr/share/nginx/html/index.html > /usr/share/nginx/html/index.html.tmp && mv /usr/share/nginx/html/index.html.tmp /usr/share/nginx/html/index.html && exec /docker-entrypoint.sh"]

# 启动nginx
CMD ["nginx", "-g", "daemon off;"]

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1