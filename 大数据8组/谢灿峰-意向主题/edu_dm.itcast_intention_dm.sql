
CREATE TABLE IF NOT EXISTS edu_dm.itcast_intention_dm (
   customer_total INT COMMENT '聚合意向客户数',
   clue_nums INT COMMENT '根据id聚合有效线索数',
   area STRING COMMENT '区域信息',
   itcast_school_id STRING COMMENT '校区id',
   itcast_school_name STRING COMMENT '校区名称',
   origin_type STRING COMMENT '来源渠道',
   itcast_subject_id STRING COMMENT '学科id',
   itcast_subject_name STRING COMMENT '学科名称',
   hourinfo STRING COMMENT '小时信息',
   origin_type_stat STRING COMMENT '数据来源:0.线下；1.线上',
   clue_state_stat STRING COMMENT '客户属性：0.老客户；1.新客户',
   tdepart_id STRING COMMENT '创建者部门id',
   tdepart_name STRING COMMENT '咨询中心名称',
   time_str STRING COMMENT '时间明细',
   groupType STRING COMMENT '产品属性类别：1.总累计值；2.区域信息；3.校区、学科组合分组；4.来源渠道；5.咨询中心;',
   time_type STRING COMMENT '时间维度：1、按小时聚合；2、按天聚合；3、按周聚合；4、按月聚合；5、按年聚合；'
)
comment '客户意向dws表'
PARTITIONED BY(yearinfo STRING,monthinfo STRING,dayinfo STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='SNAPPY');

--insert into hive.edu_dm.itcast_intention_dm



