FROM nginx:1.16

ARG TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone
