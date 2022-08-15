dwd 插入语句

```sql
INSERT overwrite TABLE edu_dwd.fact_customer_relationship PARTITION (dt)
SELECT
  
    r.id, 
    r.create_date_time, 
    r.update_date_time, 
    r.deleted, 
    r.customer_id, 
    r.first_id,     
    r.belonger, 
    r.belonger_name, 
    r.initial_belonger, 
    r.distribution_handler, 
    r.business_scrm_department_id, 
    r.last_visit_time, 
    r.next_visit_time, 
    r.origin_type, 
    if(r.itcast_school_id = 0 or r.itcast_school_id = null ,-1,r.itcast_school_id) as itcast_school_id,
    if(r.itcast_subject_id = 0 or r.itcast_subject_id = null,-1,r.itcast_subject_id) as itcast_subject_id,
    r.intention_study_type, 
    r.anticipat_signup_date, 
    r.level, 
    r.creator, 
    r.current_creator, 
    r.creator_name, 
    r.origin_channel, 
    r.comment, 
    r.first_customer_clue_id, 
    r.last_customer_clue_id, 
    r.process_state, 
    r.process_time, 
    r.payment_state, 
    r.payment_time, 
    r.signup_state, 
    r.signup_time, 
    r.notice_state, 
    r.notice_time, 
    r.lock_state, 
    r.lock_time, 
    r.itcast_clazz_id, 
    r.itcast_clazz_time, 
    r.payment_url, 
    r.payment_url_time, 
    r.ems_student_id, 
    r.delete_reason, 
    r.deleter, 
    r.deleter_name, 
    r.delete_time, 
    r.course_id, 
    r.course_name, 
    r.delete_comment, 
    r.close_state, 
    r.close_time, 
    r.appeal_id, 
    r.tenant, 
    r.total_fee, 
    r.belonged, 
    r.belonged_time, 
    r.belonger_time, 
    r.transfer, 
    r.transfer_time, 
    r.follow_type, 
    r.transfer_bxg_oa_account, 
    r.transfer_bxg_belonger_name,
    substring(r.create_date_time, 1, 13) as hourinfo ,
    if(r.origin_type = 'NETSERVICE' or r.origin_type = 'PRESIGNUP',1,0) as origin_type_state,
    a.appeal_status as clue_appeal_state,
    substring(r.create_date_time,1,4) as yearinfo,
    substring(r.create_date_time, 1, 7)as monthinfo,
    substring(r.create_date_time, 1, 10)as dayinfo,
    r.dt string
   
FROM edu_ods.customer_relationship r
left join edu_ods.customer_appeal a  on  r.id = a.customer_relationship_first_id;
```

```sql
-- 线索表
INSERT overwrite TABLE edu_dwd.fact_customer_clue PARTITION (dt)
SELECT
    c.id,
    c.create_date_time,
    c.update_date_time,
    c.deleted,
    c.customer_id,
    c.customer_relationship_id,
    c.session_id,
    c.sid,
    c.status,
    c.`user` users,
    c.create_time,
    c.platform,
    c.s_name,
    c.seo_source,
    c.seo_keywords,
    c.ip,
    c.referrer,
    c.from_url,
    c.landing_page_url,
    c.url_title,
    c.to_peer,
    c.manual_time,
    c.begin_time,
    c.reply_msg_count,
    c.total_msg_count,
    c.msg_count,
    c.`comment`,
    c.finish_reason,
    c.finish_user,
    c.end_time,
    c.platform_description,
    c.browser_name,
    c.os_info,
    c.area,
    c.country,
    c.province,
    c.city,
    c.creator,
    c.name,
    c.idcard,
    c.phone,
    if(c.itcast_school_id = 0 or c.itcast_school_id = null ,-1,c.itcast_school_id) as itcast_school_id,
    c.itcast_school,
    if(c.itcast_subject_id = 0 or c.itcast_subject_id = null,-1,c.itcast_subject_id) as itcast_subject_id,
    c.itcast_subject,
    c.wechat,
    c.qq,
    c.email,
    c.gender,
    c.level,
    c.origin_type,
    c.information_way,
    c.working_years,
    c.technical_directions,
    c.customer_state,
    c.valid,
    c.anticipat_signup_date,
    c.clue_state,
    c.scrm_department_id,
    c.superior_url,
    c.superior_source,
    c.landing_url,
    c.landing_source,
    c.info_url,
    c.info_source,
    c.origin_channel,
    c.course_id,
    c.course_name,
    c.zhuge_session_id,
    c.is_repeat,
    c.tenant,
    c.activity_id,
    c.activity_name,
    c.follow_type,
    c.shunt_mode_id,
    c.shunt_employee_group_id,
    case 
        when c.clue_state = 'VALID_PUBLIC_NEW_CLUE' then '0' 
        when c.clue_state = 'VALID_NEW_CLUES' then '1' 
        else '-1'
        end
    as clue_state_stat,
    a.appeal_status as clue_appeal_state,
    c.dt 
FROM edu_ods.customer_clue c
left join edu_ods.customer_appeal  a on a.customer_relationship_first_id = c.customer_relationship_id;
```

```sql
--剩余的表
INSERT overwrite TABLE edu_dwd.fact_customer_appeal  PARTITION (dt)   
SELECT * from edu_ods.customer_appeal;
--
insert overwrite table edu_dwd.dim_customer partition (dt)
select *  from edu_ods.customer;

insert overwrite table edu_dwd.dim_employee partition (dt)
select * from edu_ods.employee;

--

insert overwrite table edu_dwd.dim_itcast_school  partition (dt)
select * from edu_ods.itcast_school;
 
insert overwrite table edu_dwd.dim_itcast_subject partition(dt)
select * from  edu_ods.itcast_subject;

insert overwrite table edu_dwd.dim_scrm_deparment partition (dt)
select * from edu_ods.scrm_department;
```

