create database if not exists edu_dm;
use edu_dm;
drop database edu_dm;

--开启动态分区方式
set hive.exec.dynamic.partition=true;
--设置动态分区用非严格模式
set hive.exec.dynamic.partition.mode=nonstrict;



-- 说明：统计期内，全部报名客户中，各校区报名人数分布。
-- 展现：柱状图
-- 条件：年、月，校区
-- 维度：天区间，按查询条件来定
-- 指标：报名人数
-- 粒度：天/线上线下/校区
-- 数据来源：客户管理系统的customer_relationship、itcast_clazz报名课程表
--3.1
--校区报名
drop table edu_dm.vale_box_prient;
create table if not exists edu_dm.school_signup(
    signup_dm    int comment '报名人数',
    school_area       string comment '校区',
    origin_type  string comment '来源渠道：1.线上  2.线下',
    time_type    string comment '1.年  2.月  3.日'
)comment '校区报名数'
partitioned by (yearinfo string, monthinfo string, dayinfo string)
row format delimited fields terminated by '\t'
stored as orc tblproperties ('orc.compress' = 'SNAPPY');




-- 校区报名
insert overwrite table edu_dm.school_signup partition (yearinfo,monthinfo,dayinfo)
select
       count(1) as signup_dm,
       sc_name as  school_area,
         if(origin_type in ('NETSERVICE', 'PRESIGNUP'), '线上', '线下') as origin_type1 ,
        '每月' as time_type,
      substr(create_date_time, 1, 4)                         as yearinfo,
       substr(create_date_time, 6, 2)                         as monthinfo,
       '-1' as dayinfo



from edu_dwb.target_user
group by substr(create_date_time,1,4), substr(create_date_time, 6, 2) ,if(origin_type in ('NETSERVICE', 'PRESIGNUP'), '线上', '线下'),sc_name ;


--3.6-------------------------------------------------------
create table if not exists vale_box_prient
(
    id          int,

    group_type  int,
    time_type   int,

    origin_type string comment '线上或线下',
    clue_state  string comment '新老客户'


) partitioned by (yearinfo string,monthinfo string,dayinfo string)
    row format delimited
        fields terminated by '\t'
    stored as orc tblproperties ( 'orc.compress' = 'SNAPPY' );

-- 说明：线上报名量 / 线上有效线索量，与上一个指标类似，此处的线索量需要排除已申诉数据。
-- 展现：线状图。双轴：线上报名人数、线上报名转化率。
-- 条件：年、月
-- 维度：天/线上线下
-- 指标：线上报名转化率=线上报名人数/线上有效线索量
-- 粒度：天
-- 数据来源：客户管理系统的customer_relationship表、customer_clue表、customer_appeal表
--3.6
with t5 as
(
--     insert overwrite table edu_dm.test_temp2
--     partition (yearinfo, monthinfo, dayinfo)
select count( id)                                              as id_total,

        '2'                                                       as group_type,
       '每月'                                                      as time_type,
        if(origin_type in ('NETSERVICE', 'PRESIGNUP'), '线上', '线下') as origin_type ,
       '-1'                                                      as clue_state,
       substr(t1.create_date_time, 1, 4)                         as yearinfo,
       substr(t1.create_date_time, 6, 2)                         as monthinfo,
       '-1'                                                      as dayinfo

from edu_dwb.target_user as t1
--          left join edu_dwd.fact_customer_clue t2 on t2.customer_relationship_id = t1.id

group by substr(t1.create_date_time, 1, 4), substr(t1.create_date_time, 6, 2), t1.origin_type
)
insert into table vale_box_prient partition (yearinfo,monthinfo,dayinfo)
select * from t5 where origin_type in('线上');


-- 说明：统计期内，每天报名人数的趋势图。
-- 展现：线状图。
-- 条件：年、月
-- 维度：天/线上线下
-- 指标：报名人数
-- 粒度：天
-- 数据来源：客户管理系统的customer_relationship表










