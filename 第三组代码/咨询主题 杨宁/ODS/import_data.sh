sqoop import \
--connect jdbc:mysql://106.75.33.59:3306/nev \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select id,create_date_time,session_id,sid,create_time,seo_source,seo_keywords,ip,AREA,country,province,city,origin_channel,user as users,manual_time,begin_time,end_time,last_customer_msg_time_stamp,last_agent_msg_time_stamp,reply_msg_count,msg_count,browser_name,os_info, '2022-06-09' as dt from web_chat_ems_2019_07 where 1=1 and \$CONDITIONS" \
--hcatalog-database edu_ods_access \
--hcatalog-table web_chat_ems \
-m 1

sqoop import \
--connect jdbc:mysql://106.75.33.59:3306/nev \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select  *,'2022-06-09' as dt  from web_chat_text_ems_2019_07 where 1=1 and \$CONDITIONS" \
--hcatalog-database edu_ods_access \
--hcatalog-table web_chat_text_ems \
-m 1