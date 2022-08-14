# class_studying_student_count
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '2022-08-08' as dt 
from class_studying_student_count where 1=1 
and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table class_studying_student_count_dimen \
-m 1


# course_table_upload_detail
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '2022-08-08' as dt 
from course_table_upload_detail where 1=1 
and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table course_table_upload_detail_dimen \
-m 1


# student_leave_apply
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '2022-08-08' as dt 
from student_leave_apply where 1=1 
and (create_time between '1970-01-01 00:00:00' and '2022-08-08 23:59:59') 
and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table student_leave_apply_ods \
-m 1


# tbh_class_time_table
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '2022-08-08' as dt 
from tbh_class_time_table 
where 1=1 
and (create_time between '1970-01-01 00:00:00' and '2022-08-08 23:59:59') 
and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table class_time_dimen \
-m 1


# tbh_student_signin_record
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '2022-08-08' as dt 
from tbh_student_signin_record where 1=1
and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table student_signin_ods \
-m 1
