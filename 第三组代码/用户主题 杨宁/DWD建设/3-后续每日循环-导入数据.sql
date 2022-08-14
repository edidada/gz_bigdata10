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
set hive.auto.convert.join.noconditionaltask.size=512000000 ;
set hive.auto.convert.join=true;
set hive.optimize.bucketmapjoin = true;
set hive.enforce.bucketing=true;
set hive.enforce.sorting=true;
set hive.auto.convert.sortmerge.join=true;
set hive.auto.convert.sortmerge.join.noconditionaltask=true;
set hive.optimize.bucketmapjoin.sortedmerge = true;

insert overwrite table
    edu_dwd.fact_customer_relationship partition (start_date)
select
    old.id,
    old.create_date_time,
    old.update_date_time,
    old.deleted,
    old.customer_id,
    old.first_id,
    old.belonger,
    old.belonger_name,
    old.initial_belonger,
    old.distribution_handler,
    old.business_scrm_department_id,
    old.last_visit_time,
    old.next_visit_time,
    old.origin_type,
    old.itcast_school_id,
    old.itcast_subject_id,
    old.intention_study_type,
    old.anticipat_signup_date,
    old.level,
    old.creator,
    old.current_creator,
    old.creator_name,
    old.origin_channel,
    old.comment,
    old.first_customer_clue_id,
    old.last_customer_clue_id,
    old.process_state,
    old.process_time,
    old.payment_state,
    old.payment_time,
    old.signup_state,
    old.signup_time,
    old.notice_state,
    old.notice_time,
    old.lock_state,
    old.lock_time,
    old.itcast_clazz_id,
    old.itcast_clazz_time,
    old.payment_url,
    old.payment_url_time,
    old.ems_student_id,
    old.delete_reason,
    old.deleter,
    old.deleter_name,
    old.delete_time,
    old.course_id,
    old.course_name,
    old.delete_comment,
    old.close_state,
    old.close_time,
    old.appeal_id,
    old.tenant,
    old.total_fee,
    old.belonged,
    old.belonged_time,
    old.belonger_time,
    old.transfer,
    old.transfer_time,
    old.follow_type,
    old.transfer_bxg_oa_account,
    old.transfer_bxg_belonger_name,
    substr(old.create_date_time, 12, 2) as hourinfo,
    case
        when new.id is null or old.end_date != '9999-99-99' then old.end_date
        else date_sub(new.dt, 1)
        end                             as end_date,
    old.start_date
from
    edu_dwd.fact_customer_relationship as old
        left join edu_ods.customer_relationship as new
                  on old.id = new.id and dt = '2022-06-05'
union all
select
    id,
    create_date_time,
    update_date_time,
    deleted,
    customer_id,
    first_id,
    customer_relationship.belonger,
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
    dt = '2022-06-05';