-- dwd层表1 构建拉链表
CREATE TABLE IF NOT EXISTS edu_dwd.`customer_relationship_1` (
  `id` int COMMENT '客户关系id',
  `create_date_time` STRING COMMENT '创建时间',
  `update_date_time` STRING COMMENT '最后更新时间',
  `deleted` int COMMENT '是否被删除（禁用）',
  `customer_id` int COMMENT '所属客户id',
  `first_id` int COMMENT '第一条客户关系id',
  `belonger` int COMMENT '归属人',
  `belonger_name` STRING COMMENT '归属人姓名',
  `initial_belonger` int COMMENT '初始归属人',
  `distribution_handler` int COMMENT '分配处理人',
  `business_scrm_department_id` int COMMENT '归属部门',
  `last_visit_time` STRING COMMENT '最后回访时间',
  `next_visit_time` STRING COMMENT '下次回访时间',
  `origin_type` STRING COMMENT '数据来源',
  `itcast_school_id` int COMMENT '校区Id',
  `itcast_subject_id` int COMMENT '学科Id',
  `intention_study_type` STRING COMMENT '意向学习方式',
  `anticipat_signup_date` STRING COMMENT '预计报名时间',
  `level` STRING COMMENT '客户级别',
  `creator` int COMMENT '创建人',
  `current_creator` int COMMENT '当前创建人：初始==创建人，当在公海拉回时为 拉回人',
  `creator_name` STRING COMMENT '创建者姓名',
  `origin_channel` STRING COMMENT '来源渠道',
  `comment` STRING COMMENT '备注',
  `first_customer_clue_id` int COMMENT '第一条线索id',
  `last_customer_clue_id` int COMMENT '最后一条线索id',
  `process_state` STRING COMMENT '处理状态',
  `process_time` STRING COMMENT '处理状态变动时间',
  `payment_state` STRING COMMENT '支付状态',
  `payment_time` STRING COMMENT '支付状态变动时间',
  `signup_state` STRING COMMENT '报名状态',
  `signup_time` STRING COMMENT '报名时间',
  `notice_state` STRING COMMENT '通知状态',
  `notice_time` STRING COMMENT '通知状态变动时间',
  `lock_state` STRING COMMENT '锁定状态',
  `lock_time` STRING COMMENT '锁定状态修改时间',
  `itcast_clazz_id` int COMMENT '所属ems班级id',
  `itcast_clazz_time` STRING COMMENT '报班时间',
  `payment_url` STRING COMMENT '付款链接',
  `payment_url_time` STRING COMMENT '支付链接生成时间',
  `ems_student_id` int COMMENT 'ems的学生id',
  `delete_reason` STRING COMMENT '删除原因',
  `deleter` int COMMENT '删除人',
  `deleter_name` STRING COMMENT '删除人姓名',
  `delete_time` STRING COMMENT '删除时间',
  `course_id` int COMMENT '课程ID',
  `course_name` STRING COMMENT '课程名称',
  `delete_comment` STRING COMMENT '删除原因说明',
  `close_state` STRING COMMENT '关闭装填',
  `close_time` STRING COMMENT '关闭状态变动时间',
  `appeal_id` int COMMENT '申诉id',
  `tenant` int COMMENT '租户',
  `total_fee` DECIMAL COMMENT '报名费总金额',
  `belonged` int COMMENT '小周期归属人',
  `belonged_time` STRING COMMENT '归属时间',
  `belonger_time` STRING COMMENT '归属时间',
  `transfer` int COMMENT '转移人',
  `transfer_time` STRING COMMENT '转移时间',
  `follow_type` int COMMENT '分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取',
  `transfer_bxg_oa_account` STRING COMMENT '转移到博学谷归属人OA账号',
  `transfer_bxg_belonger_name` STRING COMMENT '转移到博学谷归属人OA姓名',
  `end_time` STRING COMMENT '有效截止时间')
comment '客户关系表'
PARTITIONED BY(start_time STRING)
clustered by(id) sorted by(id) into 10 buckets
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='SNAPPY');

--dwd表1 数据插入，添加start_time，end_time字段
insert into edu_dwd.customer_relationship_1
partition(start_time)
select
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
    follow_type,
    transfer_bxg_oa_account,
    transfer_bxg_belonger_name,
    '9999-99-99 99' as end_time,
	if(update_date_time is not null or update_date_time != '',
        SUBSTRING(update_date_time, 1, 13),
        SUBSTRING(create_date_time, 1, 13)
     )
    as start_time
