
insert  into edu_dm.customer_signup_dm
with groupbyall as (
select
    sum(coalesce (customer_num,0))
     as customer_num,
   itcast_school_id ,
   itcast_school_name ,
   itcast_subject_id ,
   itcast_subject_name ,
   tdepart_id ,
   tdepart_name ,
   origin_type,
   origin_type_num,
   case
        when grouping (origin_type)=0
        then 'origin_type'
        when grouping (tdepart_id)=0
        then 'tdepart'
        when grouping (itcast_school_id)=0
        then 'sch-sub'
        when grouping (origin_type_num)=0
        then 'origin_num'
        else 'all'
    end as  group_type_dm ,
    group_type as group_type_dws,
    case
        when grouping (payment_day)=0
        then 'day'
        when grouping (payment_month)=0
        then 'month'
        when grouping (payment_year)=0
        then 'year'
    end as  time_type ,
   concat(payment_year,if(payment_month is null,'',concat('-',payment_month)),if(payment_day is null,'',concat('-',payment_day)))
   as time_str ,
   payment_year ,
   payment_month ,
   payment_day
from edu_dws.customer_signup_dws
group by
grouping sets (

    -- 年
    (payment_year),
    (payment_year,origin_type_num),
    (payment_year,origin_type_num,origin_type),
    (payment_year,origin_type_num,tdepart_id,tdepart_name),
    (payment_year,origin_type_num,itcast_school_id,itcast_school_name,itcast_subject_id,itcast_subject_name)

     -- 月
    (payment_year,payment_month),
    (payment_year,payment_month,origin_type_num),
    (payment_year,payment_month,origin_type_num,origin_type),
    (payment_year,payment_month,origin_type_num,tdepart_id,tdepart_name),
    (payment_year,payment_month,origin_type_num,itcast_school_id,itcast_school_name,itcast_subject_id,itcast_subject_name)

     -- 日
     (payment_year,payment_month,payment_day),
    (payment_year,payment_month,payment_day,origin_type_num),
    (payment_year,payment_month,payment_day,origin_type_num,origin_type),
    (payment_year,payment_month,payment_day,origin_type_num,tdepart_id,tdepart_name),
    (payment_year,payment_month,payment_day,origin_type_num,itcast_school_id,itcast_school_name,itcast_subject_id,itcast_subject_name)
)
)
select
   g.customer_num,
   itcast_school_id ,
   itcast_school_name ,
   itcast_subject_id ,
   itcast_subject_name ,
   tdepart_id ,
   tdepart_name ,
   origin_type,
   origin_type_num,
   g.group_type_dm ,
   g.time_type ,
   g.time_str ,
   payment_year ,
   payment_month ,
   payment_day
from groupbyall g
where g.group_type_dm=g.group_type_dws;

