set PAGESIZE 30;
SPOOL C:\Users\Student\Desktop\Lab1.txt;

COLUMN Table_name HEADING 'Table|Name' FORMAT A25;

COLUMN Column_Name HEADING 'Column|Name' FORMAT A10;

COLUMN Constraint_Name HEADING 'Constraint|Name' FORMAT A15;

COLUMN Constraint_Type HEADING 'Constraint|Type' FORMAT A10;

SET ECHO ON;

prompt -- 1) Defining the names of the tables owned by creator

SELECT Table_name FROM user_tables;
prompt -- 3) All Constraints for the tables owned by creator 4) Constraint Type

SELECT ALL_CONSTRAINTS.Constraint_Name, Column_Name, Constraint_Type FROM ALL_Constraints RIGHT JOIN
user_cons_columns ON ALL_Constraints.Constraint_Name = user_cons_columns.CONSTRAINT_NAME;
prompt -- 2) All of the Columns
DESCRIBE CUSTOMER;

SELECT * FROM CUSTOMER;

DESCRIBE EMP;

SELECT * FROM EMP;

DESCRIBE DEPT;

SELECT * FROM DEPT;

DESCRIBE EMP_SERVICE;

SELECT * FROM EMP_SERVICE;

DESCRIBE EMP_SERVICE_LOG;

SELECT * FROM EMP_SERVICE_LOG;

DESCRIBE PURCHASE_ORDER;

SELECT * FROM PURCHASE_ORDER;

DESCRIBE SALGRADE;

SELECT * FROM SALGRADE;

DESCRIBE STATE_LOOKUP;

SELECT * FROM STATE_LOOKUP;

SET ECHO OFF;
SPOOL OFF;