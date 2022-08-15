SQOOP_HOME=/usr/bin/sqoop

if [[ $1 == "" ]];then
TD_DATE=`date -d '1 days ago' "+%Y-%m-%d"`
else
TD_DATE=$1
fi


# nev------------------------------------------------------


# nev web_chat_ems_2019_07
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect "jdbc:mysql://192.168.88.80:3306/nev?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true" \
--username root \
--password 123456 \
--query 'SELECT *, "'"$TD_DATE"'" as starts_time from web_chat_ems_2019_07 where 1=1 and date_format(create_date_time,"%Y-%m-%d")<="'$TD_DATE'" and $CONDITIONS' \
--hcatalog-database itcast_ods \
--hcatalog-table web_chat_ems \
-m 1 


# nev_chat_text_ems_2019_07
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect "jdbc:mysql://192.168.88.80:3306/nev?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true" \
--username root \
--password 123456 \
--query 'SELECT *, "'"$TD_DATE"'" as starts_time from web_chat_text_ems_2019_07 where 1=1 and $CONDITIONS' \
--hcatalog-database itcast_ods \
--hcatalog-table web_chat_text_ems \
-m 1 


# scrm------------------------------------------------------


# customer
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect "jdbc:mysql://192.168.88.80:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true" \
--username root \
--password 123456 \
--query 'SELECT *, "'"$TD_DATE"'" as starts_time from customer where 1=1 and 
date_format(update_date_time,"%Y-%m-%d") <="'$TD_DATE'" 
and $CONDITIONS' \
--hcatalog-database itcast_ods \
--hcatalog-table customer \
-m 1 


# customer_appeal
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect "jdbc:mysql://192.168.88.80:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true" \
--username root \
--password 123456 \
--query 'SELECT *, "'"$TD_DATE"'" as starts_time from customer_appeal where 1=1
and date_format(update_date_time,"%Y-%m-%d") <="'$TD_DATE'" 
and $CONDITIONS' \
--hcatalog-database itcast_ods \
--hcatalog-table customer_appeal \
-m 1 


# customer_clue
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect "jdbc:mysql://192.168.88.80:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true" \
--username root \
--password 123456 \
--query 'SELECT *, "'"$TD_DATE"'" as starts_time from customer_clue where 1=1 
and date_format(update_date_time,"%Y-%m-%d") <="'$TD_DATE'" 
and $CONDITIONS' \
--hcatalog-database itcast_ods \
--hcatalog-table customer_clue \
-m 1 

# customer_relationship
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect "jdbc:mysql://192.168.88.80:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true" \
--username root \
--password 123456 \
--query 'SELECT *, "'"$TD_DATE"'" as starts_time from customer_relationship where 1=1 
and date_format(update_date_time,"%Y-%m-%d") <="'$TD_DATE'" 
and $CONDITIONS' \
--hcatalog-database itcast_ods \
--hcatalog-table customer_relationship \
-m 1 

# employee
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect "jdbc:mysql://192.168.88.80:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true" \
--username root \
--password 123456 \
--query 'SELECT *, "'"$TD_DATE"'" as starts_time from employee where 1=1 
and date_format(update_date_time,"%Y-%m-%d") <="'$TD_DATE'" 
and $CONDITIONS' \
--hcatalog-database itcast_ods \
--hcatalog-table employee \
-m 1 

# itcast_clazz
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect "jdbc:mysql://192.168.88.80:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true" \
--username root \
--password 123456 \
--query 'SELECT *, "'"$TD_DATE"'" as starts_time from itcast_clazz where 1=1 
and date_format(update_date_time,"%Y-%m-%d") <="'$TD_DATE'" 
and $CONDITIONS' \
--hcatalog-database itcast_ods \
--hcatalog-table itcast_clazz \
-m 1 

# itcast_school
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect "jdbc:mysql://192.168.88.80:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true" \
--username root \
--password 123456 \
--query 'SELECT *, "'"$TD_DATE"'" as starts_time from itcast_school where 1=1 
and date_format(update_date_time,"%Y-%m-%d") <="'$TD_DATE'" 
and $CONDITIONS' \
--hcatalog-database itcast_ods \
--hcatalog-table itcast_school \
-m 1 

# itcast_subject
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect "jdbc:mysql://192.168.88.80:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true" \
--username root \
--password 123456 \
--query 'SELECT *, "'"$TD_DATE"'" as starts_time from itcast_subject where 1=1 
and date_format(update_date_time,"%Y-%m-%d") <="'$TD_DATE'" 
and $CONDITIONS' \
--hcatalog-database itcast_ods \
--hcatalog-table itcast_subject \
-m 1 

# scrm_department
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect "jdbc:mysql://192.168.88.80:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true" \
--username root \
--password 123456 \
--query 'SELECT *, "'"$TD_DATE"'" as starts_time from scrm_department where 1=1 
and date_format(update_date_time,"%Y-%m-%d") <="'$TD_DATE'" 
and $CONDITIONS' \
--hcatalog-database itcast_ods \
--hcatalog-table scrm_department \
-m 1 

# teach------------------------------------------------------


# calendar
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect "jdbc:mysql://192.168.88.80:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true" \
--username root \
--password 123456 \
--query 'SELECT *, "'"$TD_DATE"'" as starts_time from calendar where 1=1 and $CONDITIONS' \
--hcatalog-database itcast_ods \
--hcatalog-table calendar \
-m 1 


# class_studying_student_count
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect "jdbc:mysql://192.168.88.80:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true" \
--username root \
--password 123456 \
--query 'SELECT *, "'"$TD_DATE"'" as starts_time from class_studying_student_count where 1=1 and $CONDITIONS' \
--hcatalog-database itcast_ods \
--hcatalog-table class_studying_student_count \
-m 1 


# course_table_upload_detail
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect "jdbc:mysql://192.168.88.80:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true" \
--username root \
--password 123456 \
--query 'SELECT *, "'"$TD_DATE"'" as starts_time from course_table_upload_detail where 1=1 
and $CONDITIONS' \
--hcatalog-database itcast_ods \
--hcatalog-table course_table_upload_detail \
-m 1



# student_leave_apply
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect "jdbc:mysql://192.168.88.80:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true" \
--username root \
--password 123456 \
--query 'SELECT *, "'"$TD_DATE"'" as starts_time from student_leave_apply where 1=1 
and date_format(create_time,"%Y-%m-%d")<="'$TD_DATE'"  
and $CONDITIONS' \
--hcatalog-database itcast_ods \
--hcatalog-table student_leave_apply \
-m 1 

# tbh_class_time_table
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect "jdbc:mysql://192.168.88.80:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true" \
--username root \
--password 123456 \
--query 'SELECT *, "'"$TD_DATE"'" as starts_time from tbh_class_time_table where 1=1 
and date_format(create_time,"%Y-%m-%d")<="'$TD_DATE'"  
and $CONDITIONS' \
--hcatalog-database itcast_ods \
--hcatalog-table tbh_class_time_table \
-m 1 

# tbh_student_signin_record
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect "jdbc:mysql://192.168.88.80:3306/teach?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true" \
--username root \
--password 123456 \
--query 'SELECT *, "'"$TD_DATE"'" as starts_time from tbh_student_signin_record where 1=1 
and date_format(signin_time,"%Y-%m-%d")<="'$TD_DATE'" 
and $CONDITIONS' \
--hcatalog-database itcast_ods \
--hcatalog-table tbh_student_signin_record \
-m 1 
