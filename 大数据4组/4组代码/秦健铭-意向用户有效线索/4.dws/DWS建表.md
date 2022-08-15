

### 字段

```sql
-- 按日统计
-- 维度
	--线上线下
	online   -- orgin_online_or_noe
	offline
	--新老用户
	new_customer    -- clue_state
	regular_customer
	--学科
	subject
	-- 来源渠道
	orgin_type




-- 指标

```







### DWS 建表

```sql
-- 主题2
create database itcast_dws;
create table itcast_dws
(
	-- 维度=========================
    new_customer
    regular_customer
    
    
    
    -- 指标=========================
    
)
PARTITIONED BY(dt STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
stored as orc 
TBLPROPERTIES ('orc.compress'='SNAPPY');
```

