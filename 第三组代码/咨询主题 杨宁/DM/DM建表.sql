create database if not exists edu_dm_access;

-- 建表操作:
create table if not exists edu_dm_access.edu_visit_dm (
    sid_total            int comment '访客量',
    ip_total             int comment '访客量',
    session_total        int comment '访客量',
    hourinfo             string  comment '小时',
    area                 string comment '区域维度',
    origin_channel       string comment '来源渠道',
    seo_source           string  comment '搜索来源',
    from_url             string comment '会话来源页面',
    time_type            string comment ' 1 年 2季度 3月 4 天 5 小时',
    group_type           string comment '1总访问量 2 区域 3来源渠道 4 搜索来源 5 受访页面'
)
partitioned by(yearinfo string,quarterinfo string, monthinfo string, dayinfo string)
row format delimited fields terminated by '\t'
stored AS orc tblproperties ( 'orc.compress' = 'SNAPPY' );


create table if not exists edu_dm.edu_result_dm (
    sid_total            int comment '咨询量',
    ip_total             int comment '咨询量',
    session_total        int comment '咨询量',
    hourinfo             string  comment '小时',
    area                 string comment '区域维度',
    origin_channel       string comment '来源渠道',
    time_type            string comment ' 1 年 2季度 3月 4 天 5 小时',
    group_type           string comment '1总访问量 2 区域 3来源渠道 '
)
partitioned by(yearinfo string,quarterinfo string, monthinfo string, dayinfo string)
row format delimited fields terminated by '\t'
stored AS orc tblproperties ( 'orc.compress' = 'SNAPPY' );