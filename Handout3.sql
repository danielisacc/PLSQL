SPOOL C:\Users\danie\OneDrive\Documents\Programming\PLSQL\delavega_Handout3.txt;
SET ECHO ON;
-- Daniel Delavega
-- Competency 2.3 Hands-On Assignment


-- 1 Querying Data in a Block
DECLARE
  lv_ship_date bb_basketstatus.dtstage%TYPE;
  lv_shipper_txt bb_basketstatus.shipper%TYPE;
  lv_ship_num bb_basketstatus.shippingnum%TYPE;
  lv_bask_num bb_basketstatus.idbasket%TYPE := 3;
BEGIN
  SELECT dtstage, shipper, shippingnum
   INTO lv_ship_date, lv_shipper_txt, lv_ship_num
   FROM bb_basketstatus
   WHERE idbasket = lv_bask_num
    AND idstage = 5;
  DBMS_OUTPUT.PUT_LINE('Date Shipped: '||lv_ship_date);
  DBMS_OUTPUT.PUT_LINE('Shipper: '||lv_shipper_txt);
  DBMS_OUTPUT.PUT_LINE('Shipping #: '||lv_ship_num);
END;
/


-- 1.6 block with basketID that doesn't exist.
DECLARE
  lv_ship_date bb_basketstatus.dtstage%TYPE;
  lv_shipper_txt bb_basketstatus.shipper%TYPE;
  lv_ship_num bb_basketstatus.shippingnum%TYPE;
  lv_bask_num bb_basketstatus.idbasket%TYPE := 7;
BEGIN
  SELECT dtstage, shipper, shippingnum
   INTO lv_ship_date, lv_shipper_txt, lv_ship_num
   FROM bb_basketstatus
   WHERE idbasket = lv_bask_num
    AND idstage = 5;
  DBMS_OUTPUT.PUT_LINE('Date Shipped: '||lv_ship_date);
  DBMS_OUTPUT.PUT_LINE('Shipper: '||lv_shipper_txt);
  DBMS_OUTPUT.PUT_LINE('Shipping #: '||lv_ship_num);
END;
/


-- 2: Using a Record Variable
DECLARE
  rec_ship bb_basketstatus%ROWTYPE;
  lv_bask_num bb_basketstatus.idbasket%TYPE := 3;
BEGIN
  SELECT *
   INTO rec_ship
   FROM bb_basketstatus
   WHERE idbasket =  lv_bask_num
    AND idstage = 5;
  DBMS_OUTPUT.PUT_LINE('Date Shipped: '||rec_ship.dtstage);
  DBMS_OUTPUT.PUT_LINE('Shipper: '||rec_ship.shipper);
  DBMS_OUTPUT.PUT_LINE('Shipping #: '||rec_ship.shippingnum);
  DBMS_OUTPUT.PUT_LINE('Notes: '||rec_ship.notes);
END;
/


-- 3: Processing Databse Data with IF Statements
DECLARE
 lv_total_num NUMBER(6,2);
 lv_rating_txt VARCHAR2(4);
 lv_shop_num bb_basket.idshopper%TYPE := 22;
BEGIN
 SELECT SUM(total)
  INTO lv_total_num
  FROM bb_basket
  WHERE idShopper = lv_shop_num
    AND orderplaced = 1
  GROUP BY idshopper;
  IF lv_total_num > 200 THEN
    lv_rating_txt := 'HIGH';
  ELSIF lv_total_num > 100 THEN
    lv_rating_txt := 'MID';
  ELSE
    lv_rating_txt := 'LOW';
  END IF; 
   DBMS_OUTPUT.PUT_LINE('Shopper '||:g_shopper||' is rated '||lv_rating_txt);
END;
/


-- 4: Using Searched CASE statements
DECLARE
 lv_total_num NUMBER(6,2);
 lv_rating_txt VARCHAR2(4);
 lv_shop_num bb_basket.idshopper%TYPE := 22;
BEGIN
 SELECT SUM(total)
  INTO lv_total_num
  FROM bb_basket
  WHERE idShopper = lv_shop_num
    AND orderplaced = 1
  GROUP BY idshopper;
  CASE
    WHEN lv_total_num > 200 THEN
      lv_rating_txt := 'HIGH';
    WHEN lv_total_num > 100 THEN
      lv_rating_txt := 'MID';
    WHEN lv_total_num <= 100 THEN
      lv_rating_txt := 'LOW';
  END CASE; 
   DBMS_OUTPUT.PUT_LINE('Shopper '||:g_shopper||' is rated '||lv_rating_txt);
END;
/

-- 5 Using a WHILE loop
DECLARE
  lv_item bb_product.idproduct%TYPE := 5;
  lv_avail NUMBER(5) := 500;
  lv_quantity NUMBER(5);
  lv_item_price bb_product.price%TYPE;
BEGIN
  SELECT price
  INTO lv_item_price
  FROM bb_product
  WHERE idproduct = lv_item;
  lv_quantity := FLOOR(lv_avail/lv_item_price);
  DBMS_OUTPUT.PUT_LINE('When $'||lv_avail||' is available '||lv_quantity||' of idproduct '||lv_item||' can be purchased');
END;
/