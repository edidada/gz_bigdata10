在线教育DWD层fact_customer_clue建表:

--拉链表（事实表）
set hive.exec.orc.compression.strategy=COMPRESSION;
DROP TABLE if EXISTS edu_dwd.fact_customer_clue;
CREATE EXTERNAL TABLE IF NOT EXISTS edu_dwd.fact_customer_clue (
    id                         int              COMMENT 'customer_clue_id',
    create_date_time           STRING           COMMENT '创建时间',
    update_date_time           STRING           COMMENT '最后更新时间',
    deleted                    STRING           COMMENT '是否被删除（禁用）',
    customer_id                int              COMMENT '客户id',
    customer_relationship_id   int              COMMENT '客户关系id',
    session_id                 STRING           COMMENT '七陌会话id',
    sid                        STRING           COMMENT '访客id',
    status                     STRING           COMMENT '状态（undeal待领取 deal 已领取 finish 已关闭 changePeer 已流转）',
    users                      STRING           COMMENT '所属坐席',
    create_time                STRING           COMMENT '七陌创建时间',
    platform                   STRING           COMMENT '平台来源 （pc-网站咨询|wap-wap咨询|sdk-app咨询|weixin-微信咨询）',
    s_name                     STRING           COMMENT '用户名称',
    seo_source                 STRING           COMMENT '搜索来源',
    seo_keywords               STRING           COMMENT '关键字',
    ip                         STRING           COMMENT 'IP地址',
    referrer                   STRING           COMMENT '上级来源页面',
    from_url                   STRING           COMMENT '会话来源页面',
    landing_page_url           STRING           COMMENT '访客着陆页面',
    url_title                  STRING           COMMENT '咨询页面title',
    to_peer                    STRING           COMMENT '所属技能组',
    manual_time                STRING           COMMENT '人工开始时间',
    begin_time                 STRING           COMMENT '坐席领取时间 ',
    reply_msg_count            int              COMMENT '客服回复消息数',
    total_msg_count            int              COMMENT '消息总数',
    msg_count                  int              COMMENT '客户发送消息数',
    `comment`                  STRING           COMMENT '备注',
    finish_reason              STRING           COMMENT '结束类型',
    finish_user                STRING           COMMENT '结束坐席',
    end_time                   STRING           COMMENT '会话结束时间',
    platform_description       STRING           COMMENT '客户平台信息',
    browser_name               STRING           COMMENT '浏览器名称',
    os_info                    STRING           COMMENT '系统名称',
    area                       STRING           COMMENT '区域',
    country                    STRING           COMMENT '所在国家',
    province                   STRING           COMMENT '省',
    city                       STRING           COMMENT '城市',
    creator                    int              COMMENT '创建人',
    name                       STRING           COMMENT '客户姓名',
    idcard                     STRING           COMMENT '身份证号',
    phone                      STRING           COMMENT '手机号',
    itcast_school_id           int              COMMENT '校区Id',
    itcast_school              STRING           COMMENT '校区',
    itcast_subject_id          int              COMMENT '学科Id',
    itcast_subject             STRING           COMMENT '学科',
    wechat                     STRING           COMMENT '微信',
    qq                         STRING           COMMENT 'qq号',
    email                      STRING           COMMENT '邮箱',
    gender                     STRING           COMMENT '性别',
    level                      STRING           COMMENT '客户级别',
    origin_type                STRING           COMMENT '数据来源渠道',
    information_way            STRING           COMMENT '资讯方式',
    working_years              STRING           COMMENT '开始工作时间',
    technical_directions       STRING           COMMENT '技术方向',
    customer_state             STRING           COMMENT '当前客户状态',
    valid                      STRING           COMMENT '该线索是否是网资有效线索',
    anticipat_signup_date      STRING           COMMENT '预计报名时间',
    clue_state                 STRING           COMMENT '线索状态',
    scrm_department_id         int              COMMENT 'SCRM内部部门id',
    superior_url               STRING           COMMENT '诸葛获取上级页面URL',
    superior_source            STRING           COMMENT '诸葛获取上级页面URL标题',
    landing_url                STRING           COMMENT '诸葛获取着陆页面URL',
    landing_source             STRING           COMMENT '诸葛获取着陆页面URL来源',
    info_url                   STRING           COMMENT '诸葛获取留咨页URL',
    info_source                STRING           COMMENT '诸葛获取留咨页URL标题',
    origin_channel             STRING           COMMENT '投放渠道',
    course_id                  int              COMMENT '课程编号',
    course_name                STRING           COMMENT '课程名称',
    zhuge_session_id           STRING           COMMENT 'zhuge会话id',
    is_repeat                  int              COMMENT '是否重复线索(手机号维度) 0:正常 1：重复',
    tenant                     int              COMMENT '租户id',
    activity_id                STRING           COMMENT '活动id',
    activity_name              STRING           COMMENT '活动名称',
    follow_type                int              COMMENT '分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取',
    shunt_mode_id              int              COMMENT '匹配到的技能组id',
    shunt_employee_group_id    int              COMMENT '所属分流员工组',
    clue_state_stat            STRING           COMMENT '新老客户：0.老客户；1.新客户',
    clue_appeal_state          STRING           COMMENT '是否有效线索: 0.无效 1.有效',
    end_date                   STRING           COMMENT '有效截止时间'
)comment '客户线索表'
PARTITIONED BY(start_date STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc 
TBLPROPERTIES ('orc.compress'='SNAPPY');



在线教育DWD层fact_customer_relationship建表：

--拉链表（事实表）
set hive.exec.orc.compression.strategy=COMPRESSION;
DROP TABLE if EXISTS edu_dwd.fact_customer_relationship;
CREATE EXTERNAL TABLE IF NOT EXISTS edu_dwd.fact_customer_relationship (
    id                              int          COMMENT '客户关系id',
    create_date_time                STRING       COMMENT '创建时间',
    update_date_time                STRING       COMMENT '最后更新时间',
    deleted                         STRING       COMMENT '是否被删除（禁用）',
    customer_id                     int          COMMENT '所属客户id',
    first_id                        int          COMMENT '第一条客户关系id',
    belonger                        int          COMMENT '归属人',
    belonger_name                   STRING       COMMENT '归属人姓名',
    initial_belonger                int          COMMENT '初始归属人',
    distribution_handler            int          COMMENT '分配处理人',
    business_scrm_department_id     int          COMMENT '归属部门',
    last_visit_time                 STRING       COMMENT '最后回访时间',
    next_visit_time                 STRING       COMMENT '下次回访时间',
    origin_type                     STRING       COMMENT '数据来源',
    itcast_school_id                int          COMMENT '校区Id',
    itcast_subject_id               int          COMMENT '学科Id',
    intention_study_type            STRING       COMMENT '意向学习方式',
    anticipat_signup_date           STRING       COMMENT '预计报名时间',
    level                           STRING       COMMENT '客户级别',
    creator                         int          COMMENT '创建人',
    current_creator                 int          COMMENT '当前创建人：初始==创建人，当在公海拉回时为 拉回人',
    creator_name                    STRING       COMMENT '创建者姓名',
    origin_channel                  STRING       COMMENT '来源渠道',
    `comment`                       STRING       COMMENT '备注',
    first_customer_clue_id          int          COMMENT '第一条线索id',
    last_customer_clue_id           int          COMMENT '最后一条线索id',
    process_state                   STRING       COMMENT '处理状态',
    process_time                    STRING       COMMENT '处理状态变动时间',
    payment_state                   STRING       COMMENT '支付状态',
    payment_time                    STRING       COMMENT '支付状态变动时间',
    signup_state                    STRING       COMMENT '报名状态',
    signup_time                     STRING       COMMENT '报名时间',
    notice_state                    STRING       COMMENT '通知状态',
    notice_time                     STRING       COMMENT '通知状态变动时间', 
    lock_state                      STRING       COMMENT '锁定状态',
    lock_time                       STRING       COMMENT '锁定状态修改时间',
    itcast_clazz_id                 int          COMMENT '所属ems班级id',
    itcast_clazz_time               STRING       COMMENT '报班时间',
    payment_url                     STRING       COMMENT '付款链接',
    payment_url_time                STRING       COMMENT '支付链接生成时间',
    ems_student_id                  int          COMMENT 'ems的学生id',
    delete_reason                   STRING       COMMENT '删除原因',
    deleter                         int          COMMENT '删除人',
    deleter_name                    STRING       COMMENT '删除人姓名',
    delete_time                     STRING       COMMENT '删除时间',
    course_id                       int          COMMENT '课程ID', 
    course_name                     STRING       COMMENT '课程名称',
    delete_comment                  STRING       COMMENT '删除原因说明',
    close_state                     STRING       COMMENT '关闭装填',
    close_time                      STRING       COMMENT '关闭状态变动时间',
    appeal_id                       int          COMMENT '申诉id',
    tenant                          int          COMMENT '租户',
    total_fee                       DECIMAL      COMMENT '报名费总金额',
    belonged                        int          COMMENT '小周期归属人',
    belonged_time                   STRING       COMMENT '归属时间',
    belonger_time                   STRING       COMMENT '归属时间',
    transfer                        int          COMMENT '转移人',
    transfer_time                   STRING       COMMENT '转移时间',
    follow_type                     int          COMMENT '分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取',
    transfer_bxg_oa_account         STRING       COMMENT '转移到博学谷归属人OA账号',
    transfer_bxg_belonger_name      STRING       COMMENT '转移到博学谷归属人OA姓名',
    yearinfo                        STRING       COMMENT '年',
    monthinfo                       STRING       COMMENT '月',
    dayinfo                         STRING       COMMENT '日',
    hourinfo                        STRING       COMMENT '小时',
    origin_type_state               STRING       COMMENT '线上线下:0.线下；1.线上',
    end_date                        STRING       COMMENT '有效截止时间'
)comment '客户关系表'
PARTITIONED BY(start_date STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc 
TBLPROPERTIES ('orc.compress'='SNAPPY');





在线教育DWD层dim_customer建表：

--非拉链表（维度表）
set hive.exec.orc.compression.strategy=COMPRESSION;
DROP TABLE if EXISTS edu_dwd.dim_customer;
CREATE EXTERNAL TABLE IF NOT EXISTS edu_dwd.dim_customer (
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
)comment '客户表'
PARTITIONED BY(dt STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc 
TBLPROPERTIES ('orc.compress'='SNAPPY');



在线教育DWD层dim_itcast_subject建表

--非拉链表（维度表）
set hive.exec.orc.compression.strategy=COMPRESSION;
DROP TABLE if EXISTS edu_dwd.dim_itcast_subject;
CREATE EXTERNAL TABLE IF NOT EXISTS edu_dwd.dim_itcast_subject (
    id                   int,
    create_date_time     string    comment '创建时间',
    update_date_time     string    comment '最后更新时间',
    deleted              string    comment '是否被删除（禁用）',
    name                 string    comment '学科名称',
    code                 string,
    tenant               int
)comment '学科表'
PARTITIONED BY(dt STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc 
TBLPROPERTIES ('orc.compress'='SNAPPY');



在线教育DWD层dim_customer插入数据

--分区
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=100000;
set hive.exec.max.created.files=150000;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;
--分桶
set hive.enforce.bucketing=true;
set hive.enforce.sorting=true;
--关闭MapJoin
set hive.auto.convert.join=false;

INSERT OVERWRITE table edu_dwd.dim_customer partition(dt)
SELECT 
    id ,
    customer_relationship_id ,
    create_date_time ,
    update_date_time ,
    deleted ,
    name ,
    idcard ,
    birth_year ,
    gender ,
    phone ,
    wechat ,
    qq ,
    email ,
    area ,
    leave_school_date ,
    graduation_date ,
    bxg_student_id ,
    creator ,
    origin_type ,
    origin_channel ,
    tenant ,
    md_id ,
    '2022-08-11' as dt
FROM edu_ods.ods_customer
WHERE deleted = 'false';





在线教育DWD层dim_itcast_subject插入数据

--分区
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=100000;
set hive.exec.max.created.files=150000;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;
--分桶
set hive.enforce.bucketing=true;
set hive.enforce.sorting=true;
--关闭MapJoin
set hive.auto.convert.join=false;

INSERT OVERWRITE table edu_dwd.dim_itcast_subject partition(dt)
SELECT 
    id ,                                                              
    create_date_time ,
    update_date_time ,
    deleted ,
    name ,
    code ,
    tenant ,
    substr(create_date_time, 1, 10) as dt
FROM edu_ods.ods_itcast_subject
WHERE deleted = 'false';







在线教育DWD层dim_itcast_school建表

--非拉链表（维度表）
set hive.exec.orc.compression.strategy=COMPRESSION;
DROP TABLE if EXISTS edu_dwd.dim_itcast_school;
CREATE EXTERNAL TABLE IF NOT EXISTS edu_dwd.dim_itcast_school (
    id                    int,
    create_date_time      string       comment '创建时间',
    update_date_time      string       comment '最后更新时间',
    deleted               string       comment '是否被删除（禁用)',
    name                  string       comment '校区名称',
    code                  string,
    tenant                int
)comment '校区表'
PARTITIONED BY(dt STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc 
TBLPROPERTIES ('orc.compress'='SNAPPY');



在线教育DWD层dim_itcast_school插入数据

--分区
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=100000;
set hive.exec.max.created.files=150000;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;
--分桶
set hive.enforce.bucketing=true;
set hive.enforce.sorting=true;
--关闭MapJoin
set hive.auto.convert.join=false;

INSERT OVERWRITE table edu_dwd.dim_itcast_school partition(dt)
SELECT 
    id ,
    create_date_time ,
    update_date_time ,
    deleted ,
    name ,
    code ,
    tenant ,
    substr(create_date_time, 1, 10) as dt
FROM edu_ods.ods_itcast_school
WHERE deleted = 'false';





在线教育DWD层dim_employee建表

--非拉链表（维度表）
set hive.exec.orc.compression.strategy=COMPRESSION;
DROP TABLE if EXISTS edu_dwd.dim_employee;
CREATE EXTERNAL TABLE IF NOT EXISTS edu_dwd.dim_employee (
    id                     int,
    email                  string          comment '公司邮箱，OA登录账号',
    real_name              string          comment '员工的真实姓名',
    phone                  string          comment '手机号，目前还没有使用；隐私问题OA接口没有提供这个属性，',
    department_id          string          comment 'OA中的部门编号，有负值',
    department_name        string          comment 'OA中的部门名',
    remote_login           string          comment '员工是否可以远程登录',
    job_number             string          comment '员工工号',
    cross_school           string          comment '是否有跨校区权限',
    last_login_date        string          comment '最后登录日期',
    creator                int             comment '创建人',
    create_date_time       string          comment '创建时间',
    update_date_time       string          comment '最后更新时间',
    deleted                string          comment '是否被删除（禁用）',
    scrm_department_id     int             comment 'SCRM内部部门id',
    leave_office           string          comment '离职状态',
    leave_office_time      string          comment '离职时间',
    reinstated_time        string          comment '复职时间',
    superior_leaders_id    int             comment '上级领导ID',
    tdepart_id             int             comment '直属部门',
    tenant                 int,
    ems_user_name          string
)comment '员工表'
PARTITIONED BY(dt STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc 
TBLPROPERTIES ('orc.compress'='SNAPPY');



在线教育DWD层dim_employee插入数据

--分区
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=100000;
set hive.exec.max.created.files=150000;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;
--分桶
set hive.enforce.bucketing=true;
set hive.enforce.sorting=true;
--关闭MapJoin
set hive.auto.convert.join=false;

INSERT OVERWRITE table edu_dwd.dim_employee partition(dt)
SELECT 
    id ,
    email ,
    real_name ,
    phone ,
    department_id ,
    department_name ,
    remote_login ,
    job_number ,
    cross_school ,
    last_login_date ,
    creator ,
    create_date_time ,
    update_date_time ,
    deleted ,
    scrm_department_id ,
    leave_office ,
    leave_office_time ,
    reinstated_time ,
    superior_leaders_id ,
    tdepart_id ,
    tenant ,
    ems_user_name ,
    substr(create_date_time, 1, 10) as dt
FROM edu_ods.ods_employee
WHERE deleted = 'false';





在线教育DWD层dim_scrm_department建表

--非拉链表（维度表）
set hive.exec.orc.compression.strategy=COMPRESSION;
DROP TABLE if EXISTS edu_dwd.dim_scrm_department;
CREATE EXTERNAL TABLE IF NOT EXISTS edu_dwd.dim_scrm_department (
    id                    int            comment '部门id',
    name                  string         comment '部门名称',
    parent_id             int            comment '父部门id',
    create_date_time      string         comment '创建时间',
    update_date_time      string         comment '更新时间',
    deleted               string         comment '删除标志',
    id_path               string         comment '编码全路径',
    tdepart_code          int            comment '直属部门',
    creator               string         comment '创建者',
    depart_level          int            comment '部门层级',
    depart_sign           int            comment '部门标志，暂时默认1',
    depart_line           int            comment '业务线，存储业务线编码',
    depart_sort           int            comment '排序字段',
    disable_flag          int            comment '禁用标志',
    tenant                int
)comment '部门表'
PARTITIONED BY(dt STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc 
TBLPROPERTIES ('orc.compress'='SNAPPY');



在线教育DWD层dim_customer_appeal建表

--非拉链表（维度表）
set hive.exec.orc.compression.strategy=COMPRESSION;
DROP TABLE if EXISTS edu_dwd.dim_customer_appeal;
CREATE EXTERNAL TABLE IF NOT EXISTS edu_dwd.dim_customer_appeal (
    id                                int           comment '主键',
    customer_relationship_first_id    int           comment '第一条客户关系id',
    employee_id                       int           comment '申诉人',
    employee_name                     string        comment '申诉人姓名',
    employee_department_id            int           comment '申诉人部门',
    employee_tdepart_id               int           comment '申诉人所属部门',
    appeal_status                     int           comment '申诉状态，0:待稽核 1:无效 2：有效',
    audit_id                          int           comment '稽核人id',
    audit_name                        string        comment '稽核人姓名',
    audit_department_id               int           comment '稽核人所在部门',
    audit_department_name             string        comment '稽核人部门名称',
    audit_date_time                   string        comment '稽核时间',
    create_date_time                  string        comment '创建时间（申诉时间）',
    update_date_time                  string        comment '更新时间',
    deleted                           string        comment '删除标志位',
    tenant                            int 
)comment '投诉表'
PARTITIONED BY(dt STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc 
TBLPROPERTIES ('orc.compress'='SNAPPY');





在线教育DWD层dim_customer_appeal插入数据

--分区
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=100000;
set hive.exec.max.created.files=150000;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;
--分桶
set hive.enforce.bucketing=true;
set hive.enforce.sorting=true;
--关闭MapJoin
--set hive.auto.convert.join=false;

INSERT OVERWRITE table edu_dwd.dim_customer_appeal partition(dt)
SELECT 
    id ,
    customer_relationship_first_id ,
    employee_id ,
    employee_name ,
    employee_department_id ,
    employee_tdepart_id ,
    appeal_status ,
    audit_id ,
    audit_name ,
    audit_department_id ,
    audit_department_name ,
    audit_date_time ,
    create_date_time ,
    update_date_time ,
    deleted ,
    tenant ,
    substr(create_date_time, 1, 10) as dt
FROM edu_ods.ods_customer_appeal
WHERE deleted = 'false';



在线教育DWD层fact_customer_clue插入数据

--分区
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=100000;
set hive.exec.max.created.files=150000;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;
--分桶
set hive.enforce.bucketing=true;
set hive.enforce.sorting=true;

INSERT OVERWRITE table edu_dwd.fact_customer_clue partition (start_date)
SELECT 
    c.id ,
    c.create_date_time ,
    c.update_date_time ,
    c.deleted ,
    c.customer_id ,
    c.customer_relationship_id ,
    c.session_id ,
    c.sid ,
    c.status ,
    c.`user` ,
    c.create_time ,
    c.platform ,
    c.s_name ,
    c.seo_source ,
    c.seo_keywords ,
    c.ip ,
    c.referrer ,
    c.from_url ,
    c.landing_page_url ,
    c.url_title ,
    c.to_peer ,
    c.manual_time ,
    c.begin_time ,
    c.reply_msg_count ,
    c.total_msg_count ,
    c.msg_count ,
    c.`comment` ,
    c.finish_reason ,
    c.finish_user ,
    c.end_time ,
    c.platform_description ,
    c.browser_name ,
    c.os_info ,
    c.area ,
    c.country ,
    c.province ,
    c.city ,
    c.creator ,
    c.name ,
    c.idcard ,
    c.phone ,
    case 
        WHEN c.itcast_school_id=0 or c.itcast_school_id is null then -1
        else c.itcast_school_id
    end    
    as itcast_school_id ,
    c.itcast_school ,
    case 
        WHEN c.itcast_subject_id=0 or c.itcast_subject_id is null then -1
        else c.itcast_subject_id
    end  
    as itcast_subject_id ,
    c.itcast_subject ,
    c.wechat ,
    c.qq ,
    c.email ,
    c.gender ,
    c.level ,
    c.origin_type ,
    c.information_way ,
    c.working_years ,
    c.technical_directions ,
    c.customer_state ,
    c.valid ,
    c.anticipat_signup_date ,
    c.clue_state ,
    c.scrm_department_id ,
    c.superior_url ,
    c.superior_source ,
    c.landing_url ,
    c.landing_source ,
    c.info_url ,
    c.info_source ,
    c.origin_channel ,
    c.course_id ,
    c.course_name ,
    c.zhuge_session_id ,
    c.is_repeat ,
    c.tenant ,
    c.activity_id ,
    c.activity_name ,
    c.follow_type ,
    c.shunt_mode_id ,
    c.shunt_employee_group_id ,
    case 
        WHEN c.clue_state='VALID_PUBLIC_NEW_CLUE'
        THEN '0'
        WHEN c.clue_state='VALID_NEW_CLUES'
        THEN '1'
    end
    as clue_state_stat ,
    case 
        WHEN a.appeal_status=0 or a.appeal_status=1 
        THEN '0'
        when a.appeal_status=2
        then '1'
    end
    as clue_appeal_state ,
    '9999-99-99'
    as end_date,
    if(c.update_date_time='' or c.update_date_time is NULL,  substring(c.create_date_time, 1, 10), substring(c.update_date_time, 1, 10))
    as start_date
FROM edu_ods.ods_customer_clue c
LEFT JOIN edu_ods.ods_customer_appeal a
ON c.customer_relationship_id = a.customer_relationship_first_id
WHERE c.deleted = 'false';



在线教育DWD层fact_customer_relationship插入数据

--分区
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=100000;
set hive.exec.max.created.files=150000;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;
--分桶
set hive.enforce.bucketing=true;
set hive.enforce.sorting=true;

INSERT OVERWRITE table edu_dwd.fact_customer_relationship partition(start_date)
SELECT 
    id ,
    create_date_time ,
    update_date_time ,
    deleted ,
    customer_id ,
    first_id ,
    belonger ,
    belonger_name ,
    initial_belonger ,
    distribution_handler ,
    business_scrm_department_id ,
    last_visit_time ,
    next_visit_time ,
    origin_type ,
    case 
        WHEN itcast_school_id=0 or itcast_school_id is null then -1
        else itcast_school_id
    end    
    as itcast_school_id ,
    case 
        WHEN itcast_subject_id=0 or itcast_subject_id is null then -1
        else itcast_subject_id
    end  
    as itcast_subject_id ,
    intention_study_type ,
    anticipat_signup_date ,
    level ,
    creator ,
    current_creator ,
    creator_name ,
    origin_channel ,
    `comment` ,
    first_customer_clue_id ,
    last_customer_clue_id ,
    process_state ,
    process_time ,
    payment_state ,
    payment_time ,
    signup_state ,
    signup_time ,
    notice_state ,
    notice_time ,
    lock_state ,
    lock_time ,
    itcast_clazz_id ,
    itcast_clazz_time ,
    payment_url ,
    payment_url_time ,
    ems_student_id ,
    delete_reason ,
    deleter ,
    deleter_name ,
    delete_time ,
    course_id ,
    course_name ,
    delete_comment ,
    close_state ,
    close_time ,
    appeal_id ,
    tenant ,
    total_fee ,
    belonged ,
    belonged_time ,
    belonger_time ,
    transfer ,
    transfer_time ,
    follow_type ,
    transfer_bxg_oa_account ,
    transfer_bxg_belonger_name,
    substring(create_date_time, 1, 4) as yearinfo, 
    substring(create_date_time, 1, 7) as monthinfo ,
    substring(create_date_time, 1, 10) as dayinfo ,
    substring(create_date_time, 1, 13) as hourinfo ,
    case 
        WHEN origin_type='NETSERVICE' 
        THEN '1'
        WHEN  origin_type='PRESIGNUP'
        THEN '1'
        ELSE '0'
    END
    as origin_type_state ,
    '9999-99-99'
    as end_date,
    if(update_date_time='' or update_date_time is NULL,  substring(create_date_time, 1, 10), substring(update_date_time, 1, 10))
    as start_date
FROM edu_ods.ods_customer_relationship
WHERE deleted = 'false';



在线教育DWB层dwb_relationship_clue_detail意向线索主题宽表建表

-- 意向线索主题宽表：edu_dwb.dwb_relationship_clue_detail
set hive.exec.orc.compression.strategy=COMPRESSION;
DROP TABLE if EXISTS edu_dwb.dwb_relationship_clue_detail;
CREATE EXTERNAL TABLE IF NOT EXISTS edu_dwb.dwb_relationship_clue_detail (
-- 线索表 fact_customer_clue
    clue_id                    INT              COMMENT 'customer_clue_id',               -- cc.id
    clue_state                 STRING           COMMENT '线索状态：VALID_NEW_CLUES, VALID_PUBLIC_NEW_CLUE',  -- cc.clue_state
    clue_state_stat            STRING           COMMENT '新老客户：0.老客户；1.新客户',   -- cc.clue_state_stat
    clue_appeal_state          STRING           COMMENT '是否有效线索: 0.无效 1.有效',    -- cc.clue_appeal_state 

-- 意向表 fact_customer_relationship
    create_date_time           STRING           COMMENT '创建时间',                -- cr.create_date_time
    update_date_time           STRING           COMMENT '最后更新时间',            -- cr.update_date_time
    customer_id                INT              COMMENT '所属客户id',              -- cr.customer_id 
    origin_type                STRING           COMMENT '数据来源：NETSERVICE, PRESIGNUP...',  -- cr.origin_type
    origin_type_state          STRING           COMMENT '线上线下:0.线下；1.线上', -- cr.origin_type_state
    yearinfo                   STRING           COMMENT '年',                      -- cr.yearinfo
    monthinfo                  STRING           COMMENT '月',                      -- cr.monthinfo
    dayinfo                    STRING           COMMENT '日',                      -- cr.dayinfo
    hourinfo                   STRING           COMMENT '小时',                    -- cr.hourinfo

-- 客户表 dim_customer   
    area                       STRING           COMMENT '所在区域',       -- c.area

-- 校区表 dim_itcast_school
    itcast_school_id           INT              COMMENT '校区id',         --sc.id 
    itcast_school_name         STRING           COMMENT '校区名称',       --sc.name
    
-- 学科表 dim_itcast_subject
    itcast_subject_id          INT              COMMENT '学科id',         --sj.id
    itcast_subject_name        STRING           COMMENT '学科名称',       --sj.name

-- 员工表 dim_employee
    tdepart_id                 INT              COMMENT '部门id',         --em.tdepart_id

-- 部门表 dim_scrm_department
    tdepart_name               STRING           COMMENT '部门名称'        --dep.name
)COMMENT '意向线索主题宽表'
PARTITIONED BY(dt STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc 
TBLPROPERTIES ('orc.compress'='SNAPPY');





在线教育DWB层dwb_relationship_clue_detail意向线索主题宽表插入数据

--分区
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=100000;
set hive.exec.max.created.files=150000;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;
--分桶
set hive.enforce.bucketing=true;
set hive.enforce.sorting=true;
--开启有序动态分区

INSERT OVERWRITE table edu_dwb.dwb_relationship_clue_detail partition (dt)
SELECT 
-- 线索表 fact_customer_clue
    cc.id,
    cc.clue_state,
    cc.clue_state_stat,
    cc.clue_appeal_state ,

-- 意向表 fact_customer_relationship
    cr.create_date_time,
    cr.update_date_time,
    cr.customer_id ,
    cr.origin_type,
    cr.origin_type_state,
    cr.yearinfo,
    cr.monthinfo,
    cr.dayinfo,
    cr.hourinfo,

-- 客户表 dim_customer  
    c.area,

-- 校区表 dim_itcast_school
    sc.id ,
    sc.name,
    
-- 学科表 dim_itcast_subject
    sj.id,
    sj.name,
    
-- 员工表 dim_employee
    em.tdepart_id,

-- 部门表 dim_scrm_department
    dep.name,
    substr(cr.create_date_time, 1, 10) as dt
FROM edu_dwd.fact_customer_relationship cr 
LEFT JOIN edu_dwd.fact_customer_clue cc
    ON cc.customer_relationship_id = cr.id
LEFT JOIN edu_dwd.dim_customer c
    ON cr.customer_id = c.id
LEFT JOIN edu_dwd.dim_itcast_school sc
    ON cr.itcast_school_id = sc.id
LEFT JOIN edu_dwd.dim_itcast_subject sj
    ON cr.itcast_subject_id = sj.id
LEFT JOIN edu_dwd.dim_employee em 
    ON cr.creator = em.id
LEFT JOIN edu_dwd.dim_scrm_department dep
    ON em.tdepart_id = dep.id;





在线教育DM层dm_relationship_clue建表

-- 意向线索主题数据集市：edu_dm.dm_relationship_clue
set hive.exec.orc.compression.strategy=COMPRESSION;
DROP TABLE if EXISTS edu_dm.dm_relationship_clue;
CREATE TABLE IF NOT EXISTS edu_dm.dm_relationship_clue (
    customer_cnt               BIGINT              COMMENT '意向客户总数',
    clue_cnt                   BIGINT              COMMENT '有效线索总数',
    yearinfo                   STRING              COMMENT '年',                      
    monthinfo                  STRING              COMMENT '月',                      
    dayinfo                    STRING              COMMENT '日',                      
    hourinfo                   STRING              COMMENT '小时', 
    area                       STRING              COMMENT '所在区域', 
    itcast_subject_id          INT                 COMMENT '学科id',         
    itcast_subject_name        STRING              COMMENT '学科名称', 
    itcast_school_id           INT                 COMMENT '校区id',     
    itcast_school_name         STRING              COMMENT '校区名称',
    origin_type                STRING              COMMENT '数据来源：NETSERVICE, PRESIGNUP...', 
    tdepart_id                 INT                 COMMENT '部门id',         
    tdepart_name               STRING              COMMENT '部门名称', 
    clue_state_stat            STRING              COMMENT '新老客户：0.老客户；1.新客户',
    time_type                  STRING              COMMENT '时间维度',
    group_type                 STRING              COMMENT '组合维度',
    time_str                   STRING              COMMENT '时间明细'
)COMMENT '意向线索主题数据集市'
PARTITIONED BY(date_time STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc 
TBLPROPERTIES ('orc.compress'='SNAPPY');





在线教育DM层dm_relationship_clue插入数据

--分区
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=100000;
set hive.exec.max.created.files=150000;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;
--分桶
set hive.enforce.bucketing=true;
set hive.enforce.sorting=true;
--关闭MapJoin
set hive.auto.convert.join=false;


INSERT into hive.edu_dm.dm_relationship_clue
SELECT
    count(distinct(customer_id)) as customer_cnt ,     --意向客户总数
    count(if(clue_appeal_state != '1' or clue_appeal_state is null, clue_id, null)) as clue_cnt , --有效线索总数
    yearinfo ,
    monthinfo ,
    dayinfo ,
    hourinfo ,
    area ,
    itcast_subject_id ,
    itcast_subject_name ,
    itcast_school_id ,
    itcast_school_name ,
    origin_type ,       -- '数据来源：NETSERVICE, PRESIGNUP...'
    tdepart_id ,
    tdepart_name ,
    clue_state_stat,        -- '新老客户：0.老客户；1.新客户',
    CASE
        WHEN grouping(hourinfo)=0 THEN '按小时聚合'
        WHEN grouping(dayinfo)=0 THEN '按日聚合'
        WHEN grouping(monthinfo)=0 THEN '按月聚合'
        WHEN grouping(yearinfo)=0 THEN '按年聚合'
    END
    as time_type ,      -- '时间维度'
    CASE
        WHEN grouping(area)=0 THEN '区域'
        WHEN grouping(itcast_subject_id)=0 THEN '学科'
        WHEN grouping(itcast_school_id)=0 THEN '校区'
        WHEN grouping(origin_type)=0 THEN '来源渠道'
        WHEN grouping(tdepart_id)=0 THEN '咨询中心'
        WHEN grouping(clue_state_stat)=0 THEN '新老客户'
        ELSE '总意向量'
    END
    as group_type ,     -- '组合维度'
    CASE
        WHEN grouping(hourinfo)=0 THEN substr(hourinfo, 12, 13)
        WHEN grouping(dayinfo)=0 THEN substr(dayinfo, 9, 10)
        WHEN grouping(monthinfo)=0 THEN substr(monthinfo, 6, 7)
        WHEN grouping(yearinfo)=0 THEN substr(yearinfo, 1, 4)
    END
    as time_str,         -- '时间明细'
    '2022-08-12' as date_time     -- '计算数据的日期'
FROM edu_dwb.dwb_relationship_clue_detail
GROUP BY
grouping sets(
---- 年
    (yearinfo),
    (yearinfo, area, clue_state_stat),
    (yearinfo, itcast_subject_id, itcast_subject_name, clue_state_stat),
    (yearinfo, itcast_school_id, itcast_school_name, clue_state_stat),
    (yearinfo, origin_type, clue_state_stat),
    (yearinfo, tdepart_id, tdepart_name, clue_state_stat),
    (yearinfo, clue_state_stat),
---- 月
    (yearinfo, monthinfo),
    (yearinfo, monthinfo, area, clue_state_stat),
    (yearinfo, monthinfo, itcast_subject_id, itcast_subject_name, clue_state_stat),
    (yearinfo, monthinfo, itcast_school_id, itcast_school_name, clue_state_stat),
    (yearinfo, monthinfo, origin_type, clue_state_stat),
    (yearinfo, monthinfo, tdepart_id, tdepart_name, clue_state_stat),
    (yearinfo, monthinfo, clue_state_stat),
---- 日
    (yearinfo, monthinfo, dayinfo),
    (yearinfo, monthinfo, dayinfo, area, clue_state_stat),
    (yearinfo, monthinfo, dayinfo, itcast_subject_id, itcast_subject_name, clue_state_stat),
    (yearinfo, monthinfo, dayinfo, itcast_school_id, itcast_school_name, clue_state_stat),
    (yearinfo, monthinfo, dayinfo, origin_type, clue_state_stat),
    (yearinfo, monthinfo, dayinfo, tdepart_id, tdepart_name, clue_state_stat),
    (yearinfo, monthinfo, dayinfo, clue_state_stat),
---- 小时
    (yearinfo, monthinfo, dayinfo, hourinfo),
    (yearinfo, monthinfo, dayinfo, hourinfo, area, clue_state_stat),
    (yearinfo, monthinfo, dayinfo, hourinfo, itcast_subject_id, itcast_subject_name, clue_state_stat),
    (yearinfo, monthinfo, dayinfo, hourinfo, itcast_school_id, itcast_school_name, clue_state_stat),
    (yearinfo, monthinfo, dayinfo, hourinfo, origin_type, clue_state_stat),
    (yearinfo, monthinfo, dayinfo, hourinfo, tdepart_id, tdepart_name, clue_state_stat),
    (yearinfo, monthinfo, dayinfo, hourinfo, clue_state_stat)
);

