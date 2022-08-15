

# DWS

### DWS学生维度日数据

```sql
------------------------ 先求出每个学生每天的出勤状态------------------------------
with duty_base as (

-- 出勤基本表  
        SELECT  
            sigh.id as id,
            sigh.normal_class_flag as nomal_class_flag,
            sigh.class_id as class_id,
            sigh.student_id as student_id,
            sigh.time_table_id,
            signin_time,
            times.morning_begin_time,
            sigh.signin_date as signin_date,
            times.use_begin_date,
            times.use_end_date,
            upload.content,
            upload.class_date,
    -- 添加辅助列，上课前四十分钟，上课后十分钟，用时间戳运算
            from_unixtime(unix_timestamp((concat_ws(' ', sigh.signin_date, times.morning_begin_time))) - 2400) as morning_ahead_40,
            from_unixtime(unix_timestamp(concat_ws(' ', sigh.signin_date, times.morning_begin_time)) +600) as morning_after_10,
            concat_ws(' ', sigh.signin_date, times.morning_end_time) as morning_end_time,
            from_unixtime(unix_timestamp((concat_ws(' ', sigh.signin_date, times.afternoon_begin_time))) - 2400) as afternoon_ahead_40,
            from_unixtime(unix_timestamp(concat_ws(' ', sigh.signin_date, times.afternoon_begin_time)) +600) as afternoon_after_10,
            concat_ws(' ', sigh.signin_date, times.afternoon_end_time) as afternoon_end_time,
            from_unixtime(unix_timestamp((concat_ws(' ', sigh.signin_date, times.evening_begin_time))) - 2400) as evening_ahead_40,
            from_unixtime(unix_timestamp(concat_ws(' ', sigh.signin_date, times.evening_begin_time)) +600) as evening_after_10,
            concat_ws(' ', sigh.signin_date, times.evening_end_time) as evening_end_time
 -- 用学生打卡记录表连接班级课表 关联字段：class_id
    FROM ods_tbh_student_signin_record sigh 
        left join ods_course_table_upload_detail upload on sigh.class_id = uplo-ad.class_id 
   -- 打卡时间必须是上课时间
        and sigh.signin_date = upload.class_date
  -- 连接班级作息时间表，where筛选打卡时间要在班级作息时间的有效期内
        left join ods_tbh_class_time_table times on sigh.class_id = times.class_id 
        where (sigh.signin_date between times.use_begin_date and times.use_end_date)
    -- 把开班典礼的日期筛选掉
        and upload.content != '开班典礼' 
),

-- 添加出勤状态
duty_base_state as (
        select 
            *,
            case
                when unix_timestamp(signin_time) between unix_timestamp(morning_ahead_40) and unix_timestamp(morning_end_time)
                then '上午'
                when unix_timestamp(signin_time) between unix_timestamp(afternoon_ahead_40) and unix_timestamp(afternoon_end_time)
                then '下午'
                when unix_timestamp(signin_time) between unix_timestamp(evening_ahead_40) and unix_timestamp(evening_end_time)
                then '晚上'
                end as duty_mode,
            case
                when unix_timestamp(signin_time) between unix_timestamp(morning_ahead_40) and unix_timestamp(morning_after_10)
                then '上午正常出勤'
                when unix_timestamp(signin_time) > unix_timestamp(morning_after_10) and unix_timestamp(signin_time) <= unix_timestamp(morning_end_time)
                then '上午迟到'
                when unix_timestamp(signin_time) between unix_timestamp(afternoon_ahead_40) and unix_timestamp(afternoon_after_10)
                then '下午正常出勤'
                when unix_timestamp(signin_time) > unix_timestamp(afternoon_after_10) and unix_timestamp(signin_time) <= unix_timestamp(afternoon_end_time)
                then '下午迟到'
                when unix_timestamp(signin_time) between unix_timestamp(evening_ahead_40) and unix_timestamp(evening_after_10)
                then '晚上正常出勤'
                when unix_timestamp(signin_time) > unix_timestamp(evening_after_10) and unix_timestamp(signin_time) <= unix_timestamp(evening_end_time)
                then '晚上迟到'
                end as duty_state
        from duty_base
),

-- 去重,清洗
duty_base_state_distinct as (
        select
            *,
             row_number()over(partition by signin_date, student_id, duty_mode order by signin_time) rn
        
        from duty_base_state
        where duty_mode is not null

)
insert into edu_dws.dws_student_attendance partition (dt)

-- 行转列

        select
            signin_date,
            class_id,
            student_id,
            min(case
                when  duty_state = '上午正常出勤' then 0
                when   duty_state = '上午迟到'    then 1
                else 2
                end ) as morning_att,
                
            min(case
                when duty_state = '下午正常出勤' then 0
                when duty_state = '下午迟到'     then 1
                else 2
                end) as afternoon_att,
                
            min(case
                when duty_state = '晚上正常出勤' then 0
                when duty_state = '晚上迟到'     then 1
                else 2
                end) as evening_att,
           
            '2022-8-10' as dt

            
        from duty_base_state_distinct
        where  rn = 1
        group by signin_date, class_id, student_id
 ;



```



