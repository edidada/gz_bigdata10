-- 需求1：统计期内，全部报名客户中，各校区报名人数分布。
SELECT
    count(*) AS signup_num,
    itcast_school_id,
    itcast_school_name,
    NULL AS itcast_subject_id,
    NULL AS itcast_subject_name,
    NULL AS tdepart_id,
    NULL AS tdepart_name,
    NULL AS origin_type,
    origin_type_stat AS origin_type_stat,
    payment_time_hour AS payment_time_hour,
    'campus' AS groupType,
    concat_ws('-',payment_time_year,
    payment_time_month,payment_time_day) AS tim_str
FROM edu_dwb.customer_signup_dwm
GROUP BY itcast_school_id,itcast_school_name,
origin_type_stat,
payment_time_hour,
payment_time_day,
payment_time_month,
payment_time_year;


-- 需求2：统计期内，全部报名客户中，各学科报名人数分布。
SELECT
    count(*) AS signup_num,
    NULL AS itcast_school_id,
    NULL AS itcast_school_name,
    itcast_subject_id,
    itcast_subject_name,
    NULL AS tdepart_id,
    NULL AS tdepart_name,
    NULL AS origin_type,
    origin_type_stat AS origin_type_stat,
    payment_time_hour AS payment_time_hour,
    'subject' AS groupType,
    concat_ws('-',payment_time_year,
    payment_time_month,payment_time_day) AS tim_str,
    payment_time_year,
    payment_time_month,
    payment_time_day
FROM edu_dwb.customer_signup_dwm
GROUP BY 
itcast_subject_id,itcast_subject_name,
origin_type_stat,
payment_time_hour,
payment_time_day,
payment_time_month,
payment_time_year;



-- 需求3：统计期内，已经缴费的报名客户总量。
SELECT
    count(*) AS signup_num,
    NULL AS itcast_school_id,
    NULL AS itcast_school_name,
    NULL AS itcast_subject_id,
    NULL AS itcast_subject_name,
    NULL AS tdepart_id,
    NULL AS tdepart_name,
    NULL AS origin_type,
    NULL AS origin_type_stat,
    payment_time_hour AS payment_time_hour,
    'all' AS groupType,
    concat_ws('-',payment_time_year,
    payment_time_month,payment_time_day) AS tim_str,
    payment_time_year,
    payment_time_month,
    payment_time_day
FROM edu_dwb.customer_signup_dwm
GROUP BY
payment_time_hour,
payment_time_day,
payment_time_month,
payment_time_year;

-- 需求4：总报名量中来源渠道为线上访客渠道的报名总量


SELECT
    count(*) AS signup_num,
    NULL AS itcast_school_id,
    NULL AS itcast_school_name,
    NULL AS itcast_subject_id,
    NULL AS itcast_subject_name,
    NULL AS tdepart_id,
    NULL AS tdepart_name,
    '线上' AS origin_type,
    '0' AS origin_type_stat,
    payment_time_hour AS payment_time_hour,
    'online' AS groupType,
    concat_ws('-',payment_time_year,
    payment_time_month,payment_time_day) AS tim_str,
    payment_time_year,
    payment_time_month,
    payment_time_day
FROM edu_dwb.customer_signup_dwm
where origin_type_stat = '0'
GROUP BY
payment_time_hour,
payment_time_day,
payment_time_month,
payment_time_year;







-- 需求7：统计期内，每天报名人数的趋势图。

SELECT
    count(*) AS signup_num,
    NULL AS itcast_school_id,
    NULL AS itcast_school_name,
    NULL AS itcast_subject_id,
    NULL AS itcast_subject_name,
    NULL AS tdepart_id,
    NULL AS tdepart_name,
    NULL AS origin_type,
    NULL AS origin_type_stat,
    NULL AS payment_time_hour,
    'day_count' AS groupType,
    concat_ws('-',payment_time_year,
    payment_time_month,payment_time_day) AS tim_str,
    payment_time_year,
    payment_time_month,
    payment_time_day
FROM edu_dwb.customer_signup_dwm
GROUP BY payment_time_year,
payment_time_month,
payment_time_day;



-- 需求8：统计期内，全部报名学员中，校区学科排行榜，topN。A校区b学科第一，B校区a学科第二等等。


SELECT
    count(*) AS signup_num,
    itcast_school_id,
    itcast_school_name,
    itcast_subject_id,
    itcast_subject_name,
    NULL AS tdepart_id,
    NULL AS tdepart_name,
    NULL AS origin_type,
    NULL AS origin_type_stat,
    NULL AS payment_time_hour,
    'campus_subject' AS groupType,
    concat_ws('-',payment_time_year,
    payment_time_month,payment_time_day) AS tim_str,
    payment_time_year,
    payment_time_month,
    payment_time_day
FROM edu_dwb.customer_signup_dwm
GROUP BY itcast_school_id,
         itcast_school_name,
         itcast_subject_id,
         itcast_subject_name,
         payment_time_day,
payment_time_month,
payment_time_year
ORDER BY signup_num;

-- 需求9：统计期内，全部报名学员中，不同来源渠道的报名学员占比情况。

SELECT
    count(*) AS signup_num,
    NULL AS itcast_school_id,
    NULL AS itcast_school_name,
    NULL AS itcast_subject_id,
    NULL AS itcast_subject_name,
    NULL AS tdepart_id,
    NULL AS tdepart_name,
    origin_type,
    origin_type_stat,
    payment_time_hour AS payment_time_hour,
    'channel' AS groupType,
    concat_ws('-',payment_time_year,
    payment_time_month,payment_time_day) AS tim_str,
    payment_time_year,
    payment_time_month,
    payment_time_day
FROM edu_dwb.customer_signup_dwm
GROUP BY origin_type,
origin_type_stat,
payment_time_hour,
payment_time_day,
payment_time_month,
payment_time_year;





-- 需求10：统计期内，全部报名学员中，各咨询中心的报名学员人数占比情况。

SELECT
    count(*) AS signup_num,
    NULL AS itcast_school_id,
    NULL AS itcast_school_name,
    NULL AS itcast_subject_id,
    NULL AS itcast_subject_name,
    tdepart_id,
    tdepart_name,
    NULL AS origin_type,
    origin_type_stat,
    payment_time_hour AS payment_time_hour,
    'consulting_center' AS groupType,
    concat_ws('-',payment_time_year,
    payment_time_month,payment_time_day) AS tim_str,
    payment_time_year,
    payment_time_month,
    payment_time_day
FROM edu_dwb.customer_signup_dwm
GROUP BY tdepart_id,
         tdepart_name,
	 origin_type_stat,
	 payment_time_hour,
	 payment_time_day,
	 payment_time_month,
	 payment_time_year;


























