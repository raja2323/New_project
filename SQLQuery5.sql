USE BATCH202303;

SELECT TOP 100 COMPANY,GENDER FROM MED_2023 ORDER BY NEWID();

SELECT TOP 100 * FROM MED_2023;

--HOW TO RANK DATA
--1.RANK() OVER
----2.DENSE_RANK() OVER

SELECT 'ASIF' AS STU_NAME, 'EXCEL' AS SUBJECT,45 AS MARKS INTO STU_SUBJECT_SCORE
UNION ALL
SELECT 'ASIF' AS STU_NAME, 'SAS' AS SUBJECT,60 AS MARKS
UNION ALL
SELECT 'ASIF' AS STU_NAME, 'SQL' AS SUBJECT,60 AS MARKS
UNION ALL
SELECT 'ASIF' AS STU_NAME, 'PYTHON' AS SUBJECT,80 AS MARKS
UNION ALL
SELECT 'ASIF' AS STU_NAME, 'TABLEAU' AS SUBJECT,85 AS MARKS
UNION ALL
SELECT 'NIPUN' AS STU_NAME, 'EXCEL' AS SUBJECT,80 AS MARKS
UNION ALL
SELECT 'NIPUN' AS STU_NAME, 'SAS' AS SUBJECT,68 AS MARKS
UNION ALL
SELECT 'NIPUN' AS STU_NAME, 'PYTHON' AS SUBJECT,80 AS MARKS
UNION ALL
SELECT 'NIPUN' AS STU_NAME, 'TABLEAU' AS SUBJECT,91 AS MARKS
UNION ALL
SELECT 'SHAHIDA' AS STU_NAME, 'EXCEL' AS SUBJECT,70 AS MARKS
UNION ALL
SELECT 'SHAHIDA' AS STU_NAME, 'SAS' AS SUBJECT,78 AS MARKS
UNION ALL
SELECT 'SHAHIDA' AS STU_NAME, 'PYTHON' AS SUBJECT,98 AS MARKS
UNION ALL
SELECT 'SHADIA' AS STU_NAME, 'TABLEAU' AS SUBJECT,76 AS MARKS;

SELECT * FROM STU_SUBJECT_SCORE;


--RANK () OVER

--OVER IS A CLAUSE
--1.DEFINE SE OF RESULT
--2.TO SORT RESULT IN ASCENDING OR DESCENDING ORDER

--PARTITION BY
------------------
--A SUBSET DATA IN PARTITION
--1.USED TO PERFORM TO CALCULATION

--ORDER BY CLAUSE

--BASED STU_NAME,MARKS

SELECT
STU_NAME,
SUBJECT,
MARKS,
RANK() OVER (PARTITION BY SUBJECT ORDER BY MARKS DESC) AS RAKING
FROM STU_SUBJECT_SCORE;



SELECT
STU_NAME,
SUBJECT,
MARKS,
RANK() OVER (PARTITION BY STU_NAME ORDER BY MARKS DESC) AS RAKING

FROM STU_SUBJECT_SCORE;

--NEXT HIGHEST CONSECUTIVE HIGHEST RANKING IS MISSING.

SELECT
STU_NAME,
SUBJECT,
MARKS,
DENSE_RANK() OVER (PARTITION BY STU_NAME ORDER BY MARKS DESC) AS RAKING
FROM STU_SUBJECT_SCORE;

SELECT
STU_NAME,
SUBJECT,
MARKS,
DENSE_RANK() OVER (PARTITION BY SUBJECT ORDER BY MARKS DESC) AS RAKING
FROM STU_SUBJECT_SCORE;

--DIFFERENCE BETWEEN RANK() OBVER AND DENSE_RANK() OVER
--USEFUL FOR RANKING ORDER,
--HOWEVER THE RANK() OVER OMITS NEXT HIGHEST 
--CONSECUTIVE ORDER WHEN THE VALUES ARE THE SAME.


