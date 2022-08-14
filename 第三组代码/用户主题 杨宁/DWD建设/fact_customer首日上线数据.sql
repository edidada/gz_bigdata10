-- 开启动态分区方式
set hive.exec.dynamic.partition=true;
-- 设置动态分区方式为非严格模式
set hive.exec.dynamic.partition.mode=nonstrict;

-- 开启hive中间MapReduce过程压缩
set hive.exec.compress.intermediate=true;
--开启hive的保存的文件压缩
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;

insert overwrite table edu_dwd.fact_customer partition (start_date )
select id,
       customer_relationship_id,
       create_date_time,
       update_date_time,
       deleted,
       name,
       idcard,
       birth_year,
       gender,
       phone,
       wechat,
       qq,
       email,
       area,
       leave_school_date,
       graduation_date,
       bxg_student_id,
       creator,
       origin_type,
       origin_channel,
       tenant,
       md_id,
       '9999-99-99'as end_date,
       dt as start_date

from edu_ods.customer
 where dt<='2022-06-04';