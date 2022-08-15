#! /bin/bash
#SQOOP_HOME=/opt/cloudera/parcels/CDH-6.2.1-1.cdh6.2.1.p0.1425774/bin/sqoop
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


#导入'班级课表'
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from course_table_upload_detail where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table course_table_upload_detail \
-m 1
wait
sleep 5


#导入'学生请假申请表'
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from student_leave_apply where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table student_leave_apply \
-m 1
wait
sleep 5


#导入'班级作息时间表'
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from tbh_class_time_table  where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table tbh_class_time_table \
-m 1
wait
sleep 5


#导入'学生打卡记录表'
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from tbh_student_signin_record where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table tbh_student_signin_record \
-m 1
wait
sleep 5

#导入'日历表'
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select * from calendar where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table calendar \
-m 1
wait
sleep 5

#导入'校区表'
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from itcast_school where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table itcast_school \
-m 1
wait
sleep 5


#导入'学科表'
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from itcast_subject where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table itcast_subject \
-m 1
wait
sleep 5


#导入'部门表'
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from scrm_department where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table scrm_department \
-m 1
wait
sleep 5

#导入'班级在读学生人数表'
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from class_studying_student_count where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table class_studying_student_count \
-m 1
wait
sleep 5

#导入'访问咨询记录主表'
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/nev?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from web_chat_ems_2019_07 where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table web_chat_ems_2019_07 \
-m 1
wait
sleep 5

#导入'访问咨询记录副表'
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/nev?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from web_chat_text_ems_2019_07 where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table web_chat_text_ems_2019_07 \
-m 1
wait
sleep 5


#导入'客户静态信息表'
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from customer where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table customer \
-m 1
wait
sleep 5


#导入'线索申诉表'
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from customer_appeal where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table customer_appeal \
-m 1
wait
sleep 5


#导入'客户线索表'
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from customer_clue where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table customer_clue \
-m 1
wait
sleep 5


#导入'客户意向表'
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from customer_relationship where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table customer_relationship \
-m 1
wait
sleep 5


#导入'员工表'
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from employee where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table employee \
-m 1
wait
sleep 5


#导入'报名课程表'
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from itcast_clazz where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table itcast_clazz \
-m 1
wait
sleep 5

echo '========================================'
echo '=================success==============='
echo '========================================'