#! /bin/bash

export LANG=zh_CN.UTF-8
SQOOP_HOME=/usr/bin/sqoop
if [[ $1 == "" ]];then
   TD_DATE=`date -d '1 days ago' "+%Y-%m-%d"`
else
   TD_DATE=$1
fi

echo '========================================'
echo '==============开始全量导入==============='
echo '========================================'


# 全量 web_chat_ems
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.88.80:3306/nev?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select * from web_chat_ems_2019_07 where 1=1 and  \$CONDITIONS" \
--hcatalog-database itcast_ods \
--hcatalog-table web_chat_ems \
--hcatalog-partition-keys starts_time \
--hcatalog-partition-values ${TD_DATE} \
-m 1
wait


# web_chat_text_ems_2019_07
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.88.80:3306/nev?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select * from web_chat_text_ems_2019_07 where 1=1 and  \$CONDITIONS" \
--hcatalog-database itcast_ods \
--hcatalog-table web_chat_ems_test \
--hcatalog-partition-keys starts_time \
--hcatalog-partition-values ${TD_DATE} \
-m 1
wait
#

echo '========================================'
echo '==============导入成功 ^_^ =============='
echo '========================================'


# 全量customer
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.88.80:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select * from customer where 1=1 and  \$CONDITIONS" \
--hcatalog-database scrm_ods \
--hcatalog-table customer \
--hcatalog-partition-keys dt \
--hcatalog-partition-values ${TD_DATE} \
-m 1
wait

#customer_appeal
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.88.80:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select * from customer_appeal where 1=1 and  \$CONDITIONS" \
--hcatalog-database scrm_ods \
--hcatalog-table customer_appeal \
--hcatalog-partition-keys dt \
--hcatalog-partition-values ${TD_DATE} \
-m 1
wait

#customer_clue
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.88.80:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select * from customer_clue where 1=1 and  \$CONDITIONS" \
--hcatalog-database scrm_ods \
--hcatalog-table customer_clue \
--hcatalog-partition-keys dt \
--hcatalog-partition-values ${TD_DATE} \
-m 1
wait

#customer_relationship
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.88.80:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select * from customer_relationship where 1=1 and  \$CONDITIONS" \
--hcatalog-database scrm_ods \
--hcatalog-table customer_relationship \
--hcatalog-partition-keys dt \
--hcatalog-partition-values ${TD_DATE} \
-m 1
wait

#employee
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.88.80:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select * from employee where 1=1 and  \$CONDITIONS" \
--hcatalog-database scrm_ods \
--hcatalog-table employee \
--hcatalog-partition-keys dt \
--hcatalog-partition-values ${TD_DATE} \
-m 1
wait

#itcast_clazz
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.88.80:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select * from itcast_clazz where 1=1 and  \$CONDITIONS" \
--hcatalog-database scrm_ods \
--hcatalog-table itcast_clazz \
--hcatalog-partition-keys dt \
--hcatalog-partition-values ${TD_DATE} \
-m 1
wait

#itcast_school
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.88.80:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select * from itcast_school where 1=1 and  \$CONDITIONS" \
--hcatalog-database scrm_ods \
--hcatalog-table itcast_school \
--hcatalog-partition-keys dt \
--hcatalog-partition-values ${TD_DATE} \
-m 1
wait

# itcast_subject
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.88.80:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select * from  itcast_subject where 1=1 and  \$CONDITIONS" \
--hcatalog-database scrm_ods \
--hcatalog-table  itcast_subject \
--hcatalog-partition-keys dt \
--hcatalog-partition-values ${TD_DATE} \
-m 1
wait

# scrm_department
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.88.80:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select * from  scrm_department where 1=1 and  \$CONDITIONS" \
--hcatalog-database scrm_ods \
--hcatalog-table  iscrm_department \
--hcatalog-partition-keys dt \
--hcatalog-partition-values ${TD_DATE} \
-m 1
wait

# 全量
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.88.80:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select * from calendar where 1=1 and  \$CONDITIONS" \
--hcatalog-database zxedu_ods \
--hcatalog-table dim_calendar \
-m 1
wait


# 增量
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from class_studying_student_count where 1=1 and \$CONDITIONS" \
--hcatalog-database zxedu_ods \
--hcatalog-table dim_class_studying_student_count_dimen \
-m 1
wait


# 新增
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from student_leave_apply where 1=1 and \$CONDITIONS" \
--hcatalog-database zxedu_ods \
--hcatalog-table fact_student_leave_apply_ods \
-m 1
wait

#
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from tbh_student_signin_record where 1=1 and \$CONDITIONS" \
--hcatalog-database zxedu_ods \
--hcatalog-table fact_student_signin_ods \
-m 1
wait

/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from course_table_upload_detail where 1=1 and \$CONDITIONS" \
--hcatalog-database zxedu_ods \
--hcatalog-table  dim_course_table_upload_detail_dimen \
-m 1
wait


/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from tbh_class_time_table where 1=1 and \$CONDITIONS" \
--hcatalog-database zxedu_ods \
--hcatalog-table  dim_class_time_dimen \
-m 1



echo '========================================'
echo '==============导入成功下班吃饭==============='
echo '========================================'