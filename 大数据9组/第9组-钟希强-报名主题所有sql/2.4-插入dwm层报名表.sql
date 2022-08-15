

--分区
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=100000;
set hive.exec.max.created.files=150000;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;
--分桶
set hive.enforce.bucketing=true;
set hive.enforce.sorting=true;

-- 关掉所有的mapjoin优化
set hive.auto.convert.join=false;
set hive.optimize.bucketmapjoin=false;
set hive.auto.convert.sortmerge.join=false;
set hive.optimize.bucketmapjoin.sortedmerge=false;
set hive.auto.convert.sortmerge.join.noconditionaltask=false;



insert overwrite table edu_dwm.customer_detail_dwm partition (dt)
select
    cr.customer_id ,
    cr.itcast_school_id ,
    sch.name as itcast_school_name ,
    cr.itcast_subject_id ,
    sub.name as itcast_subject_name ,
    emp.tdepart_id ,
    dep.name as tdepart_name ,
    cr.origin_type ,
    cr.origin_type_num ,
    cc.clue_state ,
    cc.clue_state_num ,
    cr.payment_hour ,
    cr.payment_year ,
    cr.payment_month ,
    cr.payment_day ,
    cr.dt
from edu_dwd.customer_relationship_pay cr
LEFT JOIN edu_ods.itcast_clazz cla on cr.itcast_clazz_id = cla.id
LEFT JOIN edu_ods.itcast_school sch on cr.itcast_school_id = sch.id
LEFT JOIN edu_ods.itcast_subject sub on cr.itcast_subject_id = sub.id
LEFT JOIN edu_dwd.customer_clue_dt cc on cr.id = cc.customer_relationship_id
LEFT JOIN edu_ods.employee emp on cr.creator = emp.id
LEFT JOIN edu_ods.scrm_department dep on emp.tdepart_id = dep.id;

