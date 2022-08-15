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

# 日历表
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://106.75.33.59:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *,'${TD_DATE}' as dt from calendar where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table calendar \
-m 1

# 班级在读人数
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://106.75.33.59:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *,'${TD_DATE}' as dt from class_studying_student_count where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table class_studying_student_count \
-m 1

# 班级课表
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://106.75.33.59:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *,'${TD_DATE}' as dt from course_table_upload_detail where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table course_table_upload_detail \
-m 1

# 学生请假申请表
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://106.75.33.59:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *,'${TD_DATE}' as dt from student_leave_apply where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table student_leave_apply \
-m 1


# 班级作息时间表
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://106.75.33.59:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *,'${TD_DATE}' as dt from tbh_class_time_table where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table tbh_class_time_table \
-m 1


# 学生打卡记录表
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://106.75.33.59:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *,'${TD_DATE}' as dt from tbh_student_signin_record where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table tbh_student_signin_record \
-m 1


