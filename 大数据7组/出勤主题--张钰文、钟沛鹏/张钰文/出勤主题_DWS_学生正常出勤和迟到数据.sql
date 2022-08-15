-- drop table if exists edu_dws.student_attendance_dwm;

-- 学生出勤信息表
-- CREATE TABLE IF NOT EXISTS edu_dws.student_attendance_dwm (
    dateinfo        String        comment '日期',
    class_id          int           comment '班级id',
    student_id        int           comment '学员id',
    morning_att       String       comment '上午出勤情况：0.正常出勤、1.迟到、2.其他（请假+旷课）',
    afternoon_att    String        comment '下午出勤情况：0.正常出勤、1.迟到、2.其他（请假+旷课）',
    evening_att       String        comment '晚自习出勤情况：0.正常出勤、1.迟到、2.其他（请假+旷课）')
comment '学生出勤(正常出勤和迟到)数据'
PARTITIONED BY (yearinfo STRING, monthinfo STRING, dayinfo STRING)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
stored as orcfile
TBLPROPERTIES ('orc.compress'='SNAPPY');

with date_time as (
    select
        ss.signin_date,
        ss.class_id,
        ss.student_id,
        unix_timestamp(ss.signin_time, 'yyyy-MM-dd HH:mm:ss') as signin_time,
        unix_timestamp(concat_ws(' ', tu.class_date, ct.morning_begin_time), 'yyyy-MM-dd HH:mm:ss')-2400 as morning_schooltime,
        unix_timestamp(concat_ws(' ', tu.class_date, ct.morning_begin_time), 'yyyy-MM-dd HH:mm:ss')+600 as morning_laytime,
        unix_timestamp(concat_ws(' ', tu.class_date, ct.morning_end_time), 'yyyy-MM-dd HH:mm:ss') as morning_end_date,
        unix_timestamp(concat_ws(' ', tu.class_date, ct.afternoon_begin_time), 'yyyy-MM-dd HH:mm:ss')-2400 as afternoon_schooltime,
        unix_timestamp(concat_ws(' ', tu.class_date, ct.afternoon_begin_time), 'yyyy-MM-dd HH:mm:ss')+600 as afternoon_laytime,
        unix_timestamp(concat_ws(' ', tu.class_date, ct.afternoon_end_time), 'yyyy-MM-dd HH:mm:ss') as afternoon_end_date,
        unix_timestamp(concat_ws(' ', tu.class_date, ct.evening_begin_time), 'yyyy-MM-dd HH:mm:ss')-2400 as evening_schooltime,
        unix_timestamp(concat_ws(' ', tu.class_date, ct.evening_begin_time), 'yyyy-MM-dd HH:mm:ss')+600 as evening_laytime,
        unix_timestamp(concat_ws(' ', tu.class_date, ct.evening_end_time), 'yyyy-MM-dd HH:mm:ss') as evening_end_date
    from edu_ods.tbh_student_signin_record ss
    join edu_ods.course_table_upload_detail tu
    on ss.class_id = tu.class_id 
    and ss.signin_date = tu.class_date 
    and nvl(tu.content,'') != '' 
    and tu.content != '开班典礼'
    join edu_ods.tbh_class_time_table ct
    on ss.time_table_id = ct.id
    where ss.share_state = 1
)
-- insert into edu_dws.student_attendance_dwm partition(yearinfo ,monthinfo ,dayinfo)
select
    signin_date as dateinfo,
    class_id,
    student_id,
-- 上午
    case
        when signin_time between morning_schooltime and morning_laytime
        then '0' -- 正常出勤
        when signin_time between morning_laytime and morning_end_date
        then '1' -- 迟到出勤
        else '2' -- 其他(请假+旷课)
    end
    as morning_att,
-- 下午
    case
        when signin_time between afternoon_schooltime and afternoon_laytime
        then '0' -- 正常出勤
        when signin_time between afternoon_laytime and afternoon_end_date
        then '1' -- 迟到出勤
        else '2' -- 其他(请假+旷课)
    end
    as afternoon_att,
-- 晚上
    case
        when signin_time between evening_schooltime and evening_laytime
        then '0' -- 正常出勤
        when signin_time between evening_laytime and evening_end_date
        then '1' -- 迟到出勤
        else '2' -- 其他(请假+旷课)
    end
    as evening_att,
    substr(signin_date, 1, 4) as yearinfo,
    substr(signin_date, 6, 2) as monthinfo,
    substr(signin_date, 9, 2) as dayinfo
from date_time;

