---------dwd
--- DWD
--------------

-- 客户意向 拉链表
INSERT into  zxedu_dwd.fact_customer_relationship_dwd
SELECT
    id ,
    create_date_time ,
    update_date_time ,
    deleted ,
    customer_id ,
    first_id    ,
    belonger ,
    belonger_name ,
    initial_belonger ,
    distribution_handler ,
    business_scrm_department_id ,
    last_visit_time ,
    next_visit_time ,
    origin_type ,
    if(itcast_school_id is null or itcast_school_id = 0 ,-1,itcast_school_id)itcast_school_id ,

    if(itcast_subject_id is NULL or itcast_subject_id = 0 , -1,itcast_subject_id)itcast_subject_id ,
    intention_study_type ,
    anticipat_signup_date ,
    level ,
    creator ,
    current_creator ,
    creator_name ,
    origin_channel ,
    comment ,
    first_customer_clue_id ,
    last_customer_clue_id ,
    process_state ,
    process_time ,
    payment_state ,
    payment_time ,
    signup_state ,
    signup_time ,
    notice_state ,
    notice_time ,
    lock_state ,
    lock_time ,
    itcast_clazz_id ,
    itcast_clazz_time ,
    payment_url ,
    payment_url_time ,
    ems_student_id ,
    delete_reason ,
    deleter ,
    deleter_name ,
    delete_time ,
    course_id ,
    course_name ,
    delete_comment ,
    close_state ,
    close_time ,
    appeal_id ,
    tenant,
    total_fee ,
    belonged ,
    belonged_time ,
    belonger_time ,
    transfer ,
    transfer_time ,
    follow_type ,
    transfer_bxg_oa_account ,
    transfer_bxg_belonger_name ,
    substr(create_date_time , 1, 13) hourinfo ,
    if(origin_type = 'NETSERVICE' or origin_type = 'PRESIGNUP', 'online','offline') orgin_type_state ,
    '9999-99-99' ends_time,
    create_date_time starts_time
from scrm_ods.customer_relationship
where deleted != 1 and id is NOT NULL;



-----

--------------------------
--指标 : 总客户量 , 有效线索的数量
-- 维度: 年月日时
-- 其他维度  地区 来源渠道  线上线下
--          学科 校区 新老 咨询中心
-------------------------------------

----------DMDMDMDMDMDMDMD   DM 插入
-----
insert into zxedu_dm.icu_dm

    select
        -- 按照 意向id 去重
        --总客户量
        count(distinct customer_id) customer_total,
        -- 有效线索的数量
        count(if( (clue_appeal_state =0 or clue_appeal_state is null or clue_appeal_state =1)and it.customer_id is not null ,1,null )) clue_nums ,
        area,
        itcast_school_id,
        itcast_school_name,
        origin_type,
        itcast_subject_id,
        itcast_subject_name,
        tdepart_id,
        tdepart_name,
        origin_type_stat,
        clue_state_stat,

    --     time_str, -- STRING COMMENT '时间明细',
        case
            when grouping(itcast_school_id)=0
            then 'school'
            when grouping(itcast_subject_id)=0
            then 'subject'
            when grouping(area)=0
            then 'area'
            when grouping(origin_type)=0
            then 'origin'
            when grouping(tdepart_id)=0
            then 'tdepart'
            else 'all'
        end
            as groupType, -- STRING COMMENT '产品属性类别：1.总累计值；2.区域信息；3.校区、学科组合分组；4.来源渠道；5.咨询中心;',
        case
        when
            grouping(hourinfo)=0
            then 'hour'
            when grouping(dayinfo)=0
            then 'day'
            when grouping(monthinfo)=0
            then 'month'
            when grouping(yearinfo)=0
            then 'year'
        end as time_type, -- STRING COMMENT '时间维度：1、按小时聚合；2、按天聚合；3、按周聚合；4、按月聚合；5、按年聚合；'
        hourinfo,
        dayinfo,
        monthinfo,
        yearinfo
    from zxedu_dwb.itcast_intention_dwb it
    group by
    grouping sets (
    --   小时聚合
        (hourinfo,dayinfo,monthinfo,yearinfo,origin_type_stat,clue_state_stat),
    --   地区+小时
        (hourinfo,dayinfo,monthinfo,yearinfo,origin_type_stat,clue_state_stat,area),
    --   学科+小时
        (hourinfo,dayinfo,monthinfo,yearinfo,origin_type_stat,clue_state_stat,itcast_subject_id,itcast_subject_name),
    --   校区+小时
        (hourinfo,dayinfo,monthinfo,yearinfo,origin_type_stat,clue_state_stat,itcast_school_id,itcast_school_name),
    --   来源渠道+小时
        (hourinfo,dayinfo,monthinfo,yearinfo,origin_type_stat,clue_state_stat,origin_type),
    --   咨询中心(部门)+小时
        (hourinfo,dayinfo,monthinfo,yearinfo,origin_type_stat,clue_state_stat,tdepart_id,tdepart_name),
    --   线索量+小时
        --   tian聚合
        (dayinfo,monthinfo,yearinfo,origin_type_stat,clue_state_stat),
    --   origin_type_stat,clue_state_stat,地区+小时
        (origin_type_stat,clue_state_stat,dayinfo,monthinfo,yearinfo,area),
        (origin_type_stat,clue_state_stat,dayinfo,monthinfo,yearinfo,itcast_subject_id,itcast_subject_name),
        (origin_type_stat,clue_state_stat,dayinfo,monthinfo,yearinfo,itcast_school_id,itcast_school_name),
        (origin_type_stat,clue_state_stat,dayinfo,monthinfo,yearinfo,origin_type),
        (origin_type_stat,clue_state_stat,dayinfo,monthinfo,yearinfo,tdepart_id,tdepart_name),
    --   origin_type_stat,clue_state_stat,线索量+天
    --   origin_type_stat,clue_state_stat,tian聚合
        (origin_type_stat,clue_state_stat,monthinfo,yearinfo),
        (origin_type_stat,clue_state_stat,monthinfo,yearinfo,area),
        (origin_type_stat,clue_state_stat,monthinfo,yearinfo,itcast_subject_id,itcast_subject_name),
        (origin_type_stat,clue_state_stat,monthinfo,yearinfo,itcast_school_id,itcast_school_name),
        (origin_type_stat,clue_state_stat,monthinfo,yearinfo,origin_type),
        (origin_type_stat,clue_state_stat,monthinfo,yearinfo,tdepart_id,tdepart_name),
        (origin_type_stat,clue_state_stat,monthinfo,yearinfo,origin_type_stat),

        (origin_type_stat,clue_state_stat,yearinfo),
        (origin_type_stat,clue_state_stat,yearinfo,area),
        (origin_type_stat,clue_state_stat,yearinfo,itcast_subject_id,itcast_subject_name),
        (origin_type_stat,clue_state_stat,yearinfo,itcast_school_id,itcast_school_name,dayinfo),
        (origin_type_stat,clue_state_stat,yearinfo,origin_type),
        (origin_type_stat,clue_state_stat,yearinfo,tdepart_id,tdepart_name),
        (origin_type_stat,clue_state_stat,yearinfo,origin_type_stat)
    )
;
select
sum (if( (clue_appeal_state =0 or clue_appeal_state is null or clue_appeal_state =1),1,0 )) clue_nums
from zxedu_dwb.itcast_intention_dwb


