#! /bin/bash
SQOOP_HOME=/usr/bin/sqoop
export LANG=zh_CN.UTF-8
if [[ $1 == "" ]];then
TD_DATE=`date -d '1 days ago' "+%Y-%m-%d"`
else
TD_DATE=$1
fi

#V_PARYEAR=`date --date="$TD_DATE" +%Y`
#V_PARMONTH=`date --date="$TD_DATE" +%m`
#V_PARDAY=`date --date="$TD_DATE" +%d`
#V_TABLE="web_chat_ems"_"${V_PARYEAR}"_"${V_PARMONTH}"


YD_DATE=`date -d"$TD_DATE -1 day" +"%Y-%m-%d"`


echo '========================================'
echo '==============开始全量导入==============='
echo '========================================'

# 客户静态信息表
${SQOOP_HOME} import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *,'${TD_DATE}' as dt from customer where 1=1 and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table customer \
-m 1

# 线索申诉表
${SQOOP_HOME} import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *,'${TD_DATE}' as dt from customer_appeal where 1=1 and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table customer_appeal \
-m 1

# 客户线索表
${SQOOP_HOME} import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *,'${TD_DATE}' as dt from customer_clue where 1=1 and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table customer_clue \
-m 1

# 客户意向表
${SQOOP_HOME} import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *,'${TD_DATE}' as dt from customer_relationship where 1=1 and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table customer_relationship \
-m 1

# 员工表
${SQOOP_HOME} import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *,'${TD_DATE}' as dt from employee where 1=1 and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table employee \
-m 1

# 报名课程表
${SQOOP_HOME} import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *,'${TD_DATE}' as dt from itcast_clazz where 1=1 and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table itcast_clazz \
-m 1

# 校区表
${SQOOP_HOME} import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *,'${TD_DATE}' as dt from itcast_school where 1=1 and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table itcast_school \
-m 1

# 学科表
${SQOOP_HOME} import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *,'${TD_DATE}' as dt from itcast_subject where 1=1 and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table itcast_subject \
-m 1

# 部门表
${SQOOP_HOME} import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *,'${TD_DATE}' as dt from scrm_department where 1=1 and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table scrm_department \
-m 1

echo "抽取数据完成!";