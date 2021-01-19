#!/usr/bin/env bash

# ----------- 请根据实际情况，修改如下配置 ------------ #

#是否安装测试数据(on:是，off:否)
SITE_DEMO=off

#站点域名(不包括http)
SITE_DOMAIN=abc.com

#站点密钥(数字字母组合，不要用特殊字符)
SITE_KEY=1qaz2wsx3edc

#mysql超级用户密码（数字字母组合，不要用特殊字符）
MYSQL_ROOT_PASSWORD=1qaz2wsx3edc

#mysql项目数据库名称（数字字母组合，不要用特殊字符）
MYSQL_DATABASE=ctc

#mysql项目数据库用户（数字字母组合，不要用特殊字符）
MYSQL_USER=ctc

#mysql项目数据库密码（数字字母组合，不要用特殊字符）
MYSQL_PASSWORD=1qaz2wsx3edc

#redis访问密码（数字字母组合，不要用特殊字符）
REDIS_PASSWORD=1qaz2wsx3edc

# --------------- !!! 以下内容，请勿修改!!! --------------- #

#安装git和curl
sudo apt-get update && apt-get install -y curl git

if [ ! -d '/etc/docker' ]; then
  mkdir -p "/etc/docker"
fi

#写入docker配置
sudo echo '{"registry-mirrors": ["https://mirror.ccs.tencentyun.com"]}' | tee /etc/docker/daemon.json

#安装docker
if [ -z "$(command -v docker)" ]; then
  sudo curl -sSL https://get.daocloud.io/docker | sh
fi

#启动docker
sudo service docker start

#安装docker-composer
if [ -z "$(command -v docker-compose)" ]; then
  sudo curl -L "https://get.daocloud.io/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
fi

#docker-compose增加执行权限
sudo chmod +x /usr/local/bin/docker-compose

#基准目录
base_dir=~/ctc-docker

#ctc目录
ctc_dir=${base_dir}/html/ctc

#克隆ctc-docker项目
if [ ! -d ${base_dir} ]; then
  git clone https://gitee.com/koogua/course-tencent-cloud-docker.git ${base_dir}
fi

#克隆ctc项目
if [ ! -d ${ctc_dir} ]; then
  git clone https://gitee.com/koogua/course-tencent-cloud.git ${ctc_dir}
fi

#docker .env文件
docker_env=${base_dir}/.env

#复制环境变量文件
cp ${base_dir}/.env.default ${docker_env}

#替换docker .env配置项
sed -i "s/MYSQL_ROOT_PASSWORD.*/MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}/g" ${docker_env}
sed -i "s/MYSQL_DATABASE.*/MYSQL_DATABASE=${MYSQL_DATABASE}/g" ${docker_env}
sed -i "s/MYSQL_USER.*/MYSQL_USER=${MYSQL_USER}/g" ${docker_env}
sed -i "s/MYSQL_PASSWORD.*/MYSQL_PASSWORD=${MYSQL_PASSWORD}/g" ${docker_env}
sed -i "s/REDIS_PASSWORD.*/REDIS_PASSWORD=${REDIS_PASSWORD}/g" ${docker_env}

#nginx配置目录
nginx_conf_dir=${base_dir}/nginx/conf.d
nginx_default_conf=${nginx_conf_dir}/default.conf

#复制nginx站点配置文件
cp ${nginx_conf_dir}/default.conf.sample ${nginx_default_conf}

#替换nginx　default.conf配置项
sed -i "s/server_name .*/server_name ${SITE_DOMAIN};/g" ${nginx_default_conf}

#ctc config目录
ctc_config_dir=${ctc_dir}/config
ctc_config_php=${ctc_config_dir}/config.php

#复制config.php
cp ${ctc_config_dir}/config.default.php ${ctc_config_php}

#替换config.php配置项
sed -i "s/\$config\['key'\].*/\$config['key'] = '${SITE_KEY}';/g" ${ctc_config_php}
sed -i "s/\$config\['db'\]\['dbname'\].*/\$config['db']['dbname'] = '${MYSQL_DATABASE}';/g" ${ctc_config_php}
sed -i "s/\$config\['db'\]\['username'\].*/\$config['db']['username'] = '${MYSQL_USER}';/g" ${ctc_config_php}
sed -i "s/\$config\['db'\]\['password'\].*/\$config['db']['password'] = '${MYSQL_PASSWORD}';/g" ${ctc_config_php}
sed -i "s/\$config\['redis'\]\['auth'\].*/\$config['redis']['auth'] = '${REDIS_PASSWORD}';/g" ${ctc_config_php}
sed -i "s/\$config\['websocket'\]\['connect_address'\].*/\$config['websocket']['connect_address'] = 'http:\/\/${SITE_DOMAIN}:8282';/g" ${ctc_config_php}

#复制xunsearch配置文件
cp ${ctc_config_dir}/xs.course.default.ini ${ctc_config_dir}/xs.course.ini
cp ${ctc_config_dir}/xs.group.default.ini ${ctc_config_dir}/xs.group.ini
cp ${ctc_config_dir}/xs.user.default.ini ${ctc_config_dir}/xs.user.ini

#切换到基准目录
cd ${base_dir} || exit

#构建镜像
docker-compose build

#启动容器
docker-compose up -d

#导入测试数据
if [ ${SITE_DEMO} == 'on' ]; then

  echo -e "\n------ start import demo data ------\n"

  docker exec -i ctc-mysql bash <<'EOF'

  #安装curl
  apt-get update && apt-get install -y curl

  #下载数据
  curl http://download.koogua.com/ctc-test.sql.gz -o ctc-test.sql.gz

  #导入数据
  gunzip < ctc-test.sql.gz | mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE}

  echo -e "\n------ finish import demo data ------\n"

  exit
EOF

fi

docker exec -i ctc-php bash <<'EOF'

ctc_dir=/var/www/html/ctc

#修改storage目录权限
chmod -R 777 ${ctc_dir}/storage

tmp_sitemap_xml=${ctc_dir}/storage/tmp/sitemap.xml
public_sitemap_xml=${ctc_dir}/public/sitemap.xml

#创建并连接sitemap.xml
if [ ! -e ${tmp_sitemap_xml} ]; then
  touch ${tmp_sitemap_xml}
  ln -s ${tmp_sitemap_xml} ${public_sitemap_xml}
fi

#切换到ctc目录
cd ${ctc_dir}

#安装依赖包
composer install --no-dev
composer dump-autoload --optimize

#执行升级
vendor/bin/phinx migrate

#重建xunsearch索引
php console.php course_index rebuild
php console.php group_index rebuild
php console.php user_index rebuild

exit
EOF

#安装完成
echo -e "\n------ install finished, you can visit your website now. ------\n"
