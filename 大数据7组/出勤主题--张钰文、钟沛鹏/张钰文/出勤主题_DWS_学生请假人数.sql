-- drop table if exists edu_dws.class_leave_dwm;

-- 班级请假信息表
-- CREATE TABLE IF NOT EXISTS edu_dws.class_leave_dwm (
    dateinfo      String        comment '日期',
    class_id        int           comment '班级id',
    morning_leave_count       String       comment '上午请假人数',
    afternoon_leave_count    String        comment '下午请假人数',
    evening_leave_count       String        comment '晚自习请假人数')
comment '班级请假数据统计'
PARTITIONED BY (yearinfo STRING, monthinfo STRING, dayinfo STRING)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
stored as orcfile
TBLPROPERTIES ('orc.compress'='SNAPPY');

with leave_data as (
    select
        tud.class_date as dateinfo,
        tud.class_id,
        sla.audit_state,
        sla.cancel_state,
        sla.valid_state,
        sla.student_id,
        unix_timestamp(sla.begin_time, 'yyyy-MM-dd HH:mm:ss') as begin_time,
        unix_timestamp(concat_ws(' ', tud.class_date, ctt.morning_begin_time), 'yyyy-MM-dd HH:mm:ss')-2400 as morning_schooltime,
        unix_timestamp(concat_ws(' ', tud.class_date, ctt.morning_end_time), 'yyyy-MM-dd HH:mm:ss') as morning_end_date,
        unix_timestamp(concat_ws(' ', tud.class_date, ctt.afternoon_begin_time), 'yyyy-MM-dd HH:mm:ss')-2400 as afternoon_schooltime,
        unix_timestamp(concat_ws(' ', tud.class_date, ctt.afternoon_end_time), 'yyyy-MM-dd HH:mm:ss') as afternoon_end_date,
        unix_timestamp(concat_ws(' ', tud.class_date, ctt.evening_begin_time), 'yyyy-MM-dd HH:mm:ss')-2400 as evening_schooltime,
        unix_timestamp(concat_ws(' ', tud.class_date, ctt.evening_end_time), 'yyyy-MM-dd HH:mm:ss') as evening_end_date,
        substr(class_date, 1, 4) as yearinfo,
        substr(class_date, 6, 2) as monthinfo,
        substr(class_date, 9, 2) as dayinfo
    from edu_ods.student_leave_apply sla
    join edu_ods.tbh_class_time_table ctt
    on sla.class_id = ctt.class_id
    join edu_ods.course_table_upload_detail tud
    on sla.class_id = tud.class_id
    where ctt.morning_begin_time >= substr(sla.begin_time, 12, 8) and ctt.morning_begin_time <= substr(sla.end_time, 12, 8)
        and tud.class_date >= substr(sla.begin_time, 1, 10) and tud.class_date <= substr(sla.end_time, 1, 10)
)
-- insert into edu_dws.class_leave_dwm partition(yearinfo ,monthinfo ,dayinfo)
select
    dateinfo,
    class_id,
-- 上午请假人数
    count(distinct
    case
        when begin_time between morning_schooltime and morning_end_date
        then if(audit_state = '1' and valid_state = '1', student_id, null) -- 请假
    end
    ) as morning_leave_count,
-- 下午请假人数
    count(distinct
    case
        when begin_time between afternoon_schooltime and afternoon_end_date
        then if(audit_state = '1' and valid_state = '1', student_id, null) -- 请假
    end
    ) as afternoon_leave_count,
-- 晚上请假人数
    count(distinct
    case
        when begin_time between evening_schooltime and evening_end_date
        then if(audit_state = '1' and valid_state = '1', student_id, null) -- 请假
    end
    ) as evening_leave_count,
    yearinfo,
    monthinfo,
    dayinfo
from leave_data
group by class_id, dateinfo, yearinfo, monthinfo, dayinfo;

