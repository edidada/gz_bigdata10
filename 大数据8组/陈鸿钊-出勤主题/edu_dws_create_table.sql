--创建dwb层
create database if not exists edu_dws;
use edu_dws;

--创建学生请假情况汇总表
Drop table if EXISTS edu_dws.kaoqing_student;
create table edu_dws.kaoqing_student(
    class_id	            string 	comment'班级id',
    student_id	            string 	comment'学员id',
    year                    string  comment'年',
    month                   string  comment'月',
    class_date      	string	comment'上课日期',
    studying_student_count	        string	comment'在读班级人数',
    normal                  int  comment'正常打卡',
    late                    int  comment'迟到',
    leave                   int  comment'请假',
    kaoqing_type            string  comment'考勤时间段'
)
COMMENT '请假宽表'
PARTITIONED BY(dt STRING)
row format delimited fields terminated by '\t'
stored as orc
tblproperties ('orc.compress' = 'SNAPPY');