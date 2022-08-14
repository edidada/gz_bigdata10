--动态分区配置
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;

-- 统计每年各个来源的访问量
insert into table edu_dm_access.edu_visit_dm partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select 
    count(distinct sid) as sid_total,
    count(distinct ip) as ip_total,
    count(distinct session_id) as sessionid_total,
    '-1' as hourinfo,
    '-1' as area,
    origin_channel,
    '-1' as  seo_source,
    '-1' as from_url,
    '1' as time_type,
    '3' as group_type,
    yearinfo,
    '-1' as  quarterinfo,
    '-1' as monthinfo,
    '-1' as dayinfo
from  edu_dwb_access.web_chat_ems_dwb  where yearinfo ='2022'
group by yearinfo,origin_channel;


-- 统计每年每季度各个来源访问量
insert into table edu_dm_access.edu_visit_dm partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select 
    count(distinct sid) as sid_total,
    count(distinct ip) as ip_total,
    count(distinct session_id) as sessionid_total,
    '-1' as hourinfo,
    '-1' as area,
    origin_channel,
    '-1' as  seo_source,
    '-1' as from_url,
    '2' as time_type,
    '3' as group_type,
    yearinfo,
    quarterinfo,
    '-1' as monthinfo,
    '-1' as dayinfo
from  edu_dwb_access.web_chat_ems_dwb where yearinfo='当年' and quarterinfo = '当季度'
group by yearinfo,quarterinfo,origin_channel;

-- 统计每年每季度每月各个来源访问量
insert into table edu_dm_access.edu_visit_dm partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select 
    count(distinct sid) as sid_total,
    count(distinct ip) as ip_total,
    count(distinct session_id) as sessionid_total,
    '-1' as hourinfo,
    '-1' as area,
    origin_channel,
    '-1' as  seo_source,
    '-1' as from_url,
    '3' as time_type,
    '3' as group_type,
    yearinfo,
    quarterinfo,
    monthinfo,
    '-1' as dayinfo
from  edu_dwb_access.web_chat_ems_dwb  where yearinfo='当年' and quarterinfo = '当季度' and monthinfo = '当月'
group by yearinfo,quarterinfo,monthinfo,origin_channel;

-- 统计每年每季度每月每天各个来源访问量
insert into table edu_dm_access.edu_visit_dm partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select 
    count(distinct sid) as sid_total,
    count(distinct ip) as ip_total,
    count(distinct session_id) as sessionid_total,
    '-1' as hourinfo,
    '-1' as area,
    origin_channel,
    '-1' as  seo_source,
    '-1' as from_url,
    '4' as time_type,
    '3' as group_type,
    yearinfo,
    quarterinfo,
    monthinfo,
    dayinfo
from  edu_dwb_access.web_chat_ems_dwb  where yearinfo='当年' and quarterinfo = '当季度' and monthinfo = '当月' and dayinfo='当天'
group by yearinfo,quarterinfo,monthinfo,dayinfo,origin_channel;



-- 统计每年每季度每月每天每小时各个来源访问量
insert into table edu_dm_access.edu_visit_dm partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select 
    count(distinct sid) as sid_total,
    count(distinct ip) as ip_total,
    count(distinct session_id) as sessionid_total,
    hourinfo,
    '-1' as area,
    origin_channel,
    '-1' as  seo_source,
    '-1' as from_url,
    '5' as time_type,
    '3' as group_type,
    yearinfo,
    quarterinfo,
    monthinfo,
    dayinfo
from  edu_dwb_access.web_chat_ems_dwb  where yearinfo='当年' and quarterinfo = '当季度' and monthinfo = '当月' and dayinfo='当天'
group by yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo,origin_channel;