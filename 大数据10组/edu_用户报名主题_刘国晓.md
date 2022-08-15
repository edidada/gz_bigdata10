# 报名用户主题

#### ODS层

```sql
-- 创建部门表ods_scrm_department

drop table if exists edu_ods.ods_scrm_department;

create table edu_ods.ods_scrm_department(
    id               int comment '部门id',
    name             string comment '部门名称',
    parent_id        int comment '父部门id',
    create_date_time string comment '创建时间',
    update_date_time string comment '更新时间',
    deleted          string comment '删除标志',
    id_path          string comment '编码全路径',
    tdepart_code     int comment '直属部门',
    creator          string comment '创建者',
    depart_level     int comment '部门层级',
    depart_sign      int comment '部门标志，暂时默认1',
    depart_line      int comment '业务线，存储业务线编码',
    depart_sort      int comment '排序字段',
    disable_flag     int comment '禁用标志',
    tenant           int
)comment '部门表'
partitioned by(dt string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );

-- 创建学科表ods_itcast_subject

drop table if exists edu_ods.ods_itcast_subject;

create table edu_ods.ods_itcast_subject(
    id               int,
    create_date_time string comment '创建时间',
    update_date_time string comment '最后更新时间',
    deleted          string comment '是否被删除（禁用）',
    name             string comment '学科名称',
    code             string,
    tenant           int
)comment '学科表'
partitioned by(dt string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );

-- 创建校区表 ods_itcast_school
drop table if exists edu_ods.ods_itcast_school;

create table edu_ods.ods_itcast_school(
    id  int,
    create_date_time string  comment '创建时间',
    update_date_time string comment '最后更新时间',
    deleted          string comment '是否被删除（禁用)',
    name             string comment '校区名称',
    code             string,
    tenant           int

)comment '校区表'
partitioned by(dt string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );

-- 创建名课程表ods_itcast_clazz

drop table if exists edu_ods.ods_itcast_clazz;

create table edu_ods.ods_itcast_clazz(
    id                  int comment 'ems课程id(非自增)',
    create_date_time    string comment '创建时间',
    update_date_time    string comment '最后更新时间',
    deleted             int comment '是否被删除（禁用）',
    itcast_school_id    string comment 'ems校区ID',
    itcast_school_name  string comment 'ems校区名称',
    itcast_subject_id   string comment 'ems学科ID',
    itcast_subject_name string comment 'ems学科名称',
    itcast_brand        string comment 'ems品牌',
    clazz_type_state    string comment '班级类型状态',
    clazz_type_name     string comment '班级类型名称',
    teaching_mode       string comment'授课模式',
    start_time          string comment'开班时间',
    end_time            string comment '毕业时间',
    `comment`           string comment '备注',
    detail              string comment'详情(比如：27期)',
    uncertain           string comment '待定班(0:否,1:是)',
    tenant              int

)comment '报名课程表'
partitioned by(dt string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );

-- 创建
set hive.exec.orc.compression.strategy=COMPRESSION;
DROP TABLE if EXISTS edu_ods.ods_customer;

CREATE EXTERNAL TABLE IF NOT EXISTS edu_ods.ods_customer (
    id                          int, 
    customer_relationship_id    int            comment '当前意向id',
    create_date_time            string         comment '创建时间',
    update_date_time            string         comment '最后更新时间',
    deleted                     string         comment '是否被删除（禁用）',
    name                        string         comment '姓名',
    idcard                      string         comment '身份证号',
    birth_year                  int            comment '出生年份',
    gender                      string         comment '性别',
    phone                       string         comment '手机号',
    wechat                      string         comment '微信',
    qq                          string         comment 'qq号',
    email                       string         comment '邮箱',
    area                        string         comment '所在区域',
    leave_school_date           string         comment '离校时间',
    graduation_date             string         comment '毕业时间',
    bxg_student_id              string         comment '博学谷学员ID，可能未关联到，不存在',
    creator                     int            comment '创建人ID',
    origin_type                 string         comment '数据来源',
    origin_channel              string         comment '来源渠道',
    tenant                      int,
    md_id                       int            comment '中台id'
)comment '客户静态信息表'
PARTITIONED BY(dt STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc 
TBLPROPERTIES ('orc.compress'='SNAPPY');

-- 创建表ods_employee

drop table if exists edu_ods.ods_employee;

create table edu_ods.ods_employee(
    id                  int,
    email               string comment '公司邮箱，OA登录账号',
    real_name           string comment '员工的真实姓名',
    phone               string comment '手机号，目前还没有使用；隐私问题OA接口没有提供这个属性，',
    department_id       string comment 'OA中的部门编号，有负值',
    department_name     string comment 'OA中的部门名',
    remote_login        string comment '员工是否可以远程登录',
    job_number          string comment '员工工号',
    cross_school        string comment '是否有跨校区权限',
    last_login_date     string comment '最后登录日期',
    creator             int    comment '创建人',
    create_date_time    string comment '创建时间',
    update_date_time    string comment '最后更新时间',
    deleted             string comment '是否被删除（禁用）',
    scrm_department_id  int    comment 'SCRM内部部门id',
    leave_office        string comment '离职状态',
    leave_office_time   string comment '离职时间',
    reinstated_time     string comment '复职时间',
    superior_leaders_id int    comment '上级领导ID',
    tdepart_id          int    comment '直属部门',
    tenant              int,
    ems_user_name       string
)comment '员工表'
partitioned by(dt string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );

-- 创建表ods_employee

drop table if exists edu_ods.ods_employee;

create table edu_ods.ods_employee(
    id                  int,
    email               string comment '公司邮箱，OA登录账号',
    real_name           string comment '员工的真实姓名',
    phone               string comment '手机号，目前还没有使用；隐私问题OA接口没有提供这个属性，',
    department_id       string comment 'OA中的部门编号，有负值',
    department_name     string comment 'OA中的部门名',
    remote_login        string comment '员工是否可以远程登录',
    job_number          string comment '员工工号',
    cross_school        string comment '是否有跨校区权限',
    last_login_date     string comment '最后登录日期',
    creator             int    comment '创建人',
    create_date_time    string comment '创建时间',
    update_date_time    string comment '最后更新时间',
    deleted             string comment '是否被删除（禁用）',
    scrm_department_id  int    comment 'SCRM内部部门id',
    leave_office        string comment '离职状态',
    leave_office_time   string comment '离职时间',
    reinstated_time     string comment '复职时间',
    superior_leaders_id int    comment '上级领导ID',
    tdepart_id          int    comment '直属部门',
    tenant              int,
    ems_user_name       string
)comment '员工表'
partitioned by(dt string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );

-- 客户线索表
DROP TABLE if EXISTS edu_ods.ods_customer_clue;
CREATE EXTERNAL TABLE IF NOT EXISTS edu_ods.ods_customer_clue (
id                  
create_date_time        string  comment '创建时间',
update_date_time        string  comment '最后更新时间',
deleted                 string  comment '是否被删除（禁用）',
customer_id             int     comment '客户id',
customer_relationship_idint     comment '客户关系id',
session_id              string  comment   '七陌会话id',
sid                     string  comment '访客id',
status                  string  comment '状态（undeal待领取 deal 已领取 finish 已关闭 changePeer 已流转）',
`user`                  string  comment '所属坐席',
create_time             string  comment '七陌创建时间',
platform                string  comment '平台来源 （pc-网站咨询|wap-wap咨询|sdk-app咨询|weixin-微信咨询）',
s_name                  string  comment '用户名称',
seo_source              string  comment '搜索来源',
seo_keywords            string  comment '关键字',
ip                      string  comment 'IP地址',
referrer                string  comment '上级来源页面',
from_url                string  comment '会话来源页面',
landing_page_url        string  comment '访客着陆页面',
url_title               string  comment '咨询页面title',
to_peer                 string  comment '所属技能组',
manual_time             string  comment '人工开始时间',
begin_time              string  comment '坐席领取时间 ',
reply_msg_count         int     comment '客服回复消息数',
total_msg_count         int     comment '消息总数',
msg_count               int     comment '客户发送消息数',
comment                 string  comment '备注',
finish_reason           string  comment '结束类型',
finish_user             string  comment '结束坐席',
end_time                string  comment '会话结束时间',
platform_description    string  comment '客户平台信息',
browser_name            string  comment '浏览器名称',
os_info                 string  comment '系统名称',
area                    string  comment '区域',
country                 string  comment '所在国家',
province                string  comment '省',
city                    string  comment '城市',
creator                 int     comment '创建人',
name                    string  comment '客户姓名',
idcard                  string  comment '身份证号',
phone                   string  comment '手机号',
itcast_school_id        int     comment '校区Id',
itcast_school           string  comment '校区',
itcast_subject_id       int     comment '学科Id',
itcast_subject          string  comment '学科',
wechat                  string  comment '微信',
qq                      string  comment 'qq号',
email                   string  comment '邮箱',
gender                  string  comment '性别',
level                   string  comment '客户级别',
origin_type             string  comment '数据来源渠道',
information_way         string  comment '资讯方式',
working_years           string  comment '开始工作时间',
technical_directions    string  comment '技术方向',
customer_state          string  comment '当前客户状态',
valid                   string  comment '该线索是否是网资有效线索',
anticipat_signup_date   string  comment '预计报名时间',
clue_state              string  comment '线索状态',
scrm_department_id      int     comment 'SCRM内部部门id',
superior_url            string  comment '诸葛获取上级页面URL',
superior_source         string  comment '诸葛获取上级页面URL标题',
landing_url             string  comment '诸葛获取着陆页面URL',
landing_source          string  comment '诸葛获取着陆页面URL来源',
info_url                string  comment '诸葛获取留咨页URL',
info_source             string  comment '诸葛获取留咨页URL标题',
origin_channel          string  comment '投放渠道',
course_id           int, 
course_name             string,
zhuge_session_id        string,
is_repeat               int     comment '是否重复线索(手机号维度) 0:正常 1：重复',
tenant                  int     comment '租户id',
activity_id             string  comment '活动id',
activity_name           string  comment '活动名称',
follow_type             int     comment '分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取',
shunt_mode_id           int     comment '匹配到的技能组id',
shunt_employee_group_id int     comment '所属分流员工组'
)comment '客户线索表'  
PARTIT BY(dt STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc 
TBLPROPERTIES ('orc.compress'='SNAPPY');

```

