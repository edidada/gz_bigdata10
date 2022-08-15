-- drop table edu_dwb.itcast_intention_dwb1;
CREATE TABLE IF NOT EXISTS edu_dwb.itcast_intention_dwb1 (
    id string,
    customer_id string,
    create_date_time STRING,
    year string ,
    month string ,
    day string,
    hour string,
    itcast_school_id string,
    itcast_subject_id string,
    origin_type string,
    creator string,
-- edu_dwd.fact_customer_clue 客户线索表     fcc
    customer_relationship_id string,
    clue_state string,
    deleted string,
-- edu_ods.customer 客户静态信息表 eoc
    area string,
-- edu_ods.employee 员工表 eoe
    tdepart_id string,
    department_id string,
-- edu_ods.scrm_department 部门表  eos
    name string
)
comment '客户意向dwm表'
PARTITIONED BY(dt STRING)
clustered by(customer_id) sorted by(customer_id) into 10 buckets
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as ORC
TBLPROPERTIES ('orc.compress'='SNAPPY');


-- 开启动态分区支持，并开启非严格模式
SET hive.exec.dynamic.partition=true;
-- 严格模式：要求插入式要至少有一个静态分区；如果全部用动态分区，需要开启非严格模式
SET hive.exec.dynamic.partition.mode=nonstrict;

INSERT INTO edu_dwb.itcast_intention_dwb1 partition (dt)
SELECT
-- edu_dwd.fact_customer_relationship 客户意向表  fcr
    fcr.id,
    fcr.customer_id,
-- (create_date_time)
    concat_ws('-',fcr.year,fcr.month,fcr.day) as create_date_time,
    fcr.year as yearinfo,
    fcr.month as monthinfo ,
    fcr.day as dayinfo,
    fcr.hour,
    fcr.itcast_school_id,
    fcr.itcast_subject_id,
    fcr.origin_type,
    fcr.creator,
-- edu_dwd.fact_customer_clue 客户线索表     fcc
    fcc.customer_relationship_id,
    fcc.clue_state,
    fcc.deleted,
    -- concat('-',fcr.year,fcr.month,fcr.day) as create_date_time,
-- edu_ods.customer 客户静态信息表 eoc
    eoc.area,
-- edu_ods.employee 员工表 eoe
    eoe.tdepart_id,
    eoe.department_id,
-- edu_ods.scrm_department 部门表  eos
    eos.name,
    '2022-08-08' dt
FROM edu_dwd.fact_customer_relationship fcr
left JOIN edu_dwd.fact_customer_clue fcc on fcr.id = fcc.customer_relationship_id
and fcc.ends_time='9999-99-99'
left join edu_ods.customer eoc on eoc.id = fcr.customer_id
left join edu_ods.employee eoe on eoe.id = fcr.creator
left join edu_ods.scrm_department eos on eos.id = eoe.tdepart_id
where fcr.end_time = '9999-99-99'
;

-- SELECT * FROM itcast_intention_dwb1;