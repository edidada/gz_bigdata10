drop table if exists edu_dm.customer_signup_dm;
CREATE TABLE IF NOT EXISTS edu_dm.customer_signup_dm (
  customer_num           bigint     COMMENT '报名人数',
  itcast_school_id       int     COMMENT '学校id',
  itcast_school_name     STRING  COMMENT '学校name',
  itcast_subject_id      int     COMMENT '学科id',
  itcast_subject_name    STRING  COMMENT '学科name',
  tdepart_id             int     COMMENT '咨询中心id',
  tdepart_name           STRING  COMMENT '咨询中心name',
  origin_type            STRING  COMMENT '来源渠道',
  origin_type_num        int     COMMENT '数据来源:0.线下；1.线上',
  group_type_dm             STRING  COMMENT '业务分组类型',
  time_str               STRING  COMMENT '时间明细'
  )
comment '每日报名人数统计业务表'
PARTITIONED BY (payment_year String , payment_month String , payment_day String)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='SNAPPY');