#### DWD层:

两个事实表：fact_customer_clue/fact_customer_relationship

```sql
--创建客户线索事实表--fact_customer_clue  =>主要用来判断是新客户还是老客户
DROP TABLE if EXISTS edu_dwd.fact_customer_clue;

CREATE EXTERNAL TABLE IF NOT EXISTS edu_dwd.fact_customer_clue (
    id                       int,
    create_date_time         string  comment '创建时间',
    update_date_time         string  comment '最后更新时间',
    deleted                  string  comment '是否被删除（禁用）',
    customer_id              int  comment '客户id',
    customer_relationship_id int  comment '客户关系id',
    session_id               string  comment '七陌会话id',
    sid                      string  comment '访客id',
    status                   string  comment '状态（undeal待领取 deal 已领取 finish 已关闭 changePeer 已流转）',
    `user`                   string  comment '所属坐席',
    create_time              string  comment '七陌创建时间',
    platform                 string  comment '平台来源 （pc-网站咨询|wap-wap咨询|sdk-app咨询|weixin-微信咨询）',
    s_name                   string  comment '用户名称',
    seo_source               string  comment '搜索来源',
    seo_keywords             string  comment '关键字',
    ip                       string  comment 'IP地址',
    referrer                 string  comment '上级来源页面',
    from_url                 string  comment '会话来源页面',
    landing_page_url         string  comment '访客着陆页面',
    url_title                string  comment '咨询页面title',
    to_peer                  string  comment '所属技能组',
    manual_time              string  comment '人工开始时间',
    begin_time               string  comment '坐席领取时间 ',
    reply_msg_count          int  comment '客服回复消息数',
    total_msg_count          int  comment '消息总数',
    msg_count                int  comment '客户发送消息数',
    `comment`                string  comment '备注',
    finish_reason            string  comment '结束类型',
    finish_user              string  comment '结束坐席',
    end_time                 string  comment '会话结束时间',
    platform_description     string  comment '客户平台信息',
    browser_name             string  comment '浏览器名称',
    os_info                  string  comment '系统名称',
    area                     string  comment '区域',
    country                  string  comment '所在国家',
    province                 string  comment '省',
    city                     string  comment '城市',
    creator                  int  comment '创建人',
    name                     string  comment '客户姓名',
    idcard                   string  comment '身份证号',
    phone                    string  comment '手机号',
    itcast_school_id         int  comment '校区Id',
    itcast_school            string  comment '校区',
    itcast_subject_id        int  comment '学科Id',
    itcast_subject           string  comment '学科',
    wechat                   string  comment '微信',
    qq                       string  comment 'qq号',
    email                    string  comment '邮箱',
    gender                   string  comment '性别',
    level                    string  comment '客户级别',
    
    origin_type              string comment '数据来源渠道',
    
    information_way          string comment '资讯方式',
    working_years            string comment '开始工作时间',
    technical_directions     string comment '技术方向',
    customer_state           string comment '当前客户状态',
    valid                    string comment '该线索是否是网资有效线索',
    anticipat_signup_date    string comment '预计报名时间',
    
    clue_state               string     comment '线索状态(判断是新客户还是老客户),clue_state字段的值`VALID_NEW_CLUES`代表是新客户，`VALID_PUBLIC_NEW_CLUE`代表是老客户',
    
    scrm_department_id       int        comment 'SCRM内部部门id',
    superior_url             string     comment '诸葛获取上级页面URL',
    superior_source          string comment '诸葛获取上级页面URL标题',
    landing_url              string     comment '诸葛获取着陆页面URL',
    landing_source           string     comment '诸葛获取着陆页面URL来源',
    info_url                 string     comment '诸葛获取留咨页URL',
    info_source              string     comment '诸葛获取留咨页URL标题',
    origin_channel           string     comment '投放渠道',
    course_id                int,
    course_name              string,
    zhuge_session_id         string,
    is_repeat                int        comment '是否重复线索(手机号维度) 0:正常 1：重复',
    tenant                   int        comment '租户id',
    activity_id              string     comment '活动id',
    activity_name            string     comment '活动名称',
    
    follow_type              string     comment '分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取',
    
    shunt_mode_id            int        comment '匹配到的技能组id',
    shunt_employee_group_id  int        comment '所属分流员工组',
    end_date                 string     COMMENT '拉链结束日期'
)comment '客户线索表'
PARTITIONED BY(start_date STRING)
clustered by(id) sorted by(id) into 10 buckets
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc 
TBLPROPERTIES ('orc.compress'='SNAPPY');


--插入数据
INSERT INTO edu_dwd.fact_customer_clue PARTITION (start_date)
SELECT 
	id,
    create_date_time,
    update_date_time,
    deleted,
    customer_id,
    customer_relationship_id,
    session_id, 
    sid,
    status,
    `user`,
    create_time,
    platform,
    s_name,
    seo_source,
    seo_keywords,
    ip,
    referrer,
    from_url,
    landing_page_url,
    url_title,                
    to_peer,                  
    manual_time,              
    begin_time,
    reply_msg_count,          
    total_msg_count,          
    msg_count,                
    `comment`,
    finish_reason,            
    finish_user,              
    end_time,                 
    platform_description,     
    browser_name,             
    os_info,                  
    area,                     
    country,                  
    province,                 
    city,                     
    creator,                  
    name,                     
    idcard,                   
    phone,                    
    itcast_school_id,         
    itcast_school,            
    itcast_subject_id,        
    itcast_subject,           
    wechat,                   
    qq,                       
    email,                    
    gender,                   
    level,                    
    
    origin_type,
    
    information_way,
    working_years,            
    technical_directions,     
    customer_state,           
    valid,                    
    anticipat_signup_date,    
    clue_state,               
    scrm_department_id,       
    superior_url,             
    superior_source,          
    landing_url,              
    landing_source,           
    info_url,                 
    info_source,              
    origin_channel,           
    course_id,
    course_name,
    zhuge_session_id,
    is_repeat,
    tenant,
    activity_id,
    activity_name,
    
    -- 转换 0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取
    case 
        when follow_type=0
        then '自动分配'
        when follow_type=1
        then '手动分配'
        when follow_type=2
        then '自动转移'
        when follow_type=3
        then '手动单个转移'
        when follow_type=4
        then '手动批量转移'
        when follow_type=5
        then '公海领取'
        ELSE NULL
    end 
    as follow_type,
    shunt_mode_id,
    shunt_employee_group_id,
    
	'9999-99-99' as end_date,
	if(update_date_time is not null or update_date_time != '', 
        SUBSTRING(update_date_time, 1, 10), 
        SUBSTRING(create_date_time, 1, 10)
    )
    as start_date
FROM edu_ods.ods_customer_clue

-- 清洗数据
WHERE customer_id is NOT NULL AND deleted='false';



--创建fact_customer_relationship
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;

DROP TABLE if EXISTS edu_dwd.fact_customer_relationship;

CREATE TABLE edu_dwd.fact_customer_relationship (
    id                          int,
    create_date_time            string,
    update_date_time            string   comment '最后更新时间',
    deleted                     string comment '是否被删除（禁用）',
    customer_id                 int  comment '所属客户id',
    first_id                    int   comment '第一条客户关系id',
    belonger                    int  comment '归属人',
    belonger_name               string  comment '归属人姓名',
    initial_belonger            int    comment '初始归属人',
    distribution_handler        int comment '分配处理人',
    business_scrm_department_id int     comment '归属部门',
    last_visit_time        string comment '最后回访时间',
    next_visit_time       string      comment '下次回访时间',
    
    origin_type     string         comment '数据来源',
    origin_type_stat int            comment '0(线上),1(线下)',
    
    itcast_school_id     int            comment '校区Id',
    itcast_subject_id     int            comment '学科Id',
    intention_study_type   string     comment '意向学习方式',
    anticipat_signup_date   date      comment '预计报名时间',
    level    string         comment '客户级别',
    creator  int            comment '创建人',
    current_creator  int            comment '当前创建人：初始==创建人，当在公海拉回时为 拉回人',
    creator_name       string         comment '创建者姓名',
    origin_channel    string         comment '来源渠道',
    `comment`        string        comment '备注',
    first_customer_clue_id      int      comment '第一条线索id',
    last_customer_clue_id   int    comment '最后一条线索id',
    process_state      string         comment '处理状态',
    process_time       string         comment '处理状态变动时间',
    payment_state     string         comment '支付状态',
    payment_time     string         comment '支付状态变动时间',
    signup_state   string         comment '报名状态',
    signup_time    string         comment '报名时间',
    notice_state      string         comment '通知状态',
    notice_time     string         comment '通知状态变动时间',
    lock_state    string         comment '锁定状态',
    lock_time    string         comment '锁定状态修改时间',
    itcast_clazz_  int   comment '所属ems班级id',
    itcast_clazz_time     string         comment '报班时间',
    payment_url      string         comment '付款链接',
    payment_url_time     string         comment '支付链接生成时间',
    ems_student_id      int            comment 'ems的学生id',
    delete_reason     string         comment '删除原因',
    deleter     int            comment '删除人',
    deleter_name     string         comment '删除人姓名',
    delete_time   string         comment '删除时间',
    course_id  int            comment '课程ID',
    course_name        string         comment '课程名称',
    delete_comment string         comment '删除原因说明',
    close_state       string         comment '关闭装填',
    close_time        string         comment '关闭状态变动时间',
    appeal_id     int            comment '申诉id',
    tenant        int            comment '租户',
    total_fee     decimal(38,4)  comment '报名费总金额',
    belonged     int            comment '小周期归属人',
    belonged_time      string         comment '归属时间',
    belonger_time       string         comment '归属时间',
    transfer        int            comment '转移人',
    transfer_time    string         comment '转移时间',
    
    follow_type      string         comment '分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取',
    
    transfer_bxg_oa_account     string comment '转移到博学谷归属人OA账号',
    transfer_bxg_belonger_name  string    comment '转移到博学谷归属人OA姓名',
    
    payment_time_year    string  comment '支付状态变动年', 
    payment_time_month    string         comment '支付状态变动月',
    payment_time_day   string         comment '支付状态变动日',
    payment_time_hour string         comment '支付状态变动小时',
    end_date   string         comment '拉链结束日期'
)comment '客户意向表'
PARTITIONED BY(start_date STRING) 
clustered by(id) sorted by(id) into 10 buckets
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
stored as orc 
TBLPROPERTIES ('orc.compress'='SNAPPY');

-- 插入
INSERT INTO edu_dwd.fact_customer_relationship PARTITION (start_date)
SELECT 
	id,
    create_date_time,
    update_date_time,
    deleted,
    customer_id,
    first_id,
    belonger,
    belonger_name,
    initial_belonger,
    distribution_handler,
    business_scrm_department_id,
    last_visit_time,
    next_visit_time,
    origin_type,
    case 
        when origin_type='NETSERVICE'
        then 0
        when origin_type='PRESIGNUP'
        then 0
        ELSE 1
    end
    as origin_type_stat,
    itcast_school_id,
    itcast_subject_id,
    intention_study_type,
    anticipat_signup_date,
    level,
    creator,
    current_creator,
    creator_name,
    origin_channel,
    `comment`,
    first_customer_clue_id,
    last_customer_clue_id,
    process_state,
    process_time,
    payment_state,
    payment_time,
    signup_state,
    signup_time,
    notice_state,
    notice_time,
    lock_state,
    lock_time,
    itcast_clazz_id,
    itcast_clazz_time,
    payment_url,
    payment_url_time,
    ems_student_id,
    delete_reason,
    deleter,
    deleter_name,
    delete_time,
    course_id,
    course_name,
    delete_comment,
    close_state,
    close_time,
    appeal_id,
    tenant,
    total_fee,
    belonged,
    belonged_time,
    belonger_time,
    transfer,
    transfer_time,
    -- 转换 0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取
    case 
        when follow_type=0
        then '自动分配'
        when follow_type=1
        then '手动分配'
        when follow_type=2
        then '自动转移'
        when follow_type=3
        then '手动单个转移'
        when follow_type=4
        then '手动批量转移'
        when follow_type=5
        then '公海领取'
        ELSE NULL
    end 
    as follow_type,
    transfer_bxg_oa_account,
    transfer_bxg_belonger_name,
    
    substr(payment_time,1,4) as payment_time_year, 
    substr(payment_time,6,2) as payment_time_month,
    substr(payment_time,9,2) as payment_time_day,
    substr(payment_time,12,2) as payment_time_hour, 
    
	'9999-99-99' as end_date,
	if(update_date_time is not null or update_date_time != '', 
        SUBSTRING(update_date_time, 1, 10), 
        SUBSTRING(create_date_time, 1, 10)
     )
    as start_date
FROM edu_ods.ods_customer_relationship

-- 清洗数据
WHERE customer_id is NOT NULL AND deleted='false' AND payment_state='PAID';

-- SELECT * FROM fact_customer_relationship where payment_time is not null;

```

