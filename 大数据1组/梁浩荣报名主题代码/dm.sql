--  建库
create database IF NOT EXISTS itcast_dm;
--  建表
DROP TABLE IF EXISTS itcast_dm.customer_dm;
CREATE TABLE itcast_dm.customer_dm(
    time_type string COMMENT '统计时间维度：year、month、date',
    year_code string COMMENT '年',
    month_code string COMMENT '月',
    date_code string COMMENT '日期',

    `school_id` string COMMENT '校区ID',
    `school_name` string COMMENT '校区名称',
    `subject_id` string COMMENT '学科ID',
    `subject_name` string COMMENT '学科名称 ',
    `group_type` string COMMENT '维度类型：school，subject',
    -- =======统计=======
    `total_customer` bigint COMMENT '报名人数'
)
COMMENT '报名用户主题日月年统计表'
-- 统计日期,不能用来分组统计
PARTITIONED BY(dt_dm STRING)
ROW format delimited fields terminated BY '\t'
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');

-- 开启mapjoin
set hive.auto.convert.join=true;
-- 写入数据强制分桶
set hive.enforce.bucketing=true;
-- 写入数据强制排序
set hive.enforce.sorting=true;
-- 开启bucketmapjoin
set hive.optimize.bucketmapjoin = true;
-- 开启SMB Join
set hive.optimize.bucketmapjoin.sortedmerge=true;
set hive.auto.convert.sortmerge.join=true;
set hive.auto.convert.sortmerge.join.noconditionaltask=true;
-- 开启动态分区，严格模式strict：要求插入时至少有一个静态分区；动态分区，必须用非严格模式nonstrict。
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;



-- 1 按年：将天数据累加
-- insert into hive.itcast_dm.customer_dm
with groupby as
(
    select
        'year' time_type,
        year_code,
        null as month_code,
        null as date_code,

        school_id,
        school_name,
        subject_id,
        subject_name,
        case
            when grouping(school_id)=0
            then 'school'
            when grouping(subject_id)=0
            then 'subject'
        end
        as group_type_new,
        group_type as group_type_old,
        sum(total_customer) as sum_customer,
        '2022-08-08' as dt_dm
    from hive.itcast_dws.customer_dws
    group by
    grouping sets(
        (year_code,school_id,school_name,group_type),
        (year_code,subject_id,subject_name,group_type)
    )
)
select
        'year' time_type,
        year_code,
        null as month_code,
        null as date_code,

        school_id,
        school_name,
        subject_id,
        subject_name,
        group_type_new as group_type,
        sum_customer,
        dt_dm
from groupby
-- 只保留group_type相同的指标数据
-- 总结：重复分组时，两次的维度是不会自动匹配的，必须得告诉它
where group_type_new=group_type_old
;





-- 1 按月：将天数据累加
-- insert into hive.itcast_dm.customer_dm
with groupby_month as
(
    select
        'month'as time_type,
        null as year_code,
        month_code,
        null as date_code,

        school_id,
        school_name,
        subject_id,
        subject_name,
        case
            when grouping(school_id)=0
            then 'school'
            when grouping(subject_id)=0
            then 'subject'
        end
        as group_type_new,
        group_type as group_type_old,
        sum(total_customer) as sum_customer,
        '2022-08-08' as dt_dm
    from hive.itcast_dws.customer_dws
    group by
    grouping sets(
        (month_code,school_id,school_name,group_type),
        (month_code,subject_id,subject_name,group_type)
    )
)
select
        time_type,
        null as year_code,
        month_code,
        null as date_code,

        school_id,
        school_name,
        subject_id,
        subject_name,
        group_type_new as group_type,
        sum_customer,
        dt_dm
from groupby_month
-- 只保留group_type相同的指标数据
-- 总结：重复分组时，两次的维度是不会自动匹配的，必须得告诉它
where group_type_new=group_type_old
;



-- 1 按天：将天数据累加
-- insert into hive.itcast_dm.customer_dm
with groupby_date as
(
    select
        'date'as time_type,
        null as year_code,
        null as month_code,
        date_code,

        school_id,
        school_name,
        subject_id,
        subject_name,
        case
            when grouping(school_id)=0
            then 'school'
            when grouping(subject_id)=0
            then 'subject'
        end
        as group_type_new,
        group_type as group_type_old,
        sum(total_customer) as sum_customer,
        '2022-08-08' as dt_dm
    from hive.itcast_dws.customer_dws
    group by
    grouping sets(
        (date_code,school_id,school_name,group_type),
        (date_code,subject_id,subject_name,group_type)
    )
)
select
        time_type,
        null as year_code,
        null as month_code,
        date_code,

        school_id,
        school_name,
        subject_id,
        subject_name,
        group_type_new as group_type,
        sum_customer,
        dt_dm
from groupby_date
-- 只保留group_type相同的指标数据
-- 总结：重复分组时，两次的维度是不会自动匹配的，必须得告诉它
where group_type_new=group_type_old
;






-- 年月日累加

insert into hive.itcast_dm.customer_dm
with groupby as
(
    select
        case
            when grouping(date_code)=0
            then 'date'
            when grouping(month_code)=0
            then 'month'
            when grouping(year_code)=0
            then 'year'
        end
        as time_type,
        year_code,
        month_code,
        date_code,

        school_id,
        school_name,
        subject_id,
        subject_name,
        case
            when grouping(school_id)=0
            then 'school'
            when grouping(subject_id)=0
            then 'subject'
        end
        as group_type_new,
        group_type as group_type_old,
        case
            when grouping(school_id)=0
            then sum(total_customer)
            when grouping(subject_id)=0
            then sum(total_customer)
        end
        as sum_customer,
        '2022-08-08' as dt_dm
    from hive.itcast_dws.customer_dws
    group by
    grouping sets(
        (date_code,school_id,school_name,group_type),
        (date_code,subject_id,subject_name,group_type),
        (month_code,school_id,school_name,group_type),
        (month_code,subject_id,subject_name,group_type),
        (year_code,school_id,school_name,group_type),
        (year_code,subject_id,subject_name,group_type)
    )
)
select
        time_type,
        year_code,
        month_code,
        date_code,

        school_id,
        school_name,
        subject_id,
        subject_name,
        group_type_new as group_type,
        sum_customer,
        dt_dm
from groupby
-- 只保留group_type相同的指标数据
-- 总结：重复分组时，两次的维度是不会自动匹配的，必须得告诉它
where group_type_new=group_type_old
;