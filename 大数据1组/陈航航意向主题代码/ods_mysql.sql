create table web_chat_ems_2019_07
(
    id                           int auto_increment comment '主键'
        primary key,
    create_date_time             timestamp                                null comment '数据创建时间',
    session_id                   varchar(48)                   default '' not null comment '七陌sessionId',
    sid                          varchar(48) collate utf8_bin  default '' not null comment '访客id',
    create_time                  datetime                                 null comment '会话创建时间',
    seo_source                   varchar(255) collate utf8_bin default '' null comment '搜索来源',
    seo_keywords                 varchar(512) collate utf8_bin default '' null comment '关键字',
    ip                           varchar(48) collate utf8_bin  default '' null comment 'IP地址',
    area                         varchar(255) collate utf8_bin default '' null comment '地域',
    country                      varchar(16) collate utf8_bin  default '' null comment '所在国家',
    province                     varchar(16) collate utf8_bin  default '' null comment '省',
    city                         varchar(255) collate utf8_bin default '' null comment '城市',
    origin_channel               varchar(32) collate utf8_bin  default '' null comment '投放渠道',
    user                         varchar(255)                             null,
    manual_time                  datetime                                 null comment '人工开始时间',
    begin_time                   datetime                                 null comment '坐席领取时间 ',
    end_time                     datetime                                 null comment '会话结束时间',
    last_customer_msg_time_stamp datetime                                 null comment '客户最后一条消息的时间',
    last_agent_msg_time_stamp    datetime                                 null comment '坐席最后一下回复的时间',
    reply_msg_count              int(12)                       default 0  null comment '客服回复消息数',
    msg_count                    int(12)                       default 0  null comment '客户发送消息数',
    browser_name                 varchar(255) collate utf8_bin default '' null comment '浏览器名称',
    os_info                      varchar(255) collate utf8_bin default '' null comment '系统名称'
)
    comment '访问咨询表';

create table web_chat_text_ems_2019_07
(
    id                   int                   not null comment '主键'
        primary key,
    referrer             text collate utf8_bin null comment '上级来源页面',
    from_url             text collate utf8_bin null comment '会话来源页面',
    landing_page_url     text collate utf8_bin null comment '访客着陆页面',
    url_title            text collate utf8_bin null comment '咨询页面title',
    platform_description text collate utf8_bin null comment '客户平台信息',
    other_params         text collate utf8_bin null comment '扩展字段中数据',
    history              text collate utf8_bin null comment '历史访问记录'
);
