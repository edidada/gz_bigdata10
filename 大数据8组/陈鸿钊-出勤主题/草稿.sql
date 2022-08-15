/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '2022-08-08' as dt from course_table_upload_detail where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table course_table_upload_detail \
-m 1