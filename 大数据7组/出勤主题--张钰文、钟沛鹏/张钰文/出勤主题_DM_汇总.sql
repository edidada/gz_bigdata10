-- drop table if exists edu_dm.class_attendance_dm;

-- CREATE TABLE IF NOT EXISTS edu_dm.class_attendance_dm (
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
   evening_truant_ratio       String        comment '晚自习旷课率',
   time_type            STRING       COMMENT '聚合时间类型：1、按周聚合；2、按月聚合；3、按年聚合。')
comment '班级请假数据统计'
PARTITIONED BY (yearinfo STRING, monthinfo STRING, dayinfo STRING)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
stored as orcfile
TBLPROPERTIES ('orc.compress'='SNAPPY');

-- insert into edu_dm.class_attendance_dm partition(yearinfo ,monthinfo ,dayinfo)
select
    dateinfo,
    class_id,
    studying_student_count,
    morning_att_count,
    morning_att_ratio,
    afternoon_att_count,
    afternoon_att_ratio,
    evening_att_count,
    evening_att_ratio,
    morning_late_count,
    morning_late_ratio,
    afternoon_late_count,
    afternoon_late_ratio,
    evening_late_count,
    evening_late_ratio,
    morning_leave_count,
    morning_leave_ratio,
    afternoon_leave_count,
    afternoon_leave_ratio,
    evening_leave_count,
    evening_leave_ratio,
    morning_truant_count,
    morning_truant_ratio,
    afternoon_truant_count,
    afternoon_truant_ratio,
    evening_truant_count,
    evening_truant_ratio,
    '1' as time_type,
    yearinfo,
    monthinfo,
    dayinfo
from edu_dws.attendance_summary_dwm asd;

select * from edu_dm.class_attendance_dm;