![1660311969781](C:\Users\小蓝\AppData\Roaming\Typora\typora-user-images\1660311969781.png)

```sql
-- 导入到 edu_dws.dws_student_attendance 表里
此时表格状态
学生日维度
morning_att : 0为正常出勤， 1为迟到，2为请假或旷课
afternoon_att : 0为正常出勤， 1为迟到，2为请假或旷课
evening_att : 0为正常出勤， 1为迟到，2为请假或旷课
```

```sql
-- 创建一个新的临时表， 添加迟到，请假，旷课指标
CREATE TABLE edu_dws.dws_student_attendance1(
        dateinfo          STRING   COMMENT '日期',
        class_id          STRING   COMMENT '班级id',
        student_id        STRING   COMMENT '学生id',
        morning_att       STRING   COMMENT '早上是否出勤',
        afternoon_att     STRING   COMMENT '下午是否出勤',
        evening_att       STRING   COMMENT '晚上是否出勤',
        morning_late      STRING   COMMENT '早上是否迟到',
        afternoon_late    STRING   COMMENT '下午是否迟到',
        evening_late      STRING   COMMENT '晚上是否迟到',
        morning_leave     STRING   COMMENT '早上是否请假',
        afternoon_leave   STRING   COMMENT '下午是否请假',
         evening_leave    STRING   COMMENT '晚上是否请假',
        morning_absent    STRING   COMMENT '早上是否旷课',
        afternoon_absent  STRING   COMMENT '下午是否旷课',
        evening_absent    STRING   COMMENT '晚上是否旷课'
) COMMENT '学生维度全指标表'
PARTITIONED BY (dt STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS ORC
TBLPROPERTIES ('orc.compress' = 'SNAPPY');


INSERT INTO dws_student_attendance1 PARTITION(dt)

SELECT
        dateinfo,
        class_id,
        student_id,
        morning_att,
        afternoon_att,
        evening_att,
        null as morning_late,
        null as afternoon_late,
        null as evening_late,
        null as morning_leave,
        null as afternoon_leave,
        null as evening_leave,
        null as morning_absent,
        null as afternoon_absent,
        null as evening_absent,
        '2022-08-10' as dt
FROM dws_student_attendance;
```

```sql
-- 查询出有效的请假记录
with leave_base as (
SELECT 
        leave.class_id,
        leave.student_id,
        leave.begin_time,
        leave.end_time,
        concat(upload.class_date, ' ', '09:00:00:0') as class_date_morn,
        concat(upload.class_date, ' ', '15:00:00:0') as class_date_after,
        concat(upload.class_date, ' ', '19:00:00:0') as class_date_even,
        upload.class_date,
        upload.content
from edu_ods.ods_course_table_upload_detail upload  JOIN edu_ods.ods_student_leave_apply leave
on upload.class_id = leave.class_id
where leave.class_id is not NULL
and leave.audit_state = 1
and leave.cancel_state = 0
and leave.valid_state = 1

),

-- 去重,清洗
leave_base_dintinct as (
select 
        *
        
from leave_base
where   (class_date_morn between begin_time and end_time)
        or(class_date_after between begin_time and end_time)
        or(class_date_even between begin_time and end_time)
) 

insert into dws_student_attendance1 partition(dt)
select 
        class_date,
        class_id,
        student_id,
        null as morning_att,
        null as afternoon_att,
        null as evening_att,
        null as morning_late,
        null as afternoon_late,
        null as evening_late,
        max(case when class_date_morn between begin_time and end_time then 1 end) as  morn_leave,
        max(case when class_date_after between begin_time and end_time then 1 end) as  after_leave,
        max(case when class_date_even between begin_time and end_time then 1 end) as  even_leave,
        null as morning_absent,
        null as afternoon_absent,
        null as evening_absent,
        '2022-08-10' as dt
from leave_base_dintinct
group by class_date,class_id, student_id
```

