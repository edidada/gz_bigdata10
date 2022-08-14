

--开启动态分区方式
set hive.exec.dynamic.partition=true;
--设置动态分区用非严格模式
set hive.exec.dynamic.partition.mode=nonstrict;
--开启hive中间MapReduce过程压缩
set hive.exec.compress.intermediate=true;
--开启hive的保存文件的压缩
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;
set hive.auto.convert.join=true;  -- 开启map join的支持, 默认就是true
set hive.auto.convert.join.noconditionaltask.size=51200000;-- 默认为 20971520 (20M)
set hive.auto.convert.join= false;
drop database edu_dwb;
create database if not exists edu_dwb;
drop table target_user
;
create table edu_dwb.target_user_;

insert overwrite table edu_dwb.target_user_temp partition(dt)
select
--        customer_relationship
       relationship.id,
       relationship.create_date_time,
       relationship.update_date_time,
       relationship.customer_id,
       first_id,
       relationship.itcast_school_id,
       relationship.itcast_subject_id,
       relationship.origin_type,
       first_customer_clue_id,
       last_customer_clue_id,
       payment_state,
       payment_time,
       itcast_clazz_id,
       itcast_clazz_time,
       ems_student_id,
       relationship.course_id,
       appeal_id,


--        课程表itcast_clazz
       clazz.id,
       clazz.itcast_school_id,
       itcast_school_name,
       clazz.itcast_subject_id,
       itcast_subject_name,


--    relationship_clue
       clue.id,
       clue.customer_id,
       clue.customer_relationship_id,
       session_id,
       s_name,
       ip,


-- appeal
       appeal.id,
       employee_id,
       employee_name,
       employee_department_id,
       employee_tdepart_id,
       audit_id,
       audit_name,
       audit_department_id,
       appeal.tenant,
       appeal.yearinfo,
       appeal.monthinfo,
       appeal.dayinfo,
       appeal.hourinfo,

-- employee
       employees.id                             as em_empoloee_id         ,
       employees.email                          as em_email               ,

       department_id                            as em_department_id       ,
       department_name                          as em_department_name     ,
       superior_leaders_id                      as em_superior_leaders_id ,
       tdepart_id                               as em_tdepart_id          ,



--customer
       customers.customer_relationship_id       as  cu_customer_relationship_id ,

       bxg_student_id                           as  cu_bxg_student_id           ,
       md_id                                    as  cu_md_id                    ,
       customers.start_date                     as  cu_start_date               ,

    -- 学科subject
       subject.id                              as sub_id              ,

       subject.name                            as sub_name            ,
       subject.code                            as sub_code            ,
       subject.tenant                          as sub_tenant          ,

-- 学区表school
       school.id,
       school.name                              as sc_deleted         ,
       school.code                              as sc_name            ,
       school.tenant                            as sc_code,
       relationship.start_date as dt

from (select * from edu_dwd.fact_customer_relationship where end_date='9999-99-99') as relationship
left join (select * from edu_dwd.fact_itcast_clazz where end_time='9999-99-99') as clazz on relationship.itcast_clazz_id = clazz.id
left join (select * from edu_dwd.fact_customer_clue where end_date='9999-99-99') as clue on relationship.id = clue.customer_relationship_id
left join edu_dwd.fact_customer_appeal  as appeal on relationship.id = appeal.customer_relationship_first_id
left join edu_dwd.dim_employee as employees on relationship.creator = employees.id
left join (select * from edu_dwd.fact_customer where end_date='9999-99-99') as customers on customers.id = relationship.customer_id
left join edu_dwd.dim_itcast_subject as subject on relationship.itcast_subject_id = subject.id
left join edu_dwd.dim_itcast_school  as school on relationship.itcast_school_id = school.id;



insert overwrite table edu_dwb.target_user partition (dt)
select * from target_user_temp;
