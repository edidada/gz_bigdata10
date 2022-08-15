### 2.0 规范

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





改：

其他 => clue_state（新老客户）、origin_type、is_online（线上线下）

​	（需要加字段，线上线下字段改名为is_online，原始字段origin_type保留原始值）

​	origin_type(字段的数据是原始的数据，好像是6个，school,phone,net...)、is_online（线上线下）

##### 汇总



```sql
with temp as
(
    
SELECT
-- 维度
    -- 时间维度
    substr(customer_relationship_create_date_time,1,13) as hour_code,    
    -- 线索来源维度（新老客户）
    customer_clue_clue_state,    
    -- 数据来源维度（线上线下）
    customer_relationship_origin_type,    
    -- 客户所在区域
    customer_area,    
    -- 学科维度
    itcast_clazz_itcast_subject_id,
    itcast_clazz_itcast_subject_name,
    -- 学校维度
    itcast_clazz_itcast_school_id,
    itcast_clazz_itcast_school_name,
	-- 线上线下原始值
    is_online,
    -- 部门id维度
    scrm_department_id,
    -- 部门name维度
    scrm_department_name,

    
    
    
    
-- 指标
    -- 统计意向客户
    customer_relationship_id
    -- 根据申诉结果统计意向客户id
    customer_appeal_appeal_status,
    
from hive.itcast_dwb.dwb_customer_detail
where customer_clue_clue_state in ('VALID_NEW_CLUES','VALID_PUBLIC_NEW_CLUE')
    
    
)

-- ===========临时表分界线===============


SELECT
-- 维度
    -- 时间维度
    hour_code,
    -- 线索来源维度（新老客户）
    customer_clue_clue_state,
    -- 数据来源维度（线上线下）
    customer_relationship_origin_type,
    -- 客户所在区域
    customer_area,
    -- 学科维度
    itcast_clazz_itcast_subject_id,
    itcast_clazz_itcast_subject_name, 
    -- 学校维度
    itcast_clazz_itcast_school_id,
    itcast_clazz_itcast_school_name,    
    -- 线上线下原始值
    is_online,    
	-- 部门id维度
    scrm_department_id,
    -- 部门name维度
    scrm_department_name,
    
-- 指标
    -- 统计意向客户：count_customer
    case
    	when grouping(2.1 & 2.2)=0
    	then count(DISTINCT customer_relationship_id)
    end as count_customer,
    


from temp

GROUP BY
grouping sets
(
    
-- 2.1 总意向量
(hour_code,customer_clue_clue_state,customer_relationship_origin_type),

-- 2.2 意向学员位置热力图
(hour_code,customer_clue_clue_state,customer_relationship_origin_type,customer_area),
    
-- 2.3 意向学科排名
(hour_code,customer_clue_clue_state,customer_relationship_origin_type,itcast_clazz_itcast_subject_id,itcast_clazz_itcast_subject_name),
    
-- 2.4 意向学校排名
(hour_code,customer_clue_clue_state,customer_relationship_origin_type,itcast_clazz_itcast_school_id,itcast_clazz_itcast_school_name),    
    
-- 2.5 来源渠道占比   
(hour_code,customer_clue_clue_state,customer_relationship_origin_type,is_online), 
    
-- 2.6 意向贡献中心占比
(hour_code,customer_clue_clue_state,customer_relationship_origin_type,
scrm_department_id,scrm_department_name),    
    
    
    
)
;
```





### 2.1总意向量

**分析：**

维度：

​	时间 => 时

​	其他 => clue_state（线索来源:新老客户）、origin_type（数据类型：线上线下）

指标：

​	统计意向客户Id => customer_relationship.id

去重：

​	投诉表有重复id数据(一个Id投诉两次或以上)，需要对id去重distinct

```sql
-- 统计意向客户数量，意向客户区分线上线下、新老客户
with temp as
(
SELECT
-- 维度
    -- 时间维度
    substr(customer_relationship_create_date_time,1,13) as hour_code,
    -- 线索来源维度（新老客户）
    customer_clue_clue_state,
    -- 数据来源维度（线上线下）
    customer_relationship_origin_type,
    
-- 指标
    -- 统计意向客户
    customer_relationship_id
from hive.itcast_dwb.dwb_customer_detail
where customer_clue_clue_state in ('VALID_NEW_CLUES','VALID_PUBLIC_NEW_CLUE')
)

-- ===========临时表分界线===============

SELECT
-- 维度
    -- 时间维度
    hour_code,
    -- 线索来源维度（新老客户）
    customer_clue_clue_state,
    -- 数据来源维度（线上线下）
    customer_relationship_origin_type,

-- 指标
    -- 统计意向客户
    count(DISTINCT customer_relationship_id) as count_customer

from temp
GROUP BY hour_code,customer_clue_clue_state,customer_relationship_origin_type;
```



