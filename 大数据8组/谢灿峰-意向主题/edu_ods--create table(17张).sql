--建库
create database if not exists edu_ods;
use edu_ods;

--创建'班级课表'
Drop table if exists edu_ods.course_table_upload_detail;
Create external table edu_ods.course_table_upload_detail
(
base_id               int              COMMENT'id',
id                    int              COMMENT'课程主表id',
class_id              int              COMMENT'班级id',
class_date            string                 COMMENT'上课日期',
content               string       COMMENT'课程内容',
teacher_id            int              COMMENT'老师id',
teacher_name          string         COMMENT'老师名字',
job_number            string         COMMENT'工号',
classroom_id          int              COMMENT'教室id',
classroom_name        string          COMMENT'教室名称',
is_outline            int              COMMENT'是否大纲 0 否 1 是',
class_mode            int              COMMENT'上课模式 0 传统全天 1 AB上午 2 AB下午 3 线上直播',
is_stage_exam         int              COMMENT'是否阶段考试（0：否 1：是）',
is_pay                int              COMMENT'代课费（0：无 1：有）',
tutor_teacher_id      int              COMMENT'晚自习辅导老师id',
tutor_teacher_name    string         COMMENT'辅导老师姓名',
tutor_job_number      string         COMMENT'晚自习辅导老师工号',
is_subsidy            int              COMMENT'晚自习补贴（0：无 1：有）',
answer_teacher_id     int              COMMENT'答疑老师id',
answer_teacher_name   string         COMMENT'答疑老师姓名',
answer_job_number     string         COMMENT'答疑老师工号',
remark                string       COMMENT'备注',
create_time           string            COMMENT'创建时间'
)
COMMENT'班级课表'
partitioned by (dt string)
row format delimited fields terminated by '\t'
stored as orc 
tblproperties('orc.compress' = 'SNAPPY');



--创建'学生请假申请表'
Drop table if exists edu_ods.student_leave_apply;
Create external table edu_ods.student_leave_apply
(
    id                    int       COMMENT'""',
    class_id              int       COMMENT'班级id',
    student_id            int       COMMENT'学员id',
    audit_state           int       COMMENT'审核状态 0 待审核 1 通过 2 不通过',
    audit_person          int       COMMENT'审核人',
    audit_time            string     COMMENT'审核时间',
    audit_remark          string  COMMENT'审核备注',
    leave_type            int       COMMENT'请假类型  1 请假 2 销假',
    leave_reason          int       COMMENT'请假原因  1 事假 2 病假',
    begin_time            string     COMMENT'请假开始时间',
    begin_time_type       int       COMMENT'1：上午 2：下午',
    end_time              string     COMMENT'请假结束时间',
    end_time_type         int       COMMENT'1：上午 2：下午',
    days                  float         COMMENT'请假/已休天数',
    cancel_state          int       COMMENT'撤销状态  0 未撤销 1 已撤销',
    cancel_time           string     COMMENT'撤销时间',
    old_leave_id          int       COMMENT'原请假id，只有leave_type =2 销假的时候才有',
    leave_remark          string  COMMENT'请假/销假说明',
    valid_state           int       COMMENT'是否有效（0：无效 1：有效）',
    create_time           string     COMMENT'创建时间'
)
COMMENT'学生请假申请表'
partitioned by (dt string)
row format delimited fields terminated by '\t'
stored as orc 
tblproperties('orc.compress' = 'SNAPPY');


--创建'班级作息时间表'
Drop table if exists edu_ods.tbh_class_time_table;
Create external table edu_ods.tbh_class_time_table
(
    id                      int           COMMENT'主键id',
    class_id                int           COMMENT'班级id',
    morning_template_id     int           COMMENT'上午出勤模板id',
    morning_begin_time      string              COMMENT'上午开始时间',
    morning_end_time        string              COMMENT'上午结束时间',
    afternoon_template_id   int           COMMENT'下午出勤模板id',
    afternoon_begin_time    string              COMMENT'下午开始时间',
    afternoon_end_time      string              COMMENT'下午结束时间',
    evening_template_id     int           COMMENT'晚上出勤模板id',
    evening_begin_time      string              COMMENT'晚上开始时间',
    evening_end_time        string              COMMENT'晚上结束时间',
    use_begin_date          string              COMMENT'使用开始日期',
    use_end_date            string              COMMENT'使用结束日期',
    create_time             string         COMMENT'创建时间',
    create_person           int           COMMENT'创建人',
    remark                  string      COMMENT'备注'
)
COMMENT'班级作息时间表'
partitioned by (dt string)
row format delimited fields terminated by '\t'
stored as orc 
tblproperties('orc.compress' = 'SNAPPY');


--创建'学生打卡记录表'
Drop table if exists edu_ods.tbh_student_signin_record;
Create external table edu_ods.tbh_student_signin_record
(
    id                  int     COMMENT'主键id',
    normal_class_flag   int     COMMENT'是否正课 1 正课 2 自习',
    time_table_id       int     COMMENT'作息时间id 关联tbh_school_time_table 或者 tbh_class_time_table',
    class_id            int     COMMENT'班级id',
    student_id          int     COMMENT'学员id',
    signin_time         string   COMMENT'签到时间',
    signin_date         string   COMMENT'签到日期',
    inner_flag          int     COMMENT'内外网标志  0 外网 1 内网',
    signin_type         int     COMMENT'签到类型 1 心跳打卡 2 老师补卡',
    share_state         int     COMMENT'共享屏幕状态 0 否 1是  在上午或下午段有共屏记录，则该段所有记录该字段为1，内网默认为1 外网默认为0  ',
    inner_ip            string   COMMENT'内网ip地址'
)
COMMENT'学生打卡记录表'
partitioned by (dt string)
row format delimited fields terminated by '\t'
stored as orc 
tblproperties('orc.compress' = 'SNAPPY');


--创建'日历表'
Drop table if exists edu_ods.calendar;
Create external table edu_ods.calendar
(
    id                  string    COMMENT'主键',      
    datelist            string               

)
COMMENT'日历表'
partitioned by (dt string)
row format delimited fields terminated by '\t'
stored as orc 
tblproperties('orc.compress' = 'SNAPPY');


--谢灿锋部分
--创建'校区表'
drop table if exists itcast_school;
create external table edu_ods.itcast_school
(
id string,
create_date_time string,
update_date_time string,
deleted int,
name string,
code string,
tenant string
)
partitioned by (dt string)
row format delimited fields terminated by '\t'
stored as orc
tblproperties ('orc.compress' = 'SNAPPY')
;


--创建'学科表'
drop table if exists itcast_subject;
create external table itcast_subject
(
id string,
create_date_time string,
update_date_time string,
deleted int,
name string,
code string,
tenant string
)
partitioned by (dt string)
row format delimited fields terminated by '\t'
stored as orc
tblproperties ('orc.compress' = 'SNAPPY')
;


--创建'部门表'
drop table if exists scrm_department;
create external table scrm_department
(
id string,
name string,
parent_id int,
create_date_time string,
update_date_time string,
deleted int,
id_path string,
tdepart_code string,
creator string,
depart_level string,
depart_sign string,
depart_line string,
depart_sort string,
disable_flag string,
tenant string
)
partitioned by (dt string)
row format delimited fields terminated by '\t'
stored as orc
tblproperties ('orc.compress' = 'SNAPPY')
;


--创建'班级在读学生人数表'
drop table if exists class_studying_student_count;
create external table class_studying_student_count
(
    id  string ,
    school_id              string comment '校区id',
    subject_id             int  comment '学科id',
    class_id               int  comment '班级id',
    studying_student_count string comment '在读班级人数',
    studying_date          string comment '在读日期'
)
partitioned by (dt string)
row format delimited fields terminated by '\t'
stored as orc
tblproperties ('orc.compress' = 'SNAPPY')
;


--郑植原部分
--创建'访问咨询记录主表'
drop table if exists web_chat_ems_2019_07;
create external table web_chat_ems_2019_07(
    id int comment '主键',
    create_date_time string comment'数据创建时间',
    session_id string comment '七陌sessionld',
    sid string comment '访客id',
    create_time string comment '会话创建时间',
    seo_source string comment '搜索来源',
    seo_keywords string comment '关键字',
    ip string comment 'ip地址',
    area string comment '地域',
    country string comment '所在国家',
    province string comment '省',
    city string comment '城市',
    origin_channel string comment '投放渠道',
    `user` string,
    manual_time string comment '人工开始时间',
    begin_time string comment '坐席领取时间',
    end_time string comment '会话结束时间',
    last_customer_msg_time_stamp string comment '客户最后一条消息的时间',
    last_agent_msg_time_stamp string comment '坐席最后一条回复时间',
    reply_msg_count int comment '客户回复消息数',
    msg_count int comment '客户发送消息数',
    browser_name string comment '浏览器名称',
    os_info string comment '系统名称'
)
partitioned by (dt string)
row format delimited
fields terminated by '\t'
stored as orc
tblproperties ('orc.compress'='SNAPPY');


--创建'访问咨询记录副表'
drop table if exists web_chat_text_ems_2019_07;
create external table web_chat_text_ems_2019_07(
    id int comment '主键',
    referrer string comment '上级来源页面',
    from_url string comment '会话来源页面',
    landing_page_url string comment '访客着陆页面',
    url_title string comment '咨询页面titile',
    platform_description string comment '客户平台信息',
    other_params string comment '扩展字段中数据',
    history string comment '历史访问记录'
)
partitioned by (dt string)
row format delimited
fields terminated by '\t'
stored as orc
tblproperties ('orc.compress'='SNAPPY');


--创建'客户静态信息表'
drop table if exists customer;
create external table customer(
    id int,
    customer_relationship_id int comment '当前意向id',
    create_date_time string comment '创建时间',
    update_date_time string comment '最后更新时间',
    deleted int comment '是否被删除（禁用）',
    name string comment '姓名',
    idcard string comment '身份证号',
    birth_year int comment '出生年份',
    gender string comment '性别',
    phone string comment '手机号',
    wechat string comment '微信',
    qq string comment 'QQ号',
    email string comment '邮箱',
    area string comment '所在区域',
    leave_school_date string comment '离校时间',
    graduation_date string comment '毕业时间',
    bxg_student_id string comment '博学谷学院id，可能未关联到，不存在',
    creator int comment '创建人id',
    origin_type string comment '数据来源',
    origin_channel string comment '来源渠道',
    tenant int,
    md_id int
)
partitioned by (dt string)
row format delimited
fields terminated by '\t'
stored as orc
tblproperties ('orc.compress'='SNAPPY');


--创建'线索申诉表'
drop table if exists customer_appeal;
create external table customer_appeal(
    id int comment '主键',
    customer_relationship_first_id int comment '第一条客户关系id',
    employee_id int comment '申诉人',
    employee_name int comment '申诉人姓名',
    employee_department_id int comment '申诉人部门',
    employee_tdepart_id int comment '申诉人所属部门',
    appeal_status int comment '申诉状态，0：待稽核 1：无效 2：有效',
    audit_id int comment '稽核人id',
    audit_name string comment '稽核人姓名',
    audit_department_id int comment '稽核人所在部门',
    audit_department_name string comment '稽核人部门名称',
    audit_date_time string comment '稽核时间',
    create_date_time string comment '创建时间',
    update_date_time string comment '更新时间',
    deleted int comment '删除标志位',
    tenant int
)
partitioned by (dt string)
row format delimited
fields terminated by '\t'
stored as orc
tblproperties ('orc.compress'='SNAPPY');