![1660312539919](C:\Users\小蓝\AppData\Roaming\Typora\typora-user-images\1660312539919.png)

```sql
查询出一条有效的请假记录，并添加到dws_student_attendance1临时表里
```

```sql
--创建最终指标表
CREATE TABLE edu_dws.dws_student_all(
        dateinfo          STRING   COMMENT '日期',
        class_id          STRING   COMMENT '班级id',
        student_id        STRING   COMMENT '学生id',
        morning_att       STRING   COMMENT '早上是否出勤',
        morning_late      STRING   COMMENT '早上是否迟到',
        morning_leave     STRING   COMMENT '早上是否请假',
        morning_absent    STRING   COMMENT '早上是否旷课',
        afternoon_att     STRING   COMMENT '下午是否出勤',
        afternoon_late    STRING   COMMENT '下午是否迟到',
        afternoon_leave   STRING   COMMENT '下午是否请假',
        afternoon_absent  STRING   COMMENT '下午是否旷课',
        evening_att       STRING   COMMENT '晚上是否出勤',
        evening_late      STRING   COMMENT '晚上是否迟到',
        evening_leave     STRING   COMMENT '晚上是否请假',
        evening_absent    STRING   COMMENT '晚上是否旷课'
) COMMENT '学生维度全指标表'
PARTITIONED BY (dt STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS ORC
TBLPROPERTIES ('orc.compress' = 'SNAPPY');


-- 把所有数据转换 并导入最终表
with dws_student_final as (

SELECT 
    dateinfo,
    class_id,
    student_id,
    CASE when morning_att is null  or morning_att = 2 then 0 ELSE 1 end as morning_att,
    case when morning_att = 1 then 1 ELSE 0 end  as morning_late,
    case when morning_leave is NOT NULL then 1 ELSE 0 end as morning_leave,
    case when afternoon_att is null  or afternoon_att = 2 then 0 ELSE 1 end as afternoon_att,
    case when afternoon_att = 1 then 1 else 0 end as afternoon_late,
    case when afternoon_leave is NOT null then 1 ELSE 0 end as afternoon_leave,
    case when evening_att is null  or evening_att = 2 then 0 ELSE 1 end as evening_att,
    case when evening_att = 1 then 1 else 0 end as evening_late,
    case when evening_leave is not null then 1 ELSE 0 end as evening_leave,
    '2022-08-10' as dt
FROM dws_student_attendance1

)
INSERT INTO dws_student_all PARTITION(dt)
select 
        dateinfo,
        class_id,
        student_id,
        morning_att,
        morning_late,
        morning_leave,
        case when morning_att = 0 and morning_late = 0 and morning_leave = 0 then 1 else 0 end as morning_absent,
        afternoon_att,
        afternoon_late,
        afternoon_leave,
        case when afternoon_att = 0 and afternoon_late = 0 and afternoon_leave = 0 then 1 else 0 end as afternoon_absent,
        evening_att,
        evening_late,
        evening_leave,
        case when evening_att = 0 and evening_late = 0 and evening_leave = 0 then 1 else 0 end as evening_absent,
        '2022-08-10' as dt
from dws_student_final;
```





### DWS班级维度日数据

