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
-- smb
-- set hive.auto.convert.join.noconditionaltask.size=512000000 ;
-- set hive.auto.convert.join=true;
-- set hive.optimize.bucketmapjoin = true;
-- set hive.enforce.bucketing=true;
-- set hive.enforce.sorting=true;
-- set hive.auto.convert.sortmerge.join=true;
-- set hive.auto.convert.sortmerge.join.noconditionaltask=true;
-- set hive.optimize.bucketmapjoin.sortedmerge = true;

insert overwrite table
    edu_dwd.fact_customer_relationship partition (start_date)
select
    id,
    create_date_time,
    update_date_time,
    deleted,
    customer_id,
    first_id,
    belonger,
    belonger_name,
    initial_belonger,
    distribution_handler,
    business_scrm_department_id,
    last_visit_time,
    next_visit_time,
    origin_type,
    itcast_school_id,
    itcast_subject_id,
    intention_study_type,
    anticipat_signup_date,
    level,
    creator,
    current_creator,
    creator_name,
    origin_channel,
    comment,
    first_customer_clue_id,
    last_customer_clue_id,
    process_state,
    process_time,
    payment_state,
    payment_time,
    signup_state,
    signup_time,
    notice_state,
    notice_time,
    lock_state,
    lock_time,
    itcast_clazz_id,
    itcast_clazz_time,
    payment_url,
    payment_url_time,
    ems_student_id,
    delete_reason,
    deleter,
    deleter_name,
    delete_time,
    course_id,
    course_name,
    delete_comment,
    close_state,
    close_time,
    appeal_id,
    tenant,
    total_fee,
    belonged,
    belonged_time,
    belonger_time,
    transfer,
    transfer_time,
    follow_type,
    transfer_bxg_oa_account,
    transfer_bxg_belonger_name,
    substr(create_date_time, 12, 2) as hourinfo,
    '9999-99-99'                    as end_date,
    dt                              as start_date
from
    edu_ods.customer_relationship
where
    dt <= '2022-06-04';