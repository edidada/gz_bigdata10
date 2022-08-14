-- # dwd插入语句
-- calendar

INSERT INTO jy_dwd.calendar partition(dt)
SELECT
    id,
    datelist,
	dt	
FROM jy_ods.calendar C
WHERE C.ID IS NOT NULL;



-- class_studying_student_count
INSERT INTO jy_dwd.class_studying_student_count partition(dt)
SELECT
	id,
	school_id,
	subject_id,
	class_id,
	studying_student_count,
	studying_date,
	dt
FROM jy_ods.class_studying_student_count CSSC
WHERE CSSC.ID IS NOT NULL;	



-- course_table_upload_detail
INSERT INTO jy_dwd.course_table_upload_detail partition(dt)
SELECT
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
	CASE is_outline
		WHEN 0
		THEN '否'
		WHEN 1
		THEN '是'
	end
	AS is_outline,
	CASE class_mode
		WHEN 0
		THEN '传统全天'
		WHEN 1
		THEN 'AB上午'
		WHEN 2
		THEN 'AB下午'
		WHEN 3
		THEN '线上直播'
	end
	AS class_mode,
	CASE is_stage_exam
		WHEN 0
		THEN '否'
		WHEN 1
		THEN '是'
	end
	AS is_stage_exam,
	CASE is_pay
		WHEN 0
		THEN '无'
		WHEN 1
		THEN '有'
	end
	AS is_pay,
	tutor_teacher_id,
	tutor_teacher_name,
	tutor_job_number,
	CASE is_subsidy
		WHEN 0
		THEN '无'
		WHEN 1
		THEN '有'
	end
	AS is_subsidy,
	answer_teacher_id,
	answer_teacher_name,
	answer_job_number,
	remark,
	create_time,
	dt
FROM jy_ods.course_table_upload_detail CTUD
WHERE CTUD.ID IS NOT NULL;




-- student_leave_apply
INSERT INTO jy_dwd.student_leave_apply partition(dt)
SELECT
	id,
	class_id,
	student_id,
	CASE audit_state
		WHEN 0
		THEN '待审核'
		WHEN 1
		THEN '通过'
		WHEN 2
		THEN '不通过'
	end
	AS audit_state,
	audit_person,
	audit_time,
	audit_remark,
	CASE leave_type
		WHEN 1
		THEN '请假'
		WHEN 2
		THEN '销假'
	end
	AS leave_type,
	CASE leave_reason
		WHEN 1
		THEN '事假'
		WHEN 2
		THEN '病假'
	end
	AS leave_reason,
	begin_time,
	CASE begin_time_type
		WHEN 1
		THEN '上午'
		WHEN 2
		THEN '下午'
	end
	AS begin_time_type,
	end_time,
	CASE end_time_type
		WHEN 1
		THEN '上午'
		WHEN 2
		THEN '下午'
	end
	AS end_time_type,
	days,
	CASE cancel_state
		WHEN 0
		THEN '未撤销'
		WHEN 1
		THEN '已撤销'
	end
	AS cancel_state,
	cancel_time,
	old_leave_id,
	leave_remark,
	CASE valid_state
		WHEN 0
		THEN '无效'
		WHEN 1
		THEN '有效'
	end
	AS valid_state,
	create_time,
	dt
FROM jy_ods.student_leave_apply SLA
WHERE SLA.ID IS NOT NULL;



-- tbh_class_time_table 
INSERT INTO jy_dwd.tbh_class_time_table partition(dt)
SELECT
	id,
	class_id,
	morning_template_id,
	from_unixtime(unix_timestamp(morning_begin_time,'HH:mm:ss')-2400,'HH:mm:ss') AS morning_ahead_40m_time,
	morning_begin_time,
	from_unixtime(unix_timestamp(morning_begin_time,'HH:mm:ss')+600,'HH:mm:ss') AS morning_after_10m_time,
	morning_end_time,
	afternoon_template_id,
	from_unixtime(unix_timestamp(afternoon_begin_time,'HH:mm:ss')-2400,'HH:mm:ss') AS afternoon_ahead_40m_time,
	afternoon_begin_time,
	from_unixtime(unix_timestamp(afternoon_begin_time,'HH:mm:ss')+600,'HH:mm:ss') AS afternoon_after_10m_time,
	afternoon_end_time,
	evening_template_id,
	from_unixtime(unix_timestamp(evening_begin_time,'HH:mm:ss')-2400,'HH:mm:ss') AS evening_ahead_40m_time,
	evening_begin_time,
	from_unixtime(unix_timestamp(evening_begin_time,'HH:mm:ss')+600,'HH:mm:ss') AS evening_after_10m_time,
	evening_end_time,
	use_begin_date,
	use_end_date,
	create_time,
	create_person,
	remark,
	dt
FROM jy_ods.tbh_class_time_table TCTT
WHERE TCTT.ID IS NOT NULL;



-- tbh_student_signin_record
INSERT INTO jy_dwd.tbh_student_signin_record partition(dt)
SELECT
	id,
	CASE normal_class_flag
		WHEN 1
		THEN '正课'
		WHEN 2
		THEN '自习'
	end
	AS normal_class_flag,
	time_table_id,
	class_id,
	student_id,
	signin_time,
	signin_date,
	CASE inner_flag
		WHEN 0
		THEN '外网'
		WHEN 1
		THEN '内网'
	end
	AS inner_flag,
	CASE signin_type
		WHEN 1
		THEN '心跳打卡'
		WHEN 2
		THEN '老师补卡'
	end
	AS signin_type,
	CASE share_state
		WHEN 0
		THEN '否'
		WHEN 1
		THEN '是'
	end
	AS share_state,
	inner_ip,
	dt
FROM jy_ods.tbh_student_signin_record TSSR
WHERE TSSR.ID IS NOT NULL;

