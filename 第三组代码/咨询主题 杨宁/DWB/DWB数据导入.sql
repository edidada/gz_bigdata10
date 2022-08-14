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

-- SMB
set hive.auto.convert.join=true;
set hive.optimize.bucketmapjoin = true;
set hive.auto.convert.sortmerge.join=true;
set hive.auto.convert.sortmerge.join.noconditionaltask=true;
set hive.optimize.bucketmapjoin.sortedmerge = true;

insert overwrite table edu_dwb_access.web_chat_ems_dwb partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select
    t1.id ,
    t1.sid ,
    t1.ip ,
    t1.session_id ,
    t1.create_time ,
    t1.hourinfo ,
    t1.area ,
    t1.origin_channel ,
    t1.seo_source ,
    t1.msg_count ,
    t2.referrer ,
    t2.from_url ,
    t2.landing_page_url ,
    t2.url_title ,
    t2.platform_description ,
    t2.other_params ,
    t2.history ,
    t1.yearinfo ,
    t1.quarterinfo ,
    t1.monthinfo ,
    t1.dayinfo
from edu_dwd_access.fact_web_chat_ems t1 join  edu_dwd_access.fact_web_chat_text_ems t2 on  t1.id = t2.id;