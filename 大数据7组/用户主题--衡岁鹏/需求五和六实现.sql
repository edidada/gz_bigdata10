# --需求5：统计期内，新增的意向客户中报名的客户占比。全部报名人数 / 全部新增的意向人数
-- 天
select
       CONCAT(signup_num.num / total_num.num * 100,'%')
    'sign_num_trans',
   total_num.date_day 'date_day',signup_num.num
from(SELECT count( 1 ) AS num,

     DATE_FORMAT( cr.create_date_time, '%Y-%m-%d' ) AS date_day
     FROM
     customer_relationship cr
     GROUP BY
     DATE_FORMAT( cr.create_date_time, '%Y-%m-%d' )
    ) total_num
    INNER JOIN (
     SELECT
     count( 1 ) AS num,

     DATE_FORMAT( cr.create_date_time, '%Y-%m-%d' ) AS date_day
    FROM
            customer_relationship cr
        WHERE
            cr.payment_state = 'PAID'
        GROUP BY
            DATE_FORMAT( cr.create_date_time, '%Y-%m-%d' )
    ) signup_num ON total_num.date_day = signup_num.date_day
;
-- 月
select CONCAT(signup_num.num / total_num.num * 100,'%')
    'sign_num_trans',
   total_num.month 'month',signup_num.num
from(SELECT count( 1 ) AS num,
     DATE_FORMAT( cr.create_date_time, '%Y-%m' ) AS month
     FROM
     customer_relationship cr
     GROUP BY
     DATE_FORMAT( cr.create_date_time, '%Y-%m' )
    ) total_num
    INNER JOIN (
     SELECT
     count( 1 ) AS num,
     DATE_FORMAT( cr.create_date_time, '%Y-%m' ) AS month
    FROM
            customer_relationship cr
        WHERE
            cr.payment_state = 'PAID'
        GROUP BY
            DATE_FORMAT( cr.create_date_time, '%Y-%m' )
    ) signup_num ON total_num.month = signup_num.month;
-- 年
select CONCAT(signup_num.num / total_num.num * 100,'%')
    'sign_transfer',
   total_num.year 'year',signup_num.num

from(SELECT count( 1 ) AS num,
     DATE_FORMAT( cr.create_date_time, '%Y' ) AS year
     FROM
     customer_relationship cr
     GROUP BY
     DATE_FORMAT( cr.create_date_time, '%Y' )
    ) total_num
    INNER JOIN (
     SELECT
     count( 1 ) AS num,
     DATE_FORMAT( cr.create_date_time, '%Y' ) AS year
    FROM
            customer_relationship cr
        WHERE
            cr.payment_state = 'PAID'
        GROUP BY
            DATE_FORMAT( cr.create_date_time, '%Y' )
    ) signup_num ON total_num.year = signup_num.year;
# --需求6：线上报名量 / 线上有效线索量，与上一个指标类似，此处的线索量需要排除已申诉数据。
-- 天
SELECT
    CONCAT(
        signup_num.num / total_num.num * 100,
        '%'
    ) 'sign_num_valid',
    total_num.date_day,
    signup_num.num
from
    (
    SELECT
       count( 1 ) AS num,
       DATE_FORMAT( cr.create_date_time, '%Y-%m-%d' ) AS date_day
   FROM
       customer_clue cc
       LEFT JOIN customer_relationship cr ON cr.id = cc.customer_relationship_id
    WHERE
       cc.clue_state IN ( 'VALID_NEW_CLUES', 'VALID_PUBLIC_NEW_CLUE' )
        AND !cc.deleted
      -- 不能出现在申诉表有效名单里
       AND cr.id NOT IN ( SELECT customer_relationship_first_id FROM customer_appeal WHERE appeal_status = '1' )
   GROUP BY
       DATE_FORMAT( cr.create_date_time, '%Y-%m-%d' )
   ) total_num
   INNER JOIN (
   SELECT
       count( 1 ) AS num,
       DATE_FORMAT( cr.create_date_time, '%Y-%m-%d' ) AS date_day
   FROM
       customer_relationship cr
   WHERE
       cr.payment_state = 'PAID'
   GROUP BY
       DATE_FORMAT( cr.create_date_time, '%Y-%m-%d' )
   ) signup_num ON total_num.date_day = signup_num.date_day  ;
-- 月
SELECT
       total_num.month 'month',
        signup_num.num / total_num.num * 100 'ol_sign_num_transfer',
        signup_num.num
from
    (
    SELECT
       count( 1 ) AS num,
       DATE_FORMAT( cr.create_date_time, '%Y-%m' ) AS month
   FROM
       customer_clue cc
       LEFT JOIN customer_relationship cr ON cr.id = cc.customer_relationship_id
    WHERE
       cc.clue_state IN ( 'VALID_NEW_CLUES', 'VALID_PUBLIC_NEW_CLUE' ) and cr.origin_type='NETSERVICE'
        AND !cc.deleted
      -- 不能出现在申诉表有效名单里
       AND cr.id NOT IN ( SELECT customer_relationship_first_id FROM customer_appeal WHERE appeal_status = '1' )
   GROUP BY
       DATE_FORMAT( cr.create_date_time, '%Y-%m' )
   ) total_num
   INNER JOIN (
   SELECT
       count( 1 ) AS num,
       DATE_FORMAT( cr.create_date_time, '%Y-%m' ) AS month
   FROM
       customer_relationship cr
   WHERE
       cr.payment_state = 'PAID' and cr.origin_type='NETSERVICE'
   GROUP BY
       DATE_FORMAT( cr.create_date_time, '%Y-%m' )
   ) signup_num ON total_num.month= signup_num.month  ;

-- 年
SELECT
    total_num.date_day 'year',
    signup_num.num / total_num.num * 100  'sign_num_valid',
    signup_num.num
from
    (
    SELECT
       count( 1 ) AS num,
       DATE_FORMAT( cr.create_date_time, '%Y' ) AS date_day
   FROM
       customer_clue cc
       LEFT JOIN customer_relationship cr ON cr.id = cc.customer_relationship_id
    WHERE
       cc.clue_state IN ( 'VALID_NEW_CLUES', 'VALID_PUBLIC_NEW_CLUE' ) and cr.origin_type='NETSERVICE'
        AND !cc.deleted
      -- 不能出现在申诉表有效名单里
       AND cr.id NOT IN ( SELECT customer_relationship_first_id FROM customer_appeal WHERE appeal_status = '1' )
   GROUP BY
       DATE_FORMAT( cr.create_date_time, '%Y' )
   ) total_num
   INNER JOIN (
   SELECT
       count( 1 ) AS num,
       DATE_FORMAT( cr.create_date_time, '%Y' ) AS date_day
   FROM
       customer_relationship cr
   WHERE
       cr.payment_state = 'PAID'and cr.origin_type='NETSERVICE'
   GROUP BY
       DATE_FORMAT( cr.create_date_time, '%Y' )
   ) signup_num ON total_num.date_day = signup_num.date_day  ;
