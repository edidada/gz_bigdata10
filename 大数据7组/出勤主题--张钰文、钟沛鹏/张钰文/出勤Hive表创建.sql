Create Table if not exists edu_ods.calendar(
    id       int,
    datelist string
)
comment '日历'
partitioned by(dt string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );

Create Table if not exists edu_ods.class_studying_student_count(
    id                     int,
    school_id              int    Comment '校区id',
    subject_id             int    Comment '学科id',
    class_id               int    Comment '班级id',
    studying_student_count int    Comment '在读班级人数',
    studying_date          string Comment '在读日期'
)
comment '班级在读学生人数'
partitioned by(dt string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );

Create Table if not exists edu_ods.course_table_upload_detail(
    id                  int       Comment 'id',
    base_id             int       Comment '课程主表id',
    class_id            int       Comment '班级id',
    class_date          string    Comment '上课日期',
    content             string    Comment '课程内容',
    teacher_id          int       Comment '老师id',
    teacher_name        string    Comment '老师名字',
    job_number          string    Comment '工号',
    classroom_id        int       Comment '教室id',
    classroom_name      string    Comment '教室名称',
    is_outline          int       Comment '是否大纲 0 否 1 是',
    class_mode          int       Comment '上课模式 0 传统全天 1 AB上午 2 AB下午 3 线上直播',
    is_stage_exam       int       Comment '是否阶段考试（0：否 1：是）',
    is_pay              int       Comment '代课费（0：无 1：有）',
    tutor_teacher_id    int       Comment '晚自习辅导老师id',
    tutor_teacher_name  string    Comment '辅导老师姓名',
    tutor_job_number    string    Comment '晚自习辅导老师工号',
    is_subsidy          int       Comment '晚自习补贴（0：无 1：有）',
    answer_teacher_id   int       Comment '答疑老师id',
    answer_teacher_name string    Comment '答疑老师姓名',
    answer_job_number   string    Comment '答疑老师工号',
    remark              string    Comment '备注',
    create_time         string    Comment '创建时间'
)
comment '班级课表'
partitioned by(dt string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );

Create Table if not exists edu_ods.student_leave_apply(
    id              int,
    class_id        int           Comment '班级id',
    student_id      int           Comment '学员id',
    audit_state     int           Comment '审核状态 0 待审核 1 通过 2 不通过',
    audit_person    int           Comment '审核人',
    audit_time      string        Comment '审核时间',
    audit_remark    string        Comment '审核备注',
    leave_type      int           Comment '请假类型  1 请假 2 销假',
    leave_reason    int           Comment '请假原因  1 事假 2 病假',
    begin_time      string        Comment '请假开始时间',
    begin_time_type int           Comment '1：上午 2：下午',
    end_time        string        Comment '请假结束时间',
    end_time_type   int           Comment '1：上午 2：下午',
    days            int           Comment '请假/已休天数',
    cancel_state    int           Comment '撤销状态  0 未撤销 1 已撤销',
    cancel_time     string        Comment '撤销时间',
    old_leave_id    int           Comment '原请假id，只有leave_type =2 销假的时候才有',
    leave_remark    string        Comment '请假/销假说明',
    valid_state     int           Comment '是否有效（0：无效 1：有效）',
    create_time     string        Comment '创建时间'
)
comment '学生请假申请表'
partitioned by(dt string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );

Create Table if not exists edu_ods.tbh_class_time_table(
    id                    int     Comment '主键id',
    class_id              int     Comment '班级id',
    morning_template_id   int     Comment '上午出勤模板id',
    morning_begin_time    string  Comment '上午开始时间',
    morning_end_time      string  Comment '上午结束时间',
    afternoon_template_id int     Comment '下午出勤模板id',
    afternoon_begin_time  string  Comment '下午开始时间',
    afternoon_end_time    string  Comment '下午结束时间',
    evening_template_id   int     Comment '晚上出勤模板id',
    evening_begin_time    string  Comment '晚上开始时间',
    evening_end_time      string  Comment '晚上结束时间',
    use_begin_date        string  Comment '使用开始日期',
    use_end_date          string  Comment '使用结束日期',
    create_time           string  Comment '创建时间',
    create_person         int     Comment '创建人',
    remark                string  Comment '备注'
)
comment '班级作息时间表'
partitioned by(dt string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );

Create Table if not exists edu_ods.tbh_student_signin_record(
    id                int           Comment '主键id',
    normal_class_flag int           Comment '是否正课 1 正课 2 自习',
    time_table_id     int           Comment '作息时间id 关联tbh_school_time_table 或者 tbh_class_time_table',
    class_id          int           Comment '班级id',
    student_id        int           Comment '学员id',
    signin_time       string        Comment '签到时间',
    signin_date       string        Comment '签到日期',
    inner_flag        int           Comment '内外网标志  0 外网 1 内网',
    signin_type       int           Comment '签到类型 1 心跳打卡 2 老师补卡',
    share_state       int           Comment '共享屏幕状态 0 否 1是  在上午或下午段有共屏记录，则该段所有记录该字段为1，内网默认为1 外网默认为0 ',
    inner_ip          string        Comment '内网ip地址'
)
comment '学生打卡记录表'
partitioned by(dt string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );