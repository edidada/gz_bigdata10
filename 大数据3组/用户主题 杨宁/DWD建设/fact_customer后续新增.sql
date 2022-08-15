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

use edu_dwd;

insert overwrite table edu_dwd.fact_customer partition (start_date)

select old.id,
       old.customer_relationship_id,
       old.create_date_time,
       old.update_date_time,
       old.deleted,
       old.name,
       old.idcard,
       old.birth_year,
       old.gender,
       old.phone,
       old.wechat,
       old.qq,
       old.email,
       old.area,
       old.leave_school_date,
       old.graduation_date,
       old.bxg_student_id,
       old.creator,
       old.origin_type,
       old.origin_channel,
       old.tenant,
       old.md_id,
        case when new.id is null or old.end_date !='9999-99-99' then old.end_date
           else date_add('2022-05-24',-1)
               end  as end_date,
       old.start_date
from (select * from edu_dwd.fact_customer where start_date <= '2022-06-04'  ) as old
left join (select * from edu_ods.customer where dt = '2022-06-05') as new
union all
select id,
       customer_relationship_id,
       create_date_time,
       update_date_time,
       deleted,
       name,
       idcard,
       birth_year,
       gender,
       phone,
       wechat,
       qq,
       email,
       area,
       leave_school_date,
       graduation_date,
       bxg_student_id,
       creator,
       origin_type,
       origin_channel,
       tenant,
       md_id,
       '9999-99-99' as end_date,
       dt as start_date
from edu_ods.customer where dt='2022-06-05'

