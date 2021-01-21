#!/usr/bin/env bash

# ----------- 请根据实际情况，修改如下配置 ------------ #

#mysql项目数据库名称
MYSQL_DATABASE=ctc

#mysql项目数据库用户
MYSQL_USER=ctc

#mysql项目数据库密码
MYSQL_PASSWORD=1qaz2wsx3edc

#备份保留天数
KEEP_DAYS=15

#本地目录(根据实际调整，绝对路径，末尾带"/")
LOCAL_DIR=/home/root/ctc-docker/mysql/data/backup/

#远程目录(根据实际调整，末尾带"/")
REMOTE_DIR=/backup/database/

# ------------ @@@ 以下内容，非专业人士请勿修改，新手请远离！ @@@ ------------- #

docker exec -i ctc-mysql bash <<'EOF'

#备份目录(末尾不带"/")
backup_dir=/var/lib/mysql/backup

#创建备份目录
if [ ! -d ${backup_dir} ]; then
  mkdir -p ${backup_dir}
fi

#导出数据
mysqldump --no-tablespaces -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} | gzip > ${backup_dir}/${MYSQL_DATABASE}-$(date +%Y-%m-%d).sql.gz

#待删过期备份文件
rm_filename=${backup_dir}/${MYSQL_DATABASE}-$(date -d -${KEEP_DAYS}day +%Y-%m-%d).sql.gz

#删除过期备份文件
if [ `ls -l ${backup_dir} | grep sql.gz | wc -l` -gt ${KEEP_DAYS} ]; then
  if [ -e ${rm_filename} ]; then
    rm -f ${rm_filename}
  fi
fi

exit
EOF

#同步备份
coscmd upload -rs ${LOCAL_DIR} ${REMOTE_DIR}
