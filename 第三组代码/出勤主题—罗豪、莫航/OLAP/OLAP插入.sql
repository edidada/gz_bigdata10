insert into mysql.jy_olap.class_attendance
select  dateinfo,

        cast(class_id as varchar),

        cast(studying_student_count as decimal(10,2)),

        cast(morning_att_count as decimal(10,2)),

        cast((cast(morning_att_count as decimal(10,2))*1.000/studying_student_count)  as decimal(10,2)) as morning_att_ratio,

        cast(afternoon_att_count as decimal(10,2)),

        cast((cast(afternoon_att_count as decimal(10,2))*1.000/studying_student_count)  as decimal(10,2)) as afternoon_att_ratio,

        cast(evening_att_count as decimal(10,2)),

        cast((cast(evening_att_count as decimal(10,2))*1.000/studying_student_count)  as decimal(10,2)) as evening_att_ratio,

        cast(morning_late_count as decimal(10,2)),

        cast((cast(morning_late_count as decimal(10,2))*1.000/studying_student_count)  as decimal(10,2)) as morning_late_ratio,

        cast(afternoon_late_count as decimal(10,2)),

        cast((cast(afternoon_late_count as decimal(10,2))*1.000/studying_student_count)  as decimal(10,2)) as afternoon_late_ratio,

        cast(evening_late_count as decimal(10,2)),

        cast((cast(evening_late_count as decimal(10,2))*1.000/studying_student_count)  as decimal(10,2)) as evening_late_ratio,

        cast(morning_leave_count as decimal(10,2)),

        cast((cast(morning_leave_count as decimal(10,2))*1.000/studying_student_count)  as decimal(10,2)) as morning_leave_ratio,

        cast(afternoon_leave_count as decimal(10,2)),

        cast((cast(afternoon_leave_count as decimal(10,2))*1.000/studying_student_count)  as decimal(10,2)) as afternoon_leave_ratio,

        cast(evening_leave_count as decimal(10,2)),

        cast((cast(evening_leave_count as decimal(10,2))*1.000/studying_student_count)  as decimal(10,2)) as evening_leave_ratio,

        cast(morning_truant_count as decimal(10,2)),

        cast((cast(morning_truant_count as decimal(10,2))*1.000/studying_student_count)  as decimal(10,2)) as morning_truant_ratio,

        cast(afternoon_truant_count as decimal(10,2)),

        cast((cast(afternoon_truant_count as decimal(10,2))*1.000/studying_student_count)  as decimal(10,2)) as afternoon_truant_ratio,

        cast(evening_truant_count as decimal(10,2)),

        cast((cast(evening_truant_count as decimal(10,2))*1.000/studying_student_count)  as decimal(10,2)) as evening_truant_ratio

from hive.jy_dws.gate_card;