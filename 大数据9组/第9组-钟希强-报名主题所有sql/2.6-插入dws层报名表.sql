

insert into hive.edu_dws.customer_signup_dws
select
   count (distinct  customer_id)
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
    end as  group_type ,
   concat(payment_year,'-',payment_month,'-',payment_day)
   as time_str ,
   payment_year ,
   payment_month ,
   payment_day
from hive.edu_dwm.customer_detail_dwm
group by
grouping sets (
    (payment_year,payment_month,payment_day),
    (payment_year,payment_month,payment_day,origin_type_num),
    (payment_year,payment_month,payment_day,origin_type_num,origin_type),
    (payment_year,payment_month,payment_day,origin_type_num,tdepart_id,tdepart_name),
    (payment_year,payment_month,payment_day,origin_type_num,itcast_school_id,itcast_school_name,itcast_subject_id,itcast_subject_name)
);
