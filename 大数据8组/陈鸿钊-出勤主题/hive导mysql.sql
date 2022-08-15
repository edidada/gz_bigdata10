create table mysql.edu_dws.kaoqing_student(
    class_id	            varchar 	comment'班级id',
    student_id	            varchar 	comment'学员id',
    year                    varchar  comment'年',
    month                   varchar  comment'月',
    class_date      	varchar	comment'上课日期',
    studying_student_count	     varchar	comment'在读班级人数',
    normal                  int  comment'正常打卡',
    late                    int  comment'迟到',
    leave                   int  comment'请假',
    kaoqing_type            varchar  comment'考勤时间段',
    dt                      varchar
) ;

insert into mysql.edu_dws.kaoqing_student
select * from hive.edu_dws.kaoqing_student;