-- # ods建表语句

drop database if exists jy_ods;
create database if not exists jy_ods;

-- 2- 创建表:
-- calendar
DROP TABLE IF EXISTS jy_ods.calendar;
create table if not exists jy_ods.calendar
(
    id              int                                    comment '主键',
    datelist        string
)
partitioned by(dt string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );

-- class_studying_student_count
DROP TABLE IF EXISTS jy_ods.class_studying_student_count;
create table if not exists jy_ods.class_studying_student_count
(
    id                              int                                          ,
    school_id                       int                              comment '校区id',
    subject_id                      int                              comment '学科id',
    class_id                        int                              comment '班级id',
    studying_student_count          int                              comment '在读班级人数',
    studying_date                   string                           comment '在读日期'
)
partitioned by(dt string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );


-- course_table_upload_detail
DROP TABLE IF EXISTS jy_ods.course_table_upload_detail;
create table if not exists jy_ods.course_table_upload_detail
(
    id                                  int                          comment 'id',
    base_id                             int                          comment '课程主表id',
    class_id                            int                          comment '班级id',
    class_date                          string                       comment '上课日期',
    content                             string                       comment '课程内容',
    teacher_id                          int                          comment '老师id',
    teacher_name                        string                       comment '老师名字',
    job_number                          string                       comment '工号',
    classroom_id                        int                          comment '教室id',
    classroom_name                      string                       comment '教室名称',
    is_outline                          int                          comment '是否大纲 0 否 1 是',
    class_mode                          int                          comment '上课模式 0 传统全天 1 AB上午 2 AB下午 3 线上直播',
    is_stage_exam                       int                          comment '是否阶段考试（0：否 1：是）',
    is_pay                              int                          comment '代课费（0：无 1：有）',
    tutor_teacher_id                    int                          comment '晚自习辅导老师id',
    tutor_teacher_name                  string                       comment '辅导老师姓名',
    tutor_job_number                    string                       comment '晚自习辅导老师工号',
    is_subsidy                          int                          comment '晚自习补贴（0：无 1：有）',
    answer_teacher_id                   int                          comment '答疑老师id',
    answer_teacher_name                 string                       comment '答疑老师姓名',
    answer_job_number                   string                       comment '答疑老师工号',
    remark                              string                       comment '备注',
    create_time                         string                       comment '创建时间'
)     
partitioned by(dt string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );




-- student_leave_apply
DROP TABLE IF EXISTS jy_ods.student_leave_apply;
create table if not exists jy_ods.student_leave_apply
(
    id                                  int                                             ,
    class_id                            int                              comment '班级id',
    student_id                          int                              comment '学员id',
    audit_state                         int                              comment '审核状态 0 待审核 1 通过 2 不通过',
    audit_person                        int                              comment '审核人',
    audit_time                          STRING                           comment '审核时间',
    audit_remark                        STRING                           comment '审核备注',
    leave_type                          int                              comment '请假类型  1 请假 2 销假',
    leave_reason                        int                              comment '请假原因  1 事假 2 病假',
    begin_time                          STRING                           comment '请假开始时间',
    begin_time_type                     int                              comment '1：上午 2：下午',
    end_time                            STRING                           comment '请假结束时间',
    end_time_type                       int                              comment '1：上午 2：下午',
    days                                float                            comment '请假/已休天数',
    cancel_state                        int                              comment '撤销状态  0 未撤销 1 已撤销',
    cancel_time                         STRING                           comment '撤销时间',
    old_leave_id                        int                              comment '原请假id，只有leave_type =2 销假的时候才有',
    leave_remark                        STRING                           comment '请假/销假说明',
    valid_state                         int                              comment '是否有效（0：无效 1：有效）',
    create_time                         STRING                           comment '创建时间'
)
partitioned by(dt string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );



-- tbh_class_time_table 
DROP TABLE IF EXISTS jy_ods.tbh_class_time_table;
create table if not exists jy_ods.tbh_class_time_table
(
    id                                  int                               comment '主键id',
    class_id                            int                               comment '班级id',
    morning_template_id                 int                               comment '上午出勤模板id',
    morning_begin_time                  STRING                            comment '上午开始时间',
    morning_end_time                    STRING                            comment '上午结束时间',
    afternoon_template_id               int                               comment '下午出勤模板id',
    afternoon_begin_time                STRING                            comment '下午开始时间',
    afternoon_end_time                  STRING                            comment '下午结束时间',
    evening_template_id                 int                               comment '晚上出勤模板id',
    evening_begin_time                  STRING                            comment '晚上开始时间',
    evening_end_time                    STRING                            comment '晚上结束时间',
    use_begin_date                      STRING                            comment '使用开始日期',
    use_end_date                        STRING                            comment '使用结束日期',
    create_time                         STRING                            comment '创建时间',
    create_person                       int                               comment '创建人',
    remark                              STRING                            comment '备注'
)
partitioned by(dt string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );



-- tbh_student_signin_record
DROP TABLE IF EXISTS jy_ods.tbh_student_signin_record;
create table if not exists jy_ods.tbh_student_signin_record
(
    id                                     int                               comment '主键id',
    normal_class_flag                      int                               comment '是否正课 1 正课 2 自习',
    time_table_id                          int                               comment '作息时间id 关联tbh_school_time_table 或者 tbh_class_time_table',
    class_id                               int                               comment '班级id',
    student_id                             int                               comment '学员id',
    signin_time                            STRING                            comment '签到时间',
    signin_date                            STRING                            comment '签到日期',
    inner_flag                             int                               comment '内外网标志  0 外网 1 内网',
    signin_type                            int                               comment '签到类型 1 心跳打卡 2 老师补卡',
    share_state                            int                               comment '共享屏幕状态 0 否 1是  在上午或下午段有共屏记录，则该段所有记录该字段为1，内网默认为1 外网默认为0 ',
    inner_ip                               STRING                            comment '内网ip地址'
)
partitioned by(dt string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );

