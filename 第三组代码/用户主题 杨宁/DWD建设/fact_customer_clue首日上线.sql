--增量同步方式
--首次上线，初始化，仅跑一次。
--开启动态分区方式
set hive.exec.dynamic.partition=true;
--设置动态分区用非严格模式
set hive.exec.dynamic.partition.mode=nonstrict;
--开启hive中间MapReduce过程压缩
set hive.exec.compress.intermediate=true;
--开启hive的保存文件的压缩
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;
drop table edu_dwd.fact_customer_clue;
drop database edu_dwd cascade ;
create table edu_dwd.fact_customer_clue;
alter table edu_dwd.fact_customer_clue drop partition (dt='2022-06-04');
insert overwrite table edu_dwd.fact_customer_clue partition (start_date)
select id,
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
       substr(create_time,12,2) as hourinfo,
       '9999-99-99' as end_date,
       dt as start_date
       from edu_ods.customer_clue;


