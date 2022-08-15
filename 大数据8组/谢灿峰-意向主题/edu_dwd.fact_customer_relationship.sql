select * from edu_dwd.fact_customer_relationship;
use edu_dwd;
DROP TABLE edu_dwd.fact_customer_relationship;
create table if not exists edu_dwd.fact_customer_relationship
(
    id int,
    `year` string,
    `month` string,
    `day` string,
    `hour` string,
    update_date_time string,
    deleted string,
    customer_id int,
    first_id int,
    belonger int,
    belonger_name string,
    initial_belonger int,
    distribution_handler int,
    business_scrm_department_id int,
    last_visit_time string,
    next_visit_time string,
    origin_type string,
    itcast_school_id int,
    itcast_subject_id int,
    intention_study_type string,
    anticipat_signup_date string,
    level string,
    creator int,
    current_creator int,
    creator_name string,
    origin_channel string,
    `COMMENT` string,
    first_customer_clue_id int,
    last_customer_clue_id int,
    process_state string,
    process_time string,
    payment_state string,
    payment_time string,
    signup_state string,
    signup_time string,
    notice_state string,
    notice_time string,
    lock_state string,
    lock_time string,
    itcast_clazz_id int,
    itcast_clazz_time string,
    payment_url string,
    payment_url_time string,
    ems_student_id int,
    delete_reason string,
    deleter int,
    deleter_name string,
    delete_time string,
    course_id int,
    course_name string,
    delete_comment string,
    close_state string,
    close_time string,
    appeal_id int,
    tenant int,
    total_fee string,
    belonged int,
    belonged_time string,
    belonger_time string,
    transfer int,
    transfer_time string,
    follow_type int,
    transfer_bxg_oa_account string,
    transfer_bxg_belonger_name string,
    end_time string
)
partitioned by(start_time string)
clustered by(id) sorted by(id) into 10 buckets
row format delimited fields terminated by '\t'
stored as orc tblproperties('orc.compress'='SNAPPY');




-- 开启动态分区支持，并开启非严格模式
SET hive.exec.dynamic.partition=true;
-- 严格模式：要求插入式要至少有一个静态分区；如果全部用动态分区，需要开启非严格模式
SET hive.exec.dynamic.partition.mode=nonstrict;
-- SELECT * ,
--         '9999-99-99' AS end_time,
--         if(update_date_time is NOT NULL or update_date_time != '',
--         substr(update_date_time, 1, 10),
--         substr(create_date_time, 1, 10)
--         )as start_time
-- FROM edu_ods.customer_relationship;

-- SELECT * from edu_ods.customer_relationship;

INSERT OVERWRITE TABLE edu_dwd.fact_customer_relationship PARTITION (start_time)
SELECT
    id  ,
    -- 将create_date_time 转换为 yearinfo  monthinfo dayinfo hourinfo
    
    year(create_date_time)  yearinfo,
    month(create_date_time) monthinfo,
    day(create_date_time) dayinfo,
    hour(create_date_time) hourinfo,
    update_date_time  ,
    deleted  ,
    customer_id  ,
    first_id  ,
    belonger  ,
    belonger_name  ,
    initial_belonger  ,
    distribution_handler  ,
    business_scrm_department_id  ,
    last_visit_time  ,
    next_visit_time  ,
    
    -- 将origin_type 转换为 origin_type_state (用于统计线上线下)
   	--	转换逻辑: origin_type的值为: NETSERVICE 或者 PRESIGNUP 认为线上 其余认为线下
   	case origin_type  
         WHEN 'NETSERVICE'
         THEN '线上'
         WHEN 'PRESIGNUP'
         THEN '线上'
         ELSE '线下'
    END  as origin_type_state,
    
    if(itcast_school_id = 0 or itcast_school_id is NULL, -1 , itcast_school_id) 
    as itcast_school_id
    ,
    
    CASE
    when itcast_subject_id = 0
    then -1
    when itcast_subject_id IS NULL
    then -1
    ELSE itcast_subject_id
    end as itcast_subject_id
    ,
    
    intention_study_type  ,
    anticipat_signup_date  ,
    level  ,
    creator  ,
    current_creator  ,
    creator_name  ,
    origin_channel  ,
    `COMMENT`  ,
    first_customer_clue_id  ,
    last_customer_clue_id  ,
    process_state  ,
    process_time  ,
    payment_state  ,
    payment_time  ,
    signup_state  ,
    signup_time  ,
    notice_state  ,
    notice_time  ,
    lock_state  ,
    lock_time  ,
    itcast_clazz_id  ,
    itcast_clazz_time  ,
    payment_url  ,
    payment_url_time  ,
    ems_student_id  ,
    delete_reason  ,
    deleter  ,
    deleter_name  ,
    delete_time  ,
    course_id  ,
    course_name  ,
    delete_comment  ,
    close_state  ,
    close_time  ,
    appeal_id  ,
    tenant  ,
    total_fee  ,
    belonged  ,
    belonged_time  ,
    belonger_time  ,
    transfer  ,
    transfer_time  ,
    follow_type  ,
    transfer_bxg_oa_account  ,
    transfer_bxg_belonger_name  ,
    '9999-99-99'end_time ,
    if(update_date_time is NOT NULL or update_date_time != '',
        substr(update_date_time, 1, 10),
        substr(create_date_time, 1, 10)
        )as start_time
