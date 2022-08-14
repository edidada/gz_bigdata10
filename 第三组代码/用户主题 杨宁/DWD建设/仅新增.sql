-- 假设 在2022-05-24日开始运行首日初始化脚本，应该将2022-05-23日及历史数据导入到 DWD表的2022-05-23日的分区
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





--仅新增  报名课程表itcast_clazz   事实表
-- 开启动态分区
-- 首次导入仅新增数据
alter table edu_dwd.fact_itcast_clazz
    drop partition (dt !='');
insert overwrite table edu_dwd.fact_itcast_clazz partition (dt)
select *
from edu_ods.itcast_clazz
where dt <= '2022-06-04 23:59:59';


-- 仅新增
--申诉表



alter table edu_dwd.fact_customer_appeal drop partition (dt !='');
insert overwrite table edu_dwd.fact_customer_appeal partition (dt)
select id,
       customer_relationship_first_id,
       employee_id,
       employee_name,
       employee_department_id,
       employee_tdepart_id,
       appeal_status,
       audit_id,
       audit_name,
       audit_department_id,
       audit_department_name,
       audit_date_time,
       create_date_time,
       update_date_time,
       deleted,
       tenant,
       null as yearinfo,
       null as monthinfo,
       null as dayinfo,
       null as hourinfo,
       dt
from edu_ods.customer_appeal where dt <='2022-06-04';