### cule

#### 建表

增加一个字段clue_type，判断clue_state为新老客户以及无效客户，方便后期筛选

```sql
-- itcast_dwd.fact_customer_clue
drop table if exists itcast_dwd.fact_customer_clue;
CREATE TABLE IF NOT EXISTS itcast_dwd.fact_customer_clue 
(
	id int comment '',
	create_date_time string comment '创建时间',
	update_date_time timestamp comment '最后更新时间',
	`deleted` string comment '是否被删除（禁用）',
	customer_id int comment '客户id',
	customer_relationship_id int comment '客户关系id',
	session_id string comment '七陌会话id',
	sid string comment '访客id',
	status string comment '状态（undeal待领取 deal 已领取 finish 已关闭 changePeer 已流转）',
	`user` string comment '所属坐席',
	create_time string comment '七陌创建时间',
	platform string comment '平台来源 （pc-网站咨询|wap-wap咨询|sdk-app咨询|weixin-微信咨询）',
	s_name string comment '用户名称',
	seo_source string comment '搜索来源',
	seo_keywords string comment '关键字',
	ip string comment 'IP地址',
	referrer string comment '上级来源页面',
	from_url string comment '会话来源页面',
	landing_page_url string comment '访客着陆页面',
	url_title string comment '咨询页面title',
	to_peer string comment '所属技能组',
	manual_time string comment '人工开始时间',
	begin_time string comment '坐席领取时间 ',
	reply_msg_count int comment '客服回复消息数',
	total_msg_count int comment '消息总数',
	msg_count int comment '客户发送消息数',
	comment string comment '备注',
	finish_reason string comment '结束类型',
	finish_user string comment '结束坐席',
	end_time string comment '会话结束时间',
	platform_description string comment '客户平台信息',
	browser_name string comment '浏览器名称',
	os_info string comment '系统名称',
	area string comment '区域',
	country string comment '所在国家',
	province string comment '省',
	city string comment '城市',
	creator int comment '创建人',
	name string comment '客户姓名',
	idcard string comment '身份证号',
	phone string comment '手机号',
	itcast_school_id int comment '校区Id',
	itcast_school string comment '校区',
	itcast_subject_id int comment '学科Id',
	itcast_subject string comment '学科',
	wechat string comment '微信',
	qq string comment 'qq号',
	email string comment '邮箱',
	gender string comment '性别',
	level string comment '客户级别',
	origin_type string comment '数据来源渠道',
	information_way string comment '资讯方式',
	working_years string comment '开始工作时间',
	technical_directions string comment '技术方向',
	customer_state string comment '当前客户状态',
	valid string comment '该线索是否是网资有效线索',
	anticipat_signup_date string comment '预计报名时间',
	clue_state string comment '线索状态',
    -- 将clue_sate的结果判断为新用户new_cus、老用户regular_cus，无效数据
    clue_type string comment '线索状态：new_cus,regular_cus,invalid',
	scrm_department_id int comment 'SCRM内部部门id',
	superior_url string comment '诸葛获取上级页面URL',
	superior_source string comment '诸葛获取上级页面URL标题',
	landing_url string comment '诸葛获取着陆页面URL',
	landing_source string comment '诸葛获取着陆页面URL来源',
	info_url string comment '诸葛获取留咨页URL',
	info_source string comment '诸葛获取留咨页URL标题',
	origin_channel string comment '投放渠道',
	course_id int comment '',
	course_name string comment '',
	zhuge_session_id string comment '',
	is_repeat string comment '是否重复线索(手机号维度) 0:正常normal 1：重复repeated',
	tenant int comment '租户id',
	activity_id string comment '活动id',
	activity_name string comment '活动名称',
	follow_type string comment '分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取',
	shunt_mode_id int comment '匹配到的技能组id',
	shunt_employee_group_id int comment '所属分流员工组',
    stop_time STRING COMMENT '有效截止时间'
)
comment '客户关系表'
PARTITIONED BY(st_time STRING)
clustered by(id) sorted by(id) into 10 buckets
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='SNAPPY');
```



#### 插入

