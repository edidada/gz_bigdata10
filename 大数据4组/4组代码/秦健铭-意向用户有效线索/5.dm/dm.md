### dm建表

dm建表和dws一样

```sql
-- 写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;

-- 建库
create database if not exists itcast_dm;
-- 建表
DROP TABLE if EXISTS itcast_dm.dm_customer_count;
CREATE TABLE itcast_dm.dm_customer_count
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







### dm插入语句

dm和dws的区别在于时间维度的选择

```sql
insert into hive.itcast_dm.dm_customer_count
select
    -- 时间类型
    case
        when grouping(hour_code)=0
        then 'hour_type'
        when grouping(day_code)=0
        then 'day_type'
        when grouping(month_code)=0
        then 'month_type'
        when grouping(year_code)=0
        then 'year_type'
    end as time_type,
    -- 主题类型
    case
		when grouping(cus_area)=0
		    then 'area'
		when grouping(subject_id)=0
		    then 'subject'
		when grouping(school_id)=0
		    then 'school'
		when grouping(origin_type)=0
		    then 'origin'
		when grouping(dept_id)=0
		    then 'department'
		when grouping(is_online)=0
		    then 'total_and_avlidclue'
	end as group_type,
	-- 具体时间
    case
        when grouping(hour_code)=0
        then concat(year_code,'-',month_code,'-',day_code,' ',hour_code)
        when grouping(day_code)=0
        then concat(year_code,'-',month_code,'-',day_code)
        when grouping(month_code)=0
        then concat(year_code,'-',month_code)
        when grouping(year_code)=0
        then year_code
    end as time_code,
    -- 维度
    clue_type,
    origin_type,
    is_online,
    cus_area,
    subject_id,
    subject_name,
    school_id,
    school_name,
    dept_id,
    dept_name,
    year_code,
    month_code,
    day_code,
    hour_code,
    -- 意向客户量指标
    sum(coalesce(cus_count,0)) as cus_count,
    -- 有效线索量
    sum(coalesce(valid_clue_count,0)) as valid_clue_count,
    -- 分区字段
    '2022-08-14' as dt

