-- 导入employee的数据（全量方式）
-- 员工表
insert overwrite table edu_dwd.dim_employee
select * from edu_ods.employee;

--全量覆盖
--学校表
insert overwrite table edu_dwd.dim_itcast_school
select * from edu_ods.itcast_school;

--全量覆盖
--学科表
insert overwrite table edu_dwd.dim_itcast_subject
select * from edu_ods.itcast_subject;

--全量覆盖
--部门表
insert overwrite table edu_dwd.dim_crm_department
select * from edu_ods.scrm_department;