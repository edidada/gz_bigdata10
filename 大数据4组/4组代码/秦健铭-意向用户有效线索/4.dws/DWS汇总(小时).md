### DWS建表（小时）

```sql
-- 写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;

-- 建库
create database if not exists itcast_dws;
-- 建表
DROP TABLE if EXISTS itcast_dws.dws_customer_count;
CREATE TABLE itcast_dws.dws_customer_count
(
    -- 时间类型
	time_type string comment '时间类型：year_type,month_type,day_type,hour_type',
	-- 维度
    year_code string,
    month_code string,
    day_code string,
    hour_code string,
    clue_type string comment '线索来源：新客户new_cus,老客户regular_cus',
    origin_type string comment '数据来源细分',
    is_online string comment '数据来源汇总：online,offline',
	cus_area string comment '客户所在区域',
    subject_id string comment '学科id',
    subject_name string comment '学科name',
    school_id string comment '学校id',
    school_name string  comment '学校name',
    dept_id string comment '意向贡献中心id',
    dept_name string comment '意向贡献中心name',
	appeal_status string comment '上诉状态',
	-- 指标
    cus_count string comment '意向客户id',
    valid_clue_count string commment '有效线索量'
)
PARTITIONED BY(dt string)
row format delimited fields terminated by '\t'
stored as orc 
TBLPROPERTIES('orc.compress'='SNAPPY');
```

#### DWS建表v2

```sql
-- 写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;

-- 建库
create database if not exists itcast_dws;
-- 建表
DROP TABLE if EXISTS itcast_dws.dws_customer_count;
CREATE TABLE itcast_dws.dws_customer_count
(
    -- 时间类型
	time_type string comment '时间类型：year_type,month_type,day_type,hour_type',
   	-- 主题类型
    group_type string comment '主题类型：total,area,subject,school,origin,department',
    -- 具体时间
    time_code string,
	-- 维度
    clue_type string comment '线索来源：新客户new_cus,老客户regular_cus',
    origin_type string comment '数据来源细分',
    is_online string comment '数据来源汇总：online,offline',
	cus_area string comment '客户所在区域',
    subject_id int comment '学科id',
    subject_name string comment '学科name',
    school_id int comment '学校id',
    school_name string  comment '学校name',
    dept_id int comment '意向贡献中心id',
    dept_name string comment '意向贡献中心name',
    year_code string,
    month_code string,
    day_code string,
    hour_code string,
	-- 指标
    cus_count bigint comment '意向客户id',
    valid_clue_count bigint comment '有效线索量'
)
PARTITIONED BY(dt string)
row format delimited fields terminated by '\t'
stored as orc 
TBLPROPERTIES('orc.compress'='SNAPPY');
```









### DWS插入语句（小时）