--3.2------------------------------------------------------------------------
-- 学科报名
drop database if exists edu_dm cascade;
create database if not exists edu_dm;
create table if not exists edu_dm.sub_signup_dm(
    signup_dm           int      comment '报名人数',
    subject             string   comment '学科',
    origin_channel      string   comment '来源渠道：1.线上  2.线下',

    time_type           string   comment '1.年  2.月  3.日'

)comment '学科报名表'
partitioned by (yearinfo string,monthinfo string,dayinfo string)
row format delimited fields terminated by '\t'
stored as orc tblproperties ('orc.compress' = 'SNAPPY');

-- 学科报名(统计每年的学科报名人数)
insert overwrite table edu_dm.sub_signup_dm partition (yearinfo,monthinfo,dayinfo)
select
        count(1) as signup_dm,
        sub_name as subject,
        if(origin_type in ('NETSERVICE', 'PRESIGNUP'), '线上', '线下') as origin_type1,
       '每月' as time_type,
         substr(create_date_time, 1, 4)                         as yearinfo,
       substr(create_date_time, 6, 2)                         as monthinfo,
       '-1'                                                     as dayinfo

from edu_dwb.target_user
-- where payment_state = 'PAID'
group by  substr(create_date_time, 1, 4),substr(create_date_time, 6, 2) ,sub_name,if(origin_type in ('NETSERVICE', 'PRESIGNUP'), '线上', '线下');

-----------------------------------------------------------------------------------
-- 总报名量3.3
drop table edu_dm.signup_total;
create table if not exists edu_dm.signup_total(
    signup_dm       int comment '报名人数',
    origin_channel  string comment '来源渠道：1.线上  2.线下',

    time_type       string comment '1.年 2.月 3.日'
)comment '总报名量'
partitioned by (yearinfo string,monthinfo string,dayinfo string)
row format delimited fields terminated by '\t'
stored as orc tblproperties ('orc.compress' = 'SNAPPY');

insert overwrite table edu_dm.signup_total partition (yearinfo,monthinfo,dayinfo)
select
    count(1) as signup_dm,
    if(origin_type in ('NETSERVICE', 'PRESIGNUP'), '线上', '线下') as origin_type1,

       '每月' as time_type,
         substr(create_date_time, 1, 4)                         as yearinfo,
           substr(create_date_time, 6, 2)                    as monthinfo,
       '-1' as dayinfo


from edu_dwb.target_user
-- where payment_state = 'PAID'
group by substr(create_date_time, 1, 4),substr(create_date_time, 6, 2),if(origin_type in ('NETSERVICE', 'PRESIGNUP'), '线上', '线下')  ;
-------------------------------------------------------------------------------


-- 线上报名量 3.4
drop table edu_dm.signup_online;

create table if not exists edu_dm.signup_online(
    signup_dm   int comment '报名人数',
    origin_channel string comment '来源渠道:只统计线上',
    time_type   string comment '1.年 2.月 3.日'

)comment '线上报名量'
partitioned by (yearinfo string, monthinfo string,dayinfo string)
row format delimited fields terminated by '\t'
stored as orc tblproperties ('orc.compress' = 'SNAPPY');
-- 线上报名量
insert overwrite table edu_dm.signup_online partition (yearinfo,monthinfo,dayinfo)
select
        count(1) as signup_dm,
        if(origin_type in ('NETSERVICE', 'PRESIGNUP'), '线上', '线下') as origin_type1,
        '每月' as time_type,
        substr(create_date_time, 1, 4)               as yearinfo,
       substr(create_date_time, 6, 2)                                    as monthinfo,
       '-1'                                     as dayinfo


from edu_dwb.target_user
-- where payment_state = 'PAID'
where origin_type in('NETSERVICE','PRESIGNUP')
group by substr(create_date_time, 1, 4), substr(create_date_time, 6, 2)  ,origin_type;

----------------------------------------------

-- 意向用户报名转化率3.5
create table if not exists edu_dm.signup_transformation(
    signup_dm int comment '报名人数',
    intention_dm  int comment '新增意向人数',
    conversion_rate int comment '报名转换率',
    origin_channel string comment '来源渠道：1.线上 2.线下',
    time_type string comment '1.年  2.月  3.日'
)comment '意向用户报名转化率'
partitioned by (yearinfo string,monthinfo string,dayinfo string)
row format delimited fields terminated by '\t'
stored as orc tblproperties ('orc.compress' = 'SNAPPY');