```sql
-- 动态分区配置
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;

-- hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
-- 写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;
-- 写入数据强制分桶
set hive.enforce.bucketing=true;
-- 开启强制排序
set hive.enforce.sorting=true;

-- customer_clue
insert overwrite table itcast_dwd.fact_customer_clue partition (st_time)
select
	id,
	create_date_time,
	update_date_time,
	`deleted`,
	customer_id,
	customer_relationship_id,
	session_id,
	sid,
	status,
	`user`,
	create_time,
	platform,
	s_name,
	seo_source,
	seo_keywords,
	ip,
	referrer,
	from_url,
	landing_page_url,
	url_title,
	to_peer,
	manual_time,
	begin_time,
	reply_msg_count,
	total_msg_count,
	msg_count,
	`comment`,
	finish_reason,
	finish_user,
	end_time,
	platform_description,
	browser_name,
	os_info,
	area,
	country,
	province,
	city,
	creator,
	name,
	idcard,
	phone,
	itcast_school_id,
	itcast_school,
	itcast_subject_id,
	itcast_subject,
	wechat,
	qq,
	email,
	gender,
	level,
	origin_type,
	information_way,
	working_years,
	technical_directions,
	customer_state,
	valid,
	anticipat_signup_date,
	clue_state,
	-- 增加的clue_type字段，用于展示新老客户和清洗数据筛选掉INVALID无效数据
	case
		when clue_state = 'VALID_NEW_CLUES'
		then 'new_cus'
		when clue_state = 'VALID_PUBLIC_NEW_CLUE'
		then 'regular_cus'
		else 'invalid'
	end as clue_type,
	scrm_department_id,
	superior_url,
	superior_source,
	landing_url,
	landing_source,
	info_url,
	info_source,
	origin_channel,
	course_id,
	course_name,
	zhuge_session_id,
	is_repeat,
	tenant,
	activity_id,
	activity_name,
	follow_type,
	shunt_mode_id,
	shunt_employee_group_id,
	-- 拉链表end_time和st_time取值
	'9999-99-99' as `end_time`,
	if(update_date_time is not null and update_date_time != '',
      	substr(update_date_time,1,10),
      	substr(create_date_time,1,10)
     ) as st_time
from itcast_ods.customer_clue
where clue_state in ('VALID_NEW_CLUES','VALID_PUBLIC_NEW_CLUE')
;

```





### relationship

#### 建表(需要改)

增加一个字段is_online，将origin_type的内容判断为online或者offline;

增加时间字段，将create_date_time转化成年月日时

