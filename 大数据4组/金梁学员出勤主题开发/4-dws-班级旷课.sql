drop table if exists edu_dws.class_truant_dwm;
-- 班级旷课信息表
CREATE TABLE IF NOT EXISTS edu_dws.class_truant_dwm
(
    dateinfo STRING COMMENT '日期',
    class_id int COMMENT '班级id',
    morning_truant_count STRING COMMENT '上午旷课人数',
    afternoon_truant_count STRING COMMENT '下午旷课人数',
    evening_truant_count STRING COMMENT '晚自习旷课人数'
)
COMMENT '班级请假数据统计' PARTITIONED BY (yearinfo STRING, monthinfo STRING, dayinfo STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS orcfile
TBLPROPERTIES ('orc.compress'='SNAPPY'); 
select * from edu_dws.class_truant_dwm;


-- edu_dws.class_truant_dwm
insert into edu_dws.class_truant_dwm
select
    a.dateinfo,
    a.class_id,
    cast(
        cast(c.studying_student_count as int) - (cast(a.morning_att_count as int) - coalesce(cast(l.morning_leave_count as int),0))
        as varchar)
    as morning_truant_count,
    cast(
        cast(c.studying_student_count as int) - (cast(a.afternoon_att_count as int) - coalesce(cast(l.afternoon_leave_count as int), 0))
        as varchar)
    as afternoon_truant_count,
    cast(
        cast(c.studying_student_count as int) - (cast(a.evening_att_count as int) - coalesce(cast(l.evening_leave_count as int), 0))
        as varchar)
    as evening_truant_count,
    substr('2022-08-08',1,4) as yearinfo,
    substr('2022-08-08',6,2) as monthinfo,
    substr('2022-08-08',9,2) as dayinfo
from edu_dws.class_attendance_dwm a
    left join edu_dws.class_leave_dwm l
        on a.class_id = l.class_id
            and a.dateinfo = l.dateinfo
    left join edu_ods.class_studying_student_count_dimen c
        on a.class_id = c.class_id
            and a.dateinfo = c.studying_date
where a.morning_att_count is not null
    and a.afternoon_att_count is not null
    and a.evening_att_count is not null
;