### 2.2 意向学员位置热力图

**分析：**

维度：

​	时间 => 时

​	其他 => clue_state（新老客户）、origin_type（线上线下）、customer_area（客户所在区域）

指标：

​	统计意向客户id => count(customer_relationship_id)

去重：

​	由于投诉表有重复id（一个id被投诉2次或以上），需要对customer_relationship.id去重

```sql
-- 统计每个区域的意向学员数量，意向客户区分线上线下、新老客户
with temp as
(
    SELECT
-- 维度
    	-- 时间维度
    	substr(customer_relationship_create_date_time,1,13) as hour_code,
    	-- 线索来源维度（新老客户）
    	customer_clue_clue_state,
    	-- 数据来源维度（线上线下）
    	customer_relationship_origin_type,
    	-- 客户所在区域
    	customer_area,
    
-- 指标
    -- 统计意向客户
    	customer_relationship_id
	from hive.itcast_dwb.dwb_customer_detail
	where customer_clue_clue_state is not null
)

-- ===========临时表分界线===============

select
-- 维度
    -- 时间维度
    hour_code,
    -- 线索来源维度（新老客户）
    customer_clue_clue_state,
    -- 数据来源维度（线上线下）
    customer_relationship_origin_type,
    -- 客户所在区域
    customer_area,
    
-- 指标
	-- 统计意向客户
    count(customer_relationship_id)
    
from temp
group by hour_code,customer_clue_clue_state,customer_relationship_origin_type,
-- 区域
customer_area
;
```



### 2.3 意向学科排名

**分析：**

维度：

​	时间 => 时

​	其他 => clue_state（新老客户）、origin_type（线上线下）、itcast_clazz_itcast_subject_id（学科id）、itcast_clazz_itcast_subject_name（学科名称）

指标：

​	统计意向客户id => count(customer_relationship_id)

去重：

​	由于投诉表有重复id（一个id被投诉2次或以上），需要对customer_relationship.id去重

```sql
-- 统计各个学科的意向客户数量，意向客户区分线上线下、新老客户
with temp as
(
SELECT
-- 维度
    -- 时间维度
    substr(customer_relationship_create_date_time,1,13) as hour_code,
    -- 线索来源维度（新老客户）
    customer_clue_clue_state,
    -- 数据来源维度（线上线下）
    customer_relationship_origin_type,
    -- 学科维度
    itcast_clazz_itcast_subject_id,
    itcast_clazz_itcast_subject_name,
    
-- 指标
    -- 统计意向客户
    customer_relationship_id
from hive.itcast_dwb.dwb_customer_detail
where customer_clue_clue_state in ('VALID_NEW_CLUES','VALID_PUBLIC_NEW_CLUE')
)

-- ===========临时表分界线===============

SELECT
-- 维度
    -- 时间维度
    hour_code,
    -- 线索来源维度（新老客户）
    customer_clue_clue_state,
    -- 数据来源维度（线上线下）
    customer_relationship_origin_type,
    -- 学科维度
    itcast_clazz_itcast_subject_id,
    itcast_clazz_itcast_subject_name,

-- 指标
    -- 统计意向客户
    count(DISTINCT customer_relationship_id) as count_customer

from temp
GROUP BY hour_code,customer_clue_clue_state,customer_relationship_origin_type
-- 学科
itcast_clazz_itcast_subject_id,itcast_clazz_itcast_subject_name
;
```



### 2.4 意向校区排名

**分析：**

维度：

​	时间 => 时

​	其他 => clue_state（新老客户）、origin_type（线上线下）、itcast_clazz_itcast_school_id（学校id）、itcast_clazz_itcast_school_name（学校名称）

指标：

​	统计意向客户id => count(customer_relationship_id)

去重：

​	由于投诉表有重复id（一个id被投诉2次或以上），需要对customer_relationship.id去重

```sql
-- 统计各个学校的意向客户数量，意向客户区分线上线下、新老客户
with temp as
(
SELECT
-- 维度
    -- 时间维度
    substr(customer_relationship_create_date_time,1,13) as hour_code,
    -- 线索来源维度（新老客户）
    customer_clue_clue_state,
    -- 数据来源维度（线上线下）
    customer_relationship_origin_type,
    -- 学校维度
    itcast_clazz_itcast_school_id,
    itcast_clazz_itcast_school_name,
    
-- 指标
    -- 统计意向客户
    customer_relationship_id
from hive.itcast_dwb.dwb_customer_detail
where customer_clue_clue_state in ('VALID_NEW_CLUES','VALID_PUBLIC_NEW_CLUE')
)

-- ===========临时表分界线===============

SELECT
-- 维度
    -- 时间维度
    hour_code,
    -- 线索来源维度（新老客户）
    customer_clue_clue_state,
    -- 数据来源维度（线上线下）
    customer_relationship_origin_type,
    -- 学校维度
    itcast_clazz_itcast_school_id,
    itcast_clazz_itcast_school_name,

-- 指标
    -- 统计意向客户
    count(DISTINCT customer_relationship_id) as count_customer

from temp
GROUP BY hour_code,customer_clue_clue_state,customer_relationship_origin_type
-- 学科
itcast_clazz_itcast_school_id,itcast_clazz_itcast_school_name
;
```



