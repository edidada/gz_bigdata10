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
echo '==============开始全量导入==============='
echo '========================================'

/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *,'${TD_DATE}' as dt from calendar where 1=1 and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table calendar \
-m 5 \
--split-by id

wait
sleep 5

/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *,'${TD_DATE}' as dt from class_studying_student_count where 1=1 and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table class_studying_student_count \
-m 5 \
--split-by id

wait
sleep 5

/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *,'${TD_DATE}' as dt from course_table_upload_detail where 1=1 and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table course_table_upload_detail \
-m 5 \
--split-by id

wait
sleep 5

/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *,'${TD_DATE}' as dt from student_leave_apply where 1=1 and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table student_leave_apply \
-m 5 \
--split-by id

wait
sleep 5

/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *,'${TD_DATE}' as dt from tbh_class_time_table where 1=1 and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table tbh_class_time_table \
-m 5 \
--split-by id

wait
sleep 5

/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *,'${TD_DATE}' as dt from tbh_student_signin_record where 1=1 and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table tbh_student_signin_record \
-m 5 \
--split-by id

echo '========================================'
echo '=================success==============='
echo '========================================'