drop table if exists edu_dws.attendance_summary_dwm;
-- 汇总表
CREATE TABLE IF NOT EXISTS edu_dws.attendance_summary_dwm (
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
select * from edu_dws.attendance_summary_dwm;


-- edu_dws.attendance_summary_dwm
insert into edu_dws.attendance_summary_dwm
with tmp as(
    select
        a.dateinfo,
        a.class_id,
        -- attandence
        cast(studying_student_count as int) studying_student_count,
        cast(a.morning_att_count as int) morning_att_count,
        cast(a.afternoon_att_count as int) afternoon_att_count,
        cast(a.evening_att_count as int) evening_att_count,
        -- late
        cast(a.morning_late_count as int) morning_late_count,
        cast(a.afternoon_late_count as int) afternoon_late_count,
        cast(a.evening_late_count as int) evening_late_count,
        -- leave
        coalesce(cast(l.morning_leave_count as int), 0) morning_leave_count,
        coalesce(cast(l.afternoon_leave_count as int), 0) afternoon_leave_count,
        coalesce(cast(l.evening_leave_count as int), 0) evening_leave_count,
        -- truant
        cast(t.morning_truant_count as int) morning_truant_count,
        cast(t.afternoon_truant_count as int) afternoon_truant_count,
        cast(t.evening_truant_count as int) evening_truant_count
    from edu_dws.class_attendance_dwm a
        left join edu_dws.class_leave_dwm l
            on a.class_id = l.class_id
                and a.dateinfo = l.dateinfo
        left join edu_dws.class_truant_dwm t
            on a.class_id = t.class_id
                and a.dateinfo = t.dateinfo
        left join edu_ods.class_studying_student_count_dimen c
            on a.class_id = c.class_id
                and a.dateinfo = c.studying_date
)
select
    dateinfo,
    class_id,
    -- attendence
    studying_student_count,
    cast(morning_att_count as varchar) morning_att_count,
    cast(if (studying_student_count  <> 0 and studying_student_count is not null,
        cast(morning_att_count as decimal(38, 4))  / cast(studying_student_count as decimal(38, 4)),
        0) as varchar
    ) as morning_att_ratio,
    cast(afternoon_att_count as varchar) afternoon_att_count,
    cast(if (studying_student_count  <> 0 and studying_student_count is not null,
        cast(afternoon_att_count as decimal(38, 4))  / cast(studying_student_count as decimal(38, 4)),
        0) as varchar
    ) as afternoon_att_ratio,
    cast(evening_att_count as varchar),
    cast(if (studying_student_count  <> 0 and studying_student_count is not null,
        cast(evening_att_count as decimal(38, 4)) / cast(studying_student_count as decimal(38, 4)),
        0) as varchar
    ) as evening_att_ratio,
    cast(morning_late_count as varchar),
    cast(if (studying_student_count  <> 0 and studying_student_count is not null,
         cast(morning_late_count as decimal(38, 4))  / cast(studying_student_count as decimal(38, 4)),
        0) as varchar
    ) as morning_late_ratio,
    cast(afternoon_late_count as varchar),
    cast(if (studying_student_count  <> 0 and studying_student_count is not null,
        cast(afternoon_late_count as decimal(38, 4))  / cast(studying_student_count as decimal(38, 4)),
        0) as varchar
    ) as afternoon_late_ratio,
    cast(evening_late_count as varchar),
    cast(if (studying_student_count  <> 0 and studying_student_count is not null,
        cast(evening_late_count as decimal(38, 4))  / cast(studying_student_count as decimal(38, 4)),
        0) as varchar
    ) as evening_late_ratio,
    -- leave
    cast(morning_leave_count as varchar),
    cast(if (studying_student_count  <> 0 and studying_student_count is not null,
        cast(morning_leave_count as decimal(38, 4))  / cast(studying_student_count as decimal(38, 4)),
        0) as varchar
    ) as morning_leave_ratio,
    cast(afternoon_leave_count as varchar),
    cast(if (studying_student_count  <> 0 and studying_student_count is not null,
        cast(afternoon_leave_count as decimal(38, 4))  / cast(studying_student_count as decimal(38, 4)),
        0) as varchar
    ) as afternoon_leave_ratio,
    cast(evening_leave_count as varchar),
    cast(if (studying_student_count  <> 0 and studying_student_count is not null,
        cast(evening_leave_count as decimal(38, 4)) / cast(studying_student_count as decimal(38, 4)),
        0) as varchar
    ) as evening_leave_ratio,
    -- truant
    cast(morning_truant_count as varchar),
    cast(if (studying_student_count  <> 0 and studying_student_count is not null,
        cast(morning_truant_count as decimal(38, 4))  / cast(studying_student_count as decimal(38, 4)),
        0) as varchar
    ) as morning_truant_ratio,
    cast(afternoon_truant_count as varchar),
    cast(if (studying_student_count  <> 0 and studying_student_count is not null,
        cast(afternoon_truant_count as decimal(38, 4))  / cast(studying_student_count as decimal(38, 4)),
        0) as varchar
    ) as afternoon_truant_ratio,
    cast(evening_truant_count as varchar),
    cast(if (studying_student_count  <> 0 and studying_student_count is not null,
        cast(evening_truant_count as decimal(38, 4))  / cast(studying_student_count as decimal(38, 4)),
        0) as varchar
    ) as evening_truant_ratio,
    substr('2022-08-08',1,4) as yearinfo,
    substr('2022-08-08',6,2) as monthinfo,
    substr('2022-08-08',9,2) as dayinfo
from tmp
;