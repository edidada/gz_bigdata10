#### 2.0 规范

dws 按照小时计算

```sql
insert overwrite table itcast_dws.dws_customer_clue_count
with temp as 
(
	select
    	*
    row_number() over(partitioned by ) rn
    from itcast_dwb.dwb_customer_detail
)
select
	*
from temp
where rn=1;
```



#### 2.1 总意向量

**分析：**

维度：

​	时间 => 时-日-月-年

​	其他 => clue_state（线索来源:新老客户）、origin_type（数据类型：线上线下）

指标：

​	统计意向客户Id => customer_relationship.id

去重：

​	投诉表有重复id数据(一个Id投诉两次或以上)，需要对id去重distinct

```sql
with temp as
(
SELECT
    -- 时间维度
    substr(customer_relationship_create_date_time,1,4) as year_code,
    substr(customer_relationship_create_date_time,1,7) as month_code,
    substr(customer_relationship_create_date_time,1,10) as day_code,
    substr(customer_relationship_create_date_time,1,13) as hour_code,
    -- 线索来源维度（新老客户）
    customer_clue_clue_state,
    -- 数据来源维度（线上线下）
    customer_relationship_origin_type,
    customer_relationship_id
from hive.itcast_dwb.dwb_customer_detail
where customer_clue_clue_state is not null
)

SELECT
    -- 时间维度
    year_code,
    month_code,
    day_code,
    hour_code,
    -- 线索来源维度（新老客户）
    customer_clue_clue_state,
    -- 数据来源维度（线上线下）
    customer_relationship_origin_type,

    -- 指标
    count(DISTINCT customer_relationship_id) as count_customer

from temp
GROUP BY
grouping sets
(  (hour_code,day_code,month_code,year_code,customer_clue_clue_state,customer_relationship_origin_type),
    (day_code,month_code,year_code,customer_clue_clue_state,customer_relationship_origin_type),
    (month_code,year_code,customer_clue_clue_state,customer_relationship_origin_type),
    (year_code,customer_clue_clue_state,customer_relationship_origin_type)
)
order by hour_code,day_code,month_code,year_code ;
```



### 2.2 意向学员位置热力图

**分析：**

维度：

​	时间：时-日-月-年

​	其他：clue_state（新老客户）、origin_type（线上线下）、customer_area（客户所在区域）

指标：

​	统计意向客户id，count(customer_relationship_id)

去重：

​	由于投诉表有重复id（一个id被投诉2次或以上），需要对customer_relationship.id去重

```sql
with temp as
(
    SELECT
    	-- 时间维度
    	substr(customer_relationship_create_date_time,1,4) as year_code,
    	substr(customer_relationship_create_date_time,1,7) as month_code,
    	substr(customer_relationship_create_date_time,1,10) as day_code,
    	substr(customer_relationship_create_date_time,1,13) as hour_code,
    	-- 线索来源维度（新老客户）
    	customer_clue_clue_state,
    	-- 数据来源维度（线上线下）
    	customer_relationship_origin_type,
    	-- 客户所在区域
    	customer_area,

    	--计算字段
    	customer_relationship_id
	from hive.itcast_dwb.dwb_customer_detail
	where customer_clue_clue_state is not null
)
select
	year_code,
    month_code,
    day_code,
    hour_code,
    customer_area,
    -- 指标
    count(customer_relationship_id)
from temp
group by
grouping sets
(
    (hour_code,day_code,month_code,year_code,customer_clue_clue_state,customer_relationship_origin_type,customer_area),
    (day_code,month_code,year_code,customer_clue_clue_state,customer_relationship_origin_type,customer_area),
    (month_code,year_code,customer_clue_clue_state,customer_relationship_origin_type,customer_area),
    (year_code,customer_clue_clue_state,customer_relationship_origin_type,customer_area)
)
order by hour_code,day_code,month_code,year_code
;
```























