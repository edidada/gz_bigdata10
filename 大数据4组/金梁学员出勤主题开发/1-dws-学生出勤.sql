drop table if exists edu_dws.student_attendance_dwm;
-- 学生出勤信息表
CREATE TABLE IF NOT EXISTS edu_dws.student_attendance_dwm
(
    dateinfo STRING COMMENT '日期',
    class_id   int COMMENT '班级id',
    student_id int COMMENT '学员id',
    morning_att STRING COMMENT '上午出勤情况：0.正常出勤、1.迟到、2.其他（请假+旷课）',
    afternoon_att STRING COMMENT '下午出勤情况：0.正常出勤、1.迟到、2.其他（请假+旷课）',
    evening_att STRING COMMENT '晚自习出勤情况：0.正常出勤、1.迟到、2.其他（请假+旷课）'
)
COMMENT '学生出勤(正常出勤和迟到)数据' PARTITIONED BY (yearinfo STRING, monthinfo STRING, dayinfo STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS orcfile
TBLPROPERTIES ('orc.compress'='SNAPPY'); 
select * from edu_dws.student_attendance_dwm;


-- student_attendance_dwm
insert into edu_dws.student_attendance_dwm
-- partition (yearinfo, monthinfo, dayinfo)
with tmp as
(
    select
        --
        substr(s.signin_date, 1, 10) as dateinfo,
        s.student_id,
        s.signin_time,
        s.signin_date,
        t.morning_begin_time,
        t.afternoon_begin_time,
        t.evening_begin_time,
        -- 签到时间转换成时间戳
        to_unixtime(cast(substr(s.signin_time, 1, 19) as timestamp)) signin_timestamp,
        -- 打卡时间转换成时间戳
        to_unixtime(cast(concat(s.signin_date, ' ' , t.morning_begin_time) as timestamp)) morning_begin_timestamp,
        to_unixtime(cast(concat(s.signin_date, ' ' , t.morning_end_time) as timestamp)) morning_end_timestamp,
        to_unixtime(cast(concat(s.signin_date, ' ' , t.afternoon_begin_time) as timestamp)) afternoon_begin_timestamp,
        to_unixtime(cast(concat(s.signin_date, ' ' , t.afternoon_end_time) as timestamp)) afternoon_end_timestamp,
        to_unixtime(cast(concat(s.signin_date, ' ' , t.evening_begin_time) as timestamp)) evening_begin_timestamp,
        to_unixtime(cast(concat(s.signin_date, ' ' , t.evening_end_time) as timestamp)) evening_end_timestamp,
        --
        s.class_id
    from edu_ods.student_signin_ods s
        left join edu_ods.class_time_dimen t
            on s.time_table_id = t.id
        left join edu_ods.course_table_upload_detail_dimen c
            on s.class_id = c.class_id
    where coalesce(c.content, '') <> ''
        and c.content <> '开班典礼'
        and s.share_state = 1
        and c.class_id is not null
)
, tmp2 as
(
    select
        *,
        -- 打卡时间段判断
        case when signin_timestamp between morning_begin_timestamp - 60 * 40
                and morning_end_timestamp
            then 'morning'
            when signin_timestamp between afternoon_begin_timestamp - 60 * 40
                and afternoon_end_timestamp
            then 'afternoon'
            when signin_timestamp between evening_begin_timestamp - 60 * 40
                and evening_end_timestamp
            then 'evening'
            else null
        end as signin_part
    from tmp
)
, tmp3 as
(
    select
        *,
        -- 早上出勤状态
        case when signin_timestamp between morning_begin_timestamp - 60 * 40
                        and morning_begin_timestamp + 60 * 10
            then '0' -- 正常出勤
            when signin_timestamp between morning_begin_timestamp + 60 * 10
                        and morning_end_timestamp
            then '1' -- 迟到
            else '2' -- 其他
        end as morning_att,
        -- 中午出勤状态
        case when signin_timestamp between afternoon_begin_timestamp - 60 * 40
                and afternoon_begin_timestamp + 60 * 10
            then '0' -- 正常出勤
            when signin_timestamp between afternoon_begin_timestamp + 60 * 10
                and afternoon_end_timestamp
            then '1'
            else '2'
        end as afternoon_att,
        -- 晚上出勤状态
        case when signin_timestamp between evening_begin_timestamp - 60 * 40
                and evening_begin_timestamp + 60 * 10
            then '0'
            when signin_timestamp between evening_begin_timestamp + 60 * 10
                and evening_end_timestamp
            then '1'
            else '2'
        end as evening_att,
        row_number() over(partition by dateinfo, student_id, signin_part order by signin_time) as rn
    from tmp2
    where signin_part is not null
)
select
    dateinfo,
    class_id,
    student_id,
    min(morning_att) as morning_att,
    min(afternoon_att) as afternoon_att,
    min(evening_att) as evening_att,
    substr('2022-08-08',1,4) as yearinfo,
    substr('2022-08-08',6,2) as monthinfo,
    substr('2022-08-08',9,2) as dayinfo
from tmp3  where rn = 1  
group by student_id, class_id, dateinfo
;