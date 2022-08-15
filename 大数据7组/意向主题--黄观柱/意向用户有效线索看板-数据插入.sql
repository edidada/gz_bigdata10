-- 意向用户有效线索看板

-- dwd插入数据
insert overwrite table edu_dwd.fact_customer_relationship partition(dt)
select
    r.id                                                                                                                  ,
    r.create_date_time                                                                                                    ,
    r.update_date_time                                                                                                    ,
    r.deleted                                                                                                             ,
    r.customer_id                                                                                                         ,
    r.first_id                                                                                                            ,
    r.belonger                                                                                                            ,
    r.belonger_name                                                                                                       ,
    r.initial_belonger                                                                                                    ,
    r.distribution_handler                                                                                                ,
    r.business_scrm_department_id                                                                                         ,
    r.last_visit_time                                                                                                     ,
    r.next_visit_time                                                                                                     ,
    r.origin_type                                                                                                         ,
    if(r.itcast_school_id is null OR r.itcast_school_id = 0 , '-1',r.itcast_school_id) as itcast_school_id                ,
    if(r.itcast_subject_id is not null, if(r.itcast_subject_id != 0,r.itcast_subject_id,'-1'),'-1') as itcast_subject_id  ,
    r.intention_study_type                                                                                                ,
    r.anticipat_signup_date                                                                                               ,
    r.level                                                                                                               ,
    r.creator                                                                                                             ,
    r.current_creator                                                                                                     ,
    r.creator_name                                                                                                        ,
    r.origin_channel                                                                                                      ,
    r.COMMENT                                                                                                             ,
    r.first_customer_clue_id                                                                                              ,
    r.last_customer_clue_id                                                                                               ,
    r.process_state                                                                                                       ,
    r.process_time                                                                                                        ,
    r.payment_state                                                                                                       ,
    r.payment_time                                                                                                        ,
    r.signup_state                                                                                                        ,
    r.signup_time                                                                                                         ,
    r.notice_state                                                                                                        ,
    r.notice_time                                                                                                         ,
    r.lock_state                                                                                                          ,
    r.lock_time                                                                                                           ,
    r.itcast_clazz_id                                                                                                     ,
    r.itcast_clazz_time                                                                                                   ,
    r.payment_url                                                                                                         ,
    r.payment_url_time                                                                                                    ,
    r.ems_student_id                                                                                                      ,
    r.delete_reason                                                                                                       ,
    r.deleter                                                                                                             ,
    r.deleter_name                                                                                                        ,
    r.delete_time                                                                                                         ,
    r.course_id                                                                                                           ,
    r.course_name                                                                                                         ,
    r.delete_comment                                                                                                      ,
    r.close_state                                                                                                         ,
    r.close_time                                                                                                          ,
    r.appeal_id                                                                                                           ,
    r.tenant                                                                                                              ,
    r.total_fee                                                                                                           ,
    r.belonged                                                                                                            ,
    r.belonged_time                                                                                                       ,
    r.belonger_time                                                                                                       ,
    r.transfer                                                                                                            ,
    r.transfer_time                                                                                                       ,
    r.follow_type                                                                                                         ,
    r.transfer_bxg_oa_account                                                                                             ,
    r.transfer_bxg_belonger_name                                                                                          ,
    if(r.origin_type in('NETSERVICE','PRESIGNUP'),'1','0') as origin_type_stat                                            ,
    a.appeal_status as clue_appeal_state                                                                                  ,
    substr(r.create_date_time,1,4) as yearinfo                                                                            ,  
    substr(r.create_date_time,6,2) as monthinfo                                                                           ,  
    substr(r.create_date_time,9,2) as dayinfo                                                                             ,
    substr(r.create_date_time,12,2) as hourinfo                                                                           ,
    r.dt
from edu_ods.customer_relationship as r
    left join edu_ods.customer_appeal as a on  r.appeal_id = a.id and r.deleted = a.deleted 
where r.deleted = 0;




