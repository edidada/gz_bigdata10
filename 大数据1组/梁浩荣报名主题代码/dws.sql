
-- 建表------------------------
-- ----------------------------
DROP TABLE IF EXISTS itcast_dws.`customer_dws`;
CREATE TABLE itcast_dws.customer_dws
(
    `year_code` string COMMENT '年',
    `month_code` string COMMENT '月',
    `date_code` string COMMENT '日期',

    `school_id` string COMMENT '校区ID',
    `school_name` string COMMENT '校区名称',
    `subject_id` string COMMENT '学科ID',
    `subject_name` string COMMENT '学科名称 ',
    `group_type` string COMMENT '维度类型：school，subject',
    -- =======日统计=======
    `total_customer` bigint COMMENT '报名人数'
)
comment '报名用户主题日统计表' partitioned by (dt string)
row format delimited fields terminated by '\t'
stored as orc
tblproperties ('orc.compress' = 'SNAPPY');




-- 插入------------------------
-- ----------------------------

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


-- -- 1 维度组合：日+学校 22条
-- -- INSERT INTO yp_dws.dws_sale_daycount partition (dt)
-- with school_base as(
--     select *,row_number() over(partition by customer_id) rn
--     from hive.itcast_dwb.customer_dwb
--     where payment_state='PAID' and school_id is not null
-- )
-- select
--     dt,
--     school_id,
--     school_name,
--     'school' as group_type,
--     count(customer_id) as total_customer_school
-- from school_base
-- where rn=1
-- group by dt,school_id,school_name
-- ;

--
--
-- 2 维度组合：日+学科 28条
-- INSERT INTO yp_dws.dws_sale_daycount partition (dt)
-- with subject_base as(
--     select *,row_number() over(partition by customer_id) rn
--     from hive.itcast_dwb.customer_dwb
--     where payment_state='PAID' and subject_id is not null
-- )
-- select
--     dt,
--     subject_id,
--     subject_name,
--     'subject' as group_type,
--     count(customer_id) as total_customer_subject
-- from subject_base
-- where rn=1
-- group by dt,subject_id,subject_name
-- ;


INSERT INTO hive.itcast_dws.customer_dws
WITH base AS(
    select
            dt,
            customer_id,
            school_id,
            school_name,
            subject_id,
            subject_name,
            row_number() over(partition by customer_id) rn_school,
            row_number() over(partition by customer_id) rn_subject
    from hive.itcast_dwb.customer_dwb
    where payment_state='PAID'
        and school_id is not null
        and subject_id is not null
)
select
    substring (dt,1,4) as year_code,
    substring (dt,1,7) as month_code,
    substring (dt,1,10) as date_code,

    school_id,
    school_name,
    subject_id,
    subject_name,
    case
        -- 判断分组时，先判断最小粒度的分组，再判断大的分组
        when grouping(school_id)=0
        then 'school'
        when grouping(subject_id)=0
        then 'subject'
    end
    as group_type,
    case
        when grouping(school_id)=0
        then count(DISTINCT if(rn_school=1, customer_id, null))
        when grouping(subject_id)=0
        then count(DISTINCT if(rn_subject=1, customer_id, null))
    end
    as total_customer,
    dt
from base
group by
grouping sets(
    (dt,school_id,school_name),
    (dt,subject_id,subject_name)
)
;