-- 意向用户报名转化率
drop table edu_dm.signup_transformation;
alter table edu_dm.signup_transformation  drop partition (yearinfo !="",monthinfo !="",dayinfo !="");
insert overwrite table edu_dm.signup_transformation partition (yearinfo,monthinfo,dayinfo)
select
    count(1) as signup_dm,
    count(distinct clue_customer_id ) as intention_dm ,
    count(distinct clue_customer_id )/count(1)  as conversion_rate,
   if(origin_type in ('NETSERVICE', 'PRESIGNUP'), '线上', '线下') as origin_type1,

    '每月' as time_type ,
        substr(create_date_time, 1, 4)               as yearinfo,
       substr(create_date_time, 6, 2)                                    as monthinfo,
       '-1'                                     as dayinfo

from edu_dwb.target_user
-- where payment_state = 'PAID'
GROUP BY substr(create_date_time, 1, 4)  ,substr(create_date_time, 6, 2)    ,if(origin_type in ('NETSERVICE', 'PRESIGNUP'), '线上', '线下');
---------------------------------------------------------------

-- 咨询中心报名贡献
drop table ReferralCenter_Contribution;
create table if not exists edu_dm.ReferralCenter_Contribution(
    signup_dm               int comment '学员总人数',
    Referral_signup_dm      int comment '咨询中心报名人数',
    ReferralCenter          string comment '咨询中心',
    origin_channel          string comment '来源渠道',
    time_type               string comment '1.年 2.月 3.日'
)comment '咨询中心报名贡献表'
partitioned by (yearinfo string,monthinfo string,dayinfo string)
row format delimited fields terminated by '\t'
stored as orc tblproperties ('orc.compress' = 'SNAPPY');

-- 咨询中心报名贡献
insert overwrite table edu_dm.ReferralCenter_Contribution partition (yearinfo,monthinfo,dayinfo)
select
    count(1) as signup_dm,

    45918
        as Referral_signup_dm,

    employee_tdepart_id as ReferralCenter,

    if(origin_type in ('NETSERVICE', 'PRESIGNUP'), '线上', '线下') as origin_type,

    '1' as time_type,



    substr(create_date_time,1,4) as yearinfo,
          substr(create_date_time, 6, 2)  as monthinfo,
           '-1' as dayinfo



from edu_dwb.target_user
-- where payment_state = 'PAID'


GROUP BY substr(create_date_time,1,4), substr(create_date_time, 6, 2),employee_tdepart_id,if(origin_type in ('NETSERVICE', 'PRESIGNUP'), '线上', '线下');



--3.7
-- 日报名表（创建）
create table if not exists edu_dm.day_signup(
    signup_dm           int comment '报名人数',
    origin_channel      string comment '来源渠道',
    time_type           string comment '1.年  2.月  3.日'
)comment '日报名表'
partitioned by (yearinfo string,monthinfo string,dayinfo string)
row format delimited fields terminated by '\t'
stored as orc tblproperties ('orc.compress' = 'SNAPPY');


-- 日报名表（导入数据）
insert overwrite table edu_dm.day_signup partition (yearinfo,monthinfo,dayinfo)
select
        count(1) as signup_dm,
        if(origin_type IN ('NETSETVICE','PRESIGNUP'),'线上','线下' ) as origin_channel,
        '每月' as time_type,
        substr(create_date_time,1,4) as yearinfo,
          substr(create_date_time, 6, 2)  as monthinfo,
          substr(create_date_time, 9, 2) as dayinfo
from edu_dwb.target_user
group by substr(create_date_time,1,4),substr(create_date_time, 6, 2),substr(create_date_time, 9, 2),if(origin_type IN ('NETSETVICE','PRESIGNUP'),'线上','线下' ) limit 50;





