-- 学生打卡信息表:
CREATE TABLE IF NOT EXISTS edu_ods.student_signin_ods (
    id                int,
    normal_class_flag int           comment '是否正课 1 正课 2 自习 3 休息',
    time_table_id     int           comment '作息时间id normal_class_flag=2 关联tbh_school_time_table 或者 normal_class_flag=1 关联 tbh_class_time_table',
    class_id          int           comment '班级id',
    student_id        int           comment '学员id',
    signin_time       String       comment '签到时间',
    signin_date       String          comment '签到日期',
    inner_flag        int           comment '内外网标志  0 外网 1 内网',
    signin_type       int           comment '签到类型 1 心跳打卡 2 老师补卡 3 直播打卡',
    share_state       int            comment '共享屏幕状态 0 否 1是  在上午或下午段有共屏记录，则该段所有记录该字段为1，内网默认为1 外网默认为0   (暂不用)',
    inner_ip          String          comment '内网ip地址',
    create_time       String       comment '创建时间')
comment '学生打卡记录表'
PARTITIONED BY (dt STRING)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
stored as orcfile
TBLPROPERTIES ('orc.compress'='SNAPPY','orc.bloom.filter.columns'='time_table_id,class_id,signin_date,share_state');

-- 学生请假信息表:
CREATE TABLE IF NOT EXISTS edu_ods.student_leave_apply_ods (
    id              int,
    class_id        int           comment '班级id',
    student_id      int           comment '学员id',
    audit_state     int        comment '审核状态 0 待审核 1 通过 2 不通过',
    audit_person    int           comment '审核人',
    audit_time      String      comment '审核时间',
    audit_remark    String     comment '审核备注',
    leave_type      int           comment '请假类型  1 请假 2 销假 （查询是否请假不用过滤此类型，通过有效状态来判断）',
    leave_reason    int           comment '请假原因  1 事假 2 病假',
    begin_time      String      comment '请假开始时间',
    begin_time_type int           comment '1：上午 2：下午 3：晚自习',
    end_time        String      comment '请假结束时间',
    end_time_type   int           comment '1：上午 2：下午 3：晚自习',
    days            float         comment '请假/已休天数',
    cancel_state    int         comment '撤销状态  0 未撤销 1 已撤销',
    cancel_time     String      comment '撤销时间',
    old_leave_id    int           comment '原请假id，只有leave_type =2 销假的时候才有',
    leave_remark    String     comment '请假/销假说明',
    valid_state     int        comment '是否有效（0：无效 1：有效）',
    create_time     String      comment '创建时间')
comment '学生请假申请表'
PARTITIONED BY (dt STRING)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
stored as orcfile
TBLPROPERTIES ('orc.compress'='SNAPPY','orc.bloom.filter.columns'='class_id,audit_state,cancel_state,valid_state');


-- 日期课程表
CREATE TABLE IF NOT EXISTS edu_ods.course_table_upload_detail_dimen
(
    id                  int       comment 'id',
    base_id             int         comment '课程主表id',
    class_id            int         comment '班级id',
    class_date          STRING      comment '上课日期',
    content             STRING     comment '课程内容',
    teacher_id          int         comment '老师id',
    teacher_name        STRING     comment '老师名字',
    job_number          STRING     comment '工号',
    classroom_id        int         comment '教室id',
    classroom_name      STRING     comment '教室名称',
    is_outline          int         comment '是否大纲 0 否 1 是',
    class_mode          int         comment '上课模式 0 传统全天 1 AB上午 2 AB下午 3 线上直播',
    is_stage_exam       int         comment '是否阶段考试（0：否 1：是）',
    is_pay              int         comment '代课费（0：无 1：有）',
    tutor_teacher_id    int         comment '晚自习辅导老师id',
    tutor_teacher_name  STRING     comment '辅导老师姓名',
    tutor_job_number    STRING     comment '晚自习辅导老师工号',
    is_subsidy          int         comment '晚自习补贴（0：无 1：有）',
    answer_teacher_id   int         comment '答疑老师id',
    answer_teacher_name STRING     comment '答疑老师姓名',
    answer_job_number   STRING     comment '答疑老师工号',
    remark              STRING        comment '备注',
    create_time         STRING      comment '创建时间')
comment '班级课表明细表'
PARTITIONED BY (dt STRING)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
stored as orcfile
TBLPROPERTIES ('orc.compress'='SNAPPY','orc.bloom.filter.columns'='class_id,class_date');


-- 班级作息时间表
CREATE TABLE IF NOT EXISTS edu_ods.class_time_dimen (
    id                     int,
    class_id              int              comment '班级id',
    morning_template_id   int              comment '上午出勤模板id',
    morning_begin_time    STRING         comment '上午开始时间',
    morning_end_time      STRING         comment '上午结束时间',
    afternoon_template_id int              comment '下午出勤模板id',
    afternoon_begin_time  STRING         comment '下午开始时间',
    afternoon_end_time    STRING         comment '下午结束时间',
    evening_template_id   int              comment '晚上出勤模板id',
    evening_begin_time    STRING         comment '晚上开始时间',
    evening_end_time      STRING         comment '晚上结束时间',
    use_begin_date        STRING         comment '使用开始日期',
    use_end_date          STRING         comment '使用结束日期',
    create_time           STRING       comment '创建时间',
    create_person         int              comment '创建人',
    remark                STRING      comment '备注')
comment '班级作息时间表'
PARTITIONED BY (dt STRING)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
stored as orcfile
TBLPROPERTIES ('orc.compress'='SNAPPY','orc.bloom.filter.columns'='id,class_id');


-- 班级在读人数表:
CREATE TABLE IF NOT EXISTS edu_ods.class_studying_student_count_dimen (
    id                     int,
    school_id              int  comment '校区id',
    subject_id             int  comment '学科id',
    class_id               int  comment '班级id',
    studying_student_count int  comment '在读班级人数',
    studying_date          STRING comment '在读日期')
comment '在读班级的每天在读学员人数'
PARTITIONED BY (dt STRING)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
stored as orcfile
TBLPROPERTIES ('orc.compress'='SNAPPY','orc.bloom.filter.columns'='studying_student_count,studying_date');