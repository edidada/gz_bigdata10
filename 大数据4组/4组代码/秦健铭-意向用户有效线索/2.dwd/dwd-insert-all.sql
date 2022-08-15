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


-- itcast_dwd.fact_web_chat_ems
insert overwrite table itcast_dwd.fact_web_chat_ems partition(st_time)
select
    id, 
    create_date_time, 
    session_id, 
    sid, 
    create_time, 
    seo_source, 
    seo_keywords, 
    ip, 
    area, 
    country, 
    province, 
    city, 
    origin_channel, 
    `user`, 
    manual_time, 
    begin_time, 
    end_time, 
    last_customer_msg_time_stamp, 
    last_agent_msg_time_stamp, 
    reply_msg_count, 
    msg_count, 
    browser_name,
    os_info, 
    --需要转换操作:将创建时间转换为天
    starts_time as st_time
from  itcast_ods.web_chat_ems
where create_time is not null and (session_id is not null or sid is not null or ip is not null);


-- itcast_dwd.fact_web_chat_text_ems
insert overwrite table itcast_dwd.fact_web_chat_text_ems partition(st_time)
select
	*
from itcast_ods.web_chat_text_ems;


--itcast_dwd.dim_customer 
insert overwrite table itcast_dwd.dim_customer partition(st_time)
select 
    *
from itcast_ods.customer;


--itcast_dwd.dim_customer_appeal
insert overwrite table itcast_dwd.dim_customer_appeal partition(st_time)
select 
    *
from itcast_ods.customer_appeal;


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
	-- 枚举转化，将null和0转化成-1
	case
		when itcast_school_id=0 or itcast_school_id is null
			then itcast_school_id=-1
	end as itcast_school_id,
	itcast_school,
	-- 枚举转化，将null和0转化成-1
	case
		when itcast_subject_id=0 or itcast_subject_id is null
			then itcast_subject_id=-1
	end as itcast_subject_id,
	itcast_subject,
	wechat,
	qq,
	email,
	gender,
	level,
	-- 枚举转换，区分线上线下的数据
	case
		when origin_type in ('NETSERVICE', 'PRESIGNUP' )
			then 'online'
		when origin_type in ('SCHOOL', 'VISITED', 'OTHER', 'PHONE')
			then 'offline'
	end as origin_type,
	end as origin_type,
	information_way,
	working_years,
	technical_directions,
	customer_state,
	valid,
	anticipat_signup_date,
	-- 清洗数据：筛选掉INVALID无效数据
	clue_state,
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
	--is_repeat(ods为int),'是否重复线索(手机号维度) 0:正常normal 1：重复repeated'
	case
		when is_repeat = 0
		then 'normal'
		when is_repeat = 1
		then 'repeated'	
	end as is_repeat,
	tenant,
	activity_id,
	activity_name,
	--follow_type(ods为int),'分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取'
	case
		when follow_type = 0
			then 'auto_alloc'
		when follow_type = 1
			then 'manu_alloc'
		when follow_type = 2
			then 'auto_trans'
		when follow_type = 3
			then 'manu_one_trans'
		when follow_type = 4
			then 'manu_batch_trans'
		when follow_type = 5
			then 'from_common'
		else null
	end as follow_type,
	shunt_mode_id,
	shunt_employee_group_id,
	-- 拉链表end_time和st_time取值
	'9999-99-99' as `end_time`,
	if(update_date_time is not null and update_date_time != '',
      	substr(update_date_time,1,10),
      	substr(create_date_time,1,10)
     ) as st_time
from itcast_ods.customer_clue
where clue_state != 'INVALID_PUBLIC_OLD_CLUE'
;


-- customer_relationship
insert overwrite table itcast_dwd.fact_customer_relationship partition (st_time)
select
	id,
	create_date_time,
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
	-- 枚举转换，区分线上线下的数据
	case
		when origin_type in ('NETSERVICE', 'PRESIGNUP' )
			then 'online'
		when origin_type in ('SCHOOL', 'VISITED', 'OTHER', 'PHONE')
			then 'offline'
	end as origin_type,
	-- 枚举转化，将null和0转化成-1
	case
		when itcast_school_id=0 or itcast_school_id is null
			then itcast_school_id=-1
	end as itcast_school_id,
	-- 枚举转化，将null和0转化成-1
	case
		when itcast_subject_id=0 or itcast_subject_id is null
			then itcast_subject_id=-1
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
	--follow_type(ods为int),'分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取'
	case
		when follow_type = 0
			then 'auto_alloc'
		when follow_type = 1
			then 'manu_alloc'
		when follow_type = 2
			then 'auto_trans'
		when follow_type = 3
			then 'manu_one_trans'
		when follow_type = 4
			then 'manu_batch_trans'
		when follow_type = 5
			then 'from_common'
		else null
	end as follow_type,
	transfer_bxg_oa_account,
	transfer_bxg_belonger_name,
	-- 拉链表end_time和st_time取值
	'9999-99-99' as `end_time`,
	'2016-05-24' as st_time
