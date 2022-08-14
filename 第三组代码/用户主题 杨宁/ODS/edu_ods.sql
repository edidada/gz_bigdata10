drop database if exists edu_ods;
create database if not exists edu_ods;

drop table if exists edu_ods.customer_relationship;
create table if not exists edu_ods.customer_relationship(
    id                          int,

    create_date_time            string                    comment '创建的时间',
    update_date_time            string                    comment '最后更新时间',
    deleted                     string                       comment '是否被删除（禁用）',
    customer_id                 int                           comment '所属客户id',
    first_id                    int                                      comment '第一条客户关系id',
    belonger                    int                                      comment '归属人',
    belonger_name               string                              comment '归属人姓名',
    initial_belonger            int                                      comment '初始归属人',
    distribution_handler        int                                      comment '分配处理人',
    business_scrm_department_id int                              comment '归属部门',
    last_visit_time             string                                 comment '最后回访时间',
    next_visit_time             string                                 comment '下次回访时间',
    origin_type                 string              comment '数据来源',
    itcast_school_id            int                                      comment '校区Id',
    itcast_subject_id           int                                      comment '学科Id',
    intention_study_type        string              comment '意向学习方式',
    anticipat_signup_date       date                                     comment '预计报名时间',
    level                       string                               comment '客户级别',
    creator                     int                                      comment '创建人',
    current_creator             string                                      comment '当前创建人：初始==创建人，当在公海拉回时为 拉回人',
    creator_name                string                     comment '创建者姓名',
    origin_channel              string              comment '来源渠道',
    COMMENT                     string                            ,
    first_customer_clue_id      int                              comment '第一条线索id',
    last_customer_clue_id       int                              comment '最后一条线索id',
    process_state               string                              comment '处理状态',
    process_time                string                                 comment '处理状态变动时间',
    payment_state               string                              comment '支付状态',
    payment_time                string                                 comment '支付状态变动时间',
    signup_state                string              comment '报名状态',
    signup_time                 string                                 comment '报名时间',
    notice_state                string                              comment '通知状态',
    notice_time                 string                                 comment '通知状态变动时间',
    lock_state                  int                         comment '锁定状态',
    lock_time                   string                                 comment '锁定状态修改时间',
    itcast_clazz_id             int                                      comment '所属ems班级id',
    itcast_clazz_time           string                                 comment '报班时间',
    payment_url                 string                 comment '付款链接',
    payment_url_time            string                                 comment '支付链接生成时间',
    ems_student_id              int                                      comment 'ems的学生id',
    delete_reason               string                              comment '删除原因',
    deleter                     int                                      comment '删除人',
    deleter_name                string                              comment '删除人姓名',
    delete_time                 string                                 comment '删除时间',
    course_id                   int                                      comment '课程ID',
    course_name                 string                              comment '课程名称',
    delete_comment              string                 comment '删除原因说明',
    close_state                 string                              comment '关闭装填',
    close_time                  string                                 comment '关闭状态变动时间',
    appeal_id                   int                                      comment '申诉id',
    tenant                      int                             comment '租户',
    total_fee                   int                          comment '报名费总金额',
    belonged                    int                                      comment '小周期归属人',
    belonged_time               string                                 comment '归属时间',
    belonger_time               string                                 comment '归属时间',
    transfer                    int                                      comment '转移人',
    transfer_time               string                                 comment '转移时间',
    follow_type                 int                          comment '分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取',
    transfer_bxg_oa_account     string                              comment '转移到博学谷归属人OA账号',
    transfer_bxg_belonger_name  string                              comment '转移到博学谷归属人OA姓名'
    
)partitioned by(dt string)
row format delimited fields terminated by '\t'
stored AS orc tblproperties ('orc.compress' = 'zlib');

create table if not exists edu_ods.customer_appeal(
     id                            int                                     comment '主键',

    customer_relationship_first_id int                                 comment '第一条客户关系id',
    employee_id                    int                                 comment '申诉人',
    employee_name                  string                              comment '申诉人姓名',
    employee_department_id         int                                 comment '申诉人部门',
    employee_tdepart_id            int                                 comment '申诉人所属部门',
    appeal_status                  int                                 comment '申诉状态，0:待稽核 1:无效 2：有效',
    audit_id                       int                                 comment '稽核人id',
    audit_name                     string                              comment '稽核人姓名',
    audit_department_id            int                                 comment '稽核人所在部门',
    audit_department_name          string                              comment '稽核人部门名称',
    audit_date_time               string                          comment '稽核时间',
    create_date_time              string                          comment '创建时间（申诉时间）',
    update_date_time               string                          comment '更新时间',
    deleted                        int                                 comment '删除标志位',
    tenant                         int
)partitioned by(dt string)
row format delimited
    fields terminated by '\t'
stored AS orc tblproperties ('orc.compress' = 'zlib');



