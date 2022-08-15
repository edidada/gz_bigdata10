#! /bin/bash

export LANG=zh_CN.UTF-8
SQOOP_HOME=/usr/bin/sqoop
HIVE_HOME=/usr/bin/hive

if [[ $1 == '' ]];then
    TD_DATE=`date -d '1 days ago' "+%Y-%m-%d"`
else
    TD_DATE=$1
fi

echo '========================================'
echo '==============开始全量导出==============='
echo '========================================'

/usr/bin/sqoop export \
--connect 'jdbc:mysql://192.168.88.80:3306/edu_result?useUnicode=true&characterEncoding=utf-8' \
--username root \
--password 123456 \
--table class_attendance_dm \
--hcatalog-database edu_dm \
--hcatalog-table class_attendance_dm \
-m 1

echo '========================================'
echo '=================success==============='
echo '========================================'