INSERT overwrite TABLE edu_dwd.fact_customer_clue PARTITION (dt)
SELECT
    c.id                                                           ,
    c.create_date_time                                             ,
    c.update_date_time                                             ,
    c.deleted                                                      ,
    c.customer_id                                                  ,
    c.customer_relationship_id                                     ,
    c.session_id                                                   ,
    c.sid                                                          ,
    c.status                                                       ,
    c.`user` as users                                              ,
    c.create_time                                                  ,
    c.platform                                                     ,
    c.s_name                                                       ,
    c.seo_source                                                   ,
    c.seo_keywords                                                 ,
    c.ip                                                           ,
    c.referrer                                                     ,
    c.from_url                                                     ,
    c.landing_page_url                                             ,
    c.url_title                                                    ,
    c.to_peer                                                      ,
    c.manual_time                                                  ,
    c.begin_time                                                   ,
    c.reply_msg_count                                              ,
    c.total_msg_count                                              ,
    c.msg_count                                                    ,
    c.comment                                                      ,
    c.finish_reason                                                ,
    c.finish_user                                                  ,
    c.end_time                                                     ,
    c.platform_description                                         ,
    c.browser_name                                                 ,
    c.os_info                                                      ,
    c.area                                                         ,
    c.country                                                      ,
    c.province                                                     ,
    c.city                                                         ,
    c.creator                                                      ,
    c.name                                                         ,
    c.idcard                                                       ,
    c.phone                                                        ,
    c.itcast_school_id                                             ,
    c.itcast_school                                                ,
    c.itcast_subject_id                                            ,
    c.itcast_subject                                               ,
    c.wechat                                                       ,
    c.qq                                                           ,
    c.email                                                        ,
    c.gender                                                       ,
    c.level                                                        ,
    c.origin_type                                                  ,
    c.information_way                                              ,
    c.working_years                                                ,
    c.technical_directions                                         ,
    c.customer_state                                               ,
    c.valid                                                        ,
    c.anticipat_signup_date                                        ,
    c.clue_state                                                   ,
    c.scrm_department_id                                           ,
    c.superior_url                                                 ,
    c.superior_source                                              ,
    c.landing_url                                                  ,
    c.landing_source                                               ,
    c.info_url                                                     ,
    c.info_source                                                  ,
    c.origin_channel                                               ,
    c.course_id                                                    ,
    c.course_name                                                  ,
    c.zhuge_session_id                                             ,
    c.is_repeat                                                    ,
    c.tenant                                                       ,
    c.activity_id                                                  ,
    c.activity_name                                                ,
    c.follow_type                                                  ,
    c.shunt_mode_id                                                ,
    c.shunt_employee_group_id                                      ,
    case 
        when c.clue_state = 'VALID_PUBLIC_NEW_CLUE' then '0' 
        when c.clue_state = 'VALID_NEW_CLUES' then '1' 
        else '-1'
        end
    as clue_state_stat                                          ,
    a.appeal_status as clue_appeal_state                        ,
    c.dt 
FROM edu_ods.customer_clue c
    left join edu_ods.customer_appeal  a on a.customer_relationship_first_id = c.customer_relationship_id;                 




-- dwb插入数据
insert into table edu_dwb.itcast_intention_dwb partition(dt)
select                                                 
    r.customer_id                                      ,
    r.create_date_time                                 ,
    c.area                                             ,
    r.itcast_school_id                                 ,
    i.name as itcast_school_name                       ,
    r.origin_type                                      ,                                                                            
    r.itcast_subject_id                                ,                                                                            
    isj.name as itcast_subject_name                     ,                                                                           
    r.hourinfo                                         ,                                                                            
    r.origin_type_state as origin_type_stat            ,                                                                            
    cc.clue_state_stat                                 ,
    r.clue_appeal_state                                ,                                                                            
    e.tdepart_id                                       ,                                                                            
    d.name as tdepart_name                             ,
    r.dayinfo                                          ,                                                                            
    r.yearinfo                                         ,                                                                            
    r.monthinfo                                        
    
from edu_dwd.customer_relationship r
    left join edu_ods.customer c on r.customer_id = c.id
    left join edu_ods.itcast_school i on r.itcast_school_id = i.id
    left join edu_ods.itcast_subject isj on r.itcast_subject_id = isj.id
    left join edu_dwd.fact_customer_clue cc on r.id = cc.customer_relationship_id
    left join edu_ods.employee e on r.creator = e.id
    left join edu_ods.scrm_department d on e.tdepart_id = d.id;
    

