-- RPT

-- yearinfo 分区 使用create_date_time 用来筛选指定时间段
-- 需求一: 计期内，新增意向客户（包含自己录入的意向客户）总数。]

CREATE TABLE hive.zxedu_rpt.total_cc (
    customer_total BIGINT COMMENT'客户总数',
    clue_state_stat int COMMENT'新老客户 0新/1老',
    orgin_type_stat int comment'线上0/线下1',
    hourinfo STRING,
    dayinfo STRING,
    monthinfo STRING,

)
COMMENT '新意总客户'
PARTITIONED BY(yearinfo STRING)
ROW format delimited fields terminated BY '\t'
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');
 -------- 插入数据
insert  into hive.zxedu_rpt.total_cc
select
    customer_total ,
    clue_state_stat ,
    origin_type_stat orgin_type_stat ,
    hourinfo ,
     dayinfo ,
    monthinfo ,
    yearinfo
from zxedu_dm.icu_dm
where grouptype = 'all' and time_type='hour' ;
select * from hive.zxedu_rpt.total_cc;
-- 需求二: 统计指定时间段内，新增的意向客户，所在城市区域人数热力图。
CREATE TABLE zxedu_rpt.area_cc (
    customer_total BIGINT COMMENT'客户总数',
    clue_state_stat int COMMENT'新老客户 0新/1老',
    orgin_type_stat int comment'线上0/线下1',
    area string,
    hourinfo STRING,
    dayinfo STRING,
    monthinfo STRING

)
COMMENT '新意城总客户'
-- 统计日期,不能用来分组统计
PARTITIONED BY(yearinfo STRING)
ROW format delimited fields terminated BY '\t'
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');

--插入
insert into zxedu_rpt.area_cc
select
    customer_total ,
    clue_state_stat,
    origin_type_stat,
    area,
    hourinfo,
    dayinfo,
    monthinfo,

    yearinfo
from zxedu_dm.icu_dm
where grouptype = 'area' and area is not null ;

-- 需求三: 统计指定时间段内，新增的意向客户中，意向学科人数排行榜。学科名称要关联查询出来

CREATE TABLE zxedu_rpt.subject_cc (
    customer_total BIGINT COMMENT'客户总数',
    clue_state_stat int COMMENT'新老客户 0新/1老',
    orgin_type_stat int comment'线上0/线下1',
    subject_id int ,
    subject_name string,
    hourinfo STRING,
    dayinfo STRING,
    monthinfo STRING

)
COMMENT '新意学总客户'
-- 统计日期,不能用来分组统计
PARTITIONED BY(yearinfo STRING)
ROW format delimited fields terminated BY '\t'
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');

insert into zxedu_rpt.subject_cc
select
    customer_total ,
    clue_state_stat,
    origin_type_stat,
    itcast_subject_id ,
    itcast_subject_name ,
    hourinfo,
    dayinfo,
    monthinfo,

    yearinfo 
from zxedu_dm.icu_dm
where grouptype = 'subject' and itcast_subject_id is not null ;
--需求四: 统计指定时间段内，新增的意向客户中，意向校区人数排行榜。

CREATE TABLE zxedu_rpt.school_cc (
    customer_total BIGINT COMMENT'客户总数',
    clue_state_stat int COMMENT'新老客户 0新/1老',
    orgin_type_stat int comment'线上0/线下1',
    school_id int ,
    school_name string,
    hourinfo STRING,
    dayinfo STRING,
    monthinfo STRING
)
COMMENT '新意校总客户'
-- 统计日期,不能用来分组统计
PARTITIONED BY(yearinfo STRING)
ROW format delimited fields terminated BY '\t'
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');

insert into zxedu_rpt.school_cc
select
    customer_total ,
    clue_state_stat,
    origin_type_stat,
    itcast_school_id  ,
    itcast_school_name ,
    hourinfo,
    dayinfo,
    monthinfo,

    yearinfo 
from zxedu_dm.icu_dm
where grouptype = 'school' and itcast_school_id is not null;
--需求五: 统计指定时间段内，新增的意向客户中，不同来源渠道的意向客户占比。
CREATE TABLE zxedu_rpt.orgin_cc (
    customer_total BIGINT COMMENT'客户总数',
    clue_state_stat int COMMENT'新老客户 0新/1老',
    orgin_type_stat int comment'线上0/线下1',
    orgin_type string comment '渠道类型',
    hourinfo STRING,
    dayinfo STRING,
    monthinfo STRING

)
COMMENT '新意渠总客户'
-- 统计日期,不能用来分组统计
PARTITIONED BY(yearinfo STRING)
ROW format delimited fields terminated BY '\t'
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');

insert into zxedu_rpt.orgin_cc
select
    customer_total ,
    clue_state_stat,
    origin_type_stat,
    origin_type,
    hourinfo,
    dayinfo,
    monthinfo,

    yearinfo 
from zxedu_dm.icu_dm
where grouptype = 'origin' and origin_type is not null;

-- 需求六: 统计指定时间段内，新增的意向客户中，各咨询中心产生的意向客户数占比情况。
CREATE TABLE zxedu_rpt.tdepart_cc (
    customer_total BIGINT COMMENT'客户总数',
    clue_state_stat int COMMENT'新老客户 0新/1老',
    orgin_type_stat int comment'线上0/线下1',
    tdepart_id int comment'咨询中心',
    tepart_name string ,
    hourinfo STRING,
    dayinfo STRING,
    monthinfo STRING

)
COMMENT '新意询总客户'
-- 统计日期,不能用来分组统计
PARTITIONED BY(yearinfo STRING)
ROW format delimited fields terminated BY '\t'
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');

insert into zxedu_rpt.tdepart_cc
select
    customer_total ,
    clue_state_stat,
    origin_type_stat,
    tdepart_id ,
    tdepart_name ,
    hourinfo,
    dayinfo,
    monthinfo,
    yearinfo

from zxedu_dm.icu_dm
where grouptype = 'tdepart'and tdepart_id is not null;

--需求七: 统计期内，访客咨询产生的有效线索的占比。有效线索量 / 咨询量，有效线索指的是拿到电话且电话有效。
CREATE TABLE zxedu_rpt.clue_cc (
    cule_nums bigint comment'有效线索量',
    ems_nums bigint comment'访问量',
    hourinfo STRING,
    dayinfo STRING,
    monthinfo STRING

)
COMMENT '新意总客户'
-- 统计日期,不能用来分组统计
PARTITIONED BY(yearinfo STRING)
ROW format delimited fields terminated BY '\t'
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');



insert into zxedu_rpt.clue_cc
select
    clue_nums ,
    73560 ems_nums,
    hourinfo,
    dayinfo ,
    monthinfo ,
    yearinfo

from zxedu_dm.icu_dm zz
where grouptype = 'all' and  time_type='hour' ;

-- 需求八: 统计期内，1-24h之间，每个时间段的有效线索转化率。横轴：1-24h，间隔为1h，纵轴：每个时间段的有效线索转化率。


--需求九:统计期内，新增的咨询客户中，有效线索的数量。
