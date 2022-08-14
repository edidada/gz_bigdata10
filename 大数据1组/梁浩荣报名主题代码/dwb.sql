DROP TABLE IF EXISTS itcast_dwb.`customer_dwb`;
CREATE TABLE itcast_dwb.customer_dwb
(
-- `customer_relationship` as crship
    `id` int COMMENT '客户关系id',
    `customer_id` int COMMENT '所属客户id',
    `payment_state` string COMMENT '支付状态',
    `payment_time` string COMMENT '支付状态变动时间',

-- `itcast_clazz` as cls
    `clazz_id` int COMMENT 'ems课程id(非自增)',
    `school_id` string COMMENT '校区ID',
    `school_name` string COMMENT '校区名',
    `subject_id` string COMMENT '学科ID',
    `subject_name` string COMMENT '学科名 '
)
comment '报名用户主题明细宽表' partitioned by (dt string)
row format delimited fields terminated by '\t'
stored as orc
tblproperties ('orc.compress' = 'SNAPPY');



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

-- 首次过程
-- INSERT INTO itcast_dwb.customer_dwb PARTITION (dt)
-- INSERT overwrite TABLE itcast_dwb.customer_dwb PARTITION (dt)

select
-- fact_customer_relationship_dwd
    crship.id,
    crship.customer_id,
    crship.payment_state,
    crship.payment_time,

-- dim_itcast_clazz_dwd
    cls.id as clazz_id,
    cls.itcast_school_id as school_id,
    cls.itcast_school_name as school_name,
    cls.itcast_subject_id as subject_id,
    cls.itcast_subject_name as subject_name,

-- 分区
	crship.start_day as dt
from	itcast_dwd.fact_customer_relationship_dwd 		crship
	left join	itcast_dwd.dim_itcast_clazz_dwd			cls
		on	crship.itcast_clazz_id=cls.id and crship.payment_state='PAID'