```sql
-- itcast_dwd.fact_customer_relationship
drop table if exists itcast_dwd.fact_customer_relationship;
CREATE TABLE IF NOT EXISTS itcast_dwd.fact_customer_relationship 
(
	id int,
	create_date_time string,
    -- 时间转化-年月日时
    hour_code string,
    day_code string,
    month_code string,
    year_code string,
	update_date_time timestamp comment '最后更新时间',
	`deleted` string comment '是否被删除（禁用）',
	customer_id int comment '所属客户id',
	first_id int comment '第一条客户关系id',
	belonger int comment '归属人',
	belonger_name string comment '归属人姓名',
	initial_belonger int comment '初始归属人',
	distribution_handler int comment '分配处理人',
	business_scrm_department_id int comment '归属部门',
	last_visit_time string comment '最后回访时间',
	next_visit_time string comment '下次回访时间',    
	origin_type string comment '数据来源',
    -- 新增，判断origin_type属于线上还是线下
    is_online string comment '数据来源：online,offline',    
	itcast_school_id int comment '校区Id',
	itcast_subject_id int comment '学科Id',
	intention_study_type string comment '意向学习方式',
	anticipat_signup_date string comment '预计报名时间',
	level string comment '客户级别',
	creator int comment '创建人',
	current_creator int comment '当前创建人：初始==创建人，当在公海拉回时为 拉回人',
	creator_name string comment '创建者姓名',
	origin_channel string comment '来源渠道',
	`COMMENT` string comment '',
	first_customer_clue_id int comment '第一条线索id',
	last_customer_clue_id int comment '最后一条线索id',
	process_state string comment '处理状态',
	process_time string comment '处理状态变动时间',
	payment_state string comment '支付状态',
	payment_time string comment '支付状态变动时间',
	signup_state string comment '报名状态',
	signup_time string comment '报名时间',
	notice_state string comment '通知状态',
	notice_time string comment '通知状态变动时间',
	lock_state string comment '锁定状态',
	lock_time string comment '锁定状态修改时间',
	itcast_clazz_id int comment '所属ems班级id',
	itcast_clazz_time string comment '报班时间',
	payment_url string comment '付款链接',
	payment_url_time string comment '支付链接生成时间',
	ems_student_id int comment 'ems的学生id',
	delete_reason string comment '删除原因',
	deleter int comment '删除人',
	deleter_name string comment '删除人姓名',
	delete_time string comment '删除时间',
	course_id int comment '课程ID',
	course_name string comment '课程名称',
	delete_comment string comment '删除原因说明',
	close_state string comment '关闭装填',
	close_time string comment '关闭状态变动时间',
	appeal_id int comment '申诉id',
	tenant int comment '租户',
	total_fee decimal(38,4) comment '报名费总金额',
	belonged int comment '小周期归属人',
	belonged_time string comment '归属时间',
	belonger_time string comment '归属时间',
	transfer int comment '转移人',
	transfer_time string comment '转移时间',
	follow_type string comment '分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取',
	transfer_bxg_oa_account string comment '转移到博学谷归属人OA账号',
	transfer_bxg_belonger_name string comment '转移到博学谷归属人OA姓名',
	stop_time STRING COMMENT '有效截止时间'
)
comment '客户意向表'
PARTITIONED BY(st_time STRING)
clustered by(id) sorted by(id) into 10 buckets
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='SNAPPY');
```



#### 插入

增加一个字段is_online，将origin_type的内容判断为online或者offline;

增加时间字段，将create_date_time转化成年月日时

```sql
-- customer_relationship
insert overwrite table itcast_dwd.fact_customer_relationship partition (st_time)
select
	id,
	create_date_time,
	substr(create_date_time,12,2) as hour_code,
	substr(create_date_time,9,2) as day_code,
	substr(create_date_time,6,2) as month_code,
	substr(create_date_time,1,4) as year_code,
	update_date_time,
	`deleted`,
	customer_id,
	first_id,
	belonger,
	belonger_name,
	initial_belonger,
	distribution_handler,
	business_scrm_department_id,
	last_visit_time,
	next_visit_time,
	origin_type,
	-- 枚举转换，区分线上线下的数据
	case
		when origin_type in ('NETSERVICE', 'PRESIGNUP')
			then 'online'
		else 'offline'
	end as is_online,
	-- 枚举转化，将null和0转化成-1
	case
		when itcast_school_id=0 or itcast_school_id is null
			then -1
		else itcast_school_id
	end as itcast_school_id,
	-- 枚举转化，将null和0转化成-1
	case
		when itcast_subject_id=0 or itcast_subject_id is null
			then -1
		else itcast_subject_id
	end as itcast_subject_id,
	intention_study_type,
	anticipat_signup_date,
	level,
	creator,
	current_creator,
	creator_name,
	origin_channel,
	`COMMENT`,
	first_customer_clue_id,
	last_customer_clue_id,
	process_state,
	process_time,
	payment_state,
	payment_time,
	signup_state,
	signup_time,
	notice_state,
	notice_time,
	lock_state,
	lock_time,
	itcast_clazz_id,
	itcast_clazz_time,
	payment_url,
	payment_url_time,
	ems_student_id,
	delete_reason,
	deleter,
	deleter_name,
	delete_time,
	course_id,
	course_name,
	delete_comment,
	close_state,
	close_time,
	appeal_id,
	tenant,
	total_fee,
	belonged,
	belonged_time,
	belonger_time,
	transfer,
	transfer_time,
	follow_type,
	transfer_bxg_oa_account,
	transfer_bxg_belonger_name,
	-- 拉链表end_time和st_time取值
	'9999-99-99' as `end_time`,
	'2016-05-24' as st_time
from itcast_ods.customer_relationship;
```