--学区校区排行
--统计期内，全部报名学员中，校区学科排行榜，topN。A校区b学科第一，B校区a学科第二等等
--条件：年、月，校区，学科，数据量N
--维度：天/线上线下
--指标：报名学员人数
--粒度：各校区各学科的报名人数和
use edu_dm;
create table if not exists edu_dm.sub_top(
    signup_dm      int comment '报名人数',
    subject        string comment '学科',
    school_name    string comment '校区',
    origin_channel string comment '来源渠道：1.线上  2.线下',
    time_type      string comment '1.年  2.月  3.日'

)comment '学区校区排行表'
    partitioned by (yearinfo string,monthinfo string,dayinfo string)
    row format delimited fields terminated by '\t'
    stored as orc tblproperties ('orc.compress' = 'SNAPPY');

-- 学区校区排行表(统计期全部报名学员校区学科排行榜)3.8
alter table edu_dm.sub_top drop partition (yearinfo !="", monthinfo !="", dayinfo !="");
insert overwrite table edu_dm.sub_top partition (yearinfo, monthinfo, dayinfo)
select
       count(distinct id)                                               as signup_dm,
       sub_name                                              as subject,
       sc_name                                             as school_name,
       if(origin_type in ('NETSERVICE', 'PHONE'), '线上', '线下') as origin_channel,
      '3'                                                    as time_type,
       substr(create_date_time, 1, 4)                         as yearinfo,
       substr(create_date_time, 6, 2)                         as monthinfo,
       substr(create_date_time, 9, 2)                         as dayinfo
        --row_number() over (order by sc_name)             as top_school,
       --row_number() over (order by sub_name)             as top_subject
from edu_dwb.target_user
-- where payment_state = 'PAID'
group by substr(create_date_time, 1, 4) ,substr(create_date_time, 6, 2),substr(create_date_time, 9, 2),sub_name, sc_name, origin_type having subject is not null
order by signup_dm desc limit 500;

--3.9 来源渠道占比
--说明：统计期内，全部报名学员中，不同来源渠道的报名学员占比情况。
use edu_dm;
drop table edu_dm.org_type;
alter table edu_dm.org_type drop partition (yearinfo !="" ,monthinfo !="",dayinfo !="" );
create table if not exists edu_dm.org_type(
     signup_dm      int comment '总人数',
    origin_channel string comment '来源渠道：1.线上  2.线下',
    origin_type    string comment '渠道来源',
    time_type      string comment '1.年  2.月  3.日'

)comment '学区校区排行表'
    partitioned by (yearinfo string,monthinfo string,dayinfo string)
    row format delimited fields terminated by '\t'
    stored as orc tblproperties ('orc.compress' = 'SNAPPY');
--3.9-----------------------------------------------------------
create table if not exists edu_dm.org_type(
     signup_dm      int comment '总人数',
    origin_channel string comment '来源渠道：1.线上  2.线下',
    origin_type    string comment '渠道来源',
    time_type      string comment '1.年  2.月  3.日'

)comment '学区校区排行表'
    partitioned by (yearinfo string,monthinfo string,dayinfo string)
    row format delimited fields terminated by '\t'
    stored as orc tblproperties ('orc.compress' = 'SNAPPY');

--3.9 来源渠道占比
insert overwrite table edu_dm.org_type partition (yearinfo, monthinfo, dayinfo)
select
       count(distinct id)                                               as signup_dm,
        if(origin_type in ('NETSERVICE', 'PHONE'), '线上', '线下') as origin_channel,
       origin_type  as origin_type,
       '3'                                                    as time_type,
       substr(create_date_time, 1, 4)                         as yearinfo,
       substr(create_date_time, 6, 2)                         as monthinfo,
       substr(create_date_time, 9, 2)                         as dayinfo
        --row_number() over (order by sc_name)             as top_school,
       --row_number() over (order by sub_name)             as top_subject
from edu_dwb.target_user
-- where payment_state = 'PAID'
group by substr(create_date_time, 1, 4) ,substr(create_date_time, 6, 2),substr(create_date_time, 9, 2), origin_type
limit 100;