use studentdb
\. /home/student/Data/cit225/mysql/lib/create_mysql_store_ri2.sql
\. /home/student/Data/cit225/mysql/lib/seed_mysql_store_ri2.sql

TEE lab5s.txt


-- #1 [4 points]
SELECT member_id
,      c.contact_id
FROM   member m INNER JOIN contact c
USING(member_id)
ORDER BY 2;

SELECT contact_id
,      a.address_id
FROM   contact c INNER JOIN address a
USING(contact_id)
ORDER BY 2;

SELECT address_id
,      s.street_address_id
FROM   address a INNER JOIN street_address s
USING(address_id)
ORDER BY 2;

SELECT contact_id
,      telephone_id
FROM   contact c INNER JOIN telephone t
USING(contact_id)
ORDER BY 2;

-- #2 [2 points]

SELECT c.contact_id
,      s.system_user_id
FROM   contact c INNER JOIN system_user s
on c.created_by = s.system_user_id;

SELECT c.contact_id
,      s.system_user_id
FROM   contact c INNER JOIN system_user s
on c.last_updated_by = s.system_user_id;


-- #3 [2 points]

SELECT su1.system_user_id
,      su1.created_by
,      su2.system_user_id
FROM   system_user su1 INNER JOIN system_user su2
on su1.created_by = su2.system_user_id;

SELECT su1.system_user_id
,      su1.last_updated_by
,      su2.system_user_id
FROM   system_user su1 INNER JOIN system_user su2
on su1.last_updated_by = su2.system_user_id;

-- #4 [2 points]
SELECT r.rental_id
,      ri.rental_id
,      ri.item_id
,      i.item_id
FROM   rental r JOIN rental_item ri
on r.rental_id = ri.rental_id
JOIN item i on i.item_id = ri.item_id;

TEE OFF

