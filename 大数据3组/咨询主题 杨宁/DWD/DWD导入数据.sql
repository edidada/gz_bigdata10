--动态分区配置
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;

--写入数据强制分桶
set hive.enforce.bucketing=true;
-- 开启强制排序
set hive.enforce.sorting=true;
-- 是否开启并行执行
set hive.exec.parallel=true;
--  最大运行并行多少个阶段
set hive.exec.parallel.thread.number=16;
-- 矢量化查询(批量读取, 只能应用在ORC)
set hive.vectorized.execution.enabled=true;
 -- 读取零拷贝(只读取需要的字段, 只能应用ORC)
set hive.exec.orc.zerocopy=true;
-- 开启关联优化器(共享shuffle)
set hive.optimize.correlation=true;

insert overwrite table edu_dwd_access.fact_web_chat_ems partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select
    id ,
    create_date_time ,
    session_id ,
    sid ,
    create_time ,
    seo_source ,
    seo_keywords ,
    ip ,
    area ,
    country ,
    province ,
    city ,
    origin_channel ,
    users ,
    manual_time ,
    begin_time ,
    end_time ,
    last_customer_msg_time_stamp ,
    last_agent_msg_time_stamp ,
    reply_msg_count ,
    msg_count ,
    browser_name ,
    os_info ,
    substr(create_time,12,2) as hourinfo,
    substr(create_time,1,4) as yearinfo,
    quarter(create_time) as quarterinfo,
    substr(create_time,6,2) as monthinfo,
    substr(create_time,9,2) as dayinfo
from edu_ods_access.web_chat_ems ;

insert overwrite table edu_dwd_access.fact_web_chat_text_ems partition(dt)
select * from edu_ods_access.web_chat_text_ems;