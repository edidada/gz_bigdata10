insert into hive.edu_dm.dm_all
with tmp as (
select
-- 维度
    dc.yearinfo,
    dc.monthinfo,
    dc.dayinfo,
    substring(dc.houseinfo,1,2) as hourinfo,
    dc.origin_type_state,
    dc.clue_state_stat,
    dc.cc_area,
    dc.itcast_subject_id,
    oits.name as su_name,
    dc.itcast_school_id,
    oit.name as sc_name,
    sub.tdepart_id,
    sub.name as bname,

-- 指标
dc.customer_id,
if(
regexp_like(dc.phone,'^1[3456789]\d{9}$'),
dc.phone,null
)
as sum_phone


from hive.edu_dwb.dwb_customer dc
left join hive.edu_dwb.dwb_employee sub
on dc.cr_creator = sub.id
left join hive.edu_ods.itcast_subject oits
on dc.itcast_subject_id = oits.id
left join hive.edu_ods.itcast_school oit
on dc.itcast_school_id = oit.id
where cc_deleted = 'false'
)
select
--维度
    yearinfo,
    monthinfo,
    dayinfo,
    hourinfo,
    origin_type_state,
    clue_state_stat,
    cc_area,
    itcast_subject_id,
    su_name,
    itcast_school_id,
    sc_name,
    tdepart_id,
    bname,
--指标
    count(customer_id) AS total,
    count(sum_phone) as phone,
    count(customer_id) as sess,
--时间维度类型
    case
        when grouping(hourinfo)=0
        then 'hour'
        when grouping(dayinfo)=0
        then 'day'
        when grouping(monthinfo)=0
        then 'month'
        when grouping(yearinfo)=0
        then 'year'
    end as time_type,
--维度类型
    case
        when grouping(itcast_subject_id)=0
        then 'subject'
        when grouping(itcast_school_id)=0
        then 'school'
        when grouping(tdepart_id)=0
        then 'tdepart'
        when grouping(cc_area)=0
        then 'area'
        when grouping(clue_state_stat)=0
        then 'cue_state_stat'
        when grouping(origin_type_state)=0
        then 'origin_type_state'
        else 'all'
    end as group_type,
    '2022-08-14' as dt

from tmp
group by
grouping sets(
--小时
(yearinfo,monthinfo,dayinfo,hourinfo),
(yearinfo,monthinfo,dayinfo,hourinfo,origin_type_state),
(yearinfo,monthinfo,dayinfo,hourinfo,origin_type_state,clue_state_stat),
(yearinfo,monthinfo,dayinfo,hourinfo,origin_type_state,clue_state_stat,cc_area),
(yearinfo,monthinfo,dayinfo,hourinfo,origin_type_state,clue_state_stat,itcast_subject_id,su_name),
(yearinfo,monthinfo,dayinfo,hourinfo,origin_type_state,clue_state_stat,itcast_school_id,sc_name),
(yearinfo,monthinfo,dayinfo,hourinfo,origin_type_state,clue_state_stat,tdepart_id,bname),
--天
(yearinfo,monthinfo,dayinfo),
(yearinfo,monthinfo,dayinfo,origin_type_state),
(yearinfo,monthinfo,dayinfo,origin_type_state,clue_state_stat),
(yearinfo,monthinfo,dayinfo,origin_type_state,clue_state_stat,cc_area),
(yearinfo,monthinfo,dayinfo,origin_type_state,clue_state_stat,itcast_subject_id,su_name),
(yearinfo,monthinfo,dayinfo,origin_type_state,clue_state_stat,itcast_school_id,sc_name),
(yearinfo,monthinfo,dayinfo,origin_type_state,clue_state_stat,tdepart_id,bname),
--月
(yearinfo,monthinfo),
(yearinfo,monthinfo,origin_type_state),
(yearinfo,monthinfo,origin_type_state,clue_state_stat),
(yearinfo,monthinfo,origin_type_state,clue_state_stat,cc_area),
(yearinfo,monthinfo,origin_type_state,clue_state_stat,itcast_subject_id,su_name),
(yearinfo,monthinfo,origin_type_state,clue_state_stat,itcast_school_id,sc_name),
(yearinfo,monthinfo,origin_type_state,clue_state_stat,tdepart_id,bname),
--年
(yearinfo),
(yearinfo,origin_type_state),
(yearinfo,origin_type_state,clue_state_stat),
(yearinfo,origin_type_state,clue_state_stat,cc_area),
(yearinfo,origin_type_state,clue_state_stat,itcast_subject_id,su_name),
(yearinfo,origin_type_state,clue_state_stat,itcast_school_id,sc_name),
(yearinfo,origin_type_state,clue_state_stat,tdepart_id,bname)
);
