
\. /home/student/Data/cit225/mysql/lab5/lab5s.sql

-- Open log file.
TEE lab6s.txt

-- Step 1
ALTER TABLE rental_item
ADD rental_item_price INT UNSIGNED,
ADD rental_item_type INT UNSIGNED;

-- Verify output
SELECT   table_name
,        ordinal_position
,        column_name
,        data_type
FROM     information_schema.columns
WHERE    table_name = 'rental_item'
ORDER BY 2;

-- Step 2
CREATE TABLE price
(
price_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
item_id INT UNSIGNED NOT NULL,
price_type INT UNSIGNED,
active_flag CHAR(1) NOT NULL,
start_date DATE NOT NULL,
end_date DATE,
amount INT UNSIGNED,
created_by INT UNSIGNED NOT NULL,
creation_date DATE NOT NULL,
last_updated_by INT UNSIGNED NOT NULL,
last_update_date DATE NOT NULL,
KEY fk_p_1(item_id),
CONSTRAINT fk_p_1 FOREIGN KEY(item_id) REFERENCES item(item_id),
KEY fk_p_2(price_type),
CONSTRAINT fk_p_2 FOREIGN KEY(price_type) REFERENCES common_lookup(common_lookup_id),
KEY fk_p_3(created_by),
CONSTRAINT fk_p_3 FOREIGN KEY(created_by) REFERENCES system_user(system_user_id),
KEY fk_p_4(last_updated_by),
CONSTRAINT fk_p_4 FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id),
CONSTRAINT ck_price_1 CHECK (active_flag IN ('Y','N')),
CONSTRAINT ck_price_2 CHECK (end_date > DATE_ADD(start_date, INTERVAL 30 DAY))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Verify Output
SELECT   table_name
,        ordinal_position
,        column_name
,        data_type
FROM     information_schema.columns
WHERE    table_name = 'price'
ORDER BY ordinal_position;

-- Step 3a.
ALTER TABLE item
CHANGE item_release_date release_date DATE;

-- Verify Output
SELECT   table_name
,        ordinal_position
,        column_name
,        data_type
FROM     information_schema.columns
WHERE    table_name = 'item'
ORDER BY ordinal_position;

