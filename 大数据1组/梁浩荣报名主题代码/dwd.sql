### 1	fact_customer_relationship_dwd(拉链表)

### 建表

```mysql
DROP TABLE IF EXISTS itcast_dwd.`fact_customer_relationship_dwd`;
CREATE TABLE itcast_dwd.`fact_customer_relationship_dwd`(
)
comment '客户意向表' partitioned by (start_day string)
row format delimited fields terminated by '\t'
stored as orc
tblproperties ('orc.compress' = 'SNAPPY');
```

字段：62个ods + 5个新建 + 1个分区

```mysql
(
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
-- 旧字段62个，新增2+1分区   ，共65个
  `origin_type_stat` STRING COMMENT '数据来源：NETSERVICE（线上）-0，OTHER+PHONE+SCHOOL+VISITED（线下）-1',
  `end_day` STRING COMMENT '9999-99-99为正在生效,其他值为历史记录'
)
```

### 插入

```mysql
-- 开启动态分区支持，并开启非严格模式
set hive.exec.dynamic.partition=true;
-- 严格模式：要求插入时至少有一个静态分区；如果全都要用动态分区，必须用非严格模式。
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=100000;
set hive.exec.max.created.files=150000;
-- hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
-- 写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;
-- 分桶
set hive.enforce.bucketing=true;
set hive.enforce.sorting=true;


-- INSERT overwrite TABLE itcast_dwd.fact_customer_relationship_dwd PARTITION (start_day)
-- INSERT INTO itcast_dwd.fact_customer_relationship_dwd PARTITION (start_day)
SELECT *
from itcast_ods.t_customer_relationship
;
```

字段：62个ods + 2个新建 + 1个分区

```mysql
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
    comment,
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
    case
        when origin_type = 'OTHER' or origin_type = 'PHONE' or origin_type = 'SCHOOL' or origin_type = 'VISITED'
        then 0
        when origin_type = 'NETSERVICE'
        then 1
    end
    as origin_type_stat,
    '9999-99-99' as end_day,
    if(update_date_time is not null or update_date_time != '',
            substring(update_date_time, 1, 10),
            substring(create_date_time, 1, 10)
       ) as start_day	-- 分区
```

### 2	dim_itcast_clazz_dwd

### 建表

```mysql
DROP TABLE IF EXISTS itcast_dwd.`dim_itcast_clazz_dwd`;
CREATE TABLE itcast_dwd.dim_itcast_clazz_dwd(
)
comment '报名课程表' partitioned by (dt string)
row format delimited fields terminated by '\t'
stored as orc
tblproperties ('orc.compress' = 'SNAPPY');
```

字段 19个 + 1分区（dt）

```mysql
 (
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
  ends_time STRING COMMENT '有效时间'
 )
```

### 插入

```mysql
-- 开启动态分区支持，并开启非严格模式
set hive.exec.dynamic.partition=true;
-- 严格模式：要求插入时至少有一个静态分区；如果全都要用动态分区，必须用非严格模式。
set hive.exec.dynamic.partition.mode=nonstrict;

-- INSERT overwrite TABLE itcast_dwd.dim_itcast_clazz_dwd PARTITION(dt)
-- INSERT INTO itcast_dwd.dim_itcast_clazz_dwd PARTITION (dt)
SELECT *
from itcast_ods.t_itcast_clazz
;
```

字段 19个 + 1分区（dt）

```mysql
  id,
  create_date_time,
  update_date_time,
  deleted,
  itcast_school_id,
  itcast_school_name ,
  itcast_subject_id,
  itcast_subject_name ,
  itcast_brand,
  clazz_type_state,
  clazz_type_name,
  teaching_mode,
  start_time,
  end_time,
  comment,
  detail,
  uncertain,
  tenant,
  ends_time,
  dt -- 分区
```

