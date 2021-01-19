#!/usr/bin/env bash

docker exec -i ctc-mysql bash <<'EOF'

#数据库名称
db_name=ctc

#数据库用户
db_user=ctc

#数据库密码
db_pwd=1qaz2wsx3edc

#备份目录(不要修改,末尾不带"/")
backup_dir=/var/lib/mysql/backup

#备份保留天数
backup_days=15

#创建备份目录
if [ ! -d ${backup_dir} ]; then
  mkdir -p ${backup_dir}
fi

#导出数据
mysqldump --no-tablespaces -u ${db_user} -p${db_pwd} ${db_name} | gzip > ${backup_dir}/${db_name}-$(date +%Y-%m-%d).sql.gz

#待删过期备份文件
rm_filename=${backup_dir}/${db_name}-$(date -d -${backup_days}day +%Y-%m-%d).sql.gz

#删除过期备份文件
if [ `ls -l ${backup_dir} | grep sql.gz | wc -l` -gt ${backup_days} ]; then
  if [ -e ${rm_filename} ]; then
    rm -f ${rm_filename}
  fi
fi

exit
EOF

#本地目录(根据实际调整,末尾带"/")
local_dir=/home/ubuntu/ctc-docker/mysql/data/backup/

#远程目录(根据实际调整,末尾带"/")
remote_dir=/backup/database/

#同步备份
coscmd upload -rs ${local_dir} ${remote_dir}