### 2.5 来源渠道占比

**分析：**

维度：

​	时间 => 时

​	其他 => clue_state（新老客户）、origin_type（线上线下）、is_online（原始值）【先继续错下去】

​	【改：（需要加字段，线上线下字段改名为is_online，原始字段origin_type保留原始值）

​	origin_type(字段的数据是原始的数据，好像是6个，school,phone,net...)、is_online（线上线下）】

指标：

​	统计意向客户id => count(customer_relationship_id)

去重：

​	由于投诉表有重复id（一个id被投诉2次或以上），需要对customer_relationship.id去重

```sql
-- 统计各来源的意向客户数量占比 =>
-- 1.新意向客户数量/总意向客户数量
-- 2.老意向客户数量/总意向客户数量
-- 3.线上意向客户数量/总意向客户数量
-- 4.线下意向客户数量/总意向客户数量
-- 5.（每个来源：phone,school,web...）的意向客户数量/总意向客户数量
-- 意向客户区分线上线下、新老客户
with temp as
(
SELECT
-- 维度
    -- 时间维度
    substr(customer_relationship_create_date_time,1,13) as hour_code,
    -- 线索来源维度（新老客户）
    customer_clue_clue_state,
    -- 数据来源维度（线上线下）
    customer_relationship_origin_type,
    -- 线上线下原始值
    is_online,
    
-- 指标
    -- 统计意向客户
    customer_relationship_id
from hive.itcast_dwb.dwb_customer_detail
where customer_clue_clue_state in ('VALID_NEW_CLUES','VALID_PUBLIC_NEW_CLUE')
)

-- ===========临时表分界线===============

SELECT
-- 维度
    -- 时间维度
    hour_code,

-- 指标
    -- 新意向客户占比
    cast(count(distinct if(customer_clue_clue_state='newcustomer',customer_relationship_id,null)) as decimal(38,4))/cast(count(DISTINCT customer_relationship_id) as decimal(38,4)) as newcustomer_percent,
	-- 老意向客户占比
	cast(count(distinct if(customer_clue_clue_state='regularcustomer',customer_relationship_id,null)) as decimal(38,4))/cast(count(DISTINCT customer_relationship_id) as decimal(38,4)) as regularcustomer_percent,
	-- 线上意向客户占比
	cast(count(distinct if(customer_relationship_origin_type='online',customer_relationship_id,null)) as decimal(38,4))/cast(count(DISTINCT customer_relationship_id) as decimal(38,4)) as online_percent,
	-- 线下意向客户占比
	cast(count(distinct if(customer_relationship_origin_type='offline',customer_relationship_id,null)) as decimal(38,4))/cast(count(DISTINCT customer_relationship_id) as decimal(38,4)) as offline_percent,
	-- 数据来源SCHOOL
	cast(count(distinct if(is_online='SCHOOL',customer_relationship_id,null)) as decimal(38,4))/cast(count(DISTINCT customer_relationship_id) as decimal(38,4)) as SCHOOL_percent,
	-- 数据来源OTHER
	cast(count(distinct if(is_online='OTHER',customer_relationship_id,null)) as decimal(38,4))/cast(count(DISTINCT customer_relationship_id) as decimal(38,4)) as OTHER_percent,
	-- 数据来源VISITED
	cast(count(distinct if(is_online='VISITED',customer_relationship_id,null)) as decimal(38,4))/cast(count(DISTINCT customer_relationship_id) as decimal(38,4)) as VISITED_percent,
	-- 数据来源PHONE
	cast(count(distinct if(is_online='PHONE',customer_relationship_id,null)) as decimal(38,4))/cast(count(DISTINCT customer_relationship_id) as decimal(38,4)) as PHONE_percent,
	-- 数据来源NETSERVICE
	cast(count(distinct if(is_online='NETSERVICE',customer_relationship_id,null)) as decimal(38,4))/cast(count(DISTINCT customer_relationship_id) as decimal(38,4)) as NETSERVICE_percent

from temp
GROUP BY hour_code
order by hour_code;
```



#### 2.5.1 修改

思路：

​	在数仓里计算出所有维度的细分数据，在fineBI里再按照需求进行分组聚合（比如时间+ 新意向客户）

