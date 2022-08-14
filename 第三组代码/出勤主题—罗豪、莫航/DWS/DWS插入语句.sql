with t1 as
(select
        dateinfo,
        class_id,
        max(studying_student_count) as studying_student_count,
        count(if(type_check='早晨正常出勤',1,null)) as morning_att_count,
        count(if(type_check='下午正常出勤',1,null)) as afternoon_att_count,
        count(if(type_check='晚上正常出勤',1,null)) as evening_att_count,
        count(if(type_check='早晨迟到',1,null)) as morning_late_count,
        count(if(type_check='下午迟到',1,null)) as afternoon_late_count,
        count(if(type_check='晚上迟到',1,null)) as evening_late_count,
        null as morning_leave_count,
        null as afternoon_leave_count,
        null as evening_leave_count,
        dt
from jy_dwb.student_attendance_dwm
group by class_id,dateinfo,dt
union all
select
        substring(begin_time,1,10) as dateinfo,
        class_id,
        max(studying_student_count) as studying_student_count,
        null as morning_att_count,
        null as afternoon_att_count,
        null as evening_att_count,
        null as morning_late_count,
        null as afternoon_late_count,
        null as evening_late_count,
        count(if(substring(begin_time,12,8) < morning_begin_time and substring(end_time,12,8) > morning_end_time,1,null)) as morning_leave_count,
        count(if(substring(end_time,12,8) > afternoon_end_time,1,null)) as afternoon_leave_count,
        count(if(substring(end_time,12,8) > evening_end_time,1,null)) as evening_leave_count,
        dt
from jy_dwb.leave_apply
group by class_id,substring(begin_time,1,10),dt)
insert into table jy_dws.gate_card partition(dt)
 select
        dateinfo,
        class_id,
       studying_student_count,
        morning_att_count,
        afternoon_att_count,
        evening_att_count,
        morning_late_count,
       afternoon_late_count,
        evening_late_count,
        morning_leave_count,
        afternoon_leave_count,
        evening_leave_count ,
        floor(studying_student_count-morning_att_count-nvl(morning_leave_count,0)) as morning_truant_count,
        floor(studying_student_count-afternoon_att_count-nvl(afternoon_leave_count,0)) as afternoon_truant_count,
        floor(studying_student_count-evening_att_count-nvl(evening_leave_count,0)) as evening_truant_count,
        dt
        from t1;