#### DWS层：



#### DM层:

```sql
-- ===========报名用户主题==========
-- 建模规则：指标字段 + 维度字段 + group_type + time_type
insert into edu_dm.dm_baoming1
select
    case
        when grouping (payment_time_day) = 0
        then 'day'
        when grouping (payment_time_month) = 0
        then 'month'
        when grouping (payment_time_year) = 0
        then 'year'
        else 'all'
    end
    as time_type,
    case
        when grouping (itcast_school_name) = 0 and  grouping (itcast_subject_name) = 0
        then '校区/学科Top'
        when grouping (itcast_school_name) = 0
        then '校区'
        when grouping (itcast_subject_name) = 0
        then '学科'
        when grouping (origin_type_stat) = 0
        then '线上/线下'
        when grouping (origin_type) = 0
        then '数据来源类型'
        when grouping (tdepart_id) = 0
        then '咨询'
        else '总量'
    end
    as amount_type,
    count(1) as all_num,
    itcast_school_name,
    itcast_subject_name,
    origin_type,
    origin_type_stat,
    tdepart_id,
    depart_name as tdepart_name,

    payment_time_year,
    payment_time_month,
    payment_time_day,
    '2022-08-13' as date_time

from edu_dwb.dwb_customer_relationship cr
group by
grouping sets (
    -- 所有时间 统计校区
    (itcast_school_name,origin_type_stat),
    -- 年 统计校区
    (payment_time_year,itcast_school_name,origin_type_stat),
    -- 月 统计
    (payment_time_month,payment_time_year,itcast_school_name,origin_type_stat),
    -- 日统计
    (payment_time_day,payment_time_month,payment_time_year,itcast_school_name,origin_type_stat),

    -- all 统计学科
    (itcast_subject_name,origin_type_stat),
    -- 年 统计学科
    (payment_time_year,itcast_subject_name,origin_type_stat),
    -- 月 统计学科
    (payment_time_month,payment_time_year,itcast_subject_name,origin_type_stat),
    -- 日统计学科
    (payment_time_day,payment_time_month,payment_time_year,itcast_subject_name,origin_type_stat),

    -- 总报名量统计
    (),
    -- 年 总报名量统计
    (payment_time_year),
    -- 月 总报名量统计
    (payment_time_month,payment_time_year),
    -- 日 总报名量统计
    (payment_time_day,payment_time_month,payment_time_year),

    -- 线上/线下 总统计
    (origin_type_stat),
    -- 线上/线下年统计
    (payment_time_year,origin_type_stat),
    -- 线上/线下月统计
    (payment_time_month,payment_time_year,origin_type_stat),
    -- 线上/线下日统计
    (payment_time_day,payment_time_month,payment_time_year,origin_type_stat),

    --来源渠道 总统计
    (origin_type),
    -- 来源渠道 年统计
    (payment_time_year,origin_type),
    -- 来源渠道 月统计
    (payment_time_month,payment_time_year,origin_type),
    -- 来源渠道 日统计
    (payment_time_day,payment_time_month,payment_time_year,origin_type),

    --咨询中心 总统计
    (tdepart_id,depart_name),
    --咨询中心 年统计
    (payment_time_year,tdepart_id,depart_name),
    --咨询中心 月统计
    (payment_time_month,payment_time_year,tdepart_id,depart_name),
    --咨询中心 日统计
    (payment_time_month,payment_time_year,tdepart_id,depart_name),

    --学区校区TOP
(itcast_school_name,itcast_subject_name),
    -- 年统计 学区校区TOP
    (payment_time_year,itcast_school_name,itcast_subject_name),
    --月统计 学区校区TOP
    (payment_time_month,payment_time_year,itcast_school_name,itcast_subject_name),
    --日统计 学区校区TOP
    (payment_time_day,payment_time_month,payment_time_year,itcast_school_name,itcast_subject_name)
)
;

```

