--动态分区配置
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;

--写入数据强制分桶
set hive.enforce.bucketing=false;
-- 开启强制排序
set hive.enforce.sorting=false;
-- 是否开启并行执行
set hive.exec.parallel=false;
--  最大运行并行多少个阶段
set hive.exec.parallel.thread.number=16;
-- 矢量化查询(批量读取, 只能应用在ORC)
set hive.vectorized.execution.enabled=false;
 -- 读取零拷贝(只读取需要的字段, 只能应用ORC)
set hive.exec.orc.zerocopy=false;
-- 开启关联优化器(共享shuffle)
set hive.optimize.correlation=false;

-- 创建临时表
create table edu_dwd.fact_customer_clue_temp like edu_dwd.fact_customer_clue;

insert overwrite table edu_dwd.fact_customer_clue partition (start_date)

select
       old.id,
       old.create_date_time,
       old.update_date_time,
       old.deleted,
       old.customer_id,
       old.customer_relationship_id,
       old.session_id,
       old.sid,
       old.status,
       old.`user`,
       old.create_time,
       old.platform,
       old.s_name,
       old.seo_source,
       old.seo_keywords,
       old.ip,
       old.referrer,
       old.from_url,
       old.landing_page_url,
       old.url_title,
       old.to_peer,
       old.manual_time,
       old.begin_time,
       old.reply_msg_count,
       old.total_msg_count,
       old.msg_count,
       old.comment,
       old.finish_reason,
       old.finish_user,
       old.end_time,
       old.platform_description,
       old.browser_name,
       old.os_info,
       old.area,
       old.country,
       old.province,
       old.city,
       old.creator,
       old.name,
       old.idcard,
       old.phone,
       old.itcast_school_id,
       old.itcast_school,
       old.itcast_subject_id,
       old.itcast_subject,
       old.wechat,
       old.qq,
       old.email,
       old.gender,
       old.level,
       old.origin_type,
       old.information_way,
       old.working_years,
       old.technical_directions,
       old.customer_state,
       old.valid,
       old.anticipat_signup_date,
       old.clue_state,
       old.scrm_department_id,
       old.superior_url,
       old.superior_source,
       old.landing_url,
       old.landing_source,
       old.info_url,
       old.info_source,
       old.origin_channel,
       old.course_id,
       old.course_name,
       old.zhuge_session_id,
       old.is_repeat,
       old.tenant,
       old.activity_id,
       old.activity_name,
       old.follow_type,
       old.shunt_mode_id,
       old.shunt_employee_group_id,
       substr(old.create_date_time,12,2) as hourinfo,
       case when new.id is null or old.end_date!='9999-99-99' then old.end_date
           else date_add(new.dt,-1)
       end    as end_date,
       old.start_date


from (select * from edu_dwd.fact_customer_clue where start_date<='2022-06-04') as old
left join (select * from edu_ods.customer_clue where dt='2022-06-05') as new
on old.id=new.id
union all
select
       id,
       create_date_time,
       update_date_time,
       deleted,
       customer_id,
       customer_relationship_id,
       session_id,
       sid,
       status,
       `user`,
       create_time,
       platform,
       s_name,
       seo_source,
       seo_keywords,
       ip,
       referrer,
       from_url,
       landing_page_url,
       url_title,
       to_peer,
       manual_time,
       begin_time,
       reply_msg_count,
       total_msg_count,
       msg_count,
       comment,
       finish_reason,
       finish_user,
       end_time,
       platform_description,
       browser_name,
       os_info,
       area,
       country,
       province,
       city,
       creator,
       name,
       idcard,
       phone,
       itcast_school_id,
       itcast_school,
       itcast_subject_id,
       itcast_subject,
       wechat,
       qq,
       email,
       gender,
       level,
       origin_type,
       information_way,
       working_years,
       technical_directions,
       customer_state,
       valid,
       anticipat_signup_date,
       clue_state,
       scrm_department_id,
       superior_url,
       superior_source,
       landing_url,
       landing_source,
       info_url,
       info_source,
       origin_channel,
       course_id,
       course_name,
       zhuge_session_id,
       is_repeat,
       tenant,
       activity_id,
       activity_name,
       follow_type,
       shunt_mode_id,
       shunt_employee_group_id,
       substr(create_date_time,12,2) as hourinfo,
       '9999-99-99' as end_date,
       dt as start_date

from edu_ods.customer_clue where dt='2022-06-05'limit 500;
