```

# 创建库和创建表

create table if not exists edu_ods.ods_web_chat_ems(

    id       INT            comment '主键'                  ,
    create_date_time              STRING         comment '数据创建时间'          ,
    session_id                    STRING         comment '七陌SESsionId'         ,
    sid                           STRING         comment '访客id'                ,
    create_time                   STRING         comment '会话创建时间'          ,
    seo_source                    STRING         comment '搜索来源'              ,
    seo_keywords                  STRING         comment '关键字'                ,
    ip                            STRING         comment 'IP地址'                ,
    AREA                          STRING         comment '地域'                  ,
    country                       STRING         comment '所在国家'              ,
    province                      STRING         comment '省'                    ,
    city                          STRING         comment '城市'                  ,
    origin_channel                STRING         comment '投放渠道'              ,
    `user`                          STRING         comment '所属坐席'              ,
    manual_time                   STRING         comment '人工开始时间'          ,
    begin_time                    STRING         comment '坐席领取时间'          ,
    end_time                      STRING         comment '会话结束时间'          ,
    last_customer_msg_time_stamp  STRING         comment '客户最后一条消息的时间',
    last_agent_msg_time_stamp     STRING         comment '坐席最后一下回复的时间',
    reply_msg_count               INT            comment '客服回复消息数'        ,
    msg_count                     INT            comment '客户发送消息数'        ,
    browser_name                  STRING         comment '浏览器名称'            ,
    os_info                       STRING         comment '系统名称'              
)comment'访问咨询表'
partitioned by(dt string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );


create table if not exists edu_ods.ods_web_chat_text_ems(
    id INT comment'主键',
    referrer string comment'上级来源页面',
    from_url string comment'会话来源页面',
    landing_page_url string comment'访客着陆页面',
    url_title string comment'咨询页面title',
    platform_description string comment'客户平台信息',
    other_params string comment'扩展字段中数据',
    history string comment'历史访问记录'
)comment'访问咨询附属表'
partitioned by(dt string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );


-- ODS层源数据导入

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
--connect 'jdbc:mysql://106.75.33.59:3306/nev?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *,${TD_DATE} as dt from web_chat_text_ems_2019_07 where 1=1 and  \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table ods_web_chat_text_ems \
-m 1


drop table if exists edu_dwd.fact_web_chat_ems_dwd;
create table if not exists edu_dwd.fact_web_chat_ems_dwd(

    id       INT            comment '主键'                  ,
    create_date_time              STRING         comment '数据创建时间'          ,
    session_id                    STRING         comment '七陌SESsionId'         ,
    sid                           STRING         comment '访客id'                ,
    create_time                   STRING         comment '会话创建时间'          ,
    seo_source                    STRING         comment '搜索来源'              ,
    seo_keywords                  STRING         comment '关键字'                ,
    ip                            STRING         comment 'IP地址'                ,
    AREA                          STRING         comment '地域'                  ,
    country                       STRING         comment '所在国家'              ,
    province                      STRING         comment '省'                    ,
    city                          STRING         comment '城市'                  ,
    origin_channel                STRING         comment '投放渠道'              ,
    `user`                          STRING         comment '所属坐席'              ,
    manual_time                   STRING         comment '人工开始时间'          ,
    begin_time                    STRING         comment '坐席领取时间'          ,
    end_time                      STRING         comment '会话结束时间'          ,
    last_customer_msg_time_stamp  STRING         comment '客户最后一条消息的时间',
    last_agent_msg_time_stamp     STRING         comment '坐席最后一下回复的时间',
    reply_msg_count               INT            comment '客服回复消息数'        ,
    msg_count                     INT            comment '客户发送消息数'        ,
    browser_name                  STRING         comment '浏览器名称'            ,
    os_info                       STRING         comment '系统名称'          ,
    hourinfo  string comment '小时'
)
partitioned by(yearinfo string,quarterinfo string,monthinfo string,dayinfo string)
clustered by(id) sorted by (id asc) into 10 buckets
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES(
    'orc.compress'='SNAPPY' ,
    "orc.bloom.filter.columns"="id"
);



drop table if exists edu_dwd.fact_web_chat_text_ems_dwd;
create table if not exists edu_dwd.fact_web_chat_text_ems_dwd(
    id INT comment'主键',
    referrer string comment'上级来源页面',
    from_url string comment'会话来源页面',
    landing_page_url string comment'访客着陆页面',
    url_title string comment'咨询页面title',
    platform_description string comment'客户平台信息',
    other_params string comment'扩展字段中数据',
    history string comment'历史访问记录'
)
partitioned by(dt string)
clustered by(id) sorted by (id asc) into 10 buckets
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES(
    'orc.compress'='SNAPPY',
    "orc.bloom.filter.columns"="id"
);



drop database if exists edu_dwb;
create database if not exists edu_dwb;

create table if not exists edu_dwb.web_chat_ems_dwb(
    id       INT            comment '主键'                  ,
    create_date_time              STRING         comment '数据创建时间'          ,
    session_id                    STRING         comment '七陌SESsionId'         ,
    sid                           STRING         comment '访客id'                ,
    create_time                   STRING         comment '会话创建时间'          ,
    seo_source                    STRING         comment '搜索来源'              ,
    seo_keywords                  STRING         comment '关键字'                ,
    ip                            STRING         comment 'IP地址'                ,
    AREA                          STRING         comment '地域'                  ,
    country                       STRING         comment '所在国家'              ,
    province                      STRING         comment '省'                    ,
    city                          STRING         comment '城市'                  ,
    origin_channel                STRING         comment '投放渠道'              ,
    `user`                          STRING         comment '所属坐席'              ,
    manual_time                   STRING         comment '人工开始时间'          ,
    begin_time                    STRING         comment '坐席领取时间'          ,
    end_time                      STRING         comment '会话结束时间'          ,
    last_customer_msg_time_stamp  STRING         comment '客户最后一条消息的时间',
    last_agent_msg_time_stamp     STRING         comment '坐席最后一下回复的时间',
    reply_msg_count               INT            comment '客服回复消息数'        ,
    msg_count                     INT            comment '客户发送消息数'        ,
    browser_name                  STRING         comment '浏览器名称'            ,
    os_info                       STRING         comment '系统名称'          ,
    hourinfo  string comment '小时',
    referrer string comment'上级来源页面',
    from_url string comment'会话来源页面',
    landing_page_url string comment'访客着陆页面',
    url_title string comment'咨询页面title',
    platform_description string comment'客户平台信息',
    other_params string comment'扩展字段中数据',
    history string comment'历史访问记录'

)
partitioned by(yearinfo string,quarterinfo string,monthinfo string,dayinfo string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES(
    'orc.compress'='SNAPPY' ,
    'orc.create.index'='true'
);


drop database if exists edu_dm;
create database if not exists edu_dm;

create table if not exists edu_dm.visit_consult_dm(
    visit_sid bigint comment 'sid访问量',
    visit_session_id bigint comment 'session_id访问量',
    visit_ip bigint comment 'ip访问量',
    consult_sid bigint comment 'sid咨询量',
    consult_session_id bigint comment 'session_id咨询量',
    consult_ip bigint comment 'ip咨询量',
    hourinfo string comment '小时',
    area string comment '地区维度',
    origin_channel string comment '来源渠道维度',
    seo_source string comment '搜索来源维度',
    from_url string comment '受访url',
    time_type string comment '时间标记: 1 小时  2 天 3月 4 季度 5 年',
    group_type string comment '产品属性维度标记: 1 地区  2 来源渠道 3 搜索来源 4 受访url 5总访问量'
)
partitioned by(yearinfo string,quarterinfo string,monthinfo string,dayinfo string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES(
    'orc.compress'='SNAPPY'
);


# ODS层数据导入







# 全量清洗和增量清洗

-- web_chat_ems
-- 动态分区配置
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;

-- hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
-- 写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;
-- 写入数据强制分桶
set hive.enforce.bucketing=true;
-- 开启强制排序
set hive.enforce.sorting=true;


insert overwrite table edu_dwd.fact_web_chat_ems_dwd partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select
    id,
    create_date_time,
    session_id,
    sid,
    create_time,
    seo_source,
    seo_keywords,
    ip,
    area,
    country,
    province,
    city,
    origin_channel,
    `user`,
    manual_time,
    begin_time,
    end_time,
    last_customer_msg_time_stamp,
    last_agent_msg_time_stamp,
    reply_msg_count,
    msg_count,
    browser_name,
    os_info,
    substr(create_time,12,2) as hourinfo,
    substr(create_time,1,4) as yearinfo,
    quarter(create_time) as quarterinfo,
    substr(create_time,6,2) as monthinfo,
    substr(create_time,9,2) as dayinfo
from  edu_ods.ods_web_chat_ems
where create_time is not null and (session_id is not null or sid is not null or ip is not null);



-- web_chat_text_ems
insert overwrite table edu_dwd.fact_web_chat_text_ems_dwd partition(dt)
select
   *
from  edu_ods.ods_web_chat_text_ems;





-- web_chat_ems
-- 动态分区配置
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;

-- hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
-- 写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;
-- 写入数据强制分桶
set hive.enforce.bucketing=true;
-- 开启强制排序
set hive.enforce.sorting=true;



insert overwrite table edu_dwd.fact_web_chat_ems_dwd partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select
    id,
    create_date_time,
    session_id,
    sid,
    create_time,
    seo_source,
    seo_keywords,
    ip,
    area,
    country,
    province,
    city,
    origin_channel,
    `user`,
    manual_time,
    begin_time,
    end_time,
    last_customer_msg_time_stamp,
    last_agent_msg_time_stamp,
    reply_msg_count,
    msg_count,
    browser_name,
    os_info,
    substr(create_time,12,2) as hourinfo,
    substr(create_time,1,4) as yearinfo,
    quarter(create_time) as quarterinfo,
    substr(create_time,6,2) as monthinfo,
    substr(create_time,9,2) as dayinfo
from  edu_ods.ods_web_chat_ems
where dt = '2022-03-13'
	and create_time is not null and (session_id is not null or sid is not null or ip is not null);



-- web_chat_text_ems
insert overwrite table edu_dwd.fact_web_chat_text_ems_dwd partition(dt)
select
   *
from  edu_ods.ods_web_chat_text_ems where dt = '2022-03-13';


set hive.auto.convert.join=true;
-- smb
set hive.enforce.bucketing=true;
set hive.enforce.sorting=true;
set hive.optimize.bucketmapjoin = true;
set hive.auto.convert.sortmerge.join=true;
set hive.auto.convert.sortmerge.join.noconditionaltask=true;
set hive.optimize.bucketmapjoin.sortedmerge = true;

explain
select
    wce.id,
    wce.create_date_time,
    wce.session_id,
    wce.sid,
    wce.create_time,
    wce.seo_source,
    wce.seo_keywords,
    wce.ip,
    wce.area,
    wce.country,
    wce.province,
    wce.city,
    wce.origin_channel,
    wce.`user`,
    wce.manual_time,
    wce.begin_time,
    wce.end_time,
    wce.last_customer_msg_time_stamp,
    wce.last_agent_msg_time_stamp,
    wce.reply_msg_count,
    wce.msg_count,
    wce.browser_name,
    wce.os_info,
    wce.hourinfo,
    wcte.referrer,
    wcte.from_url,
    wcte.landing_page_url,
    wcte.url_title,
    wcte.platform_description,
    wcte.other_params,
    wcte.history,
    wce.yearinfo,
    wce.quarterinfo,
    wce.monthinfo,
    wce.dayinfo
from edu_dwd.fact_web_chat_ems_dwd wce  join edu_dwd.fact_web_chat_text_ems_dwd wcte on wce.id = wcte.id;




insert into table edu_dm.visit_consult_dm partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select
  count(distinct sid) as visit_sid,
  count(distinct session_id) as visit_session_id,
  count(distinct ip) as visit_ip,
  count(distinct if(msg_count>=1, sid, null)) as consult_sid,
  count(distinct if(msg_count>=1, session_id, null)) as consult_session_id,
  count(distinct if(msg_count>=1, ip, null)) as consult_ip,
  hourinfo,
  area,
  origin_channel,
  seo_source,
  from_url,
  case
    when grouping__id in (31, 63, 95, 159, 287)
    then '1'
    when grouping__id in (15, 47, 79, 143, 271)
    then '2'
    when grouping__id in (7, 39, 71, 135, 263)
    then '3'
    when grouping__id in (3, 35, 67, 131, 259)
    then '4'
    when grouping__id in (1, 33, 65, 129, 257)
    then '5'
  end
  as time_type,
  case
    when grouping__id in (31,15,7,3,1)
    then '5'
    when grouping__id in (63,47,39,35,33)
    then '1'
    when grouping__id in (95,79,71,67,65)
    then '2'
    when grouping__id in (159,143,135,131,129)
    then '3'
    when grouping__id in (287,271,263,259,257)
    then '4'
  end
  as group_type,
  yearinfo,
  quarterinfo,
  monthinfo,
  dayinfo
from edu_dwb.web_chat_ems_dwb
group by yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo,area,origin_channel,seo_source,from_url
grouping sets (
    (yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo),
    (yearinfo,quarterinfo,monthinfo,dayinfo),
    (yearinfo,quarterinfo,monthinfo),
    (yearinfo,quarterinfo),
    (yearinfo),
    (area,yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo),
    (area,yearinfo,quarterinfo,monthinfo,dayinfo),
    (area,yearinfo,quarterinfo,monthinfo),
    (area,yearinfo,quarterinfo),
    (area,yearinfo),
    (origin_channel,yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo),
    (origin_channel,yearinfo,quarterinfo,monthinfo,dayinfo),
    (origin_channel,yearinfo,quarterinfo,monthinfo),
    (origin_channel,yearinfo,quarterinfo),
    (origin_channel,yearinfo),
    (seo_source,yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo),
    (seo_source,yearinfo,quarterinfo,monthinfo,dayinfo),
    (seo_source,yearinfo,quarterinfo,monthinfo),
    (seo_source,yearinfo,quarterinfo),
    (seo_source,yearinfo),
    (from_url,yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo),
    (from_url,yearinfo,quarterinfo,monthinfo,dayinfo),
    (from_url,yearinfo,quarterinfo,monthinfo),
    (from_url,yearinfo,quarterinfo),
    (from_url,yearinfo)
);



-- 访问量指标计算:
-- 先执行删除受影响分区结果数据
alter table edu_dm.visit_consult_dm drop partition(yearinfo='2022');

insert into table edu_dm.visit_consult_dm partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select
  count(distinct sid) as visit_sid,
  count(distinct session_id) as visit_session_id,
  count(distinct ip) as visit_ip,
  count(distinct if(msg_count>=1, sid, null)) as consult_sid,
  count(distinct if(msg_count>=1, session_id, null)) as consult_session_id,
  count(distinct if(msg_count>=1, ip, null)) as consult_ip,
  hourinfo,
  area,
  origin_channel,
  seo_source,
  from_url,
  case
    when grouping__id in (31, 63, 95, 159, 287)
    then '1'
    when grouping__id in (15, 47, 79, 143, 271)
    then '2'
    when grouping__id in (7, 39, 71, 135, 263)
    then '3'
    when grouping__id in (3, 35, 67, 131, 259)
    then '4'
    when grouping__id in (1, 33, 65, 129, 257)
    then '5'
  end
  as time_type,
  case
    when grouping__id in (31,15,7,3,1)
    then '5'
    when grouping__id in (63,47,39,35,33)
    then '1'
    when grouping__id in (95,79,71,67,65)
    then '2'
    when grouping__id in (159,143,135,131,129)
    then '3'
    when grouping__id in (287,271,263,259,257)
    then '4'
  end
  as group_type,
  yearinfo,
  quarterinfo,
  monthinfo,
  dayinfo
from edu_dwb.web_chat_ems_dwb
where yearinfo = '${yearStr}'
group by yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo,area,origin_channel,seo_source,from_url
grouping sets (
    (yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo),
    (yearinfo,quarterinfo,monthinfo,dayinfo),
    (yearinfo,quarterinfo,monthinfo),
    (yearinfo,quarterinfo),
    (yearinfo),
    (area,yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo),
    (area,yearinfo,quarterinfo,monthinfo,dayinfo),
    (area,yearinfo,quarterinfo,monthinfo),
    (area,yearinfo,quarterinfo),
    (area,yearinfo),
    (origin_channel,yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo),
    (origin_channel,yearinfo,quarterinfo,monthinfo,dayinfo),
    (origin_channel,yearinfo,quarterinfo,monthinfo),
    (origin_channel,yearinfo,quarterinfo),
    (origin_channel,yearinfo),
    (seo_source,yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo),
    (seo_source,yearinfo,quarterinfo,monthinfo,dayinfo),
    (seo_source,yearinfo,quarterinfo,monthinfo),
    (seo_source,yearinfo,quarterinfo),
    (seo_source,yearinfo),
    (from_url,yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo),
    (from_url,yearinfo,quarterinfo,monthinfo,dayinfo),
    (from_url,yearinfo,quarterinfo,monthinfo),
    (from_url,yearinfo,quarterinfo),
    (from_url,yearinfo)
);






--动态分区配置
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;
--矢量化查询(批量读取操作)
set hive.vectorized.execution.enabled=true;

set hive.auto.convert.join=true;
-- smb
set hive.enforce.bucketing=true;
set hive.enforce.sorting=true;
set hive.optimize.bucketmapjoin = true;
set hive.auto.convert.sortmerge.join=true;
set hive.auto.convert.sortmerge.join.noconditionaltask=true;
set hive.optimize.bucketmapjoin.sortedmerge = true;

insert overwrite table edu_dwb.web_chat_ems_dwb partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select
    wce.id,
    wce.create_date_time,
    wce.session_id,
    wce.sid,
    wce.create_time,
    wce.seo_source,
    wce.seo_keywords,
    wce.ip,
    wce.area,
    wce.country,
    wce.province,
    wce.city,
    wce.origin_channel,
    wce.`user`,
    wce.manual_time,
    wce.begin_time,
    wce.end_time,
    wce.last_customer_msg_time_stamp,
    wce.last_agent_msg_time_stamp,
    wce.reply_msg_count,
    wce.msg_count,
    wce.browser_name,
    wce.os_info,
    wce.hourinfo,
    wcte.referrer,
    wcte.from_url,
    wcte.landing_page_url,
    wcte.url_title,
    wcte.platform_description,
    wcte.other_params,
    wcte.history,
    wce.yearinfo,
    wce.quarterinfo,
    wce.monthinfo,
    wce.dayinfo
from (select * from edu_dwd.fact_web_chat_ems_dwd where yearinfo='2022' and quarterinfo='1' and monthinfo='03' and dayinfo='13') wce  join (select * from edu_dwd.fact_web_chat_text_ems_dwd where dt = '2022-03-13') wcte on wce.id = wcte.id;








# 数据导出

-- 全量导出: 
sqoop export \
--connect "jdbc:mysql://192.168.88.80:3306/edu_result?useUnicode=true&characterEncoding=utf-8" \
--username root \
--password '123456' \
--table visit_consult_dm \
--hcatalog-database edu_dm \
--hcatalog-table visit_consult_dm



-- 增量导出操作:
delete from edu_result.visit_consult_dm where yearinfo ='2022'

sqoop export \
--connect "jdbc:mysql://192.168.88.80:3306/edu_result?useUnicode=true&characterEncoding=utf-8" \
--username root \
--password '123456' \
--table visit_consult_dm \
--hcatalog-database edu_dm \
--hcatalog-table visit_consult_dm \
--hcatalog-partition-keys yearinfo \
--hcatalog-partition-values '2022'

# hcatalog-partition-keys是分区字段，hcatalog-partition-values是指定分区的值




-- 脚本:

#! /bin/bash
export SQOOP_HOME=/usr/bin/sqoop
if [ $# >= 1 ]
then
   dateStr=$1
else
   dateStr=`date -d '-1 day' "+%Y-%m-%d"`
fi

TD_YEAR=$(date -d "$dateStr" +%Y)

mysql -uroot -p123456 -h192.168.88.80 -P3306 -e "delete from edu_result.visit_consult_dm where yearinfo='${TD_YEAR}';"


wait

${SQOOP_HOME} export \
--connect "jdbc:mysql://192.168.88.80:3306/edu_result?useUnicode=true&characterEncoding=utf-8" \
--username root \
--password '123456' \
--table visit_consult_dm \
--hcatalog-database edu_dm \
--hcatalog-table visit_consult_dm \
--hcatalog-partition-keys yearinfo \
--hcatalog-partition-values '${TD_YEAR}' \
-m 1

```