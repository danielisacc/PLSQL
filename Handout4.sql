SPOOL /home/daniel/Documents/Programming/PLSQL/Handout4.txt;
SET ECHO ON;
-- 4-1 Using an Explicit Cursor
DECLARE
   CURSOR cur_basket IS
     SELECT bi.idBasket, bi.quantity, p.stock
       FROM bb_basketitem bi INNER JOIN bb_product p
         USING (idProduct)
       WHERE bi.idBasket = 6;
   TYPE type_basket IS RECORD (
     basket bb_basketitem.idBasket%TYPE,
     qty bb_basketitem.quantity%TYPE,
     stock bb_product.stock%TYPE);
   rec_basket type_basket;
   lv_flag_txt CHAR(1) := 'Y';
BEGIN
   OPEN cur_basket;
   LOOP 
     FETCH cur_basket INTO rec_basket;
      EXIT WHEN cur_basket%NOTFOUND;
      IF rec_basket.stock < rec_basket.qty THEN lv_flag_txt := 'N'; END IF;
   END LOOP;
   CLOSE cur_basket;
   IF lv_flag_txt = 'Y' THEN DBMS_OUTPUT.PUT_LINE('All items in stock!'); END IF;
   IF lv_flag_txt = 'N' THEN DBMS_OUTPUT.PUT_LINE('All items NOT in stock!'); END IF;   
END;
/

-- 4-2 Using a Cursor For Loop
DECLARE
   CURSOR cur_shopper IS
     SELECT a.idShopper, a.promo,  b.total                          
       FROM bb_shopper a, (SELECT b.idShopper, SUM(bi.quantity*bi.price) total
                            FROM bb_basketitem bi, bb_basket b
                            WHERE bi.idBasket = b.idBasket
                            GROUP BY idShopper) b
        WHERE a.idShopper = b.idShopper
     FOR UPDATE OF a.idShopper NOWAIT;
   lv_promo_txt CHAR(1);
BEGIN
  FOR rec_shopper IN cur_shopper LOOP
   lv_promo_txt := 'X';
   IF rec_shopper.total > 100 THEN 
          lv_promo_txt := 'A';
   END IF;
   IF rec_shopper.total BETWEEN 50 AND 99 THEN 
          lv_promo_txt := 'B';
   END IF;   
   IF lv_promo_txt <> 'X' THEN
     UPDATE bb_shopper
      SET promo = lv_promo_txt
      WHERE CURRENT OF cur_shopper;
   END IF;
  END LOOP;
  COMMIT;
END;
/

SELECT idShopper, s.promo, SUM(bi.quantity*bi.price) total
FROM bb_shopper s INNER JOIN bb_basket b USING(idShopper)
    INNER JOIN bb_basketitem bi USING(idBasket)
GROUP BY idShopper, s.promo
ORDER BY idShopper;

-- 4-3 Using Implicit Cursors
UPDATE bb_shopper
  SET promo = NULL;
UPDATE bb_shopper
  SET promo = 'B'
  WHERE idShopper IN (21,23,25);
UPDATE bb_shopper
  SET promo = 'A'
  WHERE idShopper = 22;
COMMIT;

BEGIN
 UPDATE bb_shopper
  SET promo = NULL
  WHERE promo IS NOT NULL;
  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);
END;
/

-- 4-4 Using Exception Handling
DECLARE
  lv_tax_num NUMBER(2,2);
BEGIN
 CASE  'NJ' 
  WHEN 'VA' THEN lv_tax_num := .04;
  WHEN 'NC' THEN lv_tax_num := .02;  
  WHEN 'NY' THEN lv_tax_num := .06;  
 END CASE;
 DBMS_OUTPUT.PUT_LINE('tax rate = '||lv_tax_num);
END;
/

-- 4-4-3 Problem Fixed
DECLARE
  lv_tax_num NUMBER(2,2);
  broken_case EXCEPTION;
  PRAGMA EXCEPTION_INIT(broken_case, -06592);
BEGIN
 CASE  'NJ' 
  WHEN 'VA' THEN lv_tax_num := .04;
  WHEN 'NC' THEN lv_tax_num := .02;  
  WHEN 'NY' THEN lv_tax_num := .06;  
 END CASE;
 DBMS_OUTPUT.PUT_LINE('tax rate = '||lv_tax_num);
EXCEPTION
    WHEN broken_case THEN
        DBMS_OUTPUT.PUT_LINE('No tax');
END;
/

-- 4-5 Handling Predefined Exceptions
DECLARE
 rec_shopper bb_shopper%ROWTYPE;
BEGIN
 SELECT *
  INTO rec_shopper
  FROM bb_shopper
  WHERE idShopper = 99;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Invlaid Shopper ID');
END;
/

-- 4-6 Handling Exceptions with Undefined Errors
ALTER TABLE bb_basketitem
  ADD CONSTRAINT bitems_qty_ck CHECK (quantity < 20);

DECLARE
    high_quantity EXCEPTION;
    PRAGMA EXCEPTION_INIT(high_quantity, -02290);
BEGIN
  INSERT INTO bb_basketitem 
   VALUES (88,8,10.8,21,16,2,3);
EXCEPTION
    WHEN high_quantity THEN
        DBMS_OUTPUT.PUT_LINE('Check Quantity');
END;
/

-- 4-7 Handling Exceptions with User-Defined Errors
DECLARE
    none_updated EXCEPTION;
    lv_old_num NUMBER(3) := 30;
    lv_new_num NUMBER(3) := 4;
BEGIN
  UPDATE bb_basketitem
   SET idBasket = lv_new_num
   WHERE idBasket = lv_old_num;

   IF SQL%NOTFOUND THEN
    RAISE none_updated;
   END IF;
EXCEPTION
    WHEN none_updated THEN
        DBMS_OUTPUT.PUT_LINE('Invalid original basket ID');
END;
/

-- 4-8 Processing and Updating a Group of Rows
desc EMP;
-- A PLSQL block is needed to calculate annual raises and update employee salary amounts
-- All Salaries are recorded as monthly amounts

-- Requirements
    -- Calculate 6% ANNUAL raises for all employees excepr the president
    -- if a 6% raise totals more than $2000, cap the raise at $2000
    -- update the salary for each employee in the table
    -- For each employee number, display the current Annual salary,raise, and proposed new ANNUAL SALARY
    -- Finally, following the details for each employee, show the total cost of all employees salaray increase for BB

DECLARE
    raise_amt NUMBER(3,2) := 0.06;
    except_job emp.job%TYPE := 'PRESIDENT';
    raise_cap NUMBER(6) := 2000;
    total_cost NUMBER(10) := 0;
    current_raise NUMBER(6);
    current_annual NUMBER(7);
    new_annual NUMBER(7);

    CURSOR cur_emp IS
        SELECT empno, sal
        FROM EMP
        WHERE job != except_job;
    
    emp_rec emp%ROWTYPE;
BEGIN
    FOR emp_rec IN cur_emp
    LOOP
        current_annual := emp_rec.sal * 12;
        if (current_annual * raise_amt > raise_cap) THEN
            current_raise := raise_cap;
        ELSE
            current_raise := current_annual * raise_amt;
        END IF;
        new_annual := current_raise + current_annual;
        DBMS_OUTPUT.PUT_LINE(emp_rec.empno ||' '|| current_annual ||' '|| current_raise ||' '||  new_annual);
        total_cost := total_cost + current_raise;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(total_cost);
END;