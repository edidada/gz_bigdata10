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


--考勤宽表转换
with test1 as(                     --判断数字:2为出勤,1为迟到,0判断为打卡在其他时间段
    select 
        dt,
        class_id,
        class_date,
        studying_student_count,
        student_id,
        case                                --判断上午出勤情况 
            when substr(signin_time,12,8)>=morning_begin_time_40_before and substr(signin_time,12,8)<=morning_begin_time_10_after
            then '2'
            when substr(signin_time,12,8)>=morning_begin_time_10_after and substr(signin_time,12,8)<=morning_end_time
            then '1'
            else '0'
            end
            as morning_type,
        case                                --判断下午出勤情况
            when substr(signin_time,12,8)>=afternoon_begin_time_40_before and substr(signin_time,12,8)<=afternoon_begin_time_10_after
            then '2'
            when substr(signin_time,12,8)>=afternoon_begin_time_10_after and substr(signin_time,12,8)<=afternoon_end_time
            then '1'
            else '0'
            end
            as afternoon_type,
        case                                --判断晚上出勤情况
            when substr(signin_time,12,8)>=evening_begin_time_40_before and substr(signin_time,12,8)<=evening_begin_time_10_after
            then '2'
            when substr(signin_time,12,8)>=evening_begin_time_10_after and substr(signin_time,12,8)<=evening_end_time
            then '1'
            else '0'
            end
            as evening_type
    from edu_dwb.kaoqing),

test2 as(
    select 
        dt,
        class_id,
        class_date,
        studying_student_count,
        student_id,
        max(morning_type) over (partition by student_id,dt) as morning_type_sum,        --上午单人出勤情况
        max(afternoon_type) over (partition by student_id,dt) as afternoon_type_sum,    --下午单人出勤情况
        max(evening_type) over (partition by student_id,dt) as evening_type_sum,         --晚上单人出勤情况
        row_number() over(partition by student_id,dt) as rn
    from test1),


--请假宽表转换
test4 as(              --判断数字:1判断为请假,0判断为未请假
    select 
        dt,
        class_id,
        class_date,
        studying_student_count,
        student_id,
        case
            when morning_begin_time>=substr(begin_time,12,8) and morning_end_time<=substr(end_time,12,8) 
            then '1'
            else '0'
            end
            as morning_leave,
        case
            when afternoon_begin_time>=substr(begin_time,12,8) and afternoon_end_time<=substr(end_time,12,8) 
            then '1'
            else '0'
            end
            as afternoon_leave,
        case
            when evening_begin_time>=substr(begin_time,12,8) and evening_end_time<=substr(end_time,12,8) 
            then '1'
            else '0'
            end
            as evening_leave
    from edu_dwb.kaoqing_leave),
    
test5 as(
    select 
        dt,
        class_id,
        class_date,
        studying_student_count,
        student_id,
        max(morning_leave) over(partition by student_id,dt) as morning_leave_sum,               --上午单人请假情况
        max(afternoon_leave) over(partition by student_id,dt) as afternoon_leave_sum,               --下午单人请假情况
        max(evening_leave) over(partition by student_id,dt) as evening_leave_sum,               --晚自习单人请假情况
        row_number() over(partition by student_id,dt) as rn2                                --根据学生,打卡日期去重
    from test4),


test7 as(                                                       
    select                                                                                  --班级和日期汇总早上的正常和迟到情况
        dt, 
        class_id,
        student_id,
        class_date,
        studying_student_count,         
        if (morning_type_sum='2',1,0) as normal,
        if (morning_type_sum='1',1,0) as late,
        0  as leave,
        'morning_kaoqing' as kaoqing_type
        from test2
    where rn='1'

    union

    select                                                                                  --班级和日期汇总下午的正常和迟到情况
        dt, 
        class_id,
        student_id,
        class_date,
        studying_student_count ,         
        if (afternoon_type_sum='2',1,0) as normal,
        if (afternoon_type_sum='1',1,0) as late,
        0  as leave,
        'afternoon_kaoqing' as kaoqing_type
        from test2
    where rn='1'
        
    union

    select                                                                                  --班级和日期汇总晚自习的正常和迟到情况
        dt, 
        class_id,
        student_id,
        class_date,
        studying_student_count,         
        if (evening_type_sum='2',1,0) as normal,
        if (evening_type_sum='1',1,0) as late,
        0  as leave,
        'evening_kaoqing' as kaoqing_type
        from test2
    where rn='1'

    union

    select                                                                                  --班级和日期汇总早上的请假情况
        dt,
        class_id,
        student_id,
        class_date, 
        studying_student_count ,
        0 as normal,
        0 as late,
        if(morning_leave_sum='1',1,0) as leave,
        'morning_kaoqing' as kaoqing_type
    from test5
    where rn2='1'

    union

    select                                                                                  --班级和日期汇总下午的请假情况
        dt,
        class_id,
        student_id,
        class_date, 
        studying_student_count,
        0 as normal,
        0 as late,
        if(afternoon_leave_sum='1',1,0) as leave,
        'afternoon_kaoqing' as kaoqing_type
    from test5
    where rn2='1'

    union

    select                                                                                  --班级和日期汇总晚自习的请假情况
        dt,
        class_id,
        student_id,
        class_date, 
        studying_student_count ,
        0 as normal,
        0 as late,
        if(evening_leave_sum='1',1,0) as leave,
        'evening_kaoqing' as kaoqing_type
    from test5
    where rn2='1')

insert into edu_dws.kaoqing_student PARTITION(dt)
select                                                                                      --班级、日期、时间段汇总全部考勤情况
    cast(class_id as string) as class_id ,
    cast(student_id as string) as student_id,
    substr(max(class_date),1,4) as year,
    substr(max(class_date),1,7) as month,
    max(class_date) as class_date, 
    max(studying_student_count) as studying_student_count,
    max(normal) as normal,
    max(late) as late,
    max(leave) as leave,
    kaoqing_type,
    dt
    from test7
    group by student_id,class_id,dt,kaoqing_type;