from edu_ods.customer_relationship;

-- dwd层 清洗转换
CREATE TABLE IF NOT EXISTS edu_dwd.`customer_relationship_2` (
  `id` int COMMENT '客户关系id',
  `create_date_time` STRING COMMENT '创建时间',
  `update_date_time` STRING COMMENT '最后更新时间',
  `deleted` int COMMENT '是否被删除（禁用）',
  `customer_id` int COMMENT '所属客户id',
  `first_id` int COMMENT '第一条客户关系id',
  `belonger` int COMMENT '归属人',
  `belonger_name` STRING COMMENT '归属人姓名',
  `initial_belonger` int COMMENT '初始归属人',
  `distribution_handler` int COMMENT '分配处理人',
  `business_scrm_department_id` int COMMENT '归属部门',
  `last_visit_time` STRING COMMENT '最后回访时间',
  `next_visit_time` STRING COMMENT '下次回访时间',
  `origin_type` STRING COMMENT '数据来源',
  `itcast_school_id` int COMMENT '校区Id',
  `itcast_subject_id` int COMMENT '学科Id',
  `intention_study_type` STRING COMMENT '意向学习方式',
  `anticipat_signup_date` STRING COMMENT '预计报名时间',
  `level` STRING COMMENT '客户级别',
  `creator` int COMMENT '创建人',
  `current_creator` int COMMENT '当前创建人：初始==创建人，当在公海拉回时为 拉回人',
  `creator_name` STRING COMMENT '创建者姓名',
  `origin_channel` STRING COMMENT '来源渠道',
  `comment` STRING COMMENT '备注',
  `first_customer_clue_id` int COMMENT '第一条线索id',
  `last_customer_clue_id` int COMMENT '最后一条线索id',
  `process_state` STRING COMMENT '处理状态',
  `process_time` STRING COMMENT '处理状态变动时间',
  `payment_state` STRING COMMENT '支付状态',
  `payment_time` STRING COMMENT '支付状态变动时间',
  `signup_state` STRING COMMENT '报名状态',
  `signup_time` STRING COMMENT '报名时间',
  `notice_state` STRING COMMENT '通知状态',
  `notice_time` STRING COMMENT '通知状态变动时间',
  `lock_state` STRING COMMENT '锁定状态',
  `lock_time` STRING COMMENT '锁定状态修改时间',
  `itcast_clazz_id` int COMMENT '所属ems班级id',
  `itcast_clazz_time` STRING COMMENT '报班时间',
  `payment_url` STRING COMMENT '付款链接',
  `payment_url_time` STRING COMMENT '支付链接生成时间',
  `ems_student_id` int COMMENT 'ems的学生id',
  `delete_reason` STRING COMMENT '删除原因',
  `deleter` int COMMENT '删除人',
  `deleter_name` STRING COMMENT '删除人姓名',
  `delete_time` STRING COMMENT '删除时间',
  `course_id` int COMMENT '课程ID',
  `course_name` STRING COMMENT '课程名称',
  `delete_comment` STRING COMMENT '删除原因说明',
  `close_state` STRING COMMENT '关闭装填',
  `close_time` STRING COMMENT '关闭状态变动时间',
  `appeal_id` int COMMENT '申诉id',
  `tenant` int COMMENT '租户',
  `total_fee` DECIMAL COMMENT '报名费总金额',
  `belonged` int COMMENT '小周期归属人',
  `belonged_time` STRING COMMENT '归属时间',
  `belonger_time` STRING COMMENT '归属时间',
  `transfer` int COMMENT '转移人',
  `transfer_time` STRING COMMENT '转移时间',
  `follow_type` int COMMENT '分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取',
  `transfer_bxg_oa_account` STRING COMMENT '转移到博学谷归属人OA账号',
  `transfer_bxg_belonger_name` STRING COMMENT '转移到博学谷归属人OA姓名',
  `payment_time_hour` STRING COMMENT '支付状态变动小时',
  `origin_type_stat` STRING COMMENT '数据来源:0.线上；1.线下' )
