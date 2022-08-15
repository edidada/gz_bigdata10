### 导出Mysql

```sql
CREATE DATABASE itcast_olap DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
create table t_cus_result
(
    -- 时间类型
	time_type longtext comment '时间类型：year_type,month_type,day_type,hour_type',
   	-- 主题类型
    group_type longtext comment '主题类型：total,area,subject,school,origin,department',
    -- 具体时间
    time_code longtext,
	-- 维度
    clue_type longtext comment '线索来源：新客户new_cus,老客户regular_cus',
    origin_type longtext comment '数据来源细分',
    is_online longtext comment '数据来源汇总：online,offline',
	cus_area longtext comment '客户所在区域',
    subject_id int comment '学科id',
    subject_name longtext comment '学科name',
    school_id int comment '学校id',
    school_name longtext  comment '学校name',
    dept_id int comment '意向贡献中心id',
    dept_name longtext comment '意向贡献中心name',
    year_code longtext,
    month_code longtext,
    day_code longtext,
    hour_code longtext,
	-- 指标
    cus_count bigint comment '意向客户id',
    valid_clue_count bigint comment '有效线索量',
    dt longtext
);
```

