FROM nginx:1.18

ARG TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone

# 检查并创建www-data用户组，避免重复创建导致错误
RUN if ! getent group www-data > /dev/null; then \
        groupadd -g 33 www-data; \
    fi && \
    if ! getent passwd www-data > /dev/null; then \
        useradd -u 33 -g www-data -s /bin/bash -M www-data; \
    fi
