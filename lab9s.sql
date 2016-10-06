\. /home/student/Data/cit225/mysql/lab8/lab8s.sql

TEE lab9s.txt
-- 1
-- a
SELECT 'TRANSACTION' AS "Drop Table";
DROP TABLE IF EXISTS transaction;

CREATE TABLE transaction
( transaction_id            INT  UNSIGNED  PRIMARY KEY AUTO_INCREMENT
, transaction_account       CHAR(15)      NOT NULL
, transaction_type          INT  UNSIGNED         NOT NULL
, transaction_date          DATE          NOT NULL
, transaction_amount        INT  UNSIGNED         NOT NULL
, rental_id	            INT  UNSIGNED         NOT NULL
, payment_method_type	    INT  UNSIGNED         NOT NULL
, payment_account_number    CHAR(20)      NOT NULL
, created_by                INT  UNSIGNED         NOT NULL
, creation_date             DATE          NOT NULL
, last_updated_by           INT  UNSIGNED         NOT NULL
, last_update_date          DATE          NOT NULL
, CONSTRAINT fk_trans_1      FOREIGN KEY(transaction_type) REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_trans_2      FOREIGN KEY(rental_id) REFERENCES rental(rental_id)
, CONSTRAINT fk_trans_3      FOREIGN KEY(payment_method_type) REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_trans_4      FOREIGN KEY(created_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_trans_5      FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id));


SELECT   table_name
,        ordinal_position
,        column_name
,        CASE
           WHEN is_nullable = 'NO' THEN 'NOT NULL'
           ELSE 'NULLABLE'
         END AS constraints
,        column_type
FROM     information_schema.columns
WHERE    table_name = 'transaction'
ORDER BY ordinal_position;

SHOW CREATE TABLE transaction\G

-- b

CREATE UNIQUE INDEX NATURAL_KEY
 ON transaction (rental_id, transaction_type, transaction_date, payment_method_type, payment_account_number, transaction_account);

SELECT   tc.table_name
,        tc.constraint_name
,        kcu.ordinal_position
,        kcu.column_name 
FROM     information_schema.table_constraints tc INNER JOIN
         information_schema.key_column_usage kcu
ON       tc.table_name = kcu.table_name
AND      tc.constraint_name = kcu.constraint_name
AND      tc.constraint_type = 'UNIQUE'
AND      tc.table_name = 'transaction';

-- 2