SELECT
STATE_CODE,
COMPANY,
COUNT(CUSTOMER_ID) AS SUBS
INTO MED_SUMMARY2
FROM MED_2023
GROUP BY STATE_CODE,COMPANY
ORDER BY 1,2;

SELECT * FROM MED_SUMMARY2;

--CAN'T TAKE AGGREGATE FUNCTION BY GROUP BY

SELECT
STATE_CODE,
COMPANY,
SUBS,
DENSE_RANK() OVER (PARTITION BY STATE_CODE ORDER BY SUBS DESC) AS RANKING
INTO MED_BASE_SUMMARY
FROM MED_SUMMARY2;

SELECT * FROM MED_BASE_SUMMARY
WHERE COMPANY='APPOLO'AND RANKING IN (1,2 ) ;


--USE PARTITION BY
--------------------
--SUMMARIZE DATA PARENT TOTAL
--CUMMULATIVE SUM BY PARENT TOTAL

SELECT * FROM STU_SCORE;
SELECT * FROM STU_SUBJECT_SCORE;

SELECT
A.STU_NAME,
A.SUBJECT,
A.MARKS
FROM STU_SUBJECT_SCORE AS A;

--2.FIND TOTAL MARKS
SELECT 
STU_NAME,
SUM(MARKS) AS TOTAL_MARKS
FROM STU_SUBJECT_SCORE
GROUP BY STU_NAME;

DELETE STU_SUBJECT_SCORE
WHERE STU_NAME='SHADIA';

SELECT
A.STU_NAME,
A.SUBJECT,
A.MARKS,
B.TOTAL_MARKS,
FORMAT((CAST(A.MARKS AS FLOAT) /B.TOTAL_MARKS),'P0')
FROM STU_SUBJECT_SCORE AS A
LEFT JOIN
(SELECT STU_NAME,
SUM(MARKS) AS TOTAL_MARKS
FROM STU_SUBJECT_SCORE
GROUP BY STU_NAME) AS B
ON
A.STU_NAME=B.STU_NAME;

----USE SUB QUERY VERY LENGHTHY PROGRAMING GO FOR PARTITION BY CLAUSE.

SELECT
STU_NAME,
SUBJECT,
MARKS,
SUM(MARKS) OVER (PARTITION BY STU_NAME ORDER BY STU_NAME)  AS TOTAL_MARKS,
FORMAT((CAST(MARKS AS FLOAT)/SUM(MARKS) OVER (PARTITION BY STU_NAME ORDER BY STU_NAME)),'P0') AS MARKS_PERCENT
FROM STU_SUBJECT_SCORE
GROUP BY STU_NAME,SUBJECT,MARKS;


SELECT
STU_NAME,
SUBJECT,
MARKS,
SUM(MARKS) OVER (PARTITION BY STU_NAME ORDER BY SUBJECT,MARKS)  AS CUMULATIVE_SUM
FROM STU_SUBJECT_SCORE
GROUP BY STU_NAME,SUBJECT,MARKS;

--STATE_CODE AND COMAPANY WISE SUBS
SELECT * FROM MED_2023;
SELECT
STATE_CODE,
COMPANY,
COUNT(CUSTOMER_ID) AS SUBS
INTO MED_2023_SUB_BASE
FROM MED_2023
GROUP BY STATE_CODE,COMPANY
ORDER BY 1,2;
SELECT * FROM MED_2023_SUB_BASE;

SELECT
STATE_CODE,
COMPANY,
SUBS,
SUM(SUBS) OVER (PARTITION BY STATE_CODE ORDER BY STATE_CODE) AS TOTAL_SUBS,
FORMAT(CAST(SUBS AS FLOAT)/SUM(SUBS) OVER (PARTITION BY STATE_CODE ORDER BY STATE_CODE),'P0') AS BASE_PERCENTAGE
FROM  MED_2023_SUB_BASE
GROUP BY STATE_CODE,COMPANY,SUBS;


