FROM debian:stretch

ARG TZ=Asia/Shanghai

COPY ./sources.list /opt
COPY ./xunsearch/xs-docker.sh /opt

RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone

RUN cat /opt/sources.list > /etc/apt/sources.list \
    && apt-get update \
    && apt-get -y --no-install-recommends install wget make gcc g++ bzip2 zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN cd /tmp \
    && wget http://www.xunsearch.com/download/xunsearch-full-latest.tar.bz2 \
    && tar -xjf xunsearch-full-latest.tar.bz2 \
    && cd /tmp/xunsearch-full-* \
    && sh setup.sh --prefix=/usr/local/xunsearch \
    && cat /opt/xs-docker.sh > /usr/local/xunsearch/bin/xs-docker.sh \
    && rm -r /tmp/xunsearch-full-*

VOLUME ["/usr/local/xunsearch/data"]

EXPOSE 8383
EXPOSE 8384

ENTRYPOINT ["sh", "/usr/local/xunsearch/bin/xs-docker.sh"]