comment '客户关系表'
PARTITIONED BY(payment_time_year String, payment_time_month String, payment_time_day String)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='SNAPPY');
-- dwd表2 清洗转换后插入
insert into edu_dwd.customer_relationship_2
partition(payment_time_year,payment_time_month,payment_time_day)
select
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
    nvl(origin_type, -1) as origin_type,
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
    follow_type,
    transfer_bxg_oa_account,
    transfer_bxg_belonger_name,
    substr(payment_time,12,2) as payment_time_hour,
    if(origin_type='NETSERVICE' or origin_type='PRESIGNUP', 0, 1) --0是线上，1是线下
    as origin_type_stat,    -- 2011-11-01 22:22
    substr(payment_time,1,4) as payment_time_year,
    substr(payment_time,6,2) as payment_time_month,
    substr(payment_time,9,2) as payment_time_day
from edu_dwd.customer_relationship_1
where deleted = 0 and customer_id is not null and payment_state = 'PAID';

-- itcast_clazz
create table if not exists edu_dwd.itcast_clazz_dwd
(
    id                      int       comment 'ems课程id(非自增)',
    create_date_time        string    comment '创建时间',
    update_date_time        string    comment '最后更新时间',
    deleted                 TINYINT   comment '是否被删除（禁用）',
    itcast_school_id        string    comment 'ems校区ID',
    itcast_school_name      string    comment 'ems校区名称',
    itcast_subject_id       string    comment 'ems学科ID',
    itcast_subject_name     string    comment 'ems学科名称',
    itcast_brand            string    comment 'ems品牌',
    clazz_type_state        string    comment '班级类型状态',
    clazz_type_name         string    comment '班级类型名称',
    teaching_mode           string    comment '授课模式',
    start_time              string    comment '开班时间',
    end_time                string    comment '毕业时间',
    `comment`               string    comment '备注',
    detail                  string    comment '详情(比如：27期)',
    uncertain               TINYINT   comment '待定班(0:否,1:是)',
    tenant                  int       COMMENT '租户',
    ends_time                string    comment '拉链结束日期'
)
comment '报名课程表'
partitioned by(starts_time string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );

-- itcast_clazz表数据插入
insert into edu_dwd.itcast_clazz_dwd
partition(starts_time)
select
    id,
    create_date_time,
    update_date_time,
    deleted,
    itcast_school_id,
    itcast_school_name,
    itcast_subject_id,
    itcast_subject_name,
    itcast_brand,
    clazz_type_state,
    clazz_type_name,
    teaching_mode,
    start_time,
    end_time,
    `comment`,
    detail,
    uncertain,
    tenant,
    '9999-99-99 99' as ends_time, -- 9999-99-99 99
	if(update_date_time is not null or update_date_time != '',
        SUBSTRING(update_date_time, 1, 13),
        SUBSTRING(create_date_time, 1, 13)
     )
    as starts_time
from edu_ods.itcast_clazz
where id is not null and deleted = 0;

-- employee
create table if not exists edu_dwd.employee_dwd
(
    id                   int                                                                   ,
    email                string    comment '公司邮箱，OA登录账号',
    real_name            string    comment '员工的真实姓名'      ,
    phone                string    comment '手机号，目前还没有使用；隐私问题OA接口没有提供这个属性，',
    department_id        string    comment 'OA中的部门编号，有负值',
    department_name      string    comment 'OA中的部门名',
    remote_login         TINYINT   comment '员工是否可以远程登录',
    job_number           string    comment '员工工号',
    cross_school         TINYINT   comment '是否有跨校区权限',
    last_login_date      string    comment '最后登录日期',
    creator              int       comment '创建人',
    create_date_time     string    comment '创建时间',
    update_date_time     string    comment '最后更新时间',
    deleted              TINYINT   comment '是否被删除（禁用）',
    scrm_department_id   int       comment 'SCRM内部部门id',
    leave_office         TINYINT   comment '离职状态',
    leave_office_time    string    comment '离职时间',
    reinstated_time      string    comment '复职时间',
    superior_leaders_id  int       comment '上级领导ID',
    tdepart_id           int       comment '直属部门',
    tenant               int       COMMENT '租户',
    ems_user_name        string    COMMENT 'ems用户名称',
    end_time             string    comment '拉链结束日期'
)
comment '员工表'
partitioned by(start_time string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );

-- employee 数据插入
insert into edu_dwd.employee_dwd
partition(start_time)
select
    id,
    email,
    real_name,
    phone,
    department_id,
    department_name,
    remote_login,
    job_number,
    cross_school,
    last_login_date,
    creator,
    create_date_time,
    update_date_time,
    deleted,
    scrm_department_id,
    leave_office,
    leave_office_time,
    reinstated_time,
    superior_leaders_id,
    tdepart_id,
    tenant,
    ems_user_name,
    '9999-99-99 99' as end_time,
	if(update_date_time is not null or update_date_time != '',
        SUBSTRING(update_date_time, 1, 13),
        SUBSTRING(create_date_time, 1, 13)
     )
    as start_time