第五和第六个报表:

```sql
-- 第5个指标--意向用户报名转化率
SELECT
    (signup_num.num / total_num.num
    ) '报名转化率',
    total_num.date_day '时间',
    substr( total_num.date_day,1,4 ) 'year',
    substr( total_num.date_day,6,2) 'month',
    substr( total_num.date_day,9,2) 'day'
FROM
    (
        SELECT
            count( 1 ) AS num,
            DATE_FORMAT( cr.create_date_time, '%Y-%m-%d' ) AS date_day
        FROM
            customer_relationship cr
        where origin_type in ('NETSERVICE','PRESIGNUP')
        GROUP BY
            date_format( cr.create_date_time, '%Y-%m-%d' )
    ) total_num
    INNER JOIN (
        SELECT
            count( 1 ) AS num,
            DATE_FORMAT( cr2.create_date_time, '%Y-%m-%d' ) AS date_day
        FROM
           customer_relationship cr2
        WHERE
            cr2.payment_state = 'PAID'
        GROUP BY
            date_format( cr2.create_date_time, '%Y-%m-%d' )
    ) signup_num ON total_num.date_day = signup_num.date_day;


-- 第6个指标--有效线索报名转化率
SELECT
    CONCAT(
        signup_num.num / total_num.num * 100,
        '%'
    ) '线上报名转化率',
    total_num.date_day '时间',
    substr( total_num.date_day,1,4) 'year',
    substr( total_num.date_day,6,2) 'month',
    substr( total_num.date_day,9,2) 'day'
FROM
    (
    SELECT
        count( 1 ) AS num,
        DATE_FORMAT( cr.create_date_time, '%Y-%m-%d' ) AS date_day
    FROM
        customer_clue cc
        LEFT JOIN customer_relationship cr ON cr.id = cc.customer_relationship_id
     WHERE
        cc.clue_state IN ( 'VALID_NEW_CLUES', 'VALID_PUBLIC_NEW_CLUE' )
         AND cc.deleted = 'false' AND cr.id NOT IN ( SELECT customer_relationship_first_id
                                                            FROM customer_appeal WHERE appeal_status = '1' )
    GROUP BY
        DATE_FORMAT( cr.create_date_time, '%Y-%m-%d' )
    ) total_num
    INNER JOIN (
    SELECT
        count( 1 ) AS num,
        DATE_FORMAT( cr.create_date_time, '%Y-%m-%d' ) AS date_day
    FROM
        customer_relationship cr
    WHERE
        cr.payment_state = 'PAID'
    GROUP BY
        DATE_FORMAT( cr.create_date_time, '%Y-%m-%d' )
    ) signup_num ON total_num.date_day = signup_num.date_day;
```



