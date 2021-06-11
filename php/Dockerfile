FROM xiaochong0302/php:latest

# 修正 www-data 在 /var/www 目录下无法读写 .composer 的问题
RUN mkdir -p /var/www && \
  chown www-data:www-data /var/www -R

# 安装 nc，用于判断MySQL是否已经成功运行。
RUN apt-get update && \
  apt-get install -y --no-install-recommends netcat && \
  rm -rf /var/lib/apt/lists/*
