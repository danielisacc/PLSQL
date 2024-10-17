SPOOL /home/daniel/Documents/Programming/PLSQL/Handout5.txt;
SET SERVEROUTPUT ON;
SET ECHO ON;
-- 5-1: Creating a Procedure
desc BB_PRODUCT;

SELECT * FROM bb_product;

CREATE OR REPLACE PROCEDURE prod_name_sp
    (p_prodid IN bb_product.idproduct%TYPE,
    p_descrip IN bb_product.description%TYPE)
IS
BEGIN
    UPDATE bb_product
        SET description = p_descrip
        WHERE idproduct =p_prodid;
    COMMIT;
END;
/
DECLARE
    prod_id NUMBER(1) := 1;
    descrip VARCHAR2(30) := 'CapressoBar Model #388';
BEGIN
    prod_name_sp(prod_id, descrip);
END;
/
SELECT * FROM bb_product;

-- 5-2: Using a Procedure with IN Parameters
CREATE OR REPLACE PROCEDURE PROD_ADD_SP
    (p_name IN bb_product.productname%TYPE,
    p_desc IN bb_product.description%TYPE,
    p_img_path IN bb_product.productimage%TYPE,
    p_price IN bb_product.price%TYPE,
    p_status IN bb_product.active%TYPE)
IS
BEGIN
    INSERT INTO bb_product (idproduct, productname, description, productimage, price, active)
        VALUES(BB_PRODID_SEQ.nextval, p_name, p_desc, p_img_path, p_price, p_status);
END;
/
DECLARE
    name bb_product.productname%TYPE := 'Roasted Blend';
    descrip bb_product.description%TYPE := 'Well-balanced mix of roeasted beans, a medium body';
    img_path bb_product.productimage%TYPE := 'roasted.jpg';
    price bb_product.price%TYPE := 9.50;
    active_status bb_product.active%TYPE := 1;
BEGIN
    PROD_ADD_SP(name, descrip, img_path, price, active_status);
    COMMIT;
END;
/
SELECT * FROM BB_PRODUCT;
SELECT * FROM BB_TAX;
-- 5-3: Calculating the Tax on an Order
CREATE OR REPLACE PROCEDURE TAX_COST_SP
(
    lv_state IN BB_TAX.STATE%TYPE,
    subtotal IN NUMBER,
    tax OUT NUMBER
)
IS
    lv_taxrate BB_TAX.TAXRATE%TYPE;

BEGIN
    SELECT TAXRATE INTO lv_taxrate
    FROM BB_TAX
    WHERE STATE = lv_state;
    tax := lv_taxrate * subtotal;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        tax := 0;
END;
/
DECLARE
    lv_state BB_TAX.STATE%TYPE := 'VA';
    subtotal NUMBER(5,2) := 100;
    tax NUMBER(5,2);
BEGIN
    TAX_COST_SP(lv_state, subtotal, tax);
    DBMS_OUTPUT.PUT_LINE('$'||tax);
END;
/
desc BB_BASKET;
-- 5-4: Updating Columns in a Table
CREATE OR REPLACE PROCEDURE BASKET_CONFIRM_SP
(
    lv_basketid IN BB_BASKET.IDBASKET%TYPE,
    lv_subtotal IN BB_BASKET.SUBTOTAL%TYPE,
    lv_shipping IN BB_BASKET.SHIPPING%TYPE,
    lv_tax IN BB_BASKET.TAX%TYPE,
    lv_total IN BB_BASKET.TOTAL%TYPE
)
IS
BEGIN
    UPDATE BB_BASKET
    SET ORDERPLACED = 1,
        SUBTOTAL = lv_subtotal,
        SHIPPING = lv_shipping,
        TAX = lv_tax,
        TOTAL = lv_total
    WHERE IDBASKET = lv_basketid;
    COMMIT;
END;
/
INSERT INTO BB_BASKET (IDBASKET, QUANTITY, IDSHOPPER,
                        ORDERPlACED, SUBTOTAL, TOTAL,
                        SHIPPING, TAX, DTCREATED, PROMO)
    VALUES (17,2,22,0,0,0,0,0,'28-FEB-12', 0);
INSERT INTO BB_BASKETITEM (IDBASKETITEM, IDPRODUCT, PRICE,
                            QUANTITY, IDBASKET, OPTION1, OPTION2)
    VALUES (44,7,10.8,3,17,2,3);