-- dm插入数据
INSERT into  hive.edu_dm.itcast_intention_dm partition(yearinfo,monthinfo,dayinfo)
select
    count(distinct (customer_id)) as customer_total,
    '2' as clue_nums
    -- count(if(appeal_status != 1 or appeal_status is null, customer_relationship_first_id , null)) as clue_cnt 
    area,
    itcast_school_id,
    itcast_school_name,
    origin_type,
    itcast_subject_id,
    itcast_subject_name,
    hourinfo,
    origin_type_stat,  
    clue_state_stat, 
    tdepart_id,
    tdepart_name,
    --
    CASE
        when grouping(yearinfo)= 0 then substring(yearinfo,1,4)
        when grouping(monthinfo)= 0 then substring(monthinfo,6,7)
        when grouping(dayinfo)=0 then substring(dayinfo,9,10)
        when grouping(hourinfo)= 0 then substring(hourinfo,12,13)
    end
    as time_str,
    --
    CASE
        when grouping(area)=0
        then 'area'
        when grouping(itcast_subject_id)=0
        then '学科'
        when grouping(itcast_school_id)=0
        then '校区'
        when grouping(origin_type)=0
        then '来源渠道'
        when grouping(tdepart_id)=0
        then '咨询中心'
        when grouping(clue_state_stat)=0
        then '新老客户'
        else '总意向量'
    end
    as group_type, 
    --
   CASE
        WHEN grouping(hourinfo)=0 THEN 'hour'
        WHEN grouping(dayinfo)=0 THEN 'day'
        WHEN grouping(monthinfo)=0 THEN 'mouth'
        WHEN grouping(yearinfo)=0 THEN 'year'
    END
        as time_type, -- 时间维度
    yearinfo,
    monthinfo,
    dayinfo
from hive.edu_dwb.dwb_customer_intention_dwb
group by
grouping sets(
    -- time_type：年
    (yearinfo),
    (yearinfo, origin_type_stat, clue_state_stat),
    (yearinfo, origin_type, clue_state_stat),
    (yearinfo, area, clue_state_stat),
    (yearinfo, itcast_subject_id,itcast_subject_name ,clue_state_stat),
    (yearinfo, itcast_school_id, itcast_school_name,clue_state_stat),
    (yearinfo, tdepart_id,tdepart_name, clue_state_stat),
    (yearinfo,  clue_state_stat),

    -- time_type：月
    (yearinfo, monthinfo),
    (yearinfo, monthinfo, origin_type_stat, clue_state_stat),
    (yearinfo, monthinfo, origin_type, clue_state_stat),
    (yearinfo, monthinfo, area, clue_state_stat),
    (yearinfo, monthinfo, itcast_subject_id, itcast_subject_name,clue_state_stat),
    (yearinfo, monthinfo, itcast_school_id, itcast_school_name,clue_state_stat),
    (yearinfo, monthinfo, tdepart_id,tdepart_name ,clue_state_stat),
    (yearinfo, monthinfo, clue_state_stat),

    -- time_type：天
    (yearinfo, monthinfo, dayinfo),
    (yearinfo, monthinfo, dayinfo, origin_type_stat, clue_state_stat),
    (yearinfo, monthinfo, dayinfo, origin_type, clue_state_stat ),
    (yearinfo, monthinfo, dayinfo, area, clue_state_stat ),
    (yearinfo, monthinfo, dayinfo, itcast_subject_id, itcast_subject_name,clue_state_stat ),
    (yearinfo, monthinfo, dayinfo, itcast_school_id, itcast_school_name,clue_state_stat ),
    (yearinfo, monthinfo, dayinfo, tdepart_id,tdepart_name, clue_state_stat ),
    (yearinfo, monthinfo, dayinfo, clue_state_stat ),

    -- time_type：小时
    (yearinfo, monthinfo, dayinfo, hourinfo),
    (yearinfo, monthinfo, dayinfo, hourinfo, origin_type_stat, clue_state_stat),
    (yearinfo, monthinfo, dayinfo, hourinfo, origin_type, clue_state_stat),
    (yearinfo, monthinfo, dayinfo, hourinfo, area, clue_state_stat),
    (yearinfo, monthinfo, dayinfo, hourinfo, itcast_subject_id, itcast_subject_name,clue_state_stat),
    (yearinfo, monthinfo, dayinfo, hourinfo, itcast_school_id, itcast_school_name,clue_state_stat),
    (yearinfo, monthinfo, dayinfo, hourinfo, tdepart_id,tdepart_name, clue_state_stat),
    (yearinfo, monthinfo, dayinfo, hourinfo,  clue_state_stat)

);

