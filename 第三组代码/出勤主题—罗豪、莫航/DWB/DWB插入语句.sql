with attendance_tmp as (
select
    sr.class_id as class_id,
    sr.student_id as student_id,
    signin_time,
    substr(sr.signin_time,1,10) as dateinfo,
    substr(signin_time,12,8) as sign_time,
    case  when substr(signin_time,12,8) between ct.morning_ahead_40m_time and ct.morning_end_time
            then '上午'
        when substr(signin_time,12,8) between ct.afternoon_ahead_40m_time and ct.afternoon_end_time
            then '下午'
        when substr(signin_time,12,8) between ct.evening_ahead_40m_time and ct.evening_end_time
            then '晚上'
        else null
    end as check_yes,
    case  when substr(signin_time,12,8) between ct.morning_ahead_40m_time and ct.morning_after_10m_time
        then '早晨正常出勤'
        when (substr(signin_time,12,8) between ct.morning_after_10m_time and ct.morning_end_time) or  (substr(signin_time,12,8) between '00:00:00' and ct.morning_ahead_40m_time)
        then '早晨迟到'
        when substr(signin_time,12,8) between ct.afternoon_ahead_40m_time and ct.afternoon_after_10m_time
        then '下午正常出勤'
        when (substr(signin_time,12,8) between ct.morning_end_time and ct.afternoon_ahead_40m_time) or  (substr(signin_time,12,8) between ct.afternoon_after_10m_time and ct.evening_ahead_40m_time)
        then '下午迟到'
        when substr(signin_time,12,8) between ct.evening_ahead_40m_time and ct.evening_after_10m_time
        then '晚上正常出勤'
        when (substr(signin_time,12,8) between ct.afternoon_end_time and ct.evening_ahead_40m_time) or  (substr(signin_time,12,8) between ct.evening_after_10m_time and '23:59:59')
        then '晚上迟到'
        end as type_check,
    sr.dt
from jy_dwd.tbh_student_signin_record as sr
inner join  jy_dwd.tbh_class_time_table ct
on (sr.time_table_id=ct.id) and (sr.class_id=ct.class_id)
and (sr.normal_class_flag ='正课')
inner join jy_dwd.course_table_upload_detail td
on (sr.class_id=td.class_id) and (sr.signin_date=td.class_date)
inner join jy_dwd.class_studying_student_count sc
on (td.class_id=sc.class_id) and (td.class_date=sc.studying_date)
where (substring (ct.use_begin_date,1,10)<=td.class_date)
and (substring (ct.use_end_date,1,10)>=td.class_date)
),
t1 as (
select *, row_number() over(partition by substring(signin_time,1,10),student_id ,check_yes order by signin_time ) as rn
from attendance_tmp
where class_id is not null)
insert overwrite table jy_dwb.student_attendance_dwm partition(dt)
select dateinfo,
    class_id,
    student_id,
    sign_time,
    check_yes,
    type_check,
    dt
    from t1 where check_yes is not null and rn=1;








with leave_apply_tmp as (
select
    a.id ,
    a.class_id ,
    a.student_id ,
    a.audit_state ,
    a.audit_person ,
    a.audit_time ,
    a.audit_remark ,
    a.leave_type ,
    a.leave_reason ,
    a.begin_time ,
    a.begin_time_type ,
    a.end_time ,
    a.end_time_type ,
    a.days ,
    a.cancel_state ,
    a.cancel_time ,
    a.old_leave_id ,
    a.leave_remark ,
    a.valid_state ,
    a.create_time ,
    row_number()over(partition by student_id order by audit_time) as rn,
    c.dt
from jy_dwd.student_leave_apply as a
inner join jy_dwd.tbh_class_time_table as b
on (a.class_id =b.class_id)
inner join jy_dwd.course_table_upload_detail as c
on a.class_id =c.class_id where (substring (a.begin_time,12,8)<=c.class_date)
and (substring (a.end_time,12,8)>=c.class_date) and ( b.morning_begin_time between substring(a.begin_time,12,8)
and substring(a.end_time,12,8))
)
insert into jy_dwd.leave_apply partition(dt)
select
    class_id,
    student_id,
    audit_state,
    audit_person,
    audit_time,
    leave_type,
    leave_reason,
    begin_time,
    end_time,
    days,
    leave_remark,
    valid_state,
    dt
from leave_apply_tmp
where class_id is not null and rn=1







