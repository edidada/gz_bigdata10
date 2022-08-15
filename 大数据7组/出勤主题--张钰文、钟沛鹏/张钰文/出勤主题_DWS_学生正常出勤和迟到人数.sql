-- drop table edu_dws.class_attendance_dwm;

-- CREATE TABLE IF NOT EXISTS edu_dws.class_attendance_dwm (
    dateinfo        String        comment '日期',
    class_id          int           comment '班级id',
    morning_att_count       String         comment '上午出勤人数',
    afternoon_att_count      String        comment '下午出勤人数',
    evening_att_count       String        comment '晚自习出勤人数',
    morning_late_count       String         comment '上午迟到人数',
    afternoon_late_count      String        comment '下午迟到人数',
    evening_late_count       String        comment '晚自习迟到人数')
comment '学生出勤(正常出勤和迟到)数据'
PARTITIONED BY (yearinfo STRING, monthinfo STRING, dayinfo STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orcfile
TBLPROPERTIES ('orc.compress'='SNAPPY');

with date_time as (
    select
        ss.signin_date as dateinfo,
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
        unix_timestamp(concat_ws(' ', tu.class_date, ct.evening_end_time), 'yyyy-MM-dd HH:mm:ss') as evening_end_date,
        substr(signin_date, 1, 4) as yearinfo,
        substr(signin_date, 6, 2) as monthinfo,
        substr(signin_date, 9, 2) as dayinfo
    from edu_ods.tbh_student_signin_record ss
    join edu_ods.course_table_upload_detail tu
    on ss.class_id = tu.class_id and ss.signin_date = tu.class_date
    join edu_ods.tbh_class_time_table ct
    on ss.time_table_id = ct.id
)
-- insert into edu_dws.class_attendance_dwm partition(yearinfo ,monthinfo ,dayinfo)
select
    dateinfo,
    class_id,
-- 上午出勤人数
    count(distinct
    case
        when signin_time between morning_schooltime and morning_end_date
        then student_id
        else null
    end
    ) as morning_att_count,
-- 下午出勤人数
    count(distinct
    case
        when signin_time between afternoon_schooltime and afternoon_end_date
        then student_id
        else null
    end
    ) as afternoon_att_count,
-- 晚上出勤人数
    count(distinct
    case
        when signin_time between evening_schooltime and evening_end_date
        then student_id
        else null
    end
    ) as evening_att_count,
-- 上午迟到人数
    count(distinct
    case
        when signin_time between morning_laytime and morning_end_date
        then student_id
        else null
    end
    ) as morning_late_count,
-- 下午迟到人数
    count(distinct
    case
        when signin_time between afternoon_laytime and afternoon_end_date
        then student_id
        else null
    end
    ) as afternoon_late_count,
-- 晚上迟到人数
    count(distinct
    case
        when signin_time between evening_laytime and evening_end_date
        then student_id
        else null
    end
    ) as evening_late_count,
    yearinfo,
    monthinfo,
    dayinfo
from date_time
group by class_id, dateinfo, yearinfo, monthinfo, dayinfo;