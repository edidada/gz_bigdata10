-- # dwd建表语句

drop database if exists jy_dwd;
create database if not exists jy_dwd;

-- 2- 创建表:
-- calendar
DROP TABLE IF EXISTS jy_dwd.calendar;
create table if not exists jy_dwd.calendar
(
    id              int                                    comment '主键',
    datelist        string
)
COMMENT '日历表'
partitioned by(dt string)
clustered BY(id) sorted by (id ASC) INTO 10 buckets
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY', "orc.bloom.filter.columns"="id");

-- class_studying_student_count
DROP TABLE IF EXISTS jy_dwd.class_studying_student_count;
create external table if not exists jy_dwd.class_studying_student_count
(
    id                              int                                          ,
    school_id                       int                              comment '校区id',
    subject_id                      int                              comment '学科id',
    class_id                        int                              comment '班级id',
    studying_student_count          int                              comment '在读班级人数',
    studying_date                   string                           comment '在读日期'
)
COMMENT '班级在读学生人数'
partitioned by(dt string)
clustered BY(id) sorted by (id ASC) INTO 10 buckets
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY', "orc.bloom.filter.columns"="id");


-- course_table_upload_detail
DROP TABLE IF EXISTS jy_dwd.course_table_upload_detail;
create external table if not exists jy_dwd.course_table_upload_detail
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
    is_outline                          string                          comment '是否大纲 0 否 1 是',   #枚举转换
    class_mode                          string                          comment '上课模式 0 传统全天 1 AB上午 2 AB下午 3 线上直播',	#枚举转换
    is_stage_exam                       string                          comment '是否阶段考试（0：否 1：是）',		#枚举转换
    is_pay                              string                          comment '代课费（0：无 1：有）',	#枚举转换
    tutor_teacher_id                    int                          comment '晚自习辅导老师id',
    tutor_teacher_name                  string                       comment '辅导老师姓名',
    tutor_job_number                    string                       comment '晚自习辅导老师工号',
    is_subsidy                          string                          comment '晚自习补贴（0：无 1：有）',	#枚举转换
    answer_teacher_id                   int                          comment '答疑老师id',
    answer_teacher_name                 string                       comment '答疑老师姓名',
    answer_job_number                   string                       comment '答疑老师工号',
    remark                              string                       comment '备注',
    create_time                         string                       comment '创建时间'
)
COMMENT '班级课表'     
partitioned by(dt string)
clustered BY(id) sorted by (id ASC) INTO 10 buckets
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY', "orc.bloom.filter.columns"="id");




-- student_leave_apply
DROP TABLE IF EXISTS jy_dwd.student_leave_apply;
create external table if not exists jy_dwd.student_leave_apply
(
    id                                  int                                             ,
    class_id                            int                              comment '班级id',
    student_id                          int                              comment '学员id',
    audit_state                         string                              comment '审核状态 0 待审核 1 通过 2 不通过',	#枚举转换
    audit_person                        int                              comment '审核人',
    audit_time                          STRING                           comment '审核时间',
    audit_remark                        STRING                           comment '审核备注',
    leave_type                          string                              comment '请假类型  1 请假 2 销假',		#枚举转换
    leave_reason                        string                              comment '请假原因  1 事假 2 病假',		#枚举转换
    begin_time                          STRING                           comment '请假开始时间',
    begin_time_type                     string                              comment '1：上午 2：下午',		#枚举转换
    end_time                            STRING                           comment '请假结束时间',
    end_time_type                       string                              comment '1：上午 2：下午',		#枚举转换
    days                                float                            comment '请假/已休天数',
    cancel_state                        string                              comment '撤销状态  0 未撤销 1 已撤销',		#枚举转换
    cancel_time                         STRING                           comment '撤销时间',
    old_leave_id                        int                              comment '原请假id，只有leave_type =2 销假的时候才有',
    leave_remark                        STRING                           comment '请假/销假说明',
    valid_state                         string                              comment '是否有效（0：无效 1：有效）',		#枚举转换
    create_time                         STRING                           comment '创建时间'
)
COMMENT '学生请假申请表'
partitioned by(dt string)
clustered BY(id) sorted by (id ASC) INTO 10 buckets
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY', "orc.bloom.filter.columns"="id");



-- tbh_class_time_table 
DROP TABLE IF EXISTS jy_dwd.tbh_class_time_table;
create external table if not exists jy_dwd.tbh_class_time_table
(
    id                                  int                               comment '主键id',
    class_id                            int                               comment '班级id',
    morning_template_id                 int                               comment '上午出勤模板id',
	morning_ahead_40m_time				STRING							  comment '上午上课前40分钟时间点',
	morning_begin_time                  STRING                            comment '上午开始时间',
    morning_after_10m_time				STRING                            comment '上午上课后10分钟时间点',
	morning_end_time                    STRING                            comment '上午结束时间',
    afternoon_template_id               int                               comment '下午出勤模板id',
    afternoon_ahead_40m_time			STRING                            comment '下午上课前40分钟时间点',
	afternoon_begin_time                STRING                            comment '下午开始时间',
    afternoon_after_10m_time			STRING                            comment '下午上课后10分钟时间点',
	afternoon_end_time                  STRING                            comment '下午结束时间',
    evening_template_id                 int                               comment '晚上出勤模板id',
    evening_ahead_40m_time				STRING							  comment '晚上上课前40分钟时间点',
	evening_begin_time                  STRING                            comment '晚上开始时间',
    evening_after_10m_time              STRING                            comment '晚上上课后10分钟时间点',
	evening_end_time                    STRING                            comment '晚上结束时间',
    use_begin_date                      STRING                            comment '使用开始日期',
    use_end_date                        STRING                            comment '使用结束日期',
    create_time                         STRING                            comment '创建时间',
    create_person                       int                               comment '创建人',
    remark                              STRING                            comment '备注'
)
COMMENT '班级作息时间表'
partitioned by(dt string)
clustered BY(id) sorted by (id ASC) INTO 10 buckets
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY', "orc.bloom.filter.columns"="id");



-- tbh_student_signin_record
DROP TABLE IF EXISTS jy_dwd.tbh_student_signin_record;
create external table if not exists jy_dwd.tbh_student_signin_record
(
    id                                     int                               comment '主键id',
    normal_class_flag                      STRING                               comment '是否正课 1 正课 2 自习',		#枚举转换
    time_table_id                          int                               comment '作息时间id 关联tbh_school_time_table 或者 tbh_class_time_table',
    class_id                               int                               comment '班级id',
    student_id                             int                               comment '学员id',
    signin_time                            STRING                            comment '签到时间',
    signin_date                            STRING                            comment '签到日期',
    inner_flag                             string                               comment '内外网标志  0 外网 1 内网',		#枚举转换
    signin_type                            string                               comment '签到类型 1 心跳打卡 2 老师补卡',		#枚举转换
    share_state                            STRING                               comment '共享屏幕状态 0 否 1是  在上午或下午段有共屏记录，则该段所有记录该字段为1，内网默认为1 外网默认为0 ',	#枚举转换
    inner_ip                               STRING                            comment '内网ip地址'
)
COMMENT '学生打卡记录表'
partitioned by(dt string)
clustered BY(id) sorted by (id ASC) INTO 10 buckets
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY', "orc.bloom.filter.columns"="id");