```sql
-- clue_type 新老客户
-- origin_type 线上线下详细
-- is_online 线上线下

select
    'hour_type' as time_type
    -- 维度
    customer_relationship_year_code,
    customer_relationship_month_code,
    customer_relationship_day_code,
    customer_relationship_hour_code,
    customer_clue_clue_type,
    customer_relationship_is_online,
    customer_relationship_origin_type,
    customer_area,
    itcast_subject_id,
    itcast_subject_name,
    itcast_school_id,
    itcast_school_name,
    scrm_department_id,
    scrm_department_name,
    -- 意向客户量指标
    count(distinct customer_relationship_id)as cus_count,
    -- 有效线索量
    count(distinct if(customer_appeal_appeal_status is null),customer_relationship_id,null),
    -- 分区字段
    '2022-08-14' as dt
from hive.itcast_dwb.dwb_customer_detail
group by
grouping sets
(
    -- 2.1 总意向量
    (customer_relationship_hour_code,customer_relationship_day_code,customer_relationship_month_code,customer_relationship_year_code,
    customer_clue_clue_type,customer_relationship_is_online),

    -- 2.2 意向学员位置热力图
    (customer_relationship_hour_code,customer_relationship_day_code,customer_relationship_month_code,customer_relationship_year_code,
    customer_clue_clue_type,customer_relationship_is_online,customer_area),

    -- 2.3 意向学科排名
    (customer_relationship_hour_code,customer_relationship_day_code,customer_relationship_month_code,customer_relationship_year_code,
    customer_clue_clue_type,customer_relationship_is_online,itcast_subject_id,itcast_subject_name),

    -- 2.4 意向学校排名
    (customer_relationship_hour_code,customer_relationship_day_code,customer_relationship_month_code,customer_relationship_year_code,
    customer_clue_clue_type,customer_relationship_is_online,itcast_school_id,itcast_school_name),

    -- 2.5 来源渠道占比
    (customer_relationship_hour_code,customer_relationship_day_code,customer_relationship_month_code,customer_relationship_year_code,
    customer_clue_clue_type,customer_relationship_is_online,customer_relationship_origin_type),

    -- 2.6 意向贡献中心占比
    (customer_relationship_hour_code,customer_relationship_day_code,customer_relationship_month_code,customer_relationship_year_code,
    customer_clue_clue_type,customer_relationship_is_online,scrm_department_id,scrm_department_name)
);
```



#### DWS插入v2

```sql
-- clue_type 新老客户
-- origin_type 线上线下详细
-- is_online 线上线下

select
	-- 时间类型
    'hour_type' as time_type,
	-- 主题类型
	case
		when grouping(customer_area)=0
		then 'area'
		when grouping(itcast_subject_id)=0
		then 'subject'
		when grouping(itcast_school_id)=0
		then 'school'
		when grouping(customer_relationship_origin_type)=0
		then 'origin'
		when grouping(scrm_department_id)=0
		then 'department'
		when grouping(customer_relationship_is_online)=0
		then 'total'
	end as group_type,
    -- 具体时间
    case
    	when grouping(customer_relationship_hour_code)=0
    	then concat(customer_relationship_year_code,'-',customer_relationship_month_code,'-',customer_relationship_day_code,'-',customer_relationship_hour_code)
    end as time_code,
    -- 维度
    customer_clue_clue_type,
    customer_relationship_is_online,
    customer_relationship_origin_type,
    customer_area,
    itcast_subject_id,
    itcast_subject_name,
    itcast_school_id,
    itcast_school_name,
    scrm_department_id,
    scrm_department_name,
    customer_relationship_year_code,
    customer_relationship_month_code,
    customer_relationship_day_code,
    customer_relationship_hour_code,
    
    
    
    -- 意向客户量指标
    count(distinct customer_relationship_id)as cus_count,
    
    
    -- 有效线索量
    count(distinct if(customer_appeal_appeal_status is null),customer_relationship_id,null),
    
    
    
    -- 分区字段
    '2022-08-14' as dt
from hive.itcast_dwb.dwb_customer_detail
group by
grouping sets
(
    -- 2.1 总意向量
    (customer_relationship_hour_code,customer_relationship_day_code,customer_relationship_month_code,customer_relationship_year_code,
    customer_clue_clue_type,customer_relationship_is_online),

    -- 2.2 意向学员位置热力图
    (customer_relationship_hour_code,customer_relationship_day_code,customer_relationship_month_code,customer_relationship_year_code,
    customer_clue_clue_type,customer_relationship_is_online,customer_area),

    -- 2.3 意向学科排名
    (customer_relationship_hour_code,customer_relationship_day_code,customer_relationship_month_code,customer_relationship_year_code,
    customer_clue_clue_type,customer_relationship_is_online,itcast_subject_id,itcast_subject_name),

    -- 2.4 意向学校排名
    (customer_relationship_hour_code,customer_relationship_day_code,customer_relationship_month_code,customer_relationship_year_code,
    customer_clue_clue_type,customer_relationship_is_online,itcast_school_id,itcast_school_name),

    -- 2.5 来源渠道占比
    (customer_relationship_hour_code,customer_relationship_day_code,customer_relationship_month_code,customer_relationship_year_code,
    customer_clue_clue_type,customer_relationship_is_online,customer_relationship_origin_type),

    -- 2.6 意向贡献中心占比
    (customer_relationship_hour_code,customer_relationship_day_code,customer_relationship_month_code,customer_relationship_year_code,
    customer_clue_clue_type,customer_relationship_is_online,scrm_department_id,scrm_department_name)
);
```