from edu_ods.employee
where id is not null and deleted = 0;

-- scrm_department
create table if not exists edu_dwd.scrm_department_dwd
(
    id               int     comment '部门id',
    name             string  comment '部门名称',
    parent_id        int     comment '父部门id',
    create_date_time string  comment '创建时间',
    update_date_time string  comment '更新时间',
    deleted          TINYINT comment '删除标志',
    id_path          string  comment '编码全路径',
    tdepart_code     int     comment '直属部门',
    creator          int     comment '创建者',
    depart_level     int     comment '部门层级',
    depart_sign      int     comment '部门标志，暂时默认1',
    depart_line      int     comment '业务线，存储业务线编码',
    depart_sort      int     comment '排序字段',
    disable_flag     int     comment '禁用标志',
    tenant           int     COMMENT '租户',
    end_time         string  comment '拉链结束日期'
)
comment 'scrm部门表'
partitioned by(start_time string)
row format delimited fields terminated by '\t'
stored as orc
TBLPROPERTIES('orc.compress'='SNAPPY' );

-- scrm_department 数据插入
insert into edu_dwd.scrm_department_dwd
partition(start_time)
select
    id,
    name,
    parent_id,
    create_date_time,
    update_date_time,
    deleted,
    id_path,
    tdepart_code,
    creator,
    depart_level,
    depart_sign,
    depart_line,
    depart_sort,
    disable_flag,
    tenant,
    '9999-99-99 99' as end_time,
	if(update_date_time is not null or update_date_time != '',
        SUBSTRING(update_date_time, 1, 13),
        SUBSTRING(create_date_time, 1, 13)
    )
    as start_time
from edu_ods.scrm_department
where id is not null and deleted = 0;

-- dwb层 表关联形成宽表
CREATE TABLE IF NOT EXISTS edu_dwb.customer_signup_dwb
(
`customer_id` int COMMENT '所属客户id',
`itcast_school_id` STRING COMMENT '学校id',
`itcast_school_name` STRING COMMENT '学校namne',
`itcast_subject_id` STRING COMMENT '学科id',
`itcast_subject_name` STRING COMMENT '学科name',
`itcast_clazz_id` int COMMENT '所属ems班级id',
`creator` int COMMENT '创建人',
`tdepart_id` int COMMENT '咨询中心id',
`tdepart_name` STRING COMMENT '咨询中心name',
`origin_type` STRING COMMENT '来源渠道',
`origin_type_stat`STRING COMMENT '数据来源:0.线下；1.线上',
`payment_state` STRING COMMENT '支付状态',
 payment_time STRING COMMENT '时间明细',
`payment_time_hour` STRING COMMENT '最后更新时间'
)comment '报名人数统计中间表'
PARTITIONED BY (payment_time_year String, payment_time_month String, payment_time_day String)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='SNAPPY');

--customer_signup_dwb 数据插入
insert into edu_dwb.customer_signup_dwb
partition(payment_time_year,payment_time_month,payment_time_day)
select
    customer_id,
    clazz.itcast_school_id as itcast_school_id ,
    itcast_school_name,
    clazz.itcast_subject_id as itcast_subject_id ,
    itcast_subject_name,
    itcast_clazz_id,
    cr.creator as creator,
    tdepart_id,
    depart.name as tdepart_name,
    origin_type,
    origin_type_stat,
    payment_state,
    payment_time,
    payment_time_hour,
    payment_time_year,
    payment_time_month,
    payment_time_day
from edu_dwd.customer_relationship_2 cr
left join edu_dwd.itcast_clazz_dwd clazz on cr.itcast_clazz_id = clazz.id
left join edu_dwd.employee_dwd emp on cr.creator = emp.id
left join edu_dwd.scrm_department_dwd depart on emp.tdepart_id = depart.id;