--LAG FUNCTION
--------------------------
--AT MANY INSTANCE USER WOULD LIKE TO ACCESS THE DATA OF THE PREVIOUS RECORD OF THE ROW
--AND COMPARE WITH CURRENT ROW WITH PREVIOUS RECORDS

----SYNTAX
----LAG(SCALR FUNCTION,[OFFSET]) OVER BY ([PARTITION BY] ORDER BY )
--WHAT IS THE SCALR EXPRESSION
--THE VALUE TO RETURN BASED ON THE RECORD
--OFFSET NO OF THE ROWS BACK FROM THE CURRENT ROW
--BY DEFAULT THE VALUE TO BE ONE

SELECT * FROM RESTAURANT_DATA;

SELECT
REST_ID,
CUST_ID,
VISIT_DATE,
LAG(VISIT_DATE,1) OVER  (PARTITION BY REST_ID,CUST_ID ORDER BY VISIT_DATE) AS PREVIOUS_DATE,
NUMBER_OF_PERSONS,
SPENT_AMOUNT,
LAG(SPENT_AMOUNT,1) OVER (PARTITION BY REST_ID,CUST_ID ORDER BY VISIT_DATE) AS PREVIOUS_SPENT
INTO RESTAURANT_CUST_SUMMARY
FROM RESTAURANT_DATA;

SELECT * FROM RESTAURANT_CUST_SUMMARY;

SELECT
REST_ID,
CUST_ID,
VISIT_DATE,
LAG(VISIT_DATE,1) OVER  (PARTITION BY REST_ID,CUST_ID ORDER BY VISIT_DATE) AS PREVIOUS_DATE,
DATEDIFF(DAY,LAG(VISIT_DATE,1) OVER  (PARTITION BY REST_ID,CUST_ID ORDER BY VISIT_DATE),VISIT_DATE) AS PREVIOUS_DATE_GAP,
NUMBER_OF_PERSONS,
SPENT_AMOUNT,
LAG(SPENT_AMOUNT,1) OVER (PARTITION BY REST_ID,CUST_ID ORDER BY VISIT_DATE) AS PREVIOUS_SPENT
INTO RESTAURANT_CUST_SUMMARY1
FROM RESTAURANT_DATA;

SELECT * FROM RESTAURANT_CUST_SUMMARY1;

SELECT
REST_ID,
CUST_ID,
VISIT_DATE,
LAG(VISIT_DATE,1) OVER  (PARTITION BY REST_ID,CUST_ID ORDER BY VISIT_DATE) AS PREVIOUS_DATE,
DATEDIFF(DAY,LAG(VISIT_DATE,1) OVER  (PARTITION BY REST_ID,CUST_ID ORDER BY VISIT_DATE),VISIT_DATE) AS PREVIOUS_DATE_GAP,
NUMBER_OF_PERSONS,
SPENT_AMOUNT,
LAG(SPENT_AMOUNT,1) OVER (PARTITION BY REST_ID,CUST_ID ORDER BY VISIT_DATE) AS PREVIOUS_SPENT,
SPENT_AMOUNT-LAG(SPENT_AMOUNT,1) OVER (PARTITION BY REST_ID,CUST_ID ORDER BY VISIT_DATE) AS SPENT_DIFF
INTO RESTAURANT_CUST_SUMMARY2
FROM RESTAURANT_DATA;

SELECT * FROM RESTAURANT_CUST_SUMMARY2;

--RESTAURANT WISE PROFITABLE CUSTOMERS
------------------------------------------
SELECT
REST_ID,
CUST_ID,
AVG(PREVIOUS_DATE_GAP) AS AVERAGE_DAYS_GAP,
AVG(SPENT_DIFF) AS SPENT_AVG_DIFF
FROM RESTAURANT_CUST_SUMMARY2
GROUP BY REST_ID, CUST_ID
ORDER BY 1,2;


