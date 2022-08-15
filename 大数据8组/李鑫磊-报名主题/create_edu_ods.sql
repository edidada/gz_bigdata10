-- 意向表(前一个主题以构建过)
CREATE TABLE IF NOT EXISTS edu_ods.`customer_relationship` (
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
  `transfer_bxg_belonger_name` STRING COMMENT '转移到博学谷归属人OA姓名')
comment '客户关系表'
PARTITIONED BY(dt STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='ZLIB');

-- 报名课程表
CREATE EXTERNAL TABLE IF NOT EXISTS edu_ods.itcast_clazz (
  id int COMMENT 'ems课程id(非自增)',
  create_date_time STRING COMMENT '创建时间',
  update_date_time STRING COMMENT '最后更新时间',
  deleted STRING COMMENT '是否被删除（禁用）',
  itcast_school_id STRING COMMENT 'ems校区ID',
  itcast_school_name STRING COMMENT 'ems校区名称',
  itcast_subject_id STRING COMMENT 'ems学科ID',
  itcast_subject_name STRING COMMENT 'ems学科名称',
  itcast_brand STRING COMMENT 'ems品牌',
  clazz_type_state STRING COMMENT '班级类型状态',
  clazz_type_name STRING COMMENT '班级类型名称',
  teaching_mode STRING COMMENT '授课模式',
  start_time STRING COMMENT '开班时间',
  end_time STRING COMMENT '毕业时间',
  comment STRING COMMENT '备注',
  detail STRING COMMENT '详情(比如：27期)',
  uncertain STRING COMMENT '待定班(0:否,1:是)',
  tenant int COMMENT '租户',
  ends_time STRING COMMENT '有效时间')
comment '班级信息表'
PARTITIONED BY(starts_time STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='SNAPPY','orc.create.index'='true','orc.bloom.filter.columns'='id');


-- 员工表(前一个主题以构建过)
CREATE TABLE IF NOT EXISTS edu_ods.employee (
  id int COMMENT '员工id',
  email STRING COMMENT '公司邮箱，OA登录账号',
  real_name STRING COMMENT '员工的真实姓名',
  phone STRING COMMENT '手机号，目前还没有使用；隐私问题OA接口没有提供这个属性，',
  department_id STRING COMMENT 'OA中的部门编号，有负值',
  department_name STRING COMMENT 'OA中的部门名',
  remote_login STRING COMMENT '员工是否可以远程登录',
  job_number STRING COMMENT '员工工号',
  cross_school STRING COMMENT '是否有跨校区权限',
  last_login_date STRING COMMENT '最后登录日期',
  creator int COMMENT '创建人',
  create_date_time STRING COMMENT '创建时间',
  update_date_time STRING COMMENT '最后更新时间',
  deleted STRING COMMENT '是否被删除（禁用）',
  scrm_department_id int COMMENT 'SCRM内部部门id',
  leave_office STRING COMMENT '离职状态',
  leave_office_time STRING COMMENT '离职时间',
  reinstated_time STRING COMMENT '复职时间',
  superior_leaders_id int COMMENT '上级领导ID',
  tdepart_id int COMMENT '直属部门',
  tenant int COMMENT '租户',
  ems_user_name STRING COMMENT 'ems用户名称'
)
comment '员工表'
PARTITIONED BY(start_time STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='SNAPPY');

-- 部门表(前一个主题以构建过)
CREATE TABLE IF NOT EXISTS edu_ods.`scrm_department` (
  `id` int COMMENT '部门id',
  `name` STRING COMMENT '部门名称',
  `parent_id` int COMMENT '父部门id',
  `create_date_time` STRING COMMENT '创建时间',
  `update_date_time` STRING COMMENT '更新时间',
  `deleted` STRING COMMENT '删除标志',
  `id_path` STRING COMMENT '编码全路径',
  `tdepart_code` int COMMENT '直属部门',
  `creator` STRING COMMENT '创建者',
  `depart_level` int COMMENT '部门层级',
  `depart_sign` int COMMENT '部门标志，暂时默认1',
  `depart_line` int COMMENT '业务线，存储业务线编码',
  `depart_sort` int COMMENT '排序字段',
  `disable_flag` int COMMENT '禁用标志',
  `tenant` int COMMENT '租户')
comment 'scrm部门表'
PARTITIONED BY(start_time STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='SNAPPY');