-- dws层 轻度统计，粒度小时
CREATE TABLE IF NOT EXISTS edu_dws.customer_signup_dws (
  `signup_num` int COMMENT '报名人数',
  `itcast_school_id` STRING COMMENT '学校id',
  `itcast_school_name` STRING COMMENT '学校namne',
  `itcast_subject_id` STRING COMMENT '学科id',
  `itcast_subject_name` STRING COMMENT '学科name',
  `tdepart_id` int COMMENT '咨询中心id',
  `tdepart_name` STRING COMMENT '咨询中心name',
  `origin_type` STRING COMMENT '来源渠道',
   origin_type_stat STRING COMMENT '数据来源:0.线上；1.线下',
   payment_time STRING COMMENT '时间明细',
  `payment_time_hour` STRING COMMENT '最后更新时间',
   groupType STRING COMMENT '业务分组类型：1：校区、学科组合分组；2：来源渠道分组；3：咨询中心分组；4:所有'
  )
comment '报名人数统计业务表'
PARTITIONED BY (payment_time_year String, payment_time_month String, payment_time_day String)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='SNAPPY');

-- dws数据插入，
with t1 as(
select
    customer_id,
    itcast_school_id,
    itcast_school_name,
    itcast_subject_id,
    itcast_subject_name,
    tdepart_id,
    tdepart_name,
    origin_type,
    origin_type_stat,
    payment_time_hour,
    payment_time_year,
    payment_time_month,
    payment_time_day,
    concat(payment_time_year,payment_time_month, payment_time_day,payment_time_hour) --(substring(payment_time,1, 13))
    as time_str
from edu_dwb.customer_signup_dwb)
insert into edu_dws.customer_signup_dws
partition(payment_time_year,payment_time_month,payment_time_day)
select
    count(customer_id) as signup_num,
    itcast_school_id,
    itcast_school_name,
    itcast_subject_id,
    itcast_subject_name,
    tdepart_id,
    tdepart_name,
    origin_type,
    origin_type_stat,
    max(payment_time_hour) as payment_time_hour,
    case
        when grouping__id=27
        then 'tdepart'
        when grouping__id=483
        then 'scool_subject'
        when grouping__id=7
        then 'origin_type'
        when grouping__id=3
        then 'all'
    end as grouptype,
    time_str,
    max(payment_time_year) as payment_time_year,
    max(payment_time_month) as payment_time_month,
    max(payment_time_day) as payment_time_day
from t1
group by time_str,origin_type_stat,origin_type,
tdepart_id,tdepart_name,itcast_subject_id,itcast_subject_name,
itcast_school_id,itcast_school_name
grouping sets(
    (time_str,origin_type_stat),  -- 110000000 000000011 3
    (time_str,origin_type,origin_type_stat),   -- 111000000 000000111  7
    (time_str,tdepart_id,tdepart_name,origin_type_stat), -- 110110000 000011011  27
    (time_str,itcast_subject_id,itcast_subject_name,
    itcast_school_id,itcast_school_name,origin_type_stat)  --110001111  111100011 483
);

-- dm创表，粗粒度统计，年/月/日/小时
CREATE TABLE IF NOT EXISTS udu_dws.customer_signup_dws (
  `signup_num` int COMMENT '报名人数',
  `itcast_school_id` STRING COMMENT '学校id',
  `itcast_school_name` STRING COMMENT '学校namne',
  `itcast_subject_id` STRING COMMENT '学科id',
  `itcast_subject_name` STRING COMMENT '学科name',
  `tdepart_id` int COMMENT '咨询中心id',
  `tdepart_name` STRING COMMENT '咨询中心name',
  `origin_type` STRING COMMENT '来源渠道',
  origin_type_stat STRING COMMENT '数据来源:0.线下；1.线上',
  `payment_time_hour` STRING COMMENT '最后更新时间',
  groupType STRING COMMENT '业务分组类型：1：校区、学科组合分组；2：来源渠道分组；3：咨询中心分组；4:所有',
  time_type STRING COMMENT '聚合时间类型：1、按小时聚合；2、按天聚合；3、按周聚合；4、按月聚合；5、按年聚合。',
  tim_str STRING COMMENT '时间明细'
  )
comment '报名人数统计业务表'
PARTITIONED BY (payment_time_year String, payment_time_month String, payment_time_day String)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='SNAPPY');

