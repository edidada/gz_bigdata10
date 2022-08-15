--动态分区配置
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;

-- 统计每年各个地区的访问量
insert overwrite table edu_dm_access.edu_visit_dm partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select 
    count(distinct sid) as sid_total,
    count(distinct ip) as ip_total,
    count(distinct session_id) as sessionid_total,
    '-1' as hourinfo,
    area,
    '-1' as origin_channel,
    '-1' as  seo_source,
    '-1' as from_url,
    '1' as time_type,
    '2' as group_type,
    yearinfo,
    '-1' as  quarterinfo,
    '-1' as monthinfo,
    '-1' as dayinfo
from  edu_dwb_access.web_chat_ems_dwb 
group by yearinfo,area;


-- 统计每年每季度各个地区访问量
insert overwrite table edu_dm_access.edu_visit_dm partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select 
    count(distinct sid) as sid_total,
    count(distinct ip) as ip_total,
    count(distinct session_id) as sessionid_total,
    '-1' as hourinfo,
    area,
    '-1' as origin_channel,
    '-1' as  seo_source,
    '-1' as from_url,
    '2' as time_type,
    '2' as group_type,
    yearinfo,
    quarterinfo,
    '-1' as monthinfo,
    '-1' as dayinfo
from  edu_dwb_access.web_chat_ems_dwb 
group by yearinfo,quarterinfo,area;

-- 统计每年每季度每月各个地区访问量
insert overwrite table edu_dm_access.edu_visit_dm partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select 
    count(distinct sid) as sid_total,
    count(distinct ip) as ip_total,
    count(distinct session_id) as sessionid_total,
    '-1' as hourinfo,
    area,
    '-1' as origin_channel,
    '-1' as  seo_source,
    '-1' as from_url,
    '3' as time_type,
    '2' as group_type,
    yearinfo,
    quarterinfo,
    monthinfo,
    '-1' as dayinfo
from  edu_dwb_access.web_chat_ems_dwb 
group by yearinfo,quarterinfo,monthinfo,area;

-- 统计每年每季度每月每天各个地区访问量
insert overwrite table edu_dm_access.edu_visit_dm partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select 
    count(distinct sid) as sid_total,
    count(distinct ip) as ip_total,
    count(distinct session_id) as sessionid_total,
    '-1' as hourinfo,
    area,
    '-1' as origin_channel,
    '-1' as  seo_source,
    '-1' as from_url,
    '4' as time_type,
    '2' as group_type,
    yearinfo,
    quarterinfo,
    monthinfo,
    dayinfo
from  edu_dwb_access.web_chat_ems_dwb 
group by yearinfo,quarterinfo,monthinfo,dayinfo,area;



-- 统计每年每季度每月每天每小时各个地区访问量
insert overwrite table edu_dm_access.edu_visit_dm partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select 
    count(distinct sid) as sid_total,
    count(distinct ip) as ip_total,
    count(distinct session_id) as sessionid_total,
    hourinfo,
    area,
    '-1' as origin_channel,
    '-1' as  seo_source,
    '-1' as from_url,
    '5' as time_type,
    '2' as group_type,
    yearinfo,
    quarterinfo,
    monthinfo,
    dayinfo
from  edu_dwb_access.web_chat_ems_dwb 
group by yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo,area;