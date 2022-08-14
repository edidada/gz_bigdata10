drop table if exists edu_dws.class_leave_dwm;
-- 班级请假信息表
CREATE TABLE IF NOT EXISTS edu_dws.class_leave_dwm
(
    dateinfo STRING COMMENT '日期',
    class_id int COMMENT '班级id',
    morning_leave_count STRING COMMENT '上午请假人数',
    afternoon_leave_count STRING COMMENT '下午请假人数',
    evening_leave_count STRING COMMENT '晚自习请假人数'
)
COMMENT '班级请假数据统计' PARTITIONED BY (yearinfo STRING, monthinfo STRING, dayinfo STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS orcfile
TBLPROPERTIES ('orc.compress'='SNAPPY'); 
select * from edu_dws.class_leave_dwm;


-- edu_dws.class_leave_dwm
insert into edu_dws.class_leave_dwm  
with tmp as  
(  
    select  
        substr(la.create_time, 1, 10) as dateinfo,  
        la.class_id as class_id,  
        la.student_id,  
        case when la.audit_state = 1  
                and la.cancel_state = 0  
                and la.valid_state = 1  
                and t.morning_begin_time  
                    between substr(la.begin_time, 12, 18) and substr(la.end_time, 12, 18)  
            then 1  
            else 0  
        end as morning_leaved,  
        case when la.audit_state = 1  
                and la.cancel_state = 0  
                and la.valid_state = 1  
                and t.afternoon_begin_time  
                    between substr(la.begin_time, 12, 18) and substr(la.end_time, 12, 18)  
            then 1  
            else 0  
        end as afternoon_leaved,  
        case when la.audit_state = 1  
                and la.cancel_state = 0  
                and la.valid_state = 1  
                and t.evening_begin_time  
                    between substr(la.begin_time, 12, 18) and substr(la.end_time, 12, 18)  
            then 1  
            else 0  
        end as evening_leaved  
    from edu_ods.student_leave_apply_ods la  
        left join edu_ods.class_time_dimen t  
            on la.class_id = t.class_id  
        left join edu_ods.course_table_upload_detail_dimen c  
            on la.class_id = c.class_id  
    where coalesce (c.content , '') <> ''  
        and c.content <> '开班典礼'  
        and c.class_date between t.use_begin_date and t.use_end_date  
)  
select  
    dateinfo,  
    class_id,  
    cast(count(distinct  
        case when morning_leaved = 1  
            then student_id  
            else null  
        end) as varchar  
    ) as morning_leave_count,  
    cast(count(distinct  
        case when afternoon_leaved = 1  
            then student_id  
            else null  
        end) as varchar  
    ) as afternoon_leave_count,  
    cast(count(distinct  
        case when evening_leaved = 1  
            then student_id  
            else null  
        end) as varchar  
    ) as evening_leave_count,  
    substr('2022-08-08',1,4) as yearinfo,  
    substr('2022-08-08',6,2) as monthinfo,  
    substr('2022-08-08',9,2) as dayinfo  
from tmp  
group by dateinfo, class_id  
;