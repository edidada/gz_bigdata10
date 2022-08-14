#全量覆盖

# ods_employee 全量覆盖
sqoop import  \
--connect jdbc:mysql://106.75.33.59:3306/scrm  \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select  *  from employee  where 1=1 and  \$CONDITIONS"  \
--hcatalog-database edu_ods \
--hcatalog-table employee   \
-m 1


# ods_itcast_school全量覆盖

sqoop import \
--connect jdbc:mysql://106.75.33.59:3306/scrm \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query " select * from itcast_school where 1=1 and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table itcast_school  \
-m 1

# ods_itcast_subject全量覆盖

sqoop import \
--connect jdbc:mysql://106.75.33.59:3306/scrm \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query " select * from itcast_subject where 1=1 and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table itcast_subject  \
-m 1


# ods_scrm_department全量覆盖

sqoop import \
--connect jdbc:mysql://106.75.33.59:3306/scrm \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query " select * from scrm_department where 1=1 and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table scrm_department  \
-m 1



# 仅新增
# ods_customer_appeal仅新增

sqoop import \
--connect jdbc:mysql://106.75.33.59:3306/scrm \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query " select *,'2022-06-04' as dt from customer_appeal where 1=1 and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table customer_appeal  \
-m 1


# ods_itcast_clazz仅新增

sqoop import \
--connect jdbc:mysql://106.75.33.59:3306/scrm \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query " select *,'2022-06-04' as dt from itcast_clazz where create_date_time<='2022-06-04 23:59:59' and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table itcast_clazz  \
-m 1



# 新增及更新
ods_customer_clue新增及更新

sqoop import \
--connect jdbc:mysql://106.75.33.59:3306/scrm \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query " select *,'2022-06-04' as dt from customer_clue where create_date_time<='2022-06-04 23:59:59' or update_date_time<='2022-06-04 23:59:59' and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table customer_clue  \
-m 1

# ods_customer_relationship新增及更新

sqoop import \
--connect jdbc:mysql://106.75.33.59:3306/scrm \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query " select *,'2022-06-04' as dt from customer_relationship where create_date_time<='2022-06-04 23:59:59' or update_date_time<='2022-06-04 23:59:59' and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table customer_relationship  \
-m 1

# ods_customer新增及更新

sqoop import \
--connect jdbc:mysql://106.75.33.59:3306/scrm \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query " select *,'2022-06-04' as dt from customer where create_date_time<='2022-06-04 23:59:59' or update_date_time<='2022-06-04 23:59:59' and \$CONDITIONS" \
--hcatalog-database edu_ods \
--hcatalog-table customer  \
-m 1