-- Step3b.
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( '14633-14822'
, 1013
, 'The Fellowship of the Ring'
, 'The Lord of the Rings'
, 1003
, DATE_SUB(UTC_DATE(),INTERVAL 10 DAY)
, 3
, UTC_DATE()
, 3
, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('14633-14823'
, 1013
, 'The Two Towers'
, 'The Lord of the Rings'
, 1003
, DATE_SUB(UTC_DATE(),INTERVAL 10 DAY)
, 3
, UTC_DATE()
, 3
, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( '14633-14824'
, 1013
, 'The Return of the King'
, 'The Lord of the Rings'
, 1003
, DATE_SUB(UTC_DATE(),INTERVAL 10 DAY)
, 3
, UTC_DATE()
, 3
, UTC_DATE());

-- Verify output
SELECT   i.item_title
,        UTC_DATE() AS today
,        i.release_date
FROM     item i
WHERE    DATEDIFF(UTC_DATE(),i.release_date) < 31;

-- Step3c.
-- New Member Row
INSERT INTO member
( member_type
, account_number
, credit_card_number
, credit_card_type
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 1003
, 'R11-514-39'
, '1111-1111-1111-3333'
, 1007
, 1002
, UTC_DATE()
, 1002
, UTC_DATE());
-- New Contacts
INSERT INTO contact
( member_id
, contact_type
, first_name
, middle_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 1009
, 1002
, 'Lily'
, 'Luna'
, 'Potter'
, 1002
, UTC_DATE()
, 1002
, UTC_DATE());

INSERT INTO address
( contact_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 1013
, 1010
, 'Provo'
, 'Utah'
, '84606'
, 1002
, UTC_DATE()
, 1002
, UTC_DATE());

INSERT INTO street_address
( address_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 1013
, '1218 South 10th East'
, 1002
, UTC_DATE()
, 1002
, UTC_DATE());
INSERT INTO telephone
( contact_id
, address_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 1013
, 1013
, 1010
, 'USA'
, 801
, '111-1111'
, 1002
, UTC_DATE()
, 1002
, UTC_DATE()
);

INSERT INTO contact
( member_id
, contact_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 1009
, 1002
, 'Harry'
, 'Potter'
, 1002
, UTC_DATE()
, 1002
, UTC_DATE());

INSERT INTO address
( contact_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 1014
, 1010
, 'Provo'
, 'Utah'
, '84606'
, 1002
, UTC_DATE()
, 1002
, UTC_DATE());

INSERT INTO street_address
( address_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 1014
, '1219 S 10th East'
, 1002
, UTC_DATE()
, 1002
, UTC_DATE());
INSERT INTO telephone
( contact_id
, address_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 1014
, 1014
, 1010
, 'USA'
, 801
, '111-1111'
, 1002
, UTC_DATE()
, 1002
, UTC_DATE()
);
INSERT INTO contact
( member_id
, contact_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 1009
, 1002
, 'Ginny'
, 'Potter'
, 1002
, UTC_DATE()
, 1002
, UTC_DATE());

INSERT INTO address
( contact_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 1015
, 1010
, 'Provo'
, 'Utah'
, '84606'
, 1002
, UTC_DATE()
, 1002
, UTC_DATE());

INSERT INTO street_address
( address_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 1015
, '1220 S 10th East'
, 1002
, UTC_DATE()
, 1002
, UTC_DATE());
INSERT INTO telephone
( contact_id
, address_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 1015
, 1015
, 1010
, 'USA'
, 801
, '111-1111'
, 1002
, UTC_DATE()
, 1002
, UTC_DATE()
);
-- Verify Output
SELECT   CONCAT(c.last_name,', ',c.first_name) AS full_name
,        a.city
,        a.state_province AS state
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id INNER JOIN street_address sa
ON       a.address_id = sa.address_id INNER JOIN telephone t
ON       c.contact_id = t.contact_id
WHERE    c.last_name = 'Potter';

-- Step3d
INSERT INTO rental
( customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 1014
, DATE_SUB(UTC_DATE(),INTERVAL 8 DAY)
, DATE_ADD(DATE_SUB(UTC_DATE(),INTERVAL 8 DAY), INTERVAL 1 DAY)
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO rental
( customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 1015
, DATE_SUB(UTC_DATE(),INTERVAL 8 DAY)
, DATE_ADD(DATE_SUB(UTC_DATE(),INTERVAL 8 DAY), INTERVAL 3 DAY)
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO rental
( customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 1013
, DATE_SUB(UTC_DATE(),INTERVAL 8 DAY)
, DATE_ADD(DATE_SUB(UTC_DATE(),INTERVAL 8 DAY), INTERVAL 5 DAY)
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO rental_item
( rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 1006
, 1052
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO rental_item
( rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 1007
, 1053
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO rental_item
( rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 1008
, 1054
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Verify Output
SELECT   c.last_name
,        COUNT(*)
FROM     rental r INNER JOIN rental_item ri
ON       r.rental_id = ri.rental_id INNER JOIN contact c
ON       r.customer_id = c.contact_id
WHERE    DATEDIFF(UTC_DATE(),r.check_out_date) < 30
AND      c.last_name = 'Potter'
GROUP BY c.last_name;

-- Step4
-- Part 1 Add columns
ALTER TABLE common_lookup
  ADD common_lookup_table VARCHAR(40),
  ADD common_lookup_column VARCHAR(40),
  ADD common_lookup_code VARCHAR(40);

SELECT   table_name
,        ordinal_position
,        column_name
,        data_type
FROM     information_schema.columns
WHERE    table_name = 'common_lookup'
ORDER BY ordinal_position;

-- Part 2 Migrate data
UPDATE common_lookup
SET    common_lookup_table = 
         CASE
           WHEN common_lookup_context = 'MULTIPLE' THEN
             'ADDRESS'
           else
             common_lookup_context
         END;

-- Change to _TYPE value
UPDATE common_lookup
SET    common_lookup_column = 
         CASE 
           WHEN common_lookup_table = 'MEMBER' THEN
             CASE
               WHEN common_lookup_type IN ('INDIVIDUAL','GROUP') THEN
                 CONCAT(common_lookup_table,'_TYPE')
               WHEN common_lookup_type LIKE '%CARD' THEN
                 'CREDIT_CARD_TYPE'
               WHEN common_lookup_type LIKE 'MULTIPLE' THEN
                 'ADDRESS_TYPE'
               END
           ELSE
             CONCAT(common_lookup_table,'_TYPE')
         END;

-- Step 3 Drop unique index
DROP INDEX common_lookup_u1 ON common_lookup;

-- Step 6 Drop obsolete column from table
ALTER TABLE common_lookup
   DROP COLUMN common_lookup_context;

-- Step 4 Add two new rows
INSERT INTO common_lookup
( common_lookup_table
, common_lookup_column
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 'TELEPHONE'
, 'TELEPHONE_TYPE'
, 'HOME'
, 'Home'
, 1001
, UTC_DATE()
, 1001
, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_table
, common_lookup_column
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 'TELEPHONE'
, 'TELEPHONE_TYPE'
, 'WORK'
, 'Work'
, 1001
, UTC_DATE()
, 1001
, UTC_DATE());

-- Step 5 Migrate obsolete foreign key values
UPDATE telephone
SET    telephone_type = 
       (SELECT common_lookup_id
        FROM   common_lookup
        WHERE  common_lookup_table  = 'TELEPHONE'
        AND    common_lookup_column = 'TELEPHONE_TYPE'
        AND    common_lookup_type   = 'HOME');

-- Step 7 Apply NOT NULL constraint to appropriate columns
ALTER TABLE common_lookup
  MODIFY COLUMN common_lookup_table VARCHAR(30) NOT NULL;

ALTER TABLE common_lookup
  MODIFY COLUMN common_lookup_column VARCHAR(30) NOT NULL;

-- Step 8 Create unique indices
CREATE UNIQUE INDEX common_lookup_u1
  ON common_lookup(common_lookup_table,common_lookup_column,common_lookup_type);

-- Verify Output
SELECT   table_name
,        ordinal_position
,        column_name
,        data_type
FROM     information_schema.columns
WHERE    table_name = 'common_lookup'
ORDER BY ordinal_position;

SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
ORDER BY 1, 2, 3;

SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(a.address_id) AS count_dependent
,        COUNT(cl.common_lookup_table) AS count_lookup
FROM     address a RIGHT JOIN common_lookup cl
ON       a.address_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'ADDRESS'
AND      cl.common_lookup_column = 'ADDRESS_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
UNION
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(t.telephone_id) AS count_dependent
,        COUNT(cl.common_lookup_table) AS count_lookup
FROM     telephone t RIGHT JOIN common_lookup cl
ON       t.telephone_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'TELEPHONE'
AND      cl.common_lookup_column = 'TELEPHONE_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type;
NOTEE
