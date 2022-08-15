#! /bin/bash

export LANG=zh_CN.UTF-8
SQOOP_HOME=/usr/bin/sqoop
if [[ $1 == "" ]];then
   TD_DATE=`date -d '1 days ago' "+%Y-%m-%d"`
else
   TD_DATE=$1
fi



# 全量
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.89.168:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '2022-03-12' as dt from customer where 1=1 and  \$CONDITIONS" \
--hcatalog-database oe_ods \
--hcatalog-table customer \
-m 1
wait
sleep 5


/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.89.168:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '2022-03-12' as dt from customer_relationship where 1=1 and  \$CONDITIONS" \
--hcatalog-database oe_ods \
--hcatalog-table customer_relationship \
-m 1
wait
sleep 5


/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.89.168:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '2022-03-12' as dt from customer_clue where 1=1 and  \$CONDITIONS" \
--hcatalog-database oe_ods \
--hcatalog-table customer_clue \
-m 1
wait
sleep 5


/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.89.168:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '2022-03-12' as dt from employee where 1=1 and  \$CONDITIONS" \
--hcatalog-database oe_ods \
--hcatalog-table employee \
-m 1
wait
sleep 5


/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.89.168:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '2022-03-12' as dt from scrm_department where 1=1 and  \$CONDITIONS" \
--hcatalog-database oe_ods \
--hcatalog-table scrm_department \
-m 1
wait
sleep 5


/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.89.168:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '2022-03-12' as dt from itcast_school where 1=1 and  \$CONDITIONS" \
--hcatalog-database oe_ods \
--hcatalog-table itcast_school \
-m 1
wait
sleep 5


/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.89.168:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '2022-03-12' as dt from itcast_subject where 1=1 and  \$CONDITIONS" \
--hcatalog-database oe_ods \
--hcatalog-table itcast_subject \
-m 1
wait
sleep 5


/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.89.168:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '2022-03-12' as dt from customer_appeal where 1=1 and \$CONDITIONS" \
--hcatalog-database oe_ods \
--hcatalog-table customer_appeal \
-m 1
wait
sleep 5







/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.89.168:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *,'2022-03-12' as dt from customer_appeal where 1=1 and \$CONDITIONS" \
--hcatalog-database oe_ods \
--hcatalog-table customer_appeal \
-m 1
wait
sleep 5


/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.89.168:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '2022-03-12' as dt from itcast_clazz where 1=1 and  \$CONDITIONS" \
--hcatalog-database oe_ods \
--hcatalog-table itcast_clazz \
-m 1
wait
sleep 5
