DROP TABLE jy_dwb.student_attendance_dwm;
CREATE TABLE IF NOT EXISTS jy_dwb.student_attendance_dwm (
    dateinfo        String        comment '日期',
    class_id          int           comment '班级id',
    student_id        int           comment '学员id',
    sign_time       STRING          COMMENT '打卡时间',
    check_yes       STRING          COMMENT '有效出勤时段',
    type_check        string         COMMENT '出勤情况')
comment '学生出勤(正常出勤和迟到)数据'
PARTITIONED BY (dt string)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
stored as ORC
TBLPROPERTIES ('orc.compress'='SNAPPY');






create table jy_dwd.leave_apply(
    class_id        int     comment '班级id',
    student_id      int     comment '学生id',
    audit_state     string  comment '审核结果',
    audit_person     string    comment '审核人',
    audit_time       string     comment '审核时间',
    leave_type       string     comment '请假类型',
    leave_reason      string    comment '请假原因',
    begin_time       string     comment '请假开始时间',
    end_time          string    comment '请假结束时间',
    days            int         comment '请假/已休天数',
    leave_remark    string      comment '请假原因',
    valid_state     string
) PARTITIONED BY (dt string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orcfile
TBLPROPERTIES ('orc.compress'='SNAPPY');
;