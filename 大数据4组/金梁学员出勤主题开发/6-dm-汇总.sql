DROP TABLE IF EXISTS edu_result.class_attendance_dm;
CREATE TABLE IF NOT EXISTS edu_result.class_attendance_dm
(
    dateinfo               longtext COMMENT '日期',
    class_id               longtext COMMENT '班级id',
    studying_student_count int COMMENT '在读班级人数',
    morning_att_count      int COMMENT '上午出勤人数',
    morning_att_ratio      double COMMENT '上午出勤率',
    afternoon_att_count    int COMMENT '下午出勤人数',
    afternoon_att_ratio    double COMMENT '下午出勤率',
    evening_att_count      int COMMENT '晚自习出勤人数',
    evening_att_ratio      double COMMENT '晚自习出勤率',
    morning_late_count     int COMMENT '上午迟到人数',
    morning_late_ratio     double COMMENT '上午迟到率',
    afternoon_late_count   int COMMENT '下午迟到人数',
    afternoon_late_ratio   double COMMENT '下午迟到率',
    evening_late_count     int COMMENT '晚自习迟到人数',
    evening_late_ratio     double COMMENT '晚自习迟到率',
    morning_leave_count    int COMMENT '上午请假人数',
    morning_leave_ratio    double COMMENT '上午请假率',
    afternoon_leave_count  int COMMENT '下午请假人数',
    afternoon_leave_ratio  double COMMENT '下午请假率',
    evening_leave_count    int COMMENT '晚自习请假人数',
    evening_leave_ratio    double COMMENT '晚自习请假率',
    morning_truant_count   int COMMENT '上午旷课人数',
    morning_truant_ratio   double COMMENT '上午旷课率',
    afternoon_truant_count int COMMENT '下午旷课人数',
    afternoon_truant_ratio double COMMENT '下午旷课率',
    evening_truant_count   int COMMENT '晚自习旷课人数',
    evening_truant_ratio   double COMMENT '晚自习旷课率'
)
CHARSET = utf8mb4
;


insert into mysql.edu_result.class_attendance_dm
select
    cast(dateinfo as varchar),
    cast(class_id as varchar),
    cast(studying_student_count as int),
    cast(morning_att_count as int),
    cast(morning_att_ratio as double),
    cast(afternoon_att_count as int),
    cast(afternoon_att_ratio as double),
    cast(evening_att_count as int),
    cast(evening_att_ratio as double),
    cast(morning_late_count as int),
    cast(morning_late_ratio as double),
    cast(afternoon_late_count as int),
    cast(afternoon_late_ratio as double),
    cast(evening_late_count as int),
    cast(evening_late_ratio as double),
    cast(morning_leave_count as int),
    cast(morning_leave_ratio as double),
    cast(afternoon_leave_count as int),
    cast(afternoon_leave_ratio as double),
    cast(evening_leave_count as int),
    cast(evening_leave_ratio as double),
    cast(morning_truant_count as int),
    cast(morning_truant_ratio as double),
    cast(afternoon_truant_count as int),
    cast(afternoon_truant_ratio as double),
    cast(evening_truant_count as int),
    cast(evening_truant_ratio as double)
from hive.edu_dws.attendance_summary_dwm;
