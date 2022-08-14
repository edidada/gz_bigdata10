#! /bin/bash

SQOOP_HOME=/usr/bin/sqoop

if [[ $1 == '' ]];
then 
# 没传参时，采集昨天的数据
   dateStr=`date -d '-1 day' +'%Y-%m-%d'`
   tableMonth=`date -d '-1 day' +'%Y_%m'`
else 
# 根据传参，指定日期去采集数据
   dateStr=$1
   tableMonth=`date -d $1 +'%Y_%m'`
fi

echo ${dateStr}
echo ${tableMonth}

jdbcUrl1='jdbc:mysql://192.168.88.80:3306/nev?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true'
jdbcUrl2='jdbc:mysql://192.168.88.80:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true'
jdbcUrl3='jdbc:mysql://192.168.88.80:3306/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true'
username='root'
password='123456'


echo '================================================='
echo '==================teach表导入===================='
echo '================================================='

${SQOOP_HOME} import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect ${jdbcUrl3} \
--username ${username} \
--password ${password} \
--query "select *,'${dateStr}' as dt from calendar where 1=1 and  \$CONDITIONS" \
--hcatalog-database jy_ods \
--hcatalog-table calendar \
-m 1


sleep 2

${SQOOP_HOME} import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect ${jdbcUrl3} \
--username ${username} \
--password ${password} \
--query "select *,'${dateStr}' as dt from class_studying_student_count where 1=1 and  \$CONDITIONS" \
--hcatalog-database jy_ods \
--hcatalog-table class_studying_student_count \
-m 1


sleep 2

${SQOOP_HOME} import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect ${jdbcUrl3} \
--username ${username} \
--password ${password} \
--query "select *,'${dateStr}' as dt from course_table_upload_detail where 1=1 and \$CONDITIONS" \
--hcatalog-database jy_ods \
--hcatalog-table course_table_upload_detail \
-m 1


sleep 2

${SQOOP_HOME} import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect ${jdbcUrl3} \
--username ${username} \
--password ${password} \
--query "select *,'${dateStr}' as dt from student_leave_apply where 1=1 and \$CONDITIONS" \
--hcatalog-database jy_ods \
--hcatalog-table student_leave_apply \
-m 1


sleep 2

${SQOOP_HOME} import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect ${jdbcUrl3} \
--username ${username} \
--password ${password} \
--query "select *,'${dateStr}' as dt from tbh_class_time_table where 1=1 and \$CONDITIONS" \
--hcatalog-database jy_ods \
--hcatalog-table tbh_class_time_table \
-m 1


sleep 2

${SQOOP_HOME} import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect ${jdbcUrl3} \
--username ${username} \
--password ${password} \
--query "select *,'${dateStr}' as dt from tbh_student_signin_record where 1=1 and \$CONDITIONS" \
--hcatalog-database jy_ods \
--hcatalog-table tbh_student_signin_record \
-m 1 
 


echo '==============================================='
echo '===================导入结束===================='
echo '==============================================='