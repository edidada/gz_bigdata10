drop table if exists edu_dws.class_attendance_dwm;
-- 班级出勤信息表
CREATE TABLE IF NOT EXISTS edu_dws.class_attendance_dwm
(
    dateinfo STRING COMMENT '日期',
    class_id int COMMENT '班级id',
    morning_att_count STRING COMMENT '上午出勤人数',
    afternoon_att_count STRING COMMENT '下午出勤人数',
    evening_att_count STRING COMMENT '晚自习出勤人数',
    morning_late_count STRING COMMENT '上午迟到人数',
    afternoon_late_count STRING COMMENT '下午迟到人数',
    evening_late_count STRING COMMENT '晚自习迟到人数'
)
COMMENT '学生出勤(正常出勤和迟到)数据' PARTITIONED BY (yearinfo STRING, monthinfo STRING, dayinfo STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS orcfile
TBLPROPERTIES ('orc.compress'='SNAPPY'); 
select * from edu_dws.class_attendance_dwm;


-- edu_dws.class_attendance_dwm
insert into edu_dws.class_attendance_dwm  
select  
    dateinfo,  
    class_id,  
    cast(count(  
    case when morning_att = '0'  
        then 1  
        else null  
    end) as varchar  
    ) as morning_att_count,  
    cast(count(  
    case when afternoon_att = '0'  
        then 1  
        else null  
    end) as varchar  
    ) as afternoon_att_count,  
    cast(count(  
    case when evening_att = '0'  
        then 1  
        else null  
    end) as varchar  
    ) as evening_att_count,  
    cast(count(  
    case when morning_att = '1'  
        then 1  
        else null  
    end) as varchar  
    ) as morning_late_count,  
    cast(count(  
    case when afternoon_att = '1'  
        then 1  
        else null  
    end) as varchar  
    ) as afternoon_late_count,  
    cast(count(  
    case when evening_att = '1'  
        then 1  
        else null  
    end) as varchar  
    ) as evening_late_count,  
    substr('2022-08-08',1,4) as yearinfo,  
    substr('2022-08-08',6,2) as monthinfo,  
    substr('2022-08-08',9,2) as dayinfo  
from edu_dws.student_attendance_dwm  
where class_id is not null
group by class_id, dateinfo
;