FROM edu_ods.customer_relationship;
-- select * from fact_customer_relationship;

drop table if exists edu_dwd.fact_customer_relationship_tem;
CREATE TABLE edu_dwd.fact_customer_relationship_tem
(
    id int,
    year string,
    month string,
    day string,
    hour string,
    update_date_time string,
    deleted string,
    customer_id int,
    first_id int,
    belonger int,
    belonger_name string,
    initial_belonger int,
    distribution_handler int,
    business_scrm_department_id int,
    last_visit_time string,
    next_visit_time string,
    origin_type string,
    itcast_school_id int,
    itcast_subject_id int,
    intention_study_type string,
    anticipat_signup_date string,
    level string,
    creator int,
    current_creator int,
    creator_name string,
    origin_channel string,
    `COMMENT` string,
    first_customer_clue_id int,
    last_customer_clue_id int,
    process_state string,
    process_time string,
    payment_state string,
    payment_time string,
    signup_state string,
    signup_time string,
    notice_state string,
    notice_time string,
    lock_state string,
    lock_time string,
    itcast_clazz_id int,
    itcast_clazz_time string,
    payment_url string,
    payment_url_time string,
    ems_student_id int,
    delete_reason string,
    deleter int,
    deleter_name string,
    delete_time string,
    course_id int,
    course_name string,
    delete_comment string,
    close_state string,
    close_time string,
    appeal_id int,
    tenant int,
    total_fee string,
    belonged int,
    belonged_time string,
    belonger_time string,
    transfer int,
    transfer_time string,
    follow_type int,
    transfer_bxg_oa_account string,
    transfer_bxg_belonger_name string,
    end_time string
)
partitioned by(start_time string)
clustered by(id) sorted by(id) into 10 buckets
row format delimited fields terminated by '\t'
stored as orc tblproperties('orc.compress'='SNAPPY');

select * from fact_customer_relationship;

insert overwrite table edu_dwd.fact_customer_relationship_tem partition (start_time)
select
    id  ,
    -- 将create_date_time 转换为 yearinfo  monthinfo dayinfo hourinfo
    
    year(create_date_time)  yearinfo,
    month(create_date_time) monthinfo,
    day(create_date_time) dayinfo,
    hour(create_date_time) hourinfo,
    update_date_time  ,
    deleted  ,
    customer_id  ,
    first_id  ,
    belonger  ,
    belonger_name  ,
    initial_belonger  ,
    distribution_handler  ,
    business_scrm_department_id  ,
    last_visit_time  ,
    next_visit_time  ,
    
    -- 将origin_type 转换为 origin_type_state (用于统计线上线下)
   	--	转换逻辑: origin_type的值为: NETSERVICE 或者 PRESIGNUP 认为线上 其余认为线下
   	case origin_type  
         WHEN 'NETSERVICE'
         THEN '线上'
         WHEN 'PRESIGNUP'
         THEN '线上'
         ELSE '线下'
    END  as origin_type_state,
    itcast_school_id  ,
    itcast_subject_id  ,
    intention_study_type  ,
    anticipat_signup_date  ,
    level  ,
    creator  ,
    current_creator  ,
    creator_name  ,
    origin_channel  ,
    `COMMENT`  ,
    first_customer_clue_id  ,
    last_customer_clue_id  ,
    process_state  ,
    process_time  ,
    payment_state  ,
    payment_time  ,
    signup_state  ,
    signup_time  ,
    notice_state  ,
    notice_time  ,
    lock_state  ,
    lock_time  ,
    itcast_clazz_id  ,
    itcast_clazz_time  ,
    payment_url  ,
    payment_url_time  ,
    ems_student_id  ,
    delete_reason  ,
    deleter  ,
    deleter_name  ,
    delete_time  ,
    course_id  ,
    course_name  ,
    delete_comment  ,
    close_state  ,
    close_time  ,
    appeal_id  ,
    tenant  ,
    total_fee  ,
    belonged  ,
    belonged_time  ,
    belonger_time  ,
    transfer  ,
    transfer_time  ,
    follow_type  ,
    transfer_bxg_oa_account  ,
    transfer_bxg_belonger_name  ,
    '9999-99-99'end_time, '2022-08-08' as start_time
from edu_dwd.fact_customer_relationship;

select * from fact_customer_relationship_tem;




 