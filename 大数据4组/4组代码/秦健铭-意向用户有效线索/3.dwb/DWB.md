### DWB建表-customer

```sql
-- 创建库
create database if not exists itcast_dwb;

-- 写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;


DROP TABLE if EXISTS itcast_dwb.dwb_customer_detail;
CREATE TABLE itcast_dwb.dwb_customer_detail
(
	-- customer_relationship（主表cr）
	customer_relationship_id int,
	customer_relationship_customer_id int comment '所属客户id',
	customer_relationship_create_date_time string comment '创建时间',
    customer_relationship_itcast_school_id int comment '校区Id',
    customer_relationship_itcast_subject_id int comment '学科Id',
    customer_relationship_origin_type string comment '数据来源',
    customer_relationship_creator int comment '创建人',
    -- customer_appeal（id=cr.id）
    customer_appeal_id int comment '主键',
    customer_appeal_customer_relationship_first_id int comment '第一条客户关系id',
    customer_appeal_appeal_status string comment '申诉状态，0:待稽核waiting 1:无效invalid 2：有效valid',
    -- itcast_clazz
    itcast_clazz_id int comment 'ems课程id(非自增)',
    itcast_clazz_itcast_school_id  string comment 'ems校区ID',
	itcast_clazz_itcast_school_name string comment 'ems校区名称',
	itcast_clazz_itcast_subject_id  string comment 'ems学科ID',
	itcast_clazz_itcast_subject_name string comment 'ems学科名称',
    -- customer
    customer_id int,
    customer_area string comment '所在区域',
    -- employee
    employee_id int,
    employee_tdepart_id int comment '直属部门',
    employee_department_id string comment 'OA中的部门编号，有负值',
    -- customer_clue
    customer_clue_id int comment '',
    customer_clue_customer_relationship_id int comment '客户关系id',
    customer_clue_clue_state string comment '线索状态',
    customer_clue_deleted string comment '是否被删除（禁用）',
    customer_clue_create_date_time string comment '创建时间',
    -- scrm_department
    scrm_department_id int comment '部门id',
    scrm_department_name string comment '部门名称',
    -- itcast_subject
    itcast_subject_id int,
    itcast_subject_name string comment '学科名称',
    -- itcast_school
    itcast_school_id int,
    itcast_school_name string comment '校区名称'
)
PARTITIONED BY(dt STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
stored as orc 
TBLPROPERTIES ('orc.compress'='SNAPPY');
```



#### 数据插入customer

```sql
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

-- 关掉所有的mapjoin优化
set hive.auto.convert.join=false;
set hive.optimize.bucketmapjoin=false;
set hive.auto.convert.sortmerge.join=false;
set hive.optimize.bucketmapjoin.sortedmerge=false;
set hive.auto.convert.sortmerge.join.noconditionaltask=false;


insert overwrite table itcast_dwb.dwb_customer_detail partition(dt)
select
	-- customer_relationship
	fcr.id,
	fcr.customer_id,
	fcr.create_date_time,
	fcr.itcast_school_id,
	fcr.itcast_subject_id,
	fcr.origin_type,
	fcr.creator,
	-- customer appeal
	dca.id,
	dca.customer_relationship_first_id,
	dca.appeal_status,
	-- itcast_clazz
	dic.id,
	dic.itcast_school_id,
	dic.itcast_school_name,
	dic.itcast_subject_id,
	dic.itcast_subject_name,
	-- customer
	dc.id,
	dc.area,
	-- employee
	de.id,
	de.tdepart_id,
	de.department_id,
	-- customer_clue
	fcc.id,
	fcc.customer_relationship_id,
	fcc.clue_state,
	fcc.deleted,
	fcc.create_date_time,
	-- scrm_department
	dsd.id,
	dsd.name,
	-- itcast_subject
	disu.id,
	disu.name,
	-- itcast_school
	disc.id,
	disc.name,
	-- 分区字段	
	substr(fcr.create_date_time,1,7) as dt
from
-- customer_relationship(主表)
itcast_dwd.fact_customer_relationship fcr
-- customer appeal
	left join itcast_dwd.dim_customer_appeal dca
		on dca.customer_relationship_first_id = fcr.id
-- itcast_clazz
    left join itcast_dwd.dim_itcast_clazz dic
        on dic.id = fcr.itcast_clazz_id
-- customer
    left join itcast_dwd.dim_customer dc
        on dc.id = fcr.customer_id
-- employee
    left join itcast_dwd.dim_employee de 
        on de.id = fcr.creator
-- customer_clue
    left join itcast_dwd.fact_customer_clue fcc
        on fcc.customer_relationship_id = fcr.id and fcc.stop_time = '9999-99-99'
-- scrm_department
    left join itcast_dwd.dim_scrm_department dsd
        on dsd.id = de.tdepart_id
-- itcast_subject
    left join itcast_dwd.dim_itcast_subject disu
        on disu.id = fcr.itcast_subject_id
-- itcast_school
    left join itcast_dwd.dim_itcast_school disc
        on disc.id = fcr.itcast_school_id
where fcr.stop_time = '9999-99-99'
;
```





































### DWB建表-web_chat_detail

```sql
-- 创建库
create database if not exists itcast_dwb;

-- 写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;


DROP TABLE if EXISTS itcast_dwb.dwb_customer_detail;
CREATE TABLE itcast_dwb.dwb_customer_detail
(
	-- web_chat_ems(主表)
	id INT comment '主键',
    session_id STRING comment '七陌sessionId',
    sid STRING comment '访客id',
    ip STRING comment 'IP地址',
    create_time STRING comment '会话创建时间',
    area STRING comment '地域',
    country STRING comment '所在国家',
    province STRING comment '省',
    city STRING comment '城市',
    msg_count INT comment '客户发送消息数',
    origin_channel STRING comment '投放渠道',
    seo_source STRING comment '搜索来源',
    -- web_chat_text_ems
    web_chat_text_ems_id INT comment'主键',
    from_url string comment'会话来源页面'    
)
PARTITIONED BY(dt STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
stored as orc 
TBLPROPERTIES ('orc.compress'='SNAPPY');
```





### DWB建表-class_student

```sql
-- 创建库
create database if not exists itcast_dwb;

-- 写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;


DROP TABLE if EXISTS itcast_dwb.dwb_customer_detail;
CREATE TABLE itcast_dwb.dwb_customer_detail
(
	-- 
)
PARTITIONED BY(dt STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
stored as orc 
TBLPROPERTIES ('orc.compress'='SNAPPY');
```



