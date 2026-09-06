date=$(date -d yesterday +%Y%m%d)

#删除15天前的日志
find /var/log/nginx -mtime +15 -type f -name 'ctc.access.*.log' -print0 | xargs -0 rm -f
find /var/log/nginx -mtime +15 -type f -name 'ctc.error.*.log' -print0 | xargs -0 rm -f

#重命名日志文件
mv /var/log/nginx/ctc.access.log /var/log/nginx/ctc.access."${date}".log
mv /var/log/nginx/ctc.error.log /var/log/nginx/ctc.error."${date}".log

#向nginx主进程发送信号以重新打开日志
kill -USR1 "$(cat /var/run/nginx.pid)"