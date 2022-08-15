CREATE TABLE IF NOT EXISTS edu_dwb.customer_signup_dwm (
  `customer_id` int COMMENT '报名客户id',
  `itcast_school_id` STRING COMMENT '学校id',
  `itcast_school_name` STRING COMMENT '学校namne',
  `itcast_subject_id` STRING COMMENT '学科id',
  `itcast_subject_name` STRING COMMENT '学科name',
  `tdepart_id` int COMMENT '咨询中心id',
  `tdepart_name` STRING COMMENT '咨询中心name',
  `origin_type` STRING COMMENT '来源渠道',
   origin_type_stat STRING COMMENT '数据来源:0.线下；1.线上',
  `payment_time_hour` STRING COMMENT '最后更新时间')
comment '报名人数统计中间表'
PARTITIONED BY (payment_time_year String, payment_time_month String, payment_time_day String)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='SNAPPY');