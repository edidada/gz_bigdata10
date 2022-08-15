```sql
INSERT into  edu_dm.itcast_intention_dm
select
    count(distinct (customer_id)) as customer_total,
    count(if(appeal_status != 1 or appeal_status is null, customer_relationship_first_id , null)) as clue_cnt ,             --有效线索总数
    yearinfo,
    monthinfo,
    dayinfo,
    hourinfo,
    area,
    itcast_subject_id,
    itcast_subject_name,
    itcast_school_id,
    itcast_school_name,
    origin_type, -- 渠道来源
    origin_type_stat,  -- 线上线下: 对origin_type 更小粒度的细分
    tdepart_id,
    tdepart_name,
    clue_state_stat, -- 新老顾客
   CASE
        WHEN grouping(hourinfo)=0 THEN 'hour'
        WHEN grouping(dayinfo)=0 THEN 'day'
        WHEN grouping(monthinfo)=0 THEN 'mouth'
        WHEN grouping(yearinfo)=0 THEN 'year'
    END
        as time_type, -- 时间维度
    case
        when grouping(area)=0
        then 'area'
        when grouping(itcast_subject_id)=0
        then '学科'
        when grouping(itcast_school_id)=0
        then '校区'
        when grouping(origin_type)=0
        then '来源渠道'
        when grouping(tdepart_id)=0
        then '咨询中心'
        when grouping(clue_state_stat)=0
        then '新老客户'
        else '总意向量'
    end
    as group_type,  -- 组合维度

    case
        when grouping(yearinfo)= 0 then substring(yearinfo,1,4)
        when grouping(monthinfo)= 0 then substring(monthinfo,6,7)
        when grouping(dayinfo)=0 then substring(dayinfo,9,10)
        when grouping(hourinfo)= 0 then substring(hourinfo,12,13)
    end
    as time_strm -- 时间明细 方便报表层

from hive.edu_dwb.dwb_customer_intention_dwb
 group by
    grouping sets(
        -- time_type：年
        (yearinfo),
        (yearinfo, origin_type_stat, clue_state_stat),
        (yearinfo, origin_type, clue_state_stat),
        (yearinfo, area, clue_state_stat),
        (yearinfo, itcast_subject_id,itcast_subject_name ,clue_state_stat),
        (yearinfo, itcast_school_id, itcast_school_name,clue_state_stat),
        (yearinfo, tdepart_id,tdepart_name, clue_state_stat),
        (yearinfo,  clue_state_stat),

        -- time_type：月
        (yearinfo, monthinfo),
        (yearinfo, monthinfo, origin_type_stat, clue_state_stat),
        (yearinfo, monthinfo, origin_type, clue_state_stat),
        (yearinfo, monthinfo, area, clue_state_stat),
        (yearinfo, monthinfo, itcast_subject_id, itcast_subject_name,clue_state_stat),
        (yearinfo, monthinfo, itcast_school_id, itcast_school_name,clue_state_stat),
        (yearinfo, monthinfo, tdepart_id,tdepart_name ,clue_state_stat),
        (yearinfo, monthinfo, clue_state_stat),

        -- time_type：天
        (yearinfo, monthinfo, dayinfo),
        (yearinfo, monthinfo, dayinfo, origin_type_stat, clue_state_stat),
        (yearinfo, monthinfo, dayinfo, origin_type, clue_state_stat ),
        (yearinfo, monthinfo, dayinfo, area, clue_state_stat ),
        (yearinfo, monthinfo, dayinfo, itcast_subject_id, itcast_subject_name,clue_state_stat ),
        (yearinfo, monthinfo, dayinfo, itcast_school_id, itcast_school_name,clue_state_stat ),
        (yearinfo, monthinfo, dayinfo, tdepart_id,tdepart_name, clue_state_stat ),
        (yearinfo, monthinfo, dayinfo, clue_state_stat ),

        -- time_type：小时
        (yearinfo, monthinfo, dayinfo, hourinfo),
        (yearinfo, monthinfo, dayinfo, hourinfo, origin_type_stat, clue_state_stat),
        (yearinfo, monthinfo, dayinfo, hourinfo, origin_type, clue_state_stat),
        (yearinfo, monthinfo, dayinfo, hourinfo, area, clue_state_stat),
        (yearinfo, monthinfo, dayinfo, hourinfo, itcast_subject_id, itcast_subject_name,clue_state_stat),
        (yearinfo, monthinfo, dayinfo, hourinfo, itcast_school_id, itcast_school_name,clue_state_stat),
        (yearinfo, monthinfo, dayinfo, hourinfo, tdepart_id,tdepart_name, clue_state_stat),
        (yearinfo, monthinfo, dayinfo, hourinfo,  clue_state_stat)

    )


-- select origin_type from hive.edu_dwb.dwb_customer_intention_dwb group by origin_type;
-- select customer_id  from hive.edu_dwb.dwb_customer_intention_dwb group by customer_id;


-- select  * from hive.edu_dm.itcast_intention_dm;
--
-- drop table  hive.edu_dm.itcast_intention_dm;

-- select appeal_status from hive.edu_dwb.dwb_customer_intention_dwb group by appeal_status;

select count (1) from hive.edu_dm.itcast_intention_dm;
```