INSERT INTO BB_BASKETITEM (IDBASKETITEM, IDPRODUCT, PRICE,
                            QUANTITY, IDBASKET, OPTION1, OPTION2)
    VALUES (45,8,10.8,3,17,2,3);
COMMIT;
DECLARE
    lv_basketid BB_BASKET.IDBASKET%TYPE := 17;
    lv_subtotal BB_BASKET.SUBTOTAL%TYPE := 64.80;
    lv_shipping BB_BASKET.SHIPPING%TYPE := 8.00;
    lv_tax BB_BASKET.TAX%TYPE := 1.94;
    lv_total BB_BASKET.TOTAL%TYPE := 74.74;
BEGIN
    BASKET_CONFIRM_SP(lv_basketid, lv_subtotal, lv_shipping, lv_tax, lv_total);
END;
/
SELECT subtotal, shipping, tax, total, orderplaced
    FROM bb_basket
    WHERE idbasket = 17;


-- 5-5: Updating Order Status
DESC BB_BASKETSTATUS;
CREATE OR REPLACE PROCEDURE STATUS_SHIPS_SP
(
    lv_basketid IN BB_BASKETSTATUS.IDBASKET%type,
    lv_date_shipped IN BB_BASKETSTATUS.DTSTAGE%TYPE,
    lv_shipper IN BB_BASKETSTATUS.SHIPPER%TYPE,
    lv_ship_num IN BB_BASKETSTATUS.SHIPPINGNUM%TYPE
)
IS
BEGIN
    INSERT INTO BB_BASKETSTATUS (idstatus, idbasket, idstage,
                                dtstage, shipper, shippingnum)
        VALUES(BB_STATUS_SEQ.nextval, lv_basketid, 3,
                lv_date_shipped, lv_shipper, lv_ship_num);
    COMMIT;
END;
/
DECLARE
    lv_basketid BB_BASKETSTATUS.IDBASKET%TYPE := 3;
    lv_date_shipped BB_BASKETSTATUS.DTSTAGE%TYPE := '20-FEB-12';
    lv_shipper BB_BASKETSTATUS.SHIPPER%TYPE := 'UPS';
    lv_ship_num BB_BASKETSTATUS.SHIPPINGNUM%TYPE := 'ZW2384YXK4957';
BEGIN
    STATUS_SHIPS_SP(lv_basketid, lv_date_shipped, lv_shipper, lv_ship_num);
END;
/
SELECT * FROM BB_BASKETSTATUS
WHERE IDBASKET = 3;

-- 5-6: Returning Order Status Information
CREATE OR REPLACE PROCEDURE STATUS_SP
(
    lv_basketid IN BB_BASKETSTATUS.IDBASKET%TYPE,
    lv_status OUT VARCHAR
)
IS
    status_num BB_BASKETSTATUS.IDSTATUS%TYPE;
BEGIN
    SELECT IDSTAGE 
        INTO status_num
        FROM BB_BASKETSTATUS
        WHERE DTSTAGE = (
                SELECT MAX(DTSTAGE) FROM BB_BASKETSTATUS
                WHERE IDBASKET = lv_basketid
            );
    CASE status_num
        WHEN 1 THEN
            lv_status := 'Submitted and recieved';
        WHEN 2 THEN
            lv_status := 'Confirmed, processed, sent to shipping';
        WHEN 3 THEN
            lv_status := 'Shipped';
        WHEN 4 THEN
            lv_status := 'Cancelled';
        WHEN 5 THEN
            lv_status := 'Back-ordered';
        ELSE
            lv_status := 'No status is available';
    END CASE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        lv_status := 'No status is available';
END;
/
DECLARE
    lv_status VARCHAR2(30);
BEGIN
    STATUS_SP(4, lv_status);
    DBMS_OUTPUT.PUT_LINE(lv_status);
    STATUS_SP(6, lv_status);
    DBMS_OUTPUT.PUT_LINE(lv_status);
