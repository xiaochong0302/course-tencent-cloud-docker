#!/usr/bin/env bash

#ctc目录
CTC_DIR=~/ctc-docker/html/ctc

#更新源码
cd ${CTC_DIR} && git pull

docker exec -i ctc-php bash <<'EOF'

#切换到ctc目录
cd /var/www/html/ctc || exit

#安装依赖包
composer install --no-dev
composer dump-autoload --optimize

#数据迁移
vendor/bin/phinx migrate

#程序升级
php console.php upgrade

exit
EOF

echo -e "\n------ upgrade finished -------\n"