```sql
-- 创建班级日维度总表
CREATE table edu_dws.dws_class_all(
        dayinfo             STRING        COMMENT'日期',
        class_id            STRING        COMMENT'班级id',
        morn_att_count      STRING        COMMENT'早上出勤人数',
        morn_att_ratio      STRING        COMMENT'早上出勤率',
        morn_late_count     STRING        COMMENT'早上迟到人数',
        morn_late_ratio     STRING        COMMENT'早上迟到率',
        morn_leave_count    STRING        COMMENT'早上请假人数',
        morn_leave_ratio    STRING        COMMENT'早上请假率',
        morn_absent_count   STRING        COMMENT'早上旷课人数',
        morn_absent_ratio   STRING        COMMENT'早上旷课率',
        after_att_count     STRING        COMMENT'下午出勤人数',
        after_att_ratio     STRING        COMMENT'下午出勤率',
        after_late_count    STRING        COMMENT'下午迟到人数',
        after_late_ratio    STRING        COMMENT'下午迟到率',
        after_leave_count   STRING        COMMENT'下午请假人数',
        after_leave_ratio   STRING        COMMENT'下午请假率',
        after_absent_count  STRING        COMMENT'下午旷课人数',
        after_absent_ratio  STRING        COMMENT'下午旷课率',
        even_att_count      STRING        COMMENT'晚上出勤人数',
        even_att_ratio      STRING        COMMENT'晚上出勤率',
        even_late_count     STRING        COMMENT'晚上迟到人数',
        even_late_ratio     STRING        COMMENT'晚上迟到率',
        even_leave_count    STRING        COMMENT'晚上请假人数',
        even_leave_ratio    STRING        COMMENT'晚上请假率',
        even_absent_count   STRING        COMMENT'晚上旷课人数',
        even_absent_ratio   STRING        COMMENT'晚上旷课率' ,
        class_student_count STRING        COMMENT'当天班级在读人数'      
)   COMMENT'班级日维度全指标表'
    PARTITIONED BY(dt STRING)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\t'
    STORED AS ORC
    TBLPROPERTIES ('orc.compress' = 'SNAPPY');
    
    
    
-----------------------------------------------------------------


-- 查询出 出勤， 迟到， 请假人数，因为旷课人数计算需要用到前面的字段，所以在下面的子查询里计算

with student_base as (
    select 
            stu_all.dateinfo,
            stu_all.class_id,
            sum(stu_all.morning_att) as morn_att_count,
            sum(stu_all.morning_late) as morn_late_count,
            sum(stu_all.morning_leave) as morn_leave_count,
            sum(stu_all.afternoon_att) as after_att_count,
            sum(stu_all.afternoon_late) as after_late_count,
            sum(stu_all.afternoon_leave) as after_leave_count, 
            sum(stu_all.evening_att) as even_att_count, 
            sum(stu_all.evening_late) as even_late_count, 
            sum(stu_all.evening_leave) as even_leave_count, 
            stu_count.studying_student_count
    from dws_student_all stu_all left join edu_ods.ods_class_studying_student_count stu_count
    on stu_all.class_id = stu_count.class_id and stu_all.dateinfo = stu_count.studying_date
    group by stu_all.dateinfo, stu_all.class_id,stu_count.studying_student_count

),

-- 这里根据前面汇总的出勤，请假人数计算出旷课人数
student_base2 as (
    select 
            
            dateinfo,
            class_id,
            morn_att_count,
            morn_late_count,
            morn_leave_count,
            studying_student_count - morn_att_count - morn_leave_count as morn_absent_count,
            after_att_count,
            after_late_count,
            after_leave_count,
            studying_student_count - after_att_count - after_leave_count as after_absent_count,
            even_att_count,
            even_late_count,
            even_leave_count,
            studying_student_count - even_att_count - even_leave_count as even_absent_count,
            studying_student_count
    from student_base
)

-- 算出各指标百分比， 并插入到表里
insert into dws_class_all partition(dt)
    select 
            dateinfo,
            class_id,
            morn_att_count,
            morn_att_count / studying_student_count as morn_att_ratio,
            morn_late_count,
            morn_late_count / studying_student_count as morn_late_ratio,
            morn_leave_count,
            morn_leave_count / studying_student_count as morn_leave_ratio,
            morn_absent_count,
            morn_absent_count / studying_student_count as morn_absent_ratio,
            after_att_count,
            after_att_count / studying_student_count as after_att_ratio,
            after_late_count,
            after_late_count / studying_student_count as after_late_ratio,
            after_leave_count,
            after_leave_count / studying_student_count as after_leave_ratio,
            after_absent_count,
            after_absent_count / studying_student_count as after_absent_ratio,
            even_att_count,
            even_att_count / studying_student_count as even_att_ratio,
            even_late_count,
            even_late_count / studying_student_count as even_late_ratio,
            even_leave_count,
            even_leave_count / studying_student_count as even_leave_ratio,
            even_absent_count,
            even_absent_count / studying_student_count as even_absent_ratio,
            studying_student_count as class_student_count,
            '2022-08-10' as dt
    from student_base2

```