--USE OF ROW NUMBER

SELECT
CUSTOMER_ID,
COMPANY,
GENDER,
AGE,
STATE_CODE,
SPENT_AMOUNT,
ROW_NUMBER() OVER (ORDER BY CUSTOMER_ID) AS ROW_NUMBER
INTO MED_2023_ROWNUMBER
FROM MED_2023;

SELECT * FROM MED_2023_ROWNUMBER;

--CASE STUDY

SELECT 'LAKSHMI' AS NAME INTO STU_NAME
UNION ALL
SELECT 'PAYAL' AS NAME
UNION ALL
SELECT 'VISHNU' AS NAME;

SELECT * FROM STU_NAME;

SELECT
NAME,
ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS ROWNUMBER
INTO STU_V1
FROM STU_NAME;

SELECT * FROM STU_V1 ORDER BY  ROWNUMBER DESC;


CREATE TABLE EMPLOYEES
(EMP_ID INT,
NAME VARCHAR(20),
SALARY INT
);


SELECT * FROM EMPLOYEES;

INSERT INTO EMPLOYEES VALUES (10011,'SMITH',50000);
INSERT INTO EMPLOYEES VALUES (10022,'RAHUL',60000);
INSERT INTO EMPLOYEES VALUES (10033,'AJAY',70000);
INSERT INTO EMPLOYEES VALUES (10044,'ABHILASH',66000);
INSERT INTO EMPLOYEES VALUES (10055,'SAM',57000);

SELECT * FROM EMPLOYEES;

WITH TEM_TABLE(AVG_SALARY) AS 
(SELECT AVG(SALARY) FROM EMPLOYEES)

SELECT
EMP_ID,
NAME,
SALARY,
AVG_SALARY
FROM EMPLOYEES,TEM_TABLE
WHERE EMPLOYEES.SALARY>=TEM_TABLE.AVG_SALARY;


--CREATE VIEW
--------------------

SELECT
STATE_CODE,
COMPANY,
GENDER,
COUNT(CUSTOMER_ID) AS SUBS,
SUM(NO_OF_TRIPS) AS VISITS,
SUM(SPENT_AMOUNT) AS TOTAL_SPENT
FROM MED_2023
GROUP BY STATE_CODE,COMPANY,GENDER 
ORDER BY 1,2,3;

--IN SQL VIEW IS A VIRTUAL TABLE BASED RESULT
--OF SQL STATEMENT VIEW CONTAINS ROWS,COLUMNS
--NEED:OPTIMIZING YOUR DATA


CREATE VIEW 
MED_2022_VIEW1
AS 
SELECT
STATE_CODE,
COMPANY,
GENDER,
COUNT(CUSTOMER_ID) AS SUBS,
SUM(NO_OF_TRIPS) AS VISITS,
SUM(SPENT_AMOUNT) AS TOTAL_SPENT
FROM MED_2023
GROUP BY STATE_CODE,COMPANY,GENDER ;


SELECT * FROM MED_2022_VIEW1;

--VIEW NEVER
--1.STORE AS TABLE
--STORE DATA AS QUERY


--CREATE STORE PROCEDURE
-------------------------------
SELECT * FROM  MED_2023;

SELECT
CUSTOMER_ID,
COMPANY,
GENDER,
AGE,
STATE_CODE,
SPENT_AMOUNT
FROM MED_2023
WHERE COMPANY='APPOLO' AND GENDER='FEMALE' AND AGE>50 AND STATE_CODE='WA';


SELECT
CUSTOMER_ID,
COMPANY,
GENDER,
AGE,
STATE_CODE,
SPENT_AMOUNT
FROM MED_2023
WHERE COMPANY='CIPLA' AND GENDER='MALE' AND AGE>60 AND STATE_CODE='NSW';

SELECT
CUSTOMER_ID,
COMPANY,
GENDER,
AGE,
STATE_CODE,
SPENT_AMOUNT
FROM MED_2023
WHERE COMPANY='GENO' AND GENDER='MALE' AND AGE>40 AND STATE_CODE='NSW';

