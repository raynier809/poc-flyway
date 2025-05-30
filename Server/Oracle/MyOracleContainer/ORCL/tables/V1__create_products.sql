-- Tabla PRODUCTS
CREATE TABLE products (
    product_id NUMBER PRIMARY KEY,
    product_name VARCHAR2(100) NOT NULL,
    description VARCHAR2(500),
    price NUMBER(10,2) NOT NULL,
    stock_quantity NUMBER DEFAULT 0,
    created_date DATE DEFAULT SYSDATE
);

CREATE SEQUENCE products_seq START WITH 1 INCREMENT BY 1;
