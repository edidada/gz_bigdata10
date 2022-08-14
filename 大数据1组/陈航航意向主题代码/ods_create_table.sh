#! /bin/bash

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

# 全量 web_chat_ems
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://106.75.33.59:3306/nev?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select * from web_chat_ems_2019_07 where 1=1 and  \$CONDITIONS" \
--hcatalog-database itcast_ods \
--hcatalog-table web_chat_ems \
--hcatalog-partition-keys starts_time \
--hcatalog-partition-values ${TD_DATE} \
-m 1
wait
sleep 3

# web_chat_text_ems_2019_07
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://106.75.33.59:3306/nev?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select * from web_chat_text_ems_2019_07 where 1=1 and  \$CONDITIONS" \
--hcatalog-database itcast_ods \
--hcatalog-table web_chat_ems_test \
--hcatalog-partition-keys starts_time \
--hcatalog-partition-values ${TD_DATE} \
-m 1

#

echo '========================================'
echo '==============导入成功 ^_^ =============='
echo '========================================'