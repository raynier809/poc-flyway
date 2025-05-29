-- repo-root/dev/Server/SQLServer/Demo-TEXT/MyDatabase/tables/V3__create_orders.sql
CREATE TABLE orders (
    order_id     INT           IDENTITY(1,1) PRIMARY KEY,
    customer_id  INT           NOT NULL
        CONSTRAINT fk_orders_customers REFERENCES customers(customer_id),
    order_date   DATETIME      NOT NULL DEFAULT GETDATE(),
    total_amount DECIMAL(10,2) NOT NULL
);