--ABOVE PROGRAM DUPLICATE
--COMPANY,
--GENDER,
----STATE_CODE

--REPEATING PROGRAM CALLED REDUNDANT PROGRAM
--AUTOMATING PROGRAM CALLED STORE POCEDURE

--STORE POCEDURE STEPS
--IDENTIFY DYNAMICS IN THE PROGRAM
--CALL DYNAMIC VARIABLE OF FIELDS INTO A PARAMETER

--SYNTAX
--CREATE PROCEDURE NAME
--NAME PARAMETERS
--    @ NAME DATATYPE (LENGTH) PARAMETER1
--	 @ NAME DATATYPE (LENGTH) PARAMETER2
--	 AS
--	 SELECT
--	 OTHER FIELDS NOT REPEATING
--	 CONDITION PARAMETER
--	 END

CREATE PROCEDURE SQL_MACRO1
    @COM CHAR(15),
	@GEN CHAR(10),
	@AGE INT,
	@STCD CHAR(10)
	AS
	BEGIN
	SELECT
	CUSTOMER_ID,
	COMPANY,
	GENDER,
	AGE,
	STATE_CODE,
	SPENT_AMOUNT
	FROM MED_2023 
	WHERE COMPANY=@COM AND GENDER=@GEN AND AGE>@AGE AND STATE_CODE=@STCD 
	END;

	WHERE COMPANY='GENO' AND GENDER='MALE' AND AGE>40 AND STATE_CODE='NSW'
	

@COM CHAR(15),
	@GEN CHAR(10),
	@AGE INT,
	@STCD CHAR(10)


EXEC SQL_MACRO1 'APPOLO','FEMALE',50,'NSW';
EXEC SQL_MACRO1 'CIPLA','MALE',40,'WA';

--SQL LOOPING PROGRMING CONCEPT THAT ENABLES FEW LINES OF CODING REPEAT 
--UNTIL CONTION FAILED

--1.WHILE
--2.DO WHILE
--3.FOR

--STEPS
--DECLARE COUNTER AND DATATYPE
--2.SET COUNTER VALUE
--3.CONDITION

DECLARE @COUNTER INT
SET @COUNTER =1
WHILE(@COUNTER<=10)
BEGIN
   PRINT 'THE COUNTER  VALUE IS=' + CONVERT(VARCHAR,@COUNTER)
   SET @COUNTER=@COUNTER+1
   END;


   --SQL FUNCTIONS
--1.TABLE VALUED FUNCTION
--2.SCALAR VALUESD FUNCTION
--3.SYSTEM FUNCTION
--4.AGGREGATE FUNCTIONS

--USER DEFINED FUNCTIONS
--------------------------
--1.TABLE VALUED FUNCTION
--2.SCALAR VALUESD FUNCTION

--1.TABLE VALUED FUNCTION
CREATE FUNCTION SEL_GEN(@GEN CHAR(10))
RETURNS TABLE
AS RETURN
(SELECT
	CUSTOMER_ID,
	COMPANY,
	GENDER,
	AGE,
	STATE_CODE,
	SPENT_AMOUNT
	FROM MED_2023 
	WHERE GENDER=@GEN);

	SELECT * FROM SEL_GEN('FEMALE');
	
	SELECT * FROM SEL_GEN('MALE');

CREATE FUNCTION ADD_GEN(@NUM AS INT)
RETURNS DECIMAL
AS
BEGIN
RETURN(@NUM+100)
END;

--EXAMPLE2
SELECT
	CUSTOMER_ID,
	COMPANY,
	GENDER,
	AGE,
	STATE_CODE,
	SPENT_AMOUNT,
	([dbo].[ADD_GEN](SPENT_AMOUNT) )AS NEW_SPENT
	FROM MED_2023 ;




































