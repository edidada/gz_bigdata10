

drop table if exists edu_dwm.customer_detail_dwm;

CREATE TABLE IF NOT EXISTS edu_dwm.customer_detail_dwm (
  customer_id            int     COMMENT '报名客户id',
  itcast_school_id       int     COMMENT '学校id',
  itcast_school_name     STRING  COMMENT '学校namne',
  itcast_subject_id      int     COMMENT '学科id',
  itcast_subject_name    STRING  COMMENT '学科name',
  tdepart_id             int     COMMENT '咨询中心id',
  tdepart_name           STRING  COMMENT '咨询中心name',
  origin_type            STRING  COMMENT '来源渠道',
  origin_type_num        int     COMMENT '数据来源:0.线下；1.线上',
  clue_state             STRING  COMMENT '新老客户',
  clue_state_num         int     COMMENT '0新客户,1老客户',
  payment_hour           STRING  COMMENT '最后更新时间',
  payment_year           String ,
  payment_month          String ,
  payment_day            String
  )
comment '报名人数统计中间表'
PARTITIONED BY (dt STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='SNAPPY');