END;
/
desc BB_PROMOLIST;
-- 5-7: Identifying Customers
CREATE OR REPLACE PROCEDURE PROMO_SHIP_SP
(
    lv_cutoff_date IN BB_BASKET.DTCREATED%TYPE,
    lv_month IN BB_PROMOLIST.MONTH%TYPE,
    lv_year IN BB_PROMOLIST.YEAR%TYPE,
    lv_promo_flag IN BB_PROMOLIST.PROMO_FLAG%TYPE
)
IS
    CURSOR cur_shoppers IS
        SELECT DISTINCT IDSHOPPER FROM BB_BASKET b
            WHERE NOT EXISTS (
                SELECT 1
                FROM BB_BASKET
                WHERE IDSHOPPER = b.IDSHOPPER
                    AND DTCREATED >= lv_cutoff_date
            );
    
    shopper BB_BASKET.IDSHOPPER%TYPE;
BEGIN
    FOR shopper in cur_shoppers LOOP
        INSERT INTO BB_PROMOLIST (idshopper, month, year, promo_flag, used)
            VALUES(shopper.IDSHOPPER, lv_month, lv_year, lv_promo_flag, 'N');
    END LOOP;
    COMMIT;
END;
/
DECLARE
    lv_cutoff_date BB_BASKET.DTCREATED%TYPE := TO_DATE('12/02/12', 'DD/MM/YY');
    lv_month BB_PROMOLIST.MONTH%TYPE := 'APR';
    lv_year BB_PROMOLIST.YEAR%TYPE := '2012';
    lv_promo_flag BB_PROMOLIST.PROMO_FLAG%TYPE := 1;
BEGIN
    PROMO_SHIP_SP(lv_cutoff_date, lv_month, lv_year, lv_promo_flag);
END;
/
SELECT * FROM BB_PROMOLIST;

-- 5-8: Adding Items to a Basket
CREATE OR REPLACE PROCEDURE BASKET_ADD_SP
(
    lv_productid IN BB_BASKETITEM.IDPRODUCT%TYPE,
    lv_basketid IN BB_BASKET.IDBASKET%TYPE,
    lv_price IN BB_BASKETITEM.PRICE%TYPE,
    lv_quantity BB_BASKETITEM.QUANTITY%TYPE,
    lv_size_code BB_BASKETITEM.OPTION1%TYPE,
    lv_form_code BB_BASKETITEM.OPTION2%TYPE
)
IS
BEGIN
    INSERT INTO BB_BASKETITEM 
            (IDBASKETITEM, IDPRODUCT, PRICE, QUANTITY,
            IDBASKET, OPTION1, OPTION2)
        VALUES
            (BB_IDBASKETITEM_SEQ.nextval, lv_productid, lv_price,
            lv_quantity, lv_basketid, lv_size_code, lv_form_code);
    COMMIT;
END;
/
BEGIN
    BASKET_ADD_SP(8, 14, 10.80, 1, 2, 4);
END;
/
SELECT * FROM BB_BASKETITEM
WHERE IDBASKET = 14;
desc bb_shopper;
-- 5-9: Creating a Logon Procedure
CREATE OR REPLACE PROCEDURE MEMBER_CK_SP
(
    lv_id IN BB_SHOPPER.USERNAME%TYPE,
    lv_pass IN OUT BB_SHOPPER.PASSWORD%TYPE,
    lv_cookie OUT BB_SHOPPER.COOKIE%TYPE,
    p_check OUT VARCHAR2
)
IS
    lv_fullname VARCHAR(30);
BEGIN
    SELECT FIRSTNAME||' '||LASTNAME AS NAME, COOKIE
        INTO lv_fullname, lv_cookie
        FROM BB_SHOPPER
        WHERE USERNAME = lv_id
            AND PASSWORD = lv_pass;
    lv_pass := SUBSTR(lv_fullname, 1, 8);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_check := 'Invalid';
END;
/
DECLARE
    lv_pass BB_SHOPPER.PASSWORD%TYPE := 'kile';
    lv_cookie BB_SHOPPER.COOKIE%TYPE;
    p_check VARCHAR2(8);
BEGIN
    MEMBER_CK_SP('rat55', lv_pass, lv_cookie, p_check);
    DBMS_OUTPUT.PUT_LINE(lv_pass|| ' ' ||lv_cookie|| ' ' ||p_check);
    lv_pass := NULL;
    lv_cookie := NULL;
    MEMBER_CK_SP('rat', lv_pass, lv_cookie, p_check);
    DBMS_OUTPUT.PUT_LINE(lv_pass|| ' ' ||lv_cookie|| ' ' ||p_check);
END;