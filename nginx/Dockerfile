FROM nginx:1.18

ARG TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone

RUN groupadd -g 33 www-data && \
    useradd -u 33 -g www-data -s /bin/bash -M www-data