from itcast_ods.customer_relationship;


-- employee
insert overwrite table itcast_dwd.dim_employee partition (st_time)
select
	id,
	email,
	real_name,
	phone,
	department_id,
	department_name,
	remote_login,
	job_number,
	cross_school,
	last_login_date,
	creator,
	create_date_time,
	update_date_time,
	`deleted`,
	scrm_department_id,
	leave_office,
	leave_office_time,
	reinstated_time,
	superior_leaders_id,
	tdepart_id,
	tenant,
	ems_user_name,
	-- 分区字段
	starts_time as st_time
from itcast_ods.employee;


-- itcast_clazz
insert overwrite table itcast_dwd.dim_itcast_clazz partition (st_time)
select
	id,
	create_date_time,
	update_date_time,
	`deleted`,
	itcast_school_id,
	itcast_school_name,
	itcast_subject_id,
	itcast_subject_name,
	itcast_brand,
	clazz_type_state,
	clazz_type_name,
	teaching_mode,
	start_time,
	end_time,
	`comment`,
	detail,
	-- uncertain（ods为int），'待定班(0:否,1:是)'
	case
		when uncertain = 1
			then 'True'
		when uncertain = 0
			then 'False'
		else null
	end as uncertain,
	tenant,
	-- 分区字段	
	starts_time as st_time
from itcast_ods.itcast_clazz;


-- itcast_school
insert overwrite table itcast_dwd.dim_itcast_school partition(st_time)
select
    *
from itcast_ods.itcast_school;


-- dim_itcast_subject
insert overwrite table itcast_dwd.dim_itcast_subject partition(st_time)
select
    *
from itcast_ods.itcast_subject;


-- dim_scrm_department
insert overwrite table itcast_dwd.dim_scrm_department partition(st_time)
select
    *
from itcast_ods.scrm_department;


-- dim_calendar
insert overwrite table itcast_dwd.dim_calendar partition(st_time)
select
    *
from itcast_ods.calendar;


-- dim_class_studying_student_count
insert overwrite table itcast_dwd.dim_class_studying_student_count partition(st_time)
select
    *
from itcast_ods.class_studying_student_count;


-- itcast_dwd.dim_course_table_upload_detail（非拉链表、维度表）
insert overwrite table itcast_dwd.dim_course_table_upload_detail partition(st_time)
select
	id,
    base_id,
    class_id,
    class_date,
    content,
    teacher_id,
    teacher_name,
    job_number,
    classroom_id,
    classroom_name,
    is_outline,
    class_mode,
    is_stage_exam,
    is_pay,
    tutor_teacher_id,
    tutor_teacher_name,
    tutor_job_number,
    is_subsidy,
    answer_teacher_id,
    answer_teacher_name,
    answer_job_number,
    remark,
    create_time,
    starts_time as st_time
from itcast_ods.course_table_upload_detail;


-- itcast_dwd.fact_student_leave_apply(非拉链表、事实表)
insert overwrite table itcast_dwd.fact_student_leave_apply partition(st_time)
select
	id,
    class_id,
    student_id,
    audit_state,
    audit_person,
    audit_time,
    audit_remark,
    leave_type,
    leave_reason,
    begin_time,
    begin_time_type,
    end_time,
    end_time_type,
    days,
    cancel_state,
    cancel_time,
    old_leave_id,
    leave_remark,
    valid_state,
    create_time,
    starts_time as st_time
from  itcast_ods.student_leave_apply
where create_time is not null;


-- itcast_dwd.dim_tbh_class_time_table(非拉链表、维度表)
insert overwrite table itcast_dwd.dim_tbh_class_time_table partition(st_time)
 select
	id,
    class_id,
    morning_template_id,
    morning_begin_time,
    morning_end_time,
    afternoon_template_id,
    afternoon_begin_time ,
    afternoon_end_time,
    evening_template_id,
    evening_begin_time,
    evening_end_time,
    use_begin_date,
    use_end_date,
    create_time,
    create_person,
    remark,
    starts_time as st_time
from itcast_ods.tbh_class_time_table
where create_time is not null;


-- 全量
-- itcast_dwd.fact_tbh_student_signin_record(非拉链表、事实表)
insert overwrite table itcast_dwd.fact_tbh_student_signin_record partition(st_time)
select
	id,
    normal_class_flag,
    time_table_id,
    class_id,
    student_id,
    signin_time,
    signin_date,    
    inner_flag,
    signin_type,
    share_state,
    inner_ip,
    starts_time as st_time
from itcast_ods.tbh_student_signin_record;
