--开启动态分区
set hive.exec.dynamic.partition = true;
--开启非严格模式
set hive.exec.dynamic.partition.mode =nonstrict;
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


--插入考勤宽表
with tempA as(
select
    --学生打卡记录表
    a.id as id,
    a.normal_class_flag as normal_class_flag,
    a.time_table_id as time_table_id,
    a.class_id as class_id,
    a.student_id as student_id,
    a.signin_time as signin_time,
    a.signin_date as signin_date,
    a.inner_flag as inner_flag,
    a.signin_type as signin_type,
    a.share_state as share_state,
    a.inner_ip as inner_ip,
    
    --班级作息时间表
    b.morning_template_id as morning_template_id,
    b.morning_begin_time as morning_begin_time,
    b.morning_end_time as morning_end_time,
    b.afternoon_template_id as afternoon_template_id,
    b.afternoon_begin_time as afternoon_begin_time,
    b.afternoon_end_time as afternoon_end_time,
    b.evening_template_id as evening_template_id,
    b.evening_begin_time as evening_begin_time,
    b.evening_end_time as evening_end_time,
    b.use_begin_date as use_begin_date,
    b.use_end_date as use_end_date,
    b.create_time as create_time,
    b.create_person as create_person,
    
    --班级课表
    c.class_date as class_date,
    c.content as content,
    c.teacher_id as teacher_id,
    c.teacher_name as teacher_name,
    c.job_number as job_number,
    c.classroom_id as classroom_id,
    c.classroom_name as classroom_name,
    c.is_outline as is_outline,
    c.class_mode as class_mode,
    c.is_stage_exam as is_stage_exam,
    c.is_pay as is_pay,
    c.tutor_teacher_id as tutor_teacher_id,
    c.tutor_teacher_name as tutor_teacher_name,
    c.tutor_job_number as tutor_job_number,
    c.is_subsidy as is_subsidy,
    c.answer_teacher_id as answer_teacher_id,
    c.answer_teacher_name as answer_teacher_name,
    c.answer_job_number as answer_job_number,
    
    --班级在读学生人数
    d.school_id as school_id,
    d.subject_id as subject_id,
    d.studying_student_count as studying_student_count,
    d.studying_date as studying_date,
    from_unixtime(unix_timestamp(b.morning_begin_time,'HH:mm:ss')-2400,'HH:mm:ss') as morning_begin_time_40_before,
    from_unixtime(unix_timestamp(b.morning_begin_time,'HH:mm:ss')+600,'HH:mm:ss') as morning_begin_time_10_after,
    from_unixtime(unix_timestamp(b.afternoon_begin_time,'HH:mm:ss')-2400,'HH:mm:ss') as afternoon_begin_time_40_before,
    from_unixtime(unix_timestamp(b.afternoon_begin_time,'HH:mm:ss')+600,'HH:mm:ss') as afternoon_begin_time_10_after,
    from_unixtime(unix_timestamp(b.evening_begin_time,'HH:mm:ss')-2400,'HH:mm:ss') as evening_begin_time_40_before,
    from_unixtime(unix_timestamp(b.evening_begin_time,'HH:mm:ss')+600,'HH:mm:ss') as evening_begin_time_10_after,
    a.signin_date as dt
from edu_ods.tbh_student_signin_record a
inner join edu_ods.tbh_class_time_table b on b.id=a.time_table_id and a.class_id=b.class_id and a.normal_class_flag=1   --连接条件:作息时间匹配、flag为1、班级匹配
inner join edu_ods.course_table_upload_detail c on  a.class_id=c.class_id and a.signin_date=c.class_date and c.content<>'开班典礼'   --连接条件:班级匹配、打卡日期与上课日期匹配、不是开班典礼
inner join edu_ods.class_studying_student_count d on a.class_id=d.class_id and c.class_date=d.studying_date         --连接条件:班级匹配、日期匹配
where c.class_date>=b.use_begin_date and c.class_date<=b.use_end_date)                                               --判断课表是否在有效期内

insert into edu_dwb.kaoqing PARTITION (dt)
select * from tempA;


--插入请假宽表
insert into edu_dwb.kaoqing_leave PARTITION(dt)
select 
    --学生请假申请表
    a.id  as id,
    a.class_id  as class_id,
    a.student_id  as student_id,
    a.audit_state  as audit_state,
    a.audit_person  as audit_person,
    a.audit_time  as audit_time,
    a.audit_remark  as audit_remark,
    a.leave_type  as leave_type,
    a.leave_reason  as leave_reason,
    a.begin_time  as begin_time,
    a.begin_time_type  as begin_time_type,
    a.end_time  as end_time,
    a.end_time_type  as end_time_type,
    a.days  as days,
    a.cancel_state  as cancel_state,
    a.cancel_time  as cancel_time,
    a.old_leave_id  as old_leave_id,
    a.leave_remark  as leave_remark,
    a.valid_state  as valid_state,
    a.create_time  as create_time,
    
    --班级作息时间表
    b.morning_template_id  as  morning_template_id,
    b.morning_begin_time  as  morning_begin_time,
    b.morning_end_time  as  morning_end_time,
    b.afternoon_template_id  as  afternoon_template_id,
    b.afternoon_begin_time  as  afternoon_begin_time,
    b.afternoon_end_time  as  afternoon_end_time,
    b.evening_template_id  as  evening_template_id,
    b.evening_begin_time  as  evening_begin_time,
    b.evening_end_time  as  evening_end_time,
    b.use_begin_date  as  use_begin_date,
    b.use_end_date  as  use_end_date,
    b.create_person  as  create_person,
    
    --班级课表
    c.class_date  as  class_date,
    c.content  as  content,
    c.teacher_id  as  teacher_id,
    c.teacher_name  as  teacher_name,
    c.job_number  as  job_number,
    c.classroom_id  as  classroom_id,
    c.classroom_name  as  classroom_name,
    c.is_outline  as  is_outline,
    c.class_mode  as  class_mode,
    c.is_stage_exam  as  is_stage_exam,
    c.is_pay  as  is_pay,
    c.tutor_teacher_id  as  tutor_teacher_id,
    c.tutor_teacher_name  as  tutor_teacher_name,
    c.tutor_job_number  as  tutor_job_number,
    c.is_subsidy  as  is_subsidy,
    c.answer_teacher_id  as  answer_teacher_id,
    c.answer_teacher_name  as  answer_teacher_name,
    c.answer_job_number  as  answer_job_number,
    
    --班级在读学生人数
    d.school_id  as  school_id,
    d.subject_id  as  subject_id,
    d.studying_student_count  as  studying_student_count,
    d.studying_date  as  studying_date,
    c.class_date as dt
from edu_ods.student_leave_apply a
inner join edu_ods.tbh_class_time_table b on a.class_id=b.class_id                                                      --连接条件:班级匹配
inner join edu_ods.course_table_upload_detail c on a.class_id=c.class_id and c.content<>'开学典礼'                      --连接条件:班级匹配、上课内容不是'开学典礼'            
inner join edu_ods.class_studying_student_count d on c.class_id=d.class_id and c.class_date=d.studying_date             --连接条件:班级匹配、上课时间匹配
where c.class_date>=b.use_begin_date and c.class_date<=b.use_end_date                                           --判断班级作息时间有效期内
and c.class_date>=substr(a.begin_time,1,10) and c.class_date<=substr(a.end_time,1,10)                           --班级课表在请假期间
and a.audit_state='1'                                                                                           --判断审核通过
and a.cancel_state='0'                                                                                          --判断未撤销
and a.valid_state='1';                                                                                          --判断是否有效