--王振宁部分
--创建'客户线索表'
DROP TABLE if EXISTS edu_ods.customer_clue;
CREATE external TABLE edu_ods.customer_clue(
    id int,
    create_date_time string,
    update_date_time string,
    deleted string,
    customer_id int,
    customer_relationship_id int,
    session_id string,
    sid string,
    status string,
    `user` string,
    create_time string,
    platform string,
    s_name string,
    seo_source string,
    seo_keywords string,
    ip string,
    referrer string,
    from_url string,
    landing_page_url string,
    url_title string,
    to_peer string,
    manual_time string,
    begin_time string,
    reply_msg_count int,
    total_msg_count int,
    msg_count int,
    `comment` string,
    finish_reason string,
    finish_user string,
    end_time string,
    platform_description string,
    browser_name string,
    os_info string,
    area string,
    country string,
    province string,
    city string,
    creator int,
    name string,
    idcard string,
    phone string,
    itcast_school_id int,
    itcast_school string,
    itcast_subject_id int,
    itcast_subject string,
    wechat string,
    qq string,
    email string,
    gender string,
    level string,
    origin_type string,
    information_way string,
    working_years string,
    technical_directions string,
    customer_state string,
    valid string,
    anticipat_signup_date string,
    clue_state string,
    scrm_department_id int,
    superior_url string,
    superior_source string,
    landing_url string,
    landing_source string,
    info_url string,
    info_source string,
    origin_channel string,
    course_id int,
    course_name string,
    zhuge_session_id string,
    is_repeat int,
    tenant int,
    activity_id string,
    activity_name string,
    follow_type int,
    shunt_mode_id int,
    shunt_employee_group_id int
 )
partitioned by (dt string)
row format delimited fields terminated by '\t'
stored as orc
tblproperties ('orc.compress' = 'SNAPPY');


--创建'客户意向表'
DROP TABLE if EXISTS edu_ods.customer_relationship;
CREATE external TABLE edu_ods.customer_relationship(
    id int,
    create_date_time string,
    update_date_time string,
    deleted string,
    customer_id int,
    first_id int,
    belonger int,
    belonger_name string,
    initial_belonger int,
    distribution_handler int,
    business_scrm_department_id int,
    last_visit_time string,
    next_visit_time string,
    origin_type string,
    itcast_school_id int,
    itcast_subject_id int,
    intention_study_type string,
    anticipat_signup_date string,
    level string,
    creator int,
    current_creator int,
    creator_name string,
    origin_channel string,
    `COMMENT` string,
    first_customer_clue_id int,
    last_customer_clue_id int,
    process_state string,
    process_time string,
    payment_state string,
    payment_time string,
    signup_state string,
    signup_time string,
    notice_state string,
    notice_time string,
    lock_state string,
    lock_time string,
    itcast_clazz_id int,
    itcast_clazz_time string,
    payment_url string,
    payment_url_time string,
    ems_student_id int,
    delete_reason string,
    deleter int,
    deleter_name string,
    delete_time string,
    course_id int,
    course_name string,
    delete_comment string,
    close_state string,
    close_time string,
    appeal_id int,
    tenant int,
    total_fee string,
    belonged int,
    belonged_time string,
    belonger_time string,
    transfer int,
    transfer_time string,
    follow_type int,
    transfer_bxg_oa_account string,
    transfer_bxg_belonger_name string
 )
partitioned by (dt string)
row format delimited fields terminated by '\t'
stored as orc
tblproperties ('orc.compress' = 'SNAPPY');


--创建'员工表'
DROP TABLE if EXISTS edu_ods.employee;
CREATE external TABLE edu_ods.employee(
    id int,
    email string,
    real_name string,
    phone string,
    department_id string,
    department_name string,
    remote_login string,
    job_number string,
    cross_school string,
    last_login_date string,
    creator int,
    create_date_time string,
    update_date_time string,
    deleted string,
    scrm_department_id int,
    leave_office string,
    leave_office_time string,
    reinstated_time string,
    superior_leaders_id int,
    tdepart_id int,
    tenant int,
    ems_user_name string
)
partitioned by (dt string)
row format delimited fields terminated by '\t'
stored as orc
tblproperties ('orc.compress' = 'SNAPPY');


--创建'报名课程表'
DROP TABLE if EXISTS edu_ods.itcast_clazz;
CREATE external TABLE edu_ods.itcast_clazz(
    id int,
    create_date_time string,
    update_date_time string,
    deleted string,
    itcast_school_id string,
    itcast_school_name string,
    itcast_subject_id string,
    itcast_subject_name string,
    itcast_brand string,
    clazz_type_state string,
    clazz_type_name string,
    teaching_mode string,
    start_time string,
    end_time string,
    comment string,
    detail string,
    uncertain string,
    tenant int
)
partitioned by (dt string)
row format delimited fields terminated by '\t'
stored as orc
tblproperties ('orc.compress' = 'SNAPPY');



CREATE DATABASE 





