#! /bin/bash
#SQOOP_HOME=/opt/cloudera/parcels/CDH-6.2.1-1.cdh6.2.1.p0.1425774/bin/sqoop
export LANG=zh_CN.UTF-8
export ACCUMULO_HOME=/var/lib/accumulo
SQOOP_HOME=/usr/bin/sqoop
if [[ $1 == "" ]]
then
   TD_DATE=`date -d '1 days ago' "+%Y-%m-%d"`
else
   TD_DATE=$1
fi
echo ${TD_DATE}
echo '========================================'
echo '==============开始全量导入==============='
echo '========================================'

echo '=========== mysql数据库 customer_relationship    --->>>  ods层 t_customer_relationship======================'
${SQOOP_HOME} import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from customer_relationship where 1=1 and  \$CONDITIONS" \
--hcatalog-database itcast_ods \
--hcatalog-table t_customer_relationship \
-m 1
echo '========================================'
echo '=========== 完成！！！mysql数据库 customer_relationship    --->>>  ods层 t_customer_relationship======================'
echo '========================================'
wait



#sleep 2
#echo ''
#echo '=========== mysql数据库 itcast_clazz    --->>>  ods层 t_itcast_clazz======================'
#sleep 2
#${SQOOP_HOME} import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '${TD_DATE}' as dt from itcast_clazz where 1=1 and  \$CONDITIONS" \
#--hcatalog-database itcast_ods \
#--hcatalog-table t_itcast_clazz \
#-m 1
#echo '========================================'
#echo '=========== 完成！！！mysql数据库 itcast_clazz    --->>>  ods层 t_itcast_clazz======================'
#echo '========================================'
#wait




# 全量------------------------------------------------------------------------------------------------------------
# 全量------------------------------------------------------------------------------------------------------------
#      从业务库             --->>>           ODS层表    
# customer_relationship    --->>>   t_customer_relationship
#
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '2022-08-08' as dt from customer_relationship where 1=1 and  \$CONDITIONS" \
#--hcatalog-database itcast_ods \
#--hcatalog-table t_customer_relationship \
#-m 1

#wait
#sleep 2
#echo ''
#echo '===========customer_appeal    --->>>   t_customer_appeal======================'
#sleep 5
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '2022-08-08' as dt from customer_appeal where 1=1 and  \$CONDITIONS" \
#--hcatalog-database itcast_ods \
#--hcatalog-table t_customer_appeal \
#-m 1

#wait
#sleep 2
#echo ''
#echo '===========customer_clue    --->>>   t_customer_clue======================'
#sleep 5
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select id,create_date_time,update_date_time,deleted,customer_id,customer_relationship_id,session_id,sid,status, user as users ,create_time,platform,s_name,seo_source,seo_keywords,ip,referrer,from_url,landing_page_url,url_title,to_peer,begin_time,reply_msg_count,total_msg_count,msg_count,comment,finish_reason,finish_user,end_time,platform_description,browser_name,os_info,area,country,province,city,creator,name,idcard,phone,itcast_school_id,itcast_school,itcast_subject_id,itcast_subject,wechat,qq,email,gender,level,origin_type,information_way,working_years,technical_directions,customer_state,valid,anticipat_signup_date,clue_state,scrm_department_id,superior_url,superior_source,landing_url,landing_source,info_url,info_source,origin_channel,course_id,course_name,zhuge_session_id,is_repeat,tenant,activity_id,activity_name,follow_type,shunt_mode_id,shunt_employee_group_id, '2022-08-08' as dt from customer_clue where 1=1 and  \$CONDITIONS" \
#--hcatalog-database itcast_ods \
#--hcatalog-table t_customer_clue \
#-m 1


#wait
#sleep 2
#echo ''
#echo '===========employee    --->>>  t_employee======================'
#sleep 5
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '2022-08-08' as dt from employee where 1=1 and  \$CONDITIONS" \
#--hcatalog-database itcast_ods \
#--hcatalog-table t_employee \
#-m 1


#wait
#sleep 2
#echo ''
#echo '===========itcast_clazz    --->>>  t_itcast_clazz======================'
#sleep 5
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '2022-08-08' as dt from itcast_clazz where 1=1 and  \$CONDITIONS" \
#--hcatalog-database itcast_ods \
#--hcatalog-table t_itcast_clazz \
#-m 1

#wait
#sleep 2
#echo ''
#echo '===========scrm_department    --->>>  t_scrm_department======================'
#sleep 5
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '2022-08-08' as dt from scrm_department where 1=1 and  \$CONDITIONS" \
#--hcatalog-database itcast_ods \
#--hcatalog-table t_scrm_department \
#-m 1


echo '========================================'
echo '=================success==============='
echo '========================================'
# 全量
# 从业务库 --> ODS层表    
# web_chat_ems_2019_07    ->   web_chat_ems
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/nev?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '2022-08-08' as dt from web_chat_ems_2019_07 where 1=1 and (create_time between '1970-01-01 00:00:00' and '2022-03-12 23:59:59') and  \$CONDITIONS" \
#--hcatalog-database itcast_ods \
#--hcatalog-table web_chat_ems \
#-m 1


# web_chat_ems_2019_07    ->   web_chat_ems
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/nev?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '2022-08-08' as dt from web_chat_text_ems_2019_07 where 1=1 and \$CONDITIONS" \
#--hcatalog-database itcast_ods \
#--hcatalog-table web_chat_text_ems \
#-m 1


#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--driver 'com.mysql.jdbc.Driver' \
#--connect 'jdbc:mysql://106.75.33.59:3306/nev?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username itcast_edu_stu \
#--password itcast_edu_stu \
#--query "select \
#id,\
#create_date_time,\
#session_id,\
#sid,\
#create_time,\
#seo_source,\
#seo_keywords,\
#ip,\
#area,\
#country,\
#province,\
#city,\
#origin_channel,\
#user as user_match,\
#manual_time,\
#begin_time,\
#end_time,\
#last_customer_msg_time_stamp,\
#last_agent_msg_time_stamp,\
#reply_msg_count,\
#msg_count,\
#browser_name,\
#os_info,\
#'${TD_DATE}' as starts_time from web_chat_ems_2019_07 where 1=1 and  \$CONDITIONS" \
#--hcatalog-database itcast_ods \
#--hcatalog-table web_chat_ems \
#-m 10 \
#--split-by id
#wait
#sleep 5
#
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/yipin?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select * from t_date where 1=1 and  \$CONDITIONS" \
#--hcatalog-database banji_xingming_ods \
#--hcatalog-table t_date \
#-m 1
#wait
#sleep 5
#
## 增量
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/yipin?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '${TD_DATE}' as dt from t_goods_evaluation where 1=1 and \$CONDITIONS" \
#--hcatalog-database banji_xingming_ods \
#--hcatalog-table t_goods_evaluation \
#-m 1
#wait
#sleep 5
#
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/yipin?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '${TD_DATE}' as dt from t_user_login where 1=1 and  \$CONDITIONS" \
#--hcatalog-database banji_xingming_ods \
#--hcatalog-table t_user_login \
#-m 1
#wait
#sleep 5
#
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/yipin?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '${TD_DATE}' as dt from t_order_pay where 1=1 and  \$CONDITIONS" \
#--hcatalog-database banji_xingming_ods \
#--hcatalog-table t_order_pay \
#-m 1
#wait
#sleep 5
#
## 新增和更新同步
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/yipin?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '${TD_DATE}' as dt from t_store where 1=1 and \$CONDITIONS" \
#--hcatalog-database banji_xingming_ods \
#--hcatalog-table t_store \
#-m 1
#wait
#sleep 5
#
#/usr/bin/sqoop import -Dorg.apache.sqoop.splitter.allow_text_splitter=true -Dorg.apache.sqoop.db.type=mysql \
#--connect 'jdbc:mysql://192.168.88.80:3306/yipin?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '${TD_DATE}' as dt from t_trade_area where 1=1 and \$CONDITIONS" \
#--hcatalog-database banji_xingming_ods \
#--hcatalog-table t_trade_area \
#-m 1
#wait
#sleep 5
#
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/yipin?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '${TD_DATE}' as dt from t_location where 1=1 and \$CONDITIONS" \
#--hcatalog-database banji_xingming_ods \
#--hcatalog-table t_location \
#-m 1
#wait
#sleep 5
#
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/yipin?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '${TD_DATE}' as dt from t_goods where 1=1 and \$CONDITIONS" \
#--hcatalog-database banji_xingming_ods \
#--hcatalog-table t_goods \
#-m 1
#wait
#sleep 5
#
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/yipin?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '${TD_DATE}' as dt from t_goods_class where 1=1 and  \$CONDITIONS" \
#--hcatalog-database banji_xingming_ods \
#--hcatalog-table t_goods_class \
#-m 1
#wait
#sleep 5
#
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/yipin?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '${TD_DATE}' as dt from t_brand where 1=1 and \$CONDITIONS" \
#--hcatalog-database banji_xingming_ods \
#--hcatalog-table t_brand \
#-m 1
#wait
#sleep 5
#
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/yipin?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '${TD_DATE}' as dt from t_shop_order where 1=1 and  \$CONDITIONS" \
#--hcatalog-database banji_xingming_ods \
#--hcatalog-table t_shop_order \
#-m 1
#wait
#sleep 5
#
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/yipin?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '${TD_DATE}' as dt from t_shop_order_address_detail where 1=1 and  \$CONDITIONS" \
#--hcatalog-database banji_xingming_ods \
#--hcatalog-table t_shop_order_address_detail \
#-m 1
#wait
#sleep 5
#
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/yipin?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '${TD_DATE}' as dt from t_order_settle where 1=1 and  \$CONDITIONS" \
#--hcatalog-database banji_xingming_ods \
#--hcatalog-table t_order_settle \
#-m 1
#wait
#sleep 5
#
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/yipin?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '${TD_DATE}' as dt from t_refund_order where 1=1 and  \$CONDITIONS" \
#--hcatalog-database banji_xingming_ods \
#--hcatalog-table t_refund_order \
#-m 1
#wait
#sleep 5
#
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/yipin?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '${TD_DATE}' as dt from t_shop_order_group where 1=1 and  \$CONDITIONS" \
#--hcatalog-database banji_xingming_ods \
#--hcatalog-table t_shop_order_group \
#-m 1
#wait
#sleep 5
#
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/yipin?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '${TD_DATE}' as dt from t_shop_order_goods_details where 1=1 and  \$CONDITIONS" \
#--hcatalog-database banji_xingming_ods \
#--hcatalog-table t_shop_order_goods_details \
#-m 1
#wait
#sleep 5
#
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/yipin?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '${TD_DATE}' as dt from t_shop_cart where 1=1 and  \$CONDITIONS" \
#--hcatalog-database banji_xingming_ods \
#--hcatalog-table t_shop_cart \
#-m 1
#wait
#sleep 5
#
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/yipin?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '${TD_DATE}' as dt from t_store_collect where 1=1 and  \$CONDITIONS" \
#--hcatalog-database banji_xingming_ods \
#--hcatalog-table t_store_collect \
#-m 1
#wait
#sleep 5
#
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/yipin?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '${TD_DATE}' as dt from t_goods_collect where 1=1 and  \$CONDITIONS" \
#--hcatalog-database banji_xingming_ods \
#--hcatalog-table t_goods_collect \
#-m 1
#wait
#sleep 5
#
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/yipin?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '${TD_DATE}' as dt from t_order_delievery_item where 1=1 and  \$CONDITIONS" \
#--hcatalog-database banji_xingming_ods \
#--hcatalog-table t_order_delievery_item \
#-m 1
#wait
#sleep 5
#
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/yipin?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '${TD_DATE}' as dt from t_goods_evaluation_detail where 1=1 and  \$CONDITIONS" \
#--hcatalog-database banji_xingming_ods \
#--hcatalog-table t_goods_evaluation_detail \
#-m 1
#wait
#sleep 5
#
#/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
#--connect 'jdbc:mysql://192.168.88.80:3306/yipin?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
#--username root \
#--password 123456 \
#--query "select *, '${TD_DATE}' as dt from t_trade_record where 1=1 and  \$CONDITIONS" \
#--hcatalog-database banji_xingming_ods \
#--hcatalog-table t_trade_record \
#-m 1
#wait
#sleep 5

