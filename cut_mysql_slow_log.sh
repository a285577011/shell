#!/bin/bash
#story: mysql慢日志切割
logdir='/usr/local/mysql/var/'
slowlog='hans27-slow.log'
slowdir=$logdir'/slow_log/'
if [ ! -d "$slowdir" ]; then
  mkdir "$slowdir"
fi
mv $logdir$slowlog $slowdir/slow_query_`date +%Y%m%d%H`.log
#mysqladmin -uusername -ppasswd  flush-logs 刷新日志(binlog,慢日志等)