from hive.itcast_dws.dws_customer_count
group by
grouping sets
(
    -- 2.1 总意向量
    (hour_code,day_code,month_code,year_code,clue_type,is_online),
    (day_code,month_code,year_code,clue_type,is_online),
    (month_code,year_code,clue_type,is_online),
    (year_code,clue_type,is_online),

    -- 2.2 意向学员位置热力图
    (hour_code,day_code,month_code,year_code,clue_type,is_online,cus_area),
    (day_code,month_code,year_code,clue_type,is_online,cus_area),
    (month_code,year_code,clue_type,is_online,cus_area),
    (year_code,clue_type,is_online,cus_area),

    -- 2.3 意向学科排名
    (hour_code,day_code,month_code,year_code,clue_type,is_online,subject_id,subject_name),
    (day_code,month_code,year_code,clue_type,is_online,subject_id,subject_name),
    (month_code,year_code,clue_type,is_online,subject_id,subject_name),
    (year_code,clue_type,is_online,subject_id,subject_name),

    -- 2.4 意向学校排名
    (hour_code,day_code,month_code,year_code,clue_type,is_online,school_id,school_name),
    (day_code,month_code,year_code,clue_type,is_online,school_id,school_name),
    (month_code,year_code,clue_type,is_online,school_id,school_name),
    (year_code,clue_type,is_online,school_id,school_name),

    -- 2.5 来源渠道占比
    (hour_code,day_code,month_code,year_code,clue_type,is_online,origin_type),
    (day_code,month_code,year_code,clue_type,is_online,origin_type),
    (month_code,year_code,clue_type,is_online,origin_type),
    (year_code,clue_type,is_online,origin_type),

    -- 2.6 意向贡献中心占比
    (hour_code,day_code,month_code,year_code,clue_type,is_online,dept_id,dept_name),
    (day_code,month_code,year_code,clue_type,is_online,dept_id,dept_name),
    (month_code,year_code,clue_type,is_online,dept_id,dept_name),
    (year_code,clue_type,is_online,dept_id,dept_name)
)
order by group_type,time_type;
```



### 插入v2

```sql
insert into hive.itcast_dm.dm_customer_count
with temp as
(
select
    -- 时间类型
    case
        when grouping(hour_code)=0
        then 'hour_type'
        when grouping(day_code)=0
        then 'day_type'
        when grouping(month_code)=0
        then 'month_type'
        when grouping(year_code)=0
        then 'year_type'
    end as time_type,
    -- 主题类型
    case
		when grouping(cus_area)=0
		    then 'area'
		when grouping(subject_id)=0
		    then 'subject'
		when grouping(school_id)=0
		    then 'school'
		when grouping(origin_type)=0
		    then 'origin'
		when grouping(dept_id)=0
		    then 'department'
		when grouping(is_online)=0
		    then 'total'
	end as group_type_dm,
	group_type,
	-- 具体时间
    case
        when grouping(hour_code)=0
        then concat(year_code,'-',month_code,'-',day_code,' ',hour_code)
        when grouping(day_code)=0
        then concat(year_code,'-',month_code,'-',day_code)
        when grouping(month_code)=0
        then concat(year_code,'-',month_code)
        when grouping(year_code)=0
        then year_code
    end as time_code,
    -- 维度
    clue_type,
    origin_type,
    is_online,
    cus_area,
    subject_id,
    subject_name,
    school_id,
    school_name,
    dept_id,
    dept_name,
    year_code,
    month_code,
    day_code,
    hour_code,
    -- 意向客户量指标
    sum(coalesce(cus_count,0)) as cus_count,
    -- 有效线索量
    sum(coalesce(valid_clue_count,0)) as valid_clue_count,
    -- 分区字段
    '2022-08-14' as dt

from hive.itcast_dws.dws_customer_count
group by
grouping sets
(
    -- 2.1 总意向量
    (group_type,hour_code,day_code,month_code,year_code,clue_type,is_online),
    (group_type,day_code,month_code,year_code,clue_type,is_online),
    (group_type,month_code,year_code,clue_type,is_online),
    (group_type,year_code,clue_type,is_online),

    -- 2.2 意向学员位置热力图
    (group_type,hour_code,day_code,month_code,year_code,clue_type,is_online,cus_area),
    (group_type,day_code,month_code,year_code,clue_type,is_online,cus_area),
    (group_type,month_code,year_code,clue_type,is_online,cus_area),
    (group_type,year_code,clue_type,is_online,cus_area),

    -- 2.3 意向学科排名
    (group_type,hour_code,day_code,month_code,year_code,clue_type,is_online,subject_id,subject_name),
    (group_type,day_code,month_code,year_code,clue_type,is_online,subject_id,subject_name),
    (group_type,month_code,year_code,clue_type,is_online,subject_id,subject_name),
    (group_type,year_code,clue_type,is_online,subject_id,subject_name),

    -- 2.4 意向学校排名
    (group_type,hour_code,day_code,month_code,year_code,clue_type,is_online,school_id,school_name),
    (group_type,day_code,month_code,year_code,clue_type,is_online,school_id,school_name),
    (group_type,month_code,year_code,clue_type,is_online,school_id,school_name),
    (group_type,year_code,clue_type,is_online,school_id,school_name),

    -- 2.5 来源渠道占比
    (group_type,hour_code,day_code,month_code,year_code,clue_type,is_online,origin_type),
    (group_type,day_code,month_code,year_code,clue_type,is_online,origin_type),
    (group_type,month_code,year_code,clue_type,is_online,origin_type),
    (group_type,year_code,clue_type,is_online,origin_type),

    -- 2.6 意向贡献中心占比
    (group_type,hour_code,day_code,month_code,year_code,clue_type,is_online,dept_id,dept_name),
    (group_type,day_code,month_code,year_code,clue_type,is_online,dept_id,dept_name),
    (group_type,month_code,year_code,clue_type,is_online,dept_id,dept_name),
    (group_type,year_code,clue_type,is_online,dept_id,dept_name)
)
)
select
    time_type,
    group_type_dm,
    time_code,
    clue_type,
    origin_type,
    is_online,
    cus_area,
    subject_id,
    subject_name,
    school_id,
    school_name,
    dept_id,
    dept_name,
    year_code,
    month_code,
    day_code,
    hour_code,
    cus_count,
    valid_clue_count,
    dt
from temp
where group_type_dm = group_type
order by group_type,time_type;
```

