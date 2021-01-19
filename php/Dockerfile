FROM php:7.3-fpm-buster

LABEL maintainer="xiaochong0302@qq.com"

ARG PHALCON_VERSION=3.4.5.1
ARG PHALCON_EXT_PATH=php7/64bits

ARG TZ=Asia/Shanghai
ARG SOURCES_LIST=/etc/apt/sources.list

RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone

RUN set -xe && \
    curl -L https://gitee.com/koogua/cphalcon/repository/archive/v${PHALCON_VERSION}?format=tar.gz -o v${PHALCON_VERSION}.tar.gz && \
    tar xzf ${PWD}/v${PHALCON_VERSION}.tar.gz && \
    docker-php-ext-install -j $(getconf _NPROCESSORS_ONLN) ${PWD}/cphalcon/build/${PHALCON_EXT_PATH} && \
    rm -r \
        ${PWD}/v${PHALCON_VERSION}.tar.gz \
        ${PWD}/cphalcon

RUN echo "" > ${SOURCES_LIST} \
    && echo "deb http://mirrors.cloud.tencent.com/debian buster main contrib non-free" >> ${SOURCES_LIST} \
    && echo "deb http://mirrors.cloud.tencent.com/debian buster-updates main contrib non-free" >> ${SOURCES_LIST} \
    && apt-get update \
    && apt-get install -y --no-install-recommends git supervisor cron nano zip unzip libpng-dev \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql pcntl mbstring bcmath gd \
    && pecl install igbinary redis \
    && docker-php-ext-enable igbinary redis

RUN curl https://mirrors.aliyun.com/composer/composer.phar -o /usr/local/bin/composer \

COPY ./cron.d/course /etc/cron.d/course

RUN chmod 644 /etc/cron.d/course
