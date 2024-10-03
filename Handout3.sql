SPOOL /home/daniel/Documents/Programming/PLSQL/Handout3.txt;
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
   DBMS_OUTPUT.PUT_LINE('Shopper '||lv_shop_num||' is rated '||lv_rating_txt);
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
   DBMS_OUTPUT.PUT_LINE('Shopper '||lv_shop_num||' is rated '||lv_rating_txt);
END;
/

-- 5 Using a WHILE loop
DECLARE
  lv_item bb_product.idproduct%TYPE := 5;
  lv_avail NUMBER(5) := 500;
  lv_quantity NUMBER(5) := 0;
  lv_item_price bb_product.price%TYPE;
BEGIN
  SELECT price
  INTO lv_item_price
  FROM bb_product
  WHERE idproduct = lv_item;
  WHILE lv_avail >= lv_item_price LOOP
    lv_quantity := lv_quantity + 1;
    lv_avail := lv_avail - lv_item_price;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(lv_quantity||' of idproduct '||lv_item||' can be purchased');
END;
/


-- 6: Working with IF statements
DECLARE
  lv_basket_num bb_basket.idbasket%TYPE := 5;
  lv_quantity bb_basket.quantity%TYPE;
  lv_ship_cost NUMBER(6,2);
BEGIN
  SELECT quantity
  INTO lv_quantity
  FROM bb_basket
  WHERE idbasket = lv_basket_num;

  CASE
    WHEN lv_quantity <= 3 THEN lv_ship_cost := 5.00;
    WHEN lv_quantity <= 6 THEN lv_ship_cost := 7.50;
    WHEN lv_quantity <= 10 THEN lv_ship_cost := 10.00;
    WHEN lv_quantity > 10 THEN lv_ship_cost := 12.00;
  END CASE;

  DBMS_OUTPUT.PUT_LINE('When idbasket = '||lv_basket_num||' shipping cost = $'||lv_ship_cost);

  lv_basket_num := 12;
  SELECT quantity
  INTO lv_quantity
  FROM bb_basket
  WHERE idbasket = lv_basket_num;

  CASE
    WHEN lv_quantity <= 3 THEN lv_ship_cost := 5.00;
    WHEN lv_quantity <= 6 THEN lv_ship_cost := 7.50;
    WHEN lv_quantity <= 10 THEN lv_ship_cost := 10.00;
    WHEN lv_quantity > 10 THEN lv_ship_cost := 12.00;
  END CASE;
  DBMS_OUTPUT.PUT_LINE('When idbasket = '||lv_basket_num||' shipping cost = $'||lv_ship_cost);
END;
/


-- 7: USING Scalar Variables for Data Retrieval
DECLARE
  lv_subtotal bb_basket.subtotal%TYPE;
  lv_shipping bb_basket.shipping%TYPE;
  lv_tax bb_basket.tax%TYPE;
  lv_total bb_basket.total%TYPE;
  lv_basket_num bb_basket.idbasket%TYPE := 12;
BEGIN
  SELECT subtotal,shipping,tax,total
  INTO lv_subtotal,lv_shipping,lv_tax,lv_total
  FROM bb_basket
  WHERE idbasket = lv_basket_num;
DBMS_OUTPUT.PUT_LINE('subtotal: '||lv_subtotal||'
shipping: '||lv_shipping||'
tax: '||lv_tax||'
total: '||lv_total);
END;
/


-- 8: Using a Record Variable for Data Retrieval
DECLARE
  rv_bb_basket bb_basket%ROWTYPE;
  lv_basket_num bb_basket.idbasket%TYPE := 12;
BEGIN
  SELECT *
  INTO rv_bb_basket
  FROM bb_basket
  WHERE idbasket = lv_basket_num;
DBMS_OUTPUT.PUT_LINE('subtotal: '||rv_bb_basket.subtotal||'
shipping: '||rv_bb_basket.shipping||'
tax: '||rv_bb_basket.tax||'
total: '||rv_bb_basket.total);
END;
/