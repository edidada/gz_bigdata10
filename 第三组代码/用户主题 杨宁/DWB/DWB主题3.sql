

create database if not exists edu_dwb;
drop table if exists edu_dwb.target_user_temp;

create table if not exists edu_dwb.target_user_temp(
--relationship
   id                          INT COMMENT 'ID',
     create_date_time            string COMMENT '创建时间',
     update_date_time            string COMMENT '最后更新时间',
    customer_id                 INT COMMENT '所属客户id',
     first_id                    INT COMMENT '第一条客户关系id',
     itcast_school_id            INT COMMENT '校区Id',
     itcast_subject_id           INT COMMENT '学科Id',
    origin_type                 string COMMENT '数据来源',
     first_customer_clue_id      INT COMMENT '第一条线索id',
     last_customer_clue_id       INT COMMENT '最后一条线索id',
     payment_state               string COMMENT '支付状态',
    payment_time                string COMMENT '支付状态变动时间',
  itcast_clazz_id             INT COMMENT '所属ems班级id',
     itcast_clazz_time           string COMMENT '报班时间',
     ems_student_id              INT COMMENT 'ems的学生id',
     course_id                   INT COMMENT '课程ID',
   relationship_appeal_id                   INT COMMENT '申诉id',
    --clazz课程表
   clazz_id                  int comment 'ems课程id(非自增)',
 clazz_itcast_school_id    string comment 'ems校区ID',
   clazz_itcast_school_name  string comment 'ems校区名称',
   clazz_itcast_subject_id   string comment 'ems学科ID',
    clazz_itcast_subject_name string comment 'ems学科名称',
    --relationship_clue
    clue_id                       int,
     clue_customer_id              int COMMENT '客户id',
     clue_customer_relationship_id int COMMENT '客户关系id',
    clue_session_id               string COMMENT '七陌会话id',

     clue_s_name                   string COMMENT '用户名称',
     clue_ip                       string COMMENT 'IP地址',
    --appeal
     appeal_id                             int comment '主键',
     employee_id                    int comment '申诉人',
     employee_name                  string comment '申诉人姓名',
    employee_department_id         int comment '申诉人部门',
    employee_tdepart_id            int comment '申诉人所属部门',
    audit_id                       int comment '稽核人id',
    audit_name                     string comment '稽核人姓名',
    audit_department_id            int comment '稽核人所在部门',
    appeal_tenant                         int,
    yearinfo                       string comment '年',
     monthinfo                      string comment '月',
     dayinfo                        string comment '日',
    hourinfo                       string comment '小时',


  --empoloee 员工表
     em_empoloee_id                           int,
    em_email                        string comment '公司邮箱，OA登录账号',
     em_department_id                string comment 'OA中的部门编号，有负值',
     em_department_name              string comment 'OA中的部门名',
    em_superior_leaders_id          int    comment '上级领导ID',
     em_tdepart_id                   int    comment '直属部门',


--     customer  客户静态信息表
     cu_customer_relationship_id int,
    cu_bxg_student_id           string,
     cu_md_id                    int,
     cu_start_date               string,

--     学科表
    sub_id               int,
     sub_name             string,
     sub_code             string,
    sub_tenant           int,

-- 校区表
     sc_id               int,
     sc_name             string,
     sc_code             string,
    sc_tenant           string


)comment '报名用户主题'
partitioned by (dt string)
row format delimited fields terminated by '\t'
stored as orc tblproperties ('orc.compress'= 'SNAPPY');