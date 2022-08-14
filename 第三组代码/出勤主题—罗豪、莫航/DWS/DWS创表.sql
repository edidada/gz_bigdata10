CREATE TABLE jy_dws.gate_card(
    -- 日期
    dateinfo      String        comment '日期',
    -- 班级id
    class_id        int           comment '班级id',
    -- 在读总人数
    studying_student_count int  comment '在读班级人数',
    -- 班级上午出勤人数
    morning_att_count       String         comment '上午出勤人数',
    -- 班级下午出勤人数
    afternoon_att_count      String        comment '下午出勤人数',
    -- 班级晚上出勤人数
    evening_att_count       String        comment '晚自习出勤人数'
    -- 班级上午迟到人数
    morning_late_count       String        comment '上午迟到人数',
    -- 班级下午迟到人数
    afternoon_late_count     String        comment '下午迟到人数',
    -- 班级晚上迟到人数
    evening_late_count       String        comment '晚自习迟到人数',
    -- 班级上午请假人数
     morning_leave_count       String       comment '上午请假人数',
    -- 班级下午请假人数
    afternoon_leave_count    String        comment '下午请假人数',
    -- 班级晚上请假人数
    evening_leave_count       String        comment '晚自习请假人数',
    -- 班级上午旷课人数
    morning_truant_count       String          comment '上午旷课人数',
    -- 班级下午旷课人数
    afternoon_truant_count   String        comment '下午旷课人数',
    -- 班级晚上旷课人数
    evening_truant_count       String        comment '晚自习旷课人数',
)comment '班级考勤数据统计'
PARTITIONED BY (dt string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orcfile
TBLPROPERTIES ('orc.compress'='SNAPPY');