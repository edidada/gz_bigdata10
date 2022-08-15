-- drop table if exists edu_dws.attendance_summary_dwm;

-- CREATE TABLE IF NOT EXISTS edu_dws.attendance_summary_dwm (
    dateinfo      String        comment '日期',
    class_id        int           comment '班级id',
   studying_student_count int  comment '在读班级人数',
    morning_att_count       String         comment '上午出勤人数',
   morning_att_ratio       String         comment '上午出勤率',
    afternoon_att_count      String        comment '下午出勤人数',
   afternoon_att_ratio      String        comment '下午出勤率',
    evening_att_count       String        comment '晚自习出勤人数',
   evening_att_ratio       String        comment '晚自习出勤率',
   morning_late_count       String        comment '上午迟到人数',
   morning_late_ratio       String        comment '上午迟到率',
    afternoon_late_count     String        comment '下午迟到人数',
   afternoon_late_ratio     String        comment '下午迟到率',
    evening_late_count       String        comment '晚自习迟到人数',
   evening_late_ratio       String        comment '晚自习迟到率',
   morning_leave_count       String       comment '上午请假人数',
   morning_leave_ratio       String       comment '上午请假率',
    afternoon_leave_count    String        comment '下午请假人数',
   afternoon_leave_ratio    String        comment '下午请假率',
    evening_leave_count       String        comment '晚自习请假人数',
   evening_leave_ratio       String        comment '晚自习请假率',
    morning_truant_count       String          comment '上午旷课人数',
   morning_truant_ratio       String          comment '上午旷课率',
    afternoon_truant_count   String        comment '下午旷课人数',
   afternoon_truant_ratio   String        comment '下午旷课率',
    evening_truant_count       String        comment '晚自习旷课人数',
   evening_truant_ratio       String        comment '晚自习旷课率')
comment '班级请假数据统计'
PARTITIONED BY (yearinfo STRING, monthinfo STRING, dayinfo STRING)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
stored as orcfile
TBLPROPERTIES ('orc.compress'='SNAPPY');


with field_data as (
    select
        ssc.studying_date as dateinfo,
        ssc.class_id,
        ssc.studying_student_count,     -- 在读班级人数
        cad.morning_att_count,          -- 上午出勤人数
        cad.afternoon_att_count,        -- 中午出勤人数
        cad.evening_att_count,          -- 晚上出勤人数
        cad.morning_late_count,         -- 上午迟到人数
        cad.afternoon_late_count,       -- 中午迟到人数
        cad.evening_late_count,         -- 晚上迟到人数
        cld.morning_leave_count,        -- 上午请假人数
        cld.afternoon_leave_count,      -- 中午请假人数
        cld.evening_leave_count,        -- 晚上请假人数
        ctd.morning_truant_count,       -- 上午旷课人数
        ctd.afternoon_truant_count,     -- 中午旷课人数
        ctd.evening_truant_count,       -- 晚上旷课人数
        substr(ssc.studying_date, 1, 4) as yearinfo,
        substr(ssc.studying_date, 6, 2) as monthinfo,
        substr(ssc.studying_date, 9, 2) as dayinfo
    from edu_ods.class_studying_student_count ssc
    join edu_dws.class_attendance_dwm cad
    on ssc.class_id = cad.class_id and ssc.studying_date = cad.dateinfo
    join edu_dws.class_truant_dwm ctd
    on ssc.class_id = ctd.class_id and ssc.studying_date = ctd.dateinfo
    left join edu_dws.class_leave_dwm cld
    on ssc.class_id = cld.class_id and ssc.studying_date = cld.dateinfo
)
-- insert into edu_dws.attendance_summary_dwm partition(yearinfo ,monthinfo ,dayinfo)
select
    dateinfo,                           -- 日期
    class_id,                           -- 班级id
    studying_student_count,             -- 在读班级人数
    morning_att_count,                  -- 上午出勤人数
    round(morning_att_count/studying_student_count, 2)
    as morning_att_ratio,               -- 上午出勤率
    afternoon_att_count,                -- 下午出勤人数
    round(afternoon_att_count/studying_student_count, 2)
    as afternoon_att_ratio,             -- 下午出勤率
    evening_att_count,                  -- 晚上出勤人数
    round(evening_att_count/studying_student_count, 2)
    as evening_att_ratio,               -- 晚上出勤率
    morning_late_count,                 -- 上午迟到人数
    round(morning_late_count/studying_student_count, 2)
    as morning_late_ratio,              -- 上午迟到率
    afternoon_late_count,               -- 中午迟到人数
    round(afternoon_late_count/studying_student_count, 2)
    as afternoon_late_ratio,            -- 中午迟到率
    evening_late_count,                 -- 晚上迟到人数
    round(evening_late_count/studying_student_count, 2)
    as evening_late_ratio,              -- 晚上迟到率
    morning_leave_count,                -- 上午请假人数
    round(morning_leave_count/studying_student_count, 2)
    as morning_leave_ratio,             -- 上午请假率
    afternoon_leave_count,              -- 中午请假人数
    round(afternoon_leave_count/studying_student_count, 2)
    as afternoon_leave_ratio,           -- 中午请假率
    evening_leave_count,                -- 晚上请假人数
    round(evening_leave_count/studying_student_count, 2)
    as evening_leave_ratio,             -- 晚上请假率
    morning_truant_count,               -- 上午旷课人数
    round(morning_truant_count/studying_student_count, 2)
    as morning_truant_ratio,            -- 上午旷课率
    afternoon_truant_count,             -- 中午旷课人数
    round(afternoon_truant_count/studying_student_count, 2)
    as afternoon_truant_ratio,          -- 中午旷课率
    evening_truant_count,               -- 晚上旷课人数
    round(evening_truant_count/studying_student_count, 2)
    as evening_truant_ratio,            -- 晚上旷课率
    yearinfo,                           -- 年
    monthinfo,                          -- 月
    dayinfo                             -- 日
from field_data;

select * from edu_dws.attendance_summary_dwm;
