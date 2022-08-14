
DROP table if EXISTS itcast_ods.web_chat_ems ;
CREATE EXTERNAL TABLE IF NOT EXISTS itcast_ods.web_chat_ems (
  id INT comment '主键',
  create_date_time STRING comment '数据创建时间',
  session_id STRING comment '七陌sessionId',
  sid STRING comment '访客id',
  create_time STRING comment '会话创建时间',
  seo_source STRING comment '搜索来源',
  seo_keywords STRING comment '关键字',
  ip STRING comment 'IP地址',
  area STRING comment '地域',
  country STRING comment '所在国家',
  province STRING comment '省',
  city STRING comment '城市',
  origin_channel STRING comment '投放渠道',
  `user` STRING COMMENT '所属坐席',
  manual_time STRING comment '人工开始时间',
  begin_time STRING comment '坐席领取时间 ',
  end_time STRING comment '会话结束时间',
  last_customer_msg_time_stamp STRING comment '客户最后一条消息的时间',
  last_agent_msg_time_stamp STRING comment '坐席最后一下回复的时间',
  reply_msg_count INT comment '客服回复消息数',
  msg_count INT comment '客户发送消息数',
  browser_name STRING comment '浏览器名称',
  os_info STRING comment '系统名称')
comment '访问会话信息表'
PARTITIONED BY(starts_time STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
location '/user/hive/warehouse/itcast_ods.db/web_chat_ems_ods'
TBLPROPERTIES ('orc.compress'='ZLIB');


DROP table if EXISTS itcast_ods.web_chat_text_ems ;
CREATE EXTERNAL TABLE IF NOT EXISTS itcast_ods.web_chat_text_ems (
    id  string  comment '主键',
	referrer    string  comment '上级来源页面',
	from_url    string  comment '会话来源页面',
	landing_page_url    string  comment '访客着陆页面',
	url_title   string  comment '咨询页面title',
	platform_description    string  comment '客户平台信息',
	other_params    string  comment '扩展字段中数据',
	history     string  comment '历史访问记录'
  )comment '访问会话信息表'
PARTITIONED BY(starts_time STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
location '/user/hive/warehouse/itcast_ods.db/web_chat_text_ems'
TBLPROPERTIES ('orc.compress'='ZLIB');