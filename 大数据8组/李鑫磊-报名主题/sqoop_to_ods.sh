if [[ $1 == "" ]];then
   TD_DATE=`date -d '1 days ago' "+%Y-%m-%d"`
else
   TD_DATE=$1
fi

echo '========================================'
echo '==============开始全量导入==============='
echo '========================================'





echo '========================================'
echo '==============2.开始导入itcast_clazz==============='
echo '========================================'



# 全量
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--driver 'com.mysql.jdbc.Driver' \
--connect 'jdbc:mysql://192.168.88.80:3306/scrm?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *,'${TD_DATE}' as dt from customer_clue where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table customer_clue \
-m 1
wait
spleep 5