```sql
-- 统计每个来源渠道的意向客户数量，意向客户区分线上线下、新老客户
with temp as
(
SELECT
-- 维度
    -- 时间维度
    substr(customer_relationship_create_date_time,1,13) as hour_code,
    -- 线索来源维度（新老客户）
    customer_clue_clue_state,
    -- 数据来源维度（线上线下）
    customer_relationship_origin_type,
    -- 线上线下原始值
    is_online,
    
-- 指标
    -- 统计意向客户
    customer_relationship_id
from hive.itcast_dwb.dwb_customer_detail
where customer_clue_clue_state in ('VALID_NEW_CLUES','VALID_PUBLIC_NEW_CLUE')
)

-- ===========临时表分界线===============

SELECT
-- 维度
    -- 时间维度
    hour_code,
    -- 线索来源维度（新老客户）
    customer_clue_clue_state,
    -- 数据来源维度（线上线下）
    customer_relationship_origin_type,
	-- 线上线下原始值
    is_online,
    
-- 指标
    -- 统计意向客户
    count(DISTINCT customer_relationship_id) as count_customer

from temp
GROUP BY hour_code,customer_clue_clue_state,customer_relationship_origin_type,is_online;
```



### 2.6 意向贡献中心占比

**分析：**

维度：

​	时间 => 时

​	其他 => clue_state（新老客户）、origin_type（线上线下）、scrm_department_id（意向贡献中心-部门id）、scrm_department_name（意向贡献中心-部门名称）

指标：

​	统计意向客户id => count(customer_relationship_id)

去重：

​	由于投诉表有重复id（一个id被投诉2次或以上），需要对customer_relationship.id去重

```sql
-- 统计每个部门转化的意向客户数，意向客户区分线上线下、新老客户
-- 统计意向客户数量，意向客户区分线上线下、新老客户
with temp as
(
SELECT
-- 维度
    -- 时间维度
    substr(customer_relationship_create_date_time,1,13) as hour_code,
    -- 线索来源维度（新老客户）
    customer_clue_clue_state,
    -- 数据来源维度（线上线下）
    customer_relationship_origin_type,
    -- 部门id维度
    scrm_department_id,
    -- 部门name维度
    scrm_department_name,
-- 指标
    -- 统计意向客户
    customer_relationship_id
from hive.itcast_dwb.dwb_customer_detail
where customer_clue_clue_state in ('VALID_NEW_CLUES','VALID_PUBLIC_NEW_CLUE')
)

-- ===========临时表分界线===============

SELECT
-- 维度
    -- 时间维度
    hour_code,
    -- 线索来源维度（新老客户）
    customer_clue_clue_state,
    -- 数据来源维度（线上线下）
    customer_relationship_origin_type,
    -- 部门id维度
    scrm_department_id,
    -- 部门name维度
    scrm_department_name,
    
    
    
-- 指标
    -- 统计意向客户
    count(DISTINCT customer_relationship_id) as count_customer

from temp
GROUP BY hour_code,customer_clue_clue_state,customer_relationship_origin_type
scrm_department_id,scrm_department_name;

```



### 2.7 有效线索转化率 ？？申诉结果条件怎么取

**分析：**

维度：

​	时间 => 时

​	其他 => clue_state（新老客户）、origin_type（线上线下）

指标：

​	统计意向客户id => count(customer_relationship_id)  ，统计条件：customer_appeal_appeal_status，计算申诉为Null的意向客户，意为有效客户线索

去重：

​	由于投诉表有重复id（一个id被投诉2次或以上），需要对customer_relationship.id去重

```sql
-- 统计意向客户数量，意向客户区分线上线下、新老客户
-- 只计算有效线索量，咨询量在另外一个系统里
with temp as
(
SELECT
-- 维度
    -- 时间维度
    substr(customer_relationship_create_date_time,1,13) as hour_code,
    -- 线索来源维度（新老客户）
    customer_clue_clue_state,
    -- 数据来源维度（线上线下）
    customer_relationship_origin_type,
    -- 申诉结果
    customer_appeal_appeal_status,
    
-- 指标
    -- 统计意向客户
    customer_relationship_id
from hive.itcast_dwb.dwb_customer_detail
where customer_clue_clue_state in ('VALID_NEW_CLUES','VALID_PUBLIC_NEW_CLUE')
)

-- ===========临时表分界线===============

SELECT
-- 维度
    -- 时间维度
    hour_code,
    -- 线索来源维度（新老客户）
    customer_clue_clue_state,
    -- 数据来源维度（线上线下）
    customer_relationship_origin_type,

-- 指标
    -- 统计意向客户
    count(distinct if(customer_appeal_appeal_status is null,customer_relationship_id,null))

from temp
GROUP BY hour_code,customer_clue_clue_state,customer_relationship_origin_type;
```





### 2.8 有效线索转化率时间段趋势