# DM

### DM学生维度数据

```sql
--建表

CREATE TABLE edu_dm.dm_student_all(
        yearinfo            STRING      COMMENT'年份',
        monthinfo           STRING      COMMENT'月份',
        dayinfo             STRING      COMMENT'日期',
        group_type          STRING      COMMENT'时间类型',
        class_id            STRING      COMMENT'班级id',
        student_id          STRING      COMMENT'学生id',
        morn_att_count      BIGINT         COMMENT'早上出勤次数',
        morn_late_count     BIGINT         COMMENT'早上迟到次数',
        morn_leave_count    BIGINT         COMMENT'早上请假次数',        
        morn_absent_count   BIGINT         COMMENT'早上旷课次数',
        after_att_count     BIGINT         COMMENT'下午出勤次数',
        after_late_count    BIGINT         COMMENT'下午迟到次数',
        after_leave_count   BIGINT         COMMENT'下午请假次数',
        after_absent_count  BIGINT         COMMENT'下午旷课次数',
        even_att_count      BIGINT         COMMENT'晚上出勤次数',
        even_late_count     BIGINT         COMMENT'晚上迟到次数',
        even_leave_count    BIGINT         COMMENT'晚上请假次数',
        even_absent_count   BIGINT         COMMENT'晚上旷课次数'

) COMMENT'学生全维度表'

PARTITIONED BY(dt STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS ORC
TBLPROPERTIES ('orc.compress' = 'SNAPPY');




--导入

insert into edu_dm.dm_student_all
with dm_student_base as (
select
    substring (dateinfo, 1, 4) as yearinfo,
    substring (dateinfo, 1, 7) as monthinfo,
        *
from edu_dws.dws_student_all
)

select
    yearinfo,
    monthinfo,
    null as dayinfo,
    case
        when grouping (monthinfo) = 0 then 'month'
        when grouping (yearinfo) = 0  then 'year'
        end as group_type,
    max(class_id) as class_id,
    student_id,
    sum (cast(morning_att as int))       as morning_att_count,
    sum (cast(morning_late as int))      as morning_late_count,
    sum (cast(morning_leave as int))     as morning_leave_count,
    sum (cast(morning_absent as int))    as morning_absent_count,
    sum (cast(afternoon_att as int))     as after_att_count,
    sum (cast(afternoon_late as int))    as after_late_count,
    sum (cast(afternoon_leave as int))   as after_leave_count,
    sum (cast(afternoon_absent as int))  as after_absent_count,
    sum (cast(evening_att as int))       as even_att_count,
    sum (cast(evening_late as int))      as even_late_count,
    sum (cast(evening_leave as int))     as even_leave_count,
    sum (cast(evening_absent as int))    as even_absent_count,
    '2022-08-10'            as dt
from dm_student_base
group by
grouping sets(
    (monthinfo, student_id),
    (yearinfo, student_id)
)
```





### DM班级维度数据

