\. /home/student/Data/cit225/mysql/lab7/lab7s.sql

TEE lab8s.txt
-- 1
INSERT INTO price
(SELECT NULL
,      i.item_id
,      cl.common_lookup_id as price_type
,      af.active_flag
,CASE 
WHEN (DATEDIFF(UTC_DATE(), i.release_date) < 31
OR  active_flag = 'N')
THEN i.release_date
ELSE DATE_ADD(i.release_date, INTERVAL 31 DAY)
END as start_date
,Case
WHEN active_flag = 'N'
THEN DATE_ADD(i.release_date, INTERVAL 30 DAY)
ELSE
NULL
END as end_date
,(CASE
     WHEN (af.active_flag = 'Y' AND DATEDIFF(UTC_DATE(), i.release_date) < 31) 
     OR   (af.active_flag = 'N' AND DATEDIFF(UTC_DATE(), i.release_date) > 30)
        THEN 
	     (CASE
                WHEN dr.rental_days = '1'
	             THEN 3
		WHEN dr.rental_days = '3'
	             THEN 10
                WHEN dr.rental_days = '5'
	             THEN 15
               END)
      ELSE
         cast(dr.rental_days as SIGNED INTEGER)
    END) as amount
,1001
,UTC_DATE()
,1001
,UTC_DATE()
FROM     item i CROSS JOIN
        (SELECT 'Y' AS active_flag FROM dual
         UNION ALL
         SELECT 'N' AS active_flag FROM dual) af CROSS JOIN
        (SELECT '1' AS rental_days FROM dual
         UNION ALL
         SELECT '3' AS rental_days FROM dual
         UNION ALL
         SELECT '5' AS rental_days FROM dual) dr INNER JOIN
         common_lookup cl ON dr.rental_days = SUBSTR(cl.common_lookup_type,1,1)
WHERE    cl.common_lookup_table = 'RENTAL_ITEM'
AND      cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
AND NOT (active_flag = 'N' AND DATEDIFF(UTC_DATE(), i.release_date) <= 30));

SELECT  'OLD Y' AS "Type"
,        COUNT(CASE WHEN amount = 1 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 3 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 5 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'Y' AND i.item_id = p.item_id
AND      DATEDIFF(UTC_DATE(), i.release_date) > 30
AND      end_date IS NULL
UNION ALL
SELECT  'OLD N' AS "Type"
,        COUNT(CASE WHEN amount =  3 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 10 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 15 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'N' AND i.item_id = p.item_id
AND      DATEDIFF(UTC_DATE(), i.release_date) > 30
AND NOT end_date IS NULL
UNION ALL
SELECT  'NEW Y' AS "Type"
,        COUNT(CASE WHEN amount =  3 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 10 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 15 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'Y' AND i.item_id = p.item_id
AND      DATEDIFF(UTC_DATE(), i.release_date) < 31
AND      end_date IS NULL
UNION ALL
SELECT  'NEW N' AS "Type"
,        COUNT(CASE WHEN amount = 1 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 3 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 5 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'N' AND i.item_id = p.item_id
AND      DATEDIFF(UTC_DATE(), i.release_date) < 31
AND      NOT (end_date IS NULL);

-- 2


ALTER TABLE price
CHANGE COLUMN price_type price_type INT UNSIGNED NOT NULL; 

SELECT   table_name
,        ordinal_position
,        column_name
,        CASE
           WHEN is_nullable = 'NO' THEN 'NOT NULL'
           ELSE ''
         END AS constraints
,        column_type
FROM     information_schema.columns
WHERE    table_name = 'price'
AND      column_name = 'price_type'
ORDER BY ordinal_position;
-- 3

/*
UPDATE   rental_item ri
SET      rental_item_price =
           (SELECT   p.amount
            FROM     price p CROSS JOIN rental r
            WHERE    p.item_id = ri.item_id
            AND      ri.rental_id = r.rental_id
            AND      r.check_out_date
                       BETWEEN p.start_date AND IFNULL(p.end_date, UTC_DATE())
            AND   p.price_type = ri.rental_item_type);

SELECT   ri.rental_item_id, ri.rental_item_price, p.amount
FROM     price p INNER JOIN rental_item ri 
ON       p.item_id = ri.item_id AND   p.price_type = ri.rental_item_type
JOIN     rental r ON ri.rental_id = r.rental_id
WHERE    r.check_out_date BETWEEN p.start_date AND IFNULL(p.end_date, UTC_DATE())
ORDER BY 1;
*/
UPDATE   rental_item ri
SET      rental_item_price =
          (SELECT   p.amount
           FROM     price p INNER JOIN common_lookup cl1
           ON       p.price_type = cl1.common_lookup_id CROSS JOIN rental r
                    CROSS JOIN common_lookup cl2 
           WHERE    p.item_id = ri.item_id AND ri.rental_id = r.rental_id
           AND      ri.rental_item_type = cl2.common_lookup_id
           AND      cl1.common_lookup_code = cl2.common_lookup_code
           AND      r.check_out_date
                      BETWEEN p.start_date AND IFNULL(p.end_date, DATE_ADD(UTC_DATE(), INTERVAL 1 DAY)));

SELECT   ri.rental_item_id
,        ri.rental_item_price
,        p.amount
FROM     price p INNER JOIN common_lookup cl1
ON       p.price_type = cl1.common_lookup_id INNER JOIN rental_item ri 
ON       p.item_id = ri.item_id INNER JOIN common_lookup cl2
ON       ri.rental_item_type = cl2.common_lookup_id INNER JOIN rental r
ON       ri.rental_id = r.rental_id
WHERE    cl1.common_lookup_code = cl2.common_lookup_code
AND      r.check_out_date
BETWEEN  p.start_date AND IFNULL(p.end_date, DATE_ADD(UTC_DATE(), INTERVAL 1 DAY))
ORDER BY 1;

-- 4

ALTER TABLE rental_item
MODIFY rental_item_price INT UNSIGNED NOT NULL; 

SELECT   table_name
,        ordinal_position
,        column_name
,        CASE
           WHEN is_nullable = 'NO' THEN 'NOT NULL'
           ELSE ''
         END AS constraints
,        column_type
FROM     information_schema.columns
WHERE    table_name = 'rental_item'
AND      column_name = 'rental_item_price'
ORDER BY ordinal_position;
NOTEE
