-- drop table if exists edu_dws.class_truant_dwm;

-- 班级旷课信息表
-- CREATE TABLE IF NOT EXISTS edu_dws.class_truant_dwm (
    dateinfo      String        comment '日期',
    class_id        int           comment '班级id',
    morning_truant_count       String          comment '上午旷课人数',
    afternoon_truant_count   String        comment '下午旷课人数',
    evening_truant_count       String        comment '晚自习旷课人数')
comment '班级旷课数据统计'
PARTITIONED BY (yearinfo STRING, monthinfo STRING, dayinfo STRING)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
stored as orcfile
TBLPROPERTIES ('orc.compress'='SNAPPY');

with class_count as (
    select
        ssc.studying_date as dateinfo,
        ssc.class_id,
        ssc.studying_student_count, -- 在读班级人数
        cad.morning_att_count,      -- 上午出勤人数
        cad.afternoon_att_count,    -- 中午出勤人数
        cad.evening_att_count,      -- 晚上出勤人数
        cld.morning_leave_count,    -- 上午请假人数
        cld.afternoon_leave_count,  -- 中午请假人数
        cld.evening_leave_count,    -- 晚上请假人数
        cld.yearinfo,
        cld.monthinfo,
        cld.dayinfo
    from edu_ods.class_studying_student_count ssc
    left join edu_dws.class_leave_dwm cld
    on ssc.class_id = cld.class_id and ssc.studying_date = cld.dateinfo
    join edu_dws.class_attendance_dwm cad
    on ssc.class_id = cad.class_id and ssc.studying_date = cad.dateinfo
)
-- insert into edu_dws.class_truant_dwm partition(yearinfo ,monthinfo ,dayinfo)
select
    dateinfo,
    class_id,
    -- 在读人数 - 上午出勤人数 - 上午请假人数 = 旷课人数
    floor(studying_student_count - morning_att_count - nvl(morning_leave_count,0)) as morning_truant_count,
    -- 在读人数 - 中午出勤人数 - 中午请假人数 = 旷课人数
    floor(studying_student_count - afternoon_att_count - nvl(afternoon_leave_count,0)) as afternoon_truant_count,
    -- 在读人数 - 晚上出勤人数 - 晚上请假人数 = 旷课人数
    floor(studying_student_count - evening_att_count - nvl(evening_leave_count,0)) as evening_truant_count,
    yearinfo,
    monthinfo,
    dayinfo
from class_count;

select * from edu_dws.class_truant_dwm;