```sql
CREATE DATABASE edu_dm;
-- 建表
drop table edu_dm.dm_class_all;
CREATE table edu_dm.dm_class_all(
        yearinfo            STRING        COMMENT'年份',
        monthinfo           STRING        COMMENT'月份',
        dayinfo             STRING        COMMENT'日期',
        group_type          STRING        COMMENT'时间类型',
        class_id            STRING        COMMENT'班级id',
        morn_att_count      DOUBLE        COMMENT'早上出勤人数',
        morn_att_ratio      DOUBLE        COMMENT'早上出勤率',
        morn_late_count     DOUBLE        COMMENT'早上迟到人数',
        morn_late_ratio     DOUBLE        COMMENT'早上迟到率',
        morn_leave_count    DOUBLE        COMMENT'早上请假人数',
        morn_leave_ratio    DOUBLE        COMMENT'早上请假率',
        morn_absent_count   DOUBLE        COMMENT'早上旷课人数',
        morn_absent_ratio   DOUBLE        COMMENT'早上旷课率',
        after_att_count     DOUBLE        COMMENT'下午出勤人数',
        after_att_ratio     DOUBLE        COMMENT'下午出勤率',
        after_late_count    DOUBLE        COMMENT'下午迟到人数',
        after_late_ratio    DOUBLE        COMMENT'下午迟到率',
        after_leave_count   DOUBLE        COMMENT'下午请假人数',
        after_leave_ratio   DOUBLE        COMMENT'下午请假率',
        after_absent_count  DOUBLE        COMMENT'下午旷课人数',
        after_absent_ratio  DOUBLE        COMMENT'下午旷课率',
        even_att_count      DOUBLE        COMMENT'晚上出勤人数',
        even_att_ratio      DOUBLE        COMMENT'晚上出勤率',
        even_late_count     DOUBLE        COMMENT'晚上迟到人数',
        even_late_ratio     DOUBLE        COMMENT'晚上迟到率',
        even_leave_count    DOUBLE        COMMENT'晚上请假人数',
        even_leave_ratio    DOUBLE        COMMENT'晚上请假率',
        even_absent_count   DOUBLE        COMMENT'晚上旷课人数',
        even_absent_ratio   DOUBLE        COMMENT'晚上旷课率' ,
        class_student_count STRING        COMMENT'当天班级在读人数'      
)   COMMENT'班级年月日维度全指标表'
    PARTITIONED BY(dt STRING)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\t'
    STORED AS ORC
    TBLPROPERTIES ('orc.compress' = 'SNAPPY');
    
```



```sql
-- 导入语句
insert into edu_dm.dm_class_all
WITH dm_classs_base as (
        SELECT
                substr(dayinfo, 1, 4) as yearinfo,
                substr(dayinfo, 1, 7) as monthinfo,
                *
        from edu_dws.dws_class_all
)
        select
                case
                    when grouping (class_id) = 0 then yearinfo end as yearinfo ,

                case
                    when grouping (yearinfo) = 0
                    then null
                    else monthinfo end as monthinfo,

                case
                    when grouping (yearinfo) = 0 or grouping (monthinfo) = 0 then null
                    else dayinfo end as dayinfo,

                case
                    when grouping (yearinfo) = 0 then 'year'
                    when grouping (monthinfo) = 0 then 'month'
                    when grouping (dayinfo) = 0  then  'day'
                    end  as group_type,
                class_id,
                sum (cast (morn_att_count as double )) as morn_att_count,
                sum (cast (morn_att_count as double )) / sum (cast (class_student_count as double )) as morn_att_ratio,
                sum (cast (morn_late_count as double )) as morn_late_count,
                sum (cast (morn_late_count as double )) / sum (cast (class_student_count as double )) as morn_late_ratio,
                sum (cast (morn_leave_count as double )) as morn_leave_count,
                sum (cast (morn_leave_count as double )) / sum (cast (class_student_count as double )) as morn_leave_ratio,
                sum (cast (morn_absent_count as double )) as morn_absent_count,
                sum (cast (morn_absent_count as double )) / sum (cast (class_student_count as double )) as morn_absent_ratio,
                sum (cast (after_att_count as double )) as after_att_count,
                sum (cast (after_att_count as double )) / sum (cast (class_student_count as double )) as after_att_ratio,
                sum (cast (after_late_count as double )) as after_late_count,
                sum (cast (after_late_count as double )) / sum (cast (class_student_count as double )) as after_late_ratio,
                sum (cast (after_leave_count as double )) as after_leave_count,
                sum (cast (after_leave_count as double )) / sum (cast (class_student_count as double )) as after_leave_ratio,
                sum (cast (after_absent_count as double )) as after_absent_count,
                sum (cast (after_absent_count as double )) / sum (cast (class_student_count as double )) as after_absent_ratio,
                sum (cast (even_att_count as double )) as even_att_count,
                sum (cast (even_att_count as double )) / sum (cast (class_student_count as double )) as even_att_ratio,
                sum (cast (even_late_count as double )) as even_late_count,
                sum (cast (even_late_count as double )) / sum (cast (class_student_count as double )) as even_late_ratio,
                sum (cast (even_leave_count as double )) as even_leave_count,
                sum (cast (even_leave_count as double )) / sum (cast (class_student_count as double )) as even_leave_ratio,
                sum (cast (even_absent_count as double )) as even_absent_count,
                sum (cast (even_absent_count as double )) / sum (cast (class_student_count as double )) as even_absent_ratio,
                class_student_count,
                '2022-08-10' as dt
        from dm_classs_base
        group by
        grouping sets (
        (dayinfo, class_id, class_student_count) ,
        (monthinfo, class_id),
        (yearinfo, class_id)
        );
```





# Mysql-olap

### 班级维度

```sql
-- mysql-olap  班级建表
create table edu_olap.edu_olap_class(
        yearinfo            longtext   COMMENT'年份',
        monthinfo           longtext   COMMENT'月份',
        dayinfo             longtext   COMMENT'日期',
        group_type          longtext   COMMENT'时间类型',
        class_id            longtext  COMMENT'班级id',
        morn_att_count      DOUBLE        COMMENT'早上出勤人数',
        morn_att_ratio      DOUBLE        COMMENT'早上出勤率',
        morn_late_count     DOUBLE        COMMENT'早上迟到人数',
        morn_late_ratio     DOUBLE        COMMENT'早上迟到率',
        morn_leave_count    DOUBLE        COMMENT'早上请假人数',
        morn_leave_ratio    DOUBLE        COMMENT'早上请假率',
        morn_absent_count   DOUBLE        COMMENT'早上旷课人数',
        morn_absent_ratio   DOUBLE        COMMENT'早上旷课率',
        after_att_count     DOUBLE        COMMENT'下午出勤人数',
        after_att_ratio     DOUBLE        COMMENT'下午出勤率',
        after_late_count    DOUBLE        COMMENT'下午迟到人数',
        after_late_ratio    DOUBLE        COMMENT'下午迟到率',
        after_leave_count   DOUBLE        COMMENT'下午请假人数',
        after_leave_ratio   DOUBLE        COMMENT'下午请假率',
        after_absent_count  DOUBLE        COMMENT'下午旷课人数',
        after_absent_ratio  DOUBLE        COMMENT'下午旷课率',
        even_att_count      DOUBLE        COMMENT'晚上出勤人数',
        even_att_ratio      DOUBLE        COMMENT'晚上出勤率',
        even_late_count     DOUBLE        COMMENT'晚上迟到人数',
        even_late_ratio     DOUBLE        COMMENT'晚上迟到率',
        even_leave_count    DOUBLE        COMMENT'晚上请假人数',
        even_leave_ratio    DOUBLE        COMMENT'晚上请假率',
        even_absent_count   DOUBLE        COMMENT'晚上旷课人数',
        even_absent_ratio   DOUBLE        COMMENT'晚上旷课率' ,
        class_student_count longtext   COMMENT'当天班级在读人数',
        dt                  longtext   COMMENT '分区字段'

) default charset = utf8 engine=innodb;

-- presto导出语句
insert into mysql.edu_olap.edu_olap_class
select * from hive.edu_dm.dm_class_all;



```





### 学生维度

```sql

-- mysql-olap  学生建表

create table edu_olap.edu_olap_student(
    yearinfo            longtext    comment '年份',
    monthinfo           longtext    comment '月份',
    dayinfo             longtext    comment '日期',
    group_type          longtext    comment '时间类型',
    class_id            longtext    comment '班级id',
    student_id          longtext    comment '学生id',
    morn_att_count      bigint      comment '早上出勤次数',
    morn_late_count     bigint      comment '早上迟到次数',
    morn_leave_count    bigint      comment '早上请假次数',
    morn_absent_count   bigint      comment '早上旷课次数',
    after_att_count     bigint      comment '下午出勤次数',
    after_late_count    bigint      comment '下午迟到次数',
    after_leave_count   bigint      comment '下午请假次数',
    after_absent_count  bigint      comment '下午旷课次数',
    even_att_count      bigint      comment '晚上出勤次数',
    even_late_count     bigint      comment '晚上迟到次数',
    even_leave_count    bigint      comment '晚上请假次数',
    even_absent_count   bigint      comment '晚上旷课次数',
    dt                  longtext    comment '分区字段'
)comment '学生全维度表'
default charset = utf8 engine = innodb;



-- presto导出语句
insert into mysql.edu_olap.edu_olap_student
select * from hive.edu_dm.dm_student_all

```

