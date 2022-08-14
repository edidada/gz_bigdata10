
-------------------
--mysql建表
-------------------------

-- 小时汇总客户量
drop table mysql.anay.hourinfo_cc;--不能在presto中操作
create table mysql.anay.total_cc1(
    customer_total BIGINT COMMENT'客户总数',
    clue_state_stat int COMMENT'新老客户 0新/1老',
    orgin_type_stat int comment'线上0/线下1',
    hourinfo varchar,
    dayinfo varchar,
    monthinfo varchar,
    yearinfo varchar,
    dt varchar
);

insert into mysql.anay.total_cc1
select  * from hive.zxedu_rpt.total_cc;

-- 需求二: 统计指定时间段内，新增的意向客户，所在城市区域人数热力图。
-- 地区热力图
CREATE TABLE mysql.anay.area_ccc (
    customer_total BIGINT COMMENT'客户总数',
    clue_state_stat int COMMENT'新老客户 0新/1老',
    orgin_type_stat int comment'线上0/线下1',
    area varchar ,
    hourinfo varchar,
    dayinfo varchar,
    monthinfo varchar,
    yearinfo varchar

);
--mysql插入
insert into mysql.anay.area_ccc
select * from zxedu_rpt.area_cc;

-- 需求三: 统计指定时间段内，新增的意向客户中，意向学科人数排行榜。学科名称要关联查询出来

CREATE TABLE mysql.anay.subject_cc (
    customer_total BIGINT COMMENT'客户总数',
    clue_state_stat int COMMENT'新老客户 0新/1老',
    orgin_type_stat int comment'线上0/线下1',
    subject_id int ,
    subject_name varchar,
    hourinfo varchar,
    dayinfo varchar,
    monthinfo varchar,
    yearinfo varchar

)
COMMENT '新意学总客户';
-- 统计日期,不能用来分组统计
insert into mysql.anay.subject_cc
select * from zxedu_rpt.subject_cc ;

--需求四: 统计指定时间段内，新增的意向客户中，意向校区人数排行榜。

CREATE TABLE mysql.anay.school_cc (
    customer_total BIGINT COMMENT'客户总数',
    clue_state_stat int COMMENT'新老客户 0新/1老',
    orgin_type_stat int comment'线上0/线下1',
    school_id int ,
    school_name varchar,
    hourinfo varchar,
    dayinfo varchar,
    monthinfo varchar,
    yearinfo varchar
)
COMMENT '新意校总客户';
insert into mysql.anay.school_cc
select * from zxedu_rpt.school_cc;
--需求五: 统计指定时间段内，新增的意向客户中，不同来源渠道的意向客户占比。
CREATE TABLE mysql.anay.orgin_cc (
    customer_total BIGINT COMMENT'客户总数',
    clue_state_stat int COMMENT'新老客户 0新/1老',
    orgin_type_stat int comment'线上0/线下1',
    orgin_type varchar comment '渠道类型',
    hourinfo varchar,
    dayinfo varchar,
    monthinfo varchar,
    yearinfo varchar
)
COMMENT '新意渠总客户';
insert into mysql.anay.orgin_cc
select * from zxedu_rpt.orgin_cc;



-- 需求六: 统计指定时间段内，新增的意向客户中，各咨询中心产生的意向客户数占比情况。
CREATE TABLE mysql.anay.tdepart_cc (
    customer_total BIGINT COMMENT'客户总数',
    clue_state_stat int COMMENT'新老客户 0新/1老',
    orgin_type_stat int comment'线上0/线下1',
    tdepart_id int comment'咨询中心',
    tepart_name varchar ,
    hourinfo varchar,
    dayinfo varchar,
    monthinfo varchar,
    yearinfo varchar
)
COMMENT '新意询总客户';

insert into mysql.anay.tdepart_cc
select * from zxedu_rpt.tdepart_cc;


--需求七: 统计期内，访客咨询产生的有效线索的占比。有效线索量 / 咨询量，有效线索指的是拿到电话且电话有效。
CREATE TABLE mysql.anay.clue_cc (
    cule_nums bigint comment'有效线索量',
    ems_nums bigint comment'访问量',
    hourinfo varchar,
    dayinfo varchar,
    monthinfo varchar,
    yearinfo varchar
)COMMENT '新意总客户';

insert into mysql.anay.clue_cc
select * from zxedu_rpt.clue_cc;


-- 需求八: 统计期内，1-24h之间，每个时间段的有效线索转化率。横轴：1-24h，间隔为1h，纵轴：每个时间段的有效线索转化率。


--需求九:统计期内，新增的咨询客户中，有效线索的数量。



