FROM xiaochong0302/php:ctc-pro-v2

ARG TZ=Asia/Shanghai
ARG PHP_INI_DIR=/usr/local/etc/php

RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone

RUN mv ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini
