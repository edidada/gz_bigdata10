

-- 插入数据DWD
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
-- 插入数据
truncate table web_chat_ems_dwd;
select * from web_chat_ems_dwd;
INSERT INTO TABLE web_chat_ems_dwd PARTITION (yearinfo,quarterinfo,monthinfo,dayinfo)
SELECT
    id,
    create_date_time,
    session_id,
    sid,
    create_time,
    seo_source,
    seo_keywords,
    ip,
    AREA,
    country,
    province,
    city,
    origin_channel,
    `user` ,
    manual_time,
    begin_time,
    end_time,
    last_customer_msg_time_stamp,
    last_agent_msg_time_stamp,
    reply_msg_count,
    msg_count,
    browser_name,
    os_info,
    hour(create_date_time) as hourinfo,
    year(create_date_time) as yearinfo,
    quarter(create_date_time) as quarterinfo,
    month(create_date_time) as monthinfo,
    day(create_date_time) as dayinfo
FROM edu_ods.web_chat_ems_2019_07
WHERE id IS NOT NULL and session_id is not null and sid is not null;

insert into table web_chat_text_ems_dwd partition(dt)
select
    *
from edu_ods.web_chat_text_ems_2019_07
where id is not null;

        -- DWB建立

--分区模式
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
-- 启动hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;
-- 写入数据强制分桶
set hive.enforce.bucketing=true;
-- 写入数据强制排序
set hive.enforce.sorting=true;

--  开启MapJoin
set hive.auto.convert.join=false;
-- 开启Buckjoin设置
set hive.optimize.bucketmapjoin = true
-- 开启SMBjoin
set hive.auto.convert.sortmerge.join=true;
set hive.optimize.bucketmapjoin.sortedmerge = true;
set hive.auto.convert.sortmerge.join.noconditionaltask=true;


-- 建表:
drop table if exists web_chat_ems_dwb;
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
clustered by(id) sorted by (id asc) into 10 buckets
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES(
    'orc.compress'='SNAPPY' ,
    'orc.create.index'='true'
);



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
from edu_dwd.web_chat_ems_dwd wce  join edu_dwd.web_chat_text_ems_dwd wcte on wce.id = wcte.id;


    -- DM层建立
drop table if exists visit_consult_dm;
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
    group_type string comment '产品属性维度标记: 1 地区  2 来源渠道 3 搜索来源 4 受访url 5总访问量',
    yearinfo string comment '年',
    quarterinfo string comment '季',
    monthinfo string comment '月',
    dayinfo string comment '天'
)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES(
    'orc.compress'='SNAPPY'
);


--开启提速
--分区模式
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
-- 启动hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;


-- 插入数据
TRUNCATE TABLE visit_consult_dm;
SELECT * FROM visit_consult_dm;

SET hive.exec.default.partition.name =null
INSERT into TABLE visit_consult_dm
    SELECT
        count(DISTINCT sid) as visit_sid,
        count(DISTINCT session_id) as visit_session_id,
        count(DISTINCT ip) as visit_ip,
        count(DISTINCT      if(msg_count>=1,sid,null)    ) as consult_sid,
        count(DISTINCT  if(msg_count>=1,session_id,null)    ) as consult_session_id,
        count(DISTINCT  if(msg_count>=1,ip,null)    ) as consult_ip,
        hourinfo,
        area,
        origin_channel,
        seo_source,
        from_url,
        case
            when grouping__id in (31,63,95,159,287)
            then 'hour'
            when grouping__id in (15,47,79,143,271)
            then 'day'
            when grouping__id in (7,39,71,135,263)
            then 'month'
            when grouping__id in (3,35,67,131,259)
            then 'quarter'
            when grouping__id in (1,33,65,129,257)
            then 'year'
        end
        as time_type,
        case
            when grouping__id in (1,3,7,15,31)
            then '时间'
            when grouping__id in (33,35,39,47,63)
            then '地区'
            when grouping__id in (65,67,71,79,95)
            then '投放来源'
            when grouping__id in (129,131,135,143,159)
            then '渠道来源'
            when grouping__id in (257,259,263,271,287)
            then '来源url'
        end
        as group_type,
        yearinfo,
        quarterinfo,
        monthinfo,
        dayinfo
    FROM edu_dwb.web_chat_ems_dwb
    GROUP BY
    yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo,area,origin_channel,seo_source,from_url
    GROUPING SETS   (
    (yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo),  -- 二进制31
    (yearinfo,quarterinfo,monthinfo,dayinfo),   -- 二进制15
    (yearinfo,quarterinfo,monthinfo),   -- 二进制7
    (yearinfo,quarterinfo),  -- 二进制3
    (yearinfo),  -- 二进制1
    (area,yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo),  -- 二进制63
    (area,yearinfo,quarterinfo,monthinfo,dayinfo),  -- 二进制47
    (area,yearinfo,quarterinfo,monthinfo),  -- 二进制39
    (area,yearinfo,quarterinfo),    -- 二进制35
    (area,yearinfo),    -- 二进制33
    (origin_channel,yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo), -- 二进制95
    (origin_channel,yearinfo,quarterinfo,monthinfo,dayinfo),    -- 二进制79
    (origin_channel,yearinfo,quarterinfo,monthinfo),    -- 二进制71
    (origin_channel,yearinfo,quarterinfo),    -- 二进制67
    (origin_channel,yearinfo),    -- 二进制65
    (seo_source,yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo),    -- 二进制159
    (seo_source,yearinfo,quarterinfo,monthinfo,dayinfo),    -- 二进制143
    (seo_source,yearinfo,quarterinfo,monthinfo),    -- 二进制135
    (seo_source,yearinfo,quarterinfo),    -- 二进制131
    (seo_source,yearinfo),    -- 二进制129
    (from_url,yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo),    -- 二进制287
    (from_url,yearinfo,quarterinfo,monthinfo,dayinfo),    -- 二进制271
    (from_url,yearinfo,quarterinfo,monthinfo),    -- 二进制263
    (from_url,yearinfo,quarterinfo),    -- 二进制259
    (from_url,yearinfo)     -- 二进制257
    );