INSERT INTO common_lookup
( common_lookup_id
, common_lookup_table
, common_lookup_column
, common_lookup_code
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( NULL
, 'TRANSACTION'
, 'TRANSACTION_TYPE'
, 'CR'
, 'CREDIT'
, 'Credit'
, 1
, UTC_DATE()
, 1
, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_id
, common_lookup_table
, common_lookup_column
, common_lookup_code
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( NULL
, 'TRANSACTION'
, 'TRANSACTION_TYPE'
, 'DR'
, 'DEBIT'
, 'Debit'
, 1
, UTC_DATE()
, 1
, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_id
, common_lookup_table
, common_lookup_column
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( NULL
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE'
, 'DISCOVER_CARD'
, 'Discover card'
, 1
, UTC_DATE()
, 1
, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_id
, common_lookup_table
, common_lookup_column
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( NULL
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE'
, 'VISA_CARD'
, 'Visa_card'
, 1
, UTC_DATE()
, 1
, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_id
, common_lookup_table
, common_lookup_column
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( NULL
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE'
, 'MASTER_CARD'
, 'Master card'
, 1
, UTC_DATE()
, 1
, UTC_DATE());

INSERT INTO common_lookup
( common_lookup_id
, common_lookup_table
, common_lookup_column
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( NULL
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE'
, 'CASH'
, 'Cash'
, 1
, UTC_DATE()
, 1
, UTC_DATE());

SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table = 'TRANSACTION'
AND      common_lookup_column IN ('TRANSACTION_TYPE','PAYMENT_METHOD_TYPE')
ORDER BY 1, 2, 3 DESC;

-- 3

-- a

SELECT 'AIRPORT' AS "Drop Table";
DROP TABLE IF EXISTS airport;

CREATE TABLE airport
( airport_id            INT  UNSIGNED     PRIMARY KEY AUTO_INCREMENT
, airport_code          CHAR(3)        NOT NULL
, airport_city          CHAR(30)       NOT NULL
, city                  CHAR(30)       NOT NULL
, state_province        CHAR(30)       NOT NULL
, created_by            INT UNSIGNED   NOT NULL
, creation_date         DATE           NOT NULL
, last_updated_by       INT UNSIGNED   NOT NULL
, last_update_date      DATE           NOT NULL
, CONSTRAINT fk_air_1      FOREIGN KEY(created_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_air_2      FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id));


SELECT   table_name
,        ordinal_position
,        column_name
,        data_type
FROM     information_schema.columns
WHERE    table_name = 'airport'
ORDER BY ordinal_position;

-- b

CREATE UNIQUE INDEX nk_airport
 ON airport (airport_code, airport_city, city, state_province);

SELECT   tc.table_name
,        tc.constraint_name
,        kcu.ordinal_position
,        kcu.column_name 
FROM     information_schema.table_constraints tc INNER JOIN
         information_schema.key_column_usage kcu
ON       tc.table_name = kcu.table_name
AND      tc.constraint_name = kcu.constraint_name
AND      tc.constraint_type = 'UNIQUE'
AND      tc.table_name = 'airport';

-- c

INSERT INTO airport
( airport_id
, airport_code
, airport_city
, city
, state_province
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( NULL
, 'LAX'
, 'Los Angeles'
, 'Los Angeles'
, 'California'
, 1
, UTC_DATE()
, 1
, UTC_DATE());

INSERT INTO airport
( airport_id
, airport_code
, airport_city
, city
, state_province
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( NULL
, 'SLC'
, 'Salt Lake City'
, 'Provo'
, 'Utah'
, 1
, UTC_DATE()
, 1
, UTC_DATE());

INSERT INTO airport
( airport_id
, airport_code
, airport_city
, city
, state_province
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( NULL
, 'SLC'
, 'Salt Lake City'
, 'Spanish Fork'
, 'Utah'
, 1
, UTC_DATE()
, 1
, UTC_DATE());

INSERT INTO airport
( airport_id
, airport_code
, airport_city
, city
, state_province
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( NULL
, 'SFO'
, 'San Francisco'
, 'San Francisco'
, 'California'
, 1
, UTC_DATE()
, 1
, UTC_DATE());

INSERT INTO airport
( airport_id
, airport_code
, airport_city
, city
, state_province
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( NULL
, 'SJC'
, 'San Jose'
, 'San Jose'
, 'California'
, 1
, UTC_DATE()
, 1
, UTC_DATE());

INSERT INTO airport
( airport_id
, airport_code
, airport_city
, city
, state_province
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( NULL
, 'SJC'
, 'San Jose'
, 'San Carlos'
, 'California'
, 1
, UTC_DATE()
, 1
, UTC_DATE());

SELECT   airport_code
,        airport_city
,        city
,        state_province
FROM     airport;

-- d

SELECT 'ACCOUNT_LIST' AS "Drop Table";
DROP TABLE IF EXISTS account_list;

CREATE TABLE account_list
( account_list_id           INT   UNSIGNED     PRIMARY KEY AUTO_INCREMENT
, account_number            CHAR(10)      NOT NULL
, consumed_date             DATE            
, consumed_by               INT  UNSIGNED         
, created_by                INT  UNSIGNED      NOT NULL
, creation_date             DATE           NOT NULL
, last_updated_by           INT  UNSIGNED          NOT NULL
, last_update_date          DATE            NOT NULL
, CONSTRAINT fk_account_list_1      FOREIGN KEY(consumed_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_account_list_2      FOREIGN KEY(created_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_account_list_3      FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id));

SELECT   table_name
,        ordinal_position
,        column_name
,        data_type
FROM     information_schema.columns
WHERE    table_name = 'account_list'
ORDER BY ordinal_position;



-- e

-- Conditionally drop the procedure.
SELECT 'DROP PROCEDURE seed_account_list' AS "Statement";
DROP PROCEDURE IF EXISTS seed_account_list;
 
-- Create procedure to insert automatic numbered rows.
SELECT 'CREATE PROCEDURE seed_account_list' AS "Statement";
 
-- Reset delimiter to write a procedure.
DELIMITER $$
 
CREATE PROCEDURE seed_account_list() MODIFIES SQL DATA
BEGIN
 
  DECLARE lv_key CHAR(3);

  DECLARE lv_key_min  INT DEFAULT 0;
  DECLARE lv_key_max  INT DEFAULT 50;
 
  DECLARE duplicate_key INT DEFAULT 0;
  DECLARE fetched INT DEFAULT 0;
  
  DECLARE parameter_cursor CURSOR FOR
    SELECT DISTINCT airport_code FROM airport;
 
  DECLARE CONTINUE HANDLER FOR 1062 SET duplicate_key = 1;
 
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fetched = 1;
 
  START TRANSACTION;
 
  SAVEPOINT all_or_none;
    
  OPEN parameter_cursor;
  cursor_parameter: LOOP
 
    FETCH parameter_cursor
    INTO  lv_key;
 
    IF fetched = 1 THEN LEAVE cursor_parameter; END IF;
 
    seed: WHILE (lv_key_min < lv_key_max) DO
      SET lv_key_min = lv_key_min + 1;
 
      INSERT INTO account_list
      VALUES
      ( null
      , CONCAT(lv_key,'-',LPAD(lv_key_min,6,'0'))
      , null
      , null
      , 2
      , UTC_DATE()
      , 2
      , UTC_DATE());
    END WHILE;
 
    SET lv_key_min = 0;
 
  END LOOP cursor_parameter;
  CLOSE parameter_cursor;
 
  IF duplicate_key = 1 THEN

    ROLLBACK TO SAVEPOINT all_or_none;
 
  END IF;
 

  COMMIT;
 
END;
$$
 
-- Reset delimiter to the default.
DELIMITER ;

SELECT   r.routine_schema
,        r.routine_name
FROM     information_schema.routines r
WHERE    r.routine_name = 'seed_account_list';

CALL seed_account_list();

SELECT   consumed_date
,        COUNT(*) AS "# Accounts"
FROM     account_list;

SELECT   SUBSTR(account_number,1,3) AS "Airport"
,        COUNT(*) AS "# Accounts"
FROM     account_list
WHERE    consumed_date IS NULL
GROUP BY airport
ORDER BY 1;


-- f

UPDATE address
SET    state_province = 'California'
WHERE  state_province = 'CA';

UPDATE address
SET    state_province = 'Utah'
WHERE  state_province = 'UT';

-- g

DELIMITER $$
 
CREATE PROCEDURE update_member_account() MODIFIES SQL DATA
BEGIN
  DECLARE lv_member_id      INT UNSIGNED;
  DECLARE lv_city           CHAR(30);
  DECLARE lv_state_province CHAR(30);
  DECLARE lv_account_number CHAR(10);
 
  DECLARE duplicate_key INT DEFAULT 0;
  DECLARE fetched INT DEFAULT 0;
 
  DECLARE member_cursor CURSOR FOR
    SELECT   DISTINCT
             m.member_id
    ,        a.city
    ,        a.state_province
    FROM     member m INNER JOIN contact c
    ON       m.member_id = c.member_id INNER JOIN address a
    ON       c.contact_id = a.contact_id
    ORDER BY m.member_id;
 
  DECLARE CONTINUE HANDLER FOR 1062 SET duplicate_key = 1;
 
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fetched = 1;
 
  START TRANSACTION;
  
  SAVEPOINT all_or_none;
  
  OPEN member_cursor;
  cursor_member: LOOP
 
    FETCH member_cursor
    INTO  lv_member_id
    ,     lv_city
    ,     lv_state_province;
 
    IF fetched = 1 THEN LEAVE cursor_member; END IF;
 
      SELECT al.account_number
      INTO   lv_account_number
      FROM   account_list al INNER JOIN airport ap
      ON     SUBSTRING(al.account_number,1,3) = ap.airport_code
      WHERE  ap.city = lv_city
      AND    ap.state_province = lv_state_province
      AND    consumed_by IS NULL
      AND    consumed_date IS NULL LIMIT 1;
 
      UPDATE member
      SET    account_number = lv_account_number
      WHERE  member_id = lv_member_id;
 
      UPDATE account_list
      SET    consumed_by = 2
      ,      consumed_date = UTC_DATE()
      WHERE  account_number = lv_account_number;
 
  END LOOP cursor_member;
  CLOSE member_cursor;
 
  IF duplicate_key = 1 THEN
 
    ROLLBACK TO SAVEPOINT all_or_none;
 
  END IF;
 
  COMMIT;
 
END;
$$
 
-- Reset delimiter to the default.
DELIMITER ;

SELECT   r.routine_schema
,        r.routine_name
FROM     information_schema.routines r
WHERE    r.routine_name = 'update_member_account';

CALL update_member_account();

SELECT   DISTINCT
         m.member_id
,        c.last_name
,        m.account_number
,        a.city
,        a.state_province
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id
ORDER BY 1;

-- 4
-- Conditionally drop the table.
DROP TABLE IF EXISTS transaction_upload;
 
-- Create the new upload target table.
CREATE TABLE transaction_upload
( account_number            CHAR(10)
, first_name                CHAR(20)     
, middle_name               CHAR(20)            
, last_name                 CHAR(20)          
, checkout_date             DATE          
, return_date               DATE            
, rental_item_type          CHAR(12)          
, transaction_type          CHAR(14)
, transaction_amount        INT
, transaction_date          DATE
, item_id                   INT
, payment_method_type       CHAR(14)
, payment_account_number    CHAR(19));

-- Load the data from a file, don't forget the \n after the \r on Windows or it won't work.
LOAD DATA LOCAL INFILE '/home/student/Data/cit225/mysql/upload/transaction_upload_mysql.csv'
INTO TABLE transaction_upload
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
ESCAPED BY '\\'
LINES TERMINATED BY '\r\n';
 
-- Select the uploaded records.
SELECT * FROM transaction_upload;

SELECT   table_name
,        ordinal_position
,        column_name
,        CASE
           WHEN is_nullable = 'NO' THEN 'NOT NULL'
           ELSE ''
         END AS constraints
,        column_type
FROM     information_schema.columns
WHERE    table_name = 'transaction_upload'
ORDER BY ordinal_position;

SELECT   COUNT(*) AS "External Rows"
FROM     transaction_upload;



NOTEE
