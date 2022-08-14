create database if not exists edu_dwb_access;

-- 建表操作:
create table if not exists edu_dwb_access.web_chat_ems_dwb (
    id                   int comment '主键',
    sid                  string comment '访客id',
    ip                   string comment 'ip地址',
    session_id           string comment '会话系统sessionid',
    create_time          string comment '会话创建时间',
    hourinfo             string  comment '小时',
    area                 string comment '区域维度',
    origin_channel       string comment '来源渠道',
    seo_source           string  comment '搜索来源',
    msg_count            int  comment '客户发送消息数',
    referrer             string comment '上级来源页面',
    from_url             string comment '会话来源页面',
    landing_page_url     string comment '访客着陆页面',
    url_title            string comment '咨询页面title',
    platform_description string comment '客户平台信息',
    other_params         string comment '扩展字段中数据',
    history              string comment '历史访问记录'
)
partitioned by(yearinfo string,quarterinfo string, monthinfo string, dayinfo string)
row format delimited fields terminated by '\t'
stored AS orc tblproperties (
    'orc.compress' = 'SNAPPY',
    'orc.create.index'='true'
);