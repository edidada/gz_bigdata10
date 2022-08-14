edu_project_dwb_宽表插入数据

```sql

insert overwrite table edu_dwb.dwb_customer_intention_dwb partition (dt) 
select

-- customer_relationship as cr
    cr.create_date_time,
    cr.customer_id,
    cr.id,
    cr.origin_type_state,
    cr.itcast_subject_id,
    cr.itcast_school_id,
    cr.creator,
 
-- customer_clue as cc 
    cc.customer_relationship_id,
    cc.clue_state_stat,
    
    cc.platform,
    cc.deleted,
    cc.clue_appeal_state,
    c.area,
    cc.valid,
    cc.is_repeat,
    cc.follow_type,
-- customer
-- c.area
    
-- itcast_subject as sj
    sj.name asitcast_subject_name ,
-- itcast_school as sc
    sc.name as itcast_school_name,
--employee as e
    e.tdepart_id,
-- scrm_department as cd
    cd.name as tdepart_name,
-- customer_appeal as ca
    ca.customer_relationship_first_id,
    ca.appeal_status,
    substring(cr.create_date_time,1,4) as yearinfo,
    substring(cr.create_date_time, 1, 7)as monthinfo,
    substring(cr.create_date_time, 1, 10)as dayinfo,
    substring(cr.create_date_time, 1, 13) as hourinfo,
    cr.dt

from edu_dwd.fact_customer_relationship as cr
left join edu_dwd.fact_customer_appeal ca on ca.customer_relationship_first_id=cr.id
left join edu_dwd.dim_employee e on e.id=cr.creator
left join edu_dwd.dim_scrm_deparment cd on cd.id=e.tdepart_id
left join edu_dwd.dim_itcast_school sc on sc.id=cr.itcast_school_id
left join edu_dwd.dim_itcast_subject sj on sj.id=cr.itcast_subject_id
left join edu_dwd.fact_customer_clue cc on cc.customer_relationship_id=cr.id 
left join edu_dwd.dim_customer c on c.id=cr.customer_id ;


select *  from dwb_customer_intention_dwb;
```