#### DWS插入v3

```sql
-- clue_type 新老客户
-- origin_type 线上线下详细
-- is_online 线上线下
insert into hive.itcast_dws.dws_customer_count
select
	-- 时间类型
    'hour_type' as time_type,
	-- 主题类型
	case
		when grouping(customer_area)=0
		then 'area'
		when grouping(itcast_subject_id)=0
		then 'subject'
		when grouping(itcast_school_id)=0
		then 'school'
		when grouping(customer_relationship_origin_type)=0
		then 'origin'
		when grouping(scrm_department_id)=0
		then 'department'
		when grouping(customer_relationship_is_online)=0
		then 'total'
	end as group_type,
    -- 具体时间
    case
    	when grouping(customer_relationship_hour_code)=0
    	then concat(customer_relationship_year_code,'-',customer_relationship_month_code,'-',customer_relationship_day_code,' ',customer_relationship_hour_code)
    end as time_code,
    -- 维度
    customer_clue_clue_type,
    customer_relationship_origin_type,
    customer_relationship_is_online,    
    customer_area,
    itcast_subject_id,
    itcast_subject_name,
    itcast_school_id,
    itcast_school_name,
    scrm_department_id,
    scrm_department_name,
    customer_relationship_year_code,
    customer_relationship_month_code,
    customer_relationship_day_code,
    customer_relationship_hour_code,
    -- 意向客户量指标
    count(distinct customer_relationship_id) as cus_count,
    -- 有效线索量
    count(distinct if(customer_appeal_appeal_status is null,customer_relationship_id,null)) as valid_clue_count,
    -- 分区字段
    '2022-08-14' as dt
    
from hive.itcast_dwb.dwb_customer_detail
where customer_clue_clue_type in ('new_cus','regular_cus')
group by
grouping sets
(
    -- 2.1 总意向量
    (customer_relationship_hour_code,customer_relationship_day_code,customer_relationship_month_code,customer_relationship_year_code,
    customer_clue_clue_type,customer_relationship_is_online),

    -- 2.2 意向学员位置热力图
    (customer_relationship_hour_code,customer_relationship_day_code,customer_relationship_month_code,customer_relationship_year_code,
    customer_clue_clue_type,customer_relationship_is_online,customer_area),

    -- 2.3 意向学科排名
    (customer_relationship_hour_code,customer_relationship_day_code,customer_relationship_month_code,customer_relationship_year_code,
    customer_clue_clue_type,customer_relationship_is_online,itcast_subject_id,itcast_subject_name),

    -- 2.4 意向学校排名
    (customer_relationship_hour_code,customer_relationship_day_code,customer_relationship_month_code,customer_relationship_year_code,
    customer_clue_clue_type,customer_relationship_is_online,itcast_school_id,itcast_school_name),

    -- 2.5 来源渠道占比
    (customer_relationship_hour_code,customer_relationship_day_code,customer_relationship_month_code,customer_relationship_year_code,
    customer_clue_clue_type,customer_relationship_is_online,customer_relationship_origin_type),

    -- 2.6 意向贡献中心占比
    (customer_relationship_hour_code,customer_relationship_day_code,customer_relationship_month_code,customer_relationship_year_code,
    customer_clue_clue_type,customer_relationship_is_online,scrm_department_id,scrm_department_name)
);
```