-- DM 数据插入
with groupby as
(   select
        count(signup_num) as signup_num,
        itcast_school_id,
        max(itcast_school_name) as itcast_school_name,
        itcast_subject_id,
        max(itcast_subject_name) as itcast_subject_name,
        tdepart_id,
        max(tdepart_name) as tdepart_name,
        origin_type,
        origin_type_stat,
        max(payment_time_hour) as payment_time_hour,
        case
            when grouping__id in (81,83,87,95)
            then 'tdepart'
            when grouping__id in (401,403,407,415)
            then 'scool_subject'
            when grouping__id in (49,51,55,63)
            then 'origin_type'
            when grouping__id in (17,19,23,31)
            then 'all'
        end as grouptype,
        max(dws.grouptype) as grouptype_old,
        case
            when grouping__id in (31,63,95,415)
            then '小时'
            when grouping__id in (23,55,87,407)
            then '天'
            when grouping__id in (19,51,83,403)
            then '月'
            when grouping__id in (17,49,81,401)
            then '年'
        end as time_type,
        time_str,
        payment_time_year,
        payment_time_day
        payment_time_month,
        payment_time_day
    from edu_dws.customer_signup_dws dws
    group by
    payment_time_year,payment_time_month,payment_time_day,time_str,origin_type_stat,origin_type,tdepart_id,itcast_subject_id,itcast_school_id
    grouping sets(
    -- 年
        (payment_time_year,origin_type_stat),
        (payment_time_year,origin_type,origin_type_stat),
        (payment_time_year,tdepart_id,origin_type_stat),
        (payment_time_year,itcast_subject_id,itcast_school_id,origin_type_stat),
    -- 月
        (payment_time_month,payment_time_year,origin_type_stat),
        (payment_time_month,payment_time_year,origin_type,origin_type_stat),
        (payment_time_month,payment_time_year,tdepart_id,origin_type_stat),
        (payment_time_month,payment_time_year,itcast_subject_id,itcast_school_id,origin_type_stat),
    -- 日
        (payment_time_day,payment_time_month,payment_time_year,origin_type_stat),
        (payment_time_day,payment_time_month,payment_time_year,origin_type,origin_type_stat),
        (payment_time_day,payment_time_month,payment_time_year,tdepart_id,origin_type_stat),
        (payment_time_day,payment_time_month,payment_time_year,itcast_subject_id,itcast_school_id,origin_type_stat),
    -- 小时
        (time_str,payment_time_day,payment_time_month,payment_time_year,origin_type_stat),
        (time_str,payment_time_day,payment_time_month,payment_time_year,origin_type,origin_type_stat),
        (time_str,payment_time_day,payment_time_month,payment_time_year,tdepart_id,origin_type_stat),
        (time_str,payment_time_day,payment_time_month,payment_time_year,itcast_subject_id,itcast_school_id,origin_type_stat)
    )
)
insert into edu_dm.customer_signup_dm
partition(payment_time_year)
select
    signup_num,
    itcast_school_id,
    itcast_school_name,
    itcast_subject_id,
    itcast_subject_name,
    tdepart_id,
    tdepart_name,
    origin_type,
    origin_type_stat,
    payment_time_hour,
    grouptype,
    time_type,
    time_str,
    payment_time_day,
    payment_time_month,
    payment_time_year
from groupby
where grouptype = grouptype_old;

-- 本地 mysql创建表
CREATE TABLE IF NOT EXISTS oltp_customer_signup_result
(
`customer_id` int COMMENT '所属客户id',
`itcast_school_id` varchar(50) COMMENT '学校id',
`itcast_school_name` varchar(50) COMMENT '学校namne',
`itcast_subject_id` varchar(50) COMMENT '学科id',
`itcast_subject_name` varchar(50) COMMENT '学科name',
`itcast_clazz_id` int COMMENT '所属ems班级id',
`creator` int COMMENT '创建人',
`tdepart_id` int COMMENT '咨询中心id',
`tdepart_name` varchar(50) COMMENT '咨询中心name',
`origin_type` varchar(50) COMMENT '来源渠道',
`origin_type_stat` varchar(50) COMMENT '数据来源:0.线上；1.线下',
`payment_state` varchar(50) COMMENT '支付状态',
 payment_time varchar(50) COMMENT '时间明细',
`payment_time_hour` varchar(50) COMMENT '最后更新时间',
`payment_time_year`varchar(50),
payment_time_month varchar(50),
payment_time_day varchar(50)
)CHARSET=utf8mb4;

--sqoop数据导出
sqoop export \
--connect "jdbc:mysql://192.168.88.80:3306/edu_result?useUnicode=true&characterEncoding=utf-8" \
--username root \
--password '123456' \
--table oltp_customer_signup_result \
--hcatalog-database edu_dm \
--hcatalog-table customer_signup_dm



