
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
--connect 'jdbc:mysql://192.168.89.168:3306/nev?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '2022-03-12' as dt from web_chat_ems_2019_07 where 1=1 and (create_time between '1970-01-01 00:00:00' and '2022-03-12 23:59:59') and  \$CONDITIONS" \
--hcatalog-database oe_ods \
--hcatalog-table web_chat_ems_2019_07 \
-m 1
