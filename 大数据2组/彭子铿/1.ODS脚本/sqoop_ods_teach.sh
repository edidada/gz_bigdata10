
onnector-name：驱动类型
rt LANG=zh_CN.UTF-8
SQOOP_HOME=/usr/bin/sqoop
if [[ $1 == "" ]];then
   TD_DATE=`date -d '1 days ago' "+%Y-%m-%d"`
else
   TD_DATE=$1
fi

# 全量
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.89.168:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from calendar where 1=1 and  \$CONDITIONS" \
--hcatalog-database oe_ods \
--hcatalog-table calendar \
-m 1
wait
spleep 5
# 2
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.89.168:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from class_studying_student_count where 1=1 and  \$CONDITIONS" \
--hcatalog-database oe_ods \
--hcatalog-table class_studying_student_count \
-m 1
wait
spleep 5
# 3
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.89.168:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from course_table_upload_detail where 1=1 and  \$CONDITIONS" \
--hcatalog-database oe_ods \
--hcatalog-table course_table_upload_detail \
-m 1
wait
spleep 5

# 3备份
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.89.168:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from course_table_upload_detail where 1=1 and  \$CONDITIONS" \
--hcatalog-database oe_ods \
--hcatalog-table course_table_upload_detail_1 \
-m 1
wait
spleep 5
# 4
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.89.168:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from student_leave_apply where 1=1 and  \$CONDITIONS" \
--hcatalog-database oe_ods \
--hcatalog-table student_leave_apply \
-m 1
wait
spleep 5
# 5
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.89.168:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from tbh_class_time_table where 1=1 and  \$CONDITIONS" \
--hcatalog-database oe_ods \
--hcatalog-table tbh_class_time_table \
-m 1
wait
spleep 5
# 6
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.89.168:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from tbh_student_signin_record where 1=1 and  \$CONDITIONS" \
--hcatalog-database oe_ods \
--hcatalog-table tbh_student_signin_record \
-m 1

