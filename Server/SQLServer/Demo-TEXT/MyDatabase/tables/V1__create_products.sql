-- repo-root/dev/Server/SQLServer/Demo-TEXT/MyDatabase/tables/V1__create_products.sql
CREATE TABLE products (
    product_id   INT           IDENTITY(1,1) PRIMARY KEY,
    name         VARCHAR(100)  NOT NULL,
    description  VARCHAR(255)  NULL,
    price        DECIMAL(10,2) NOT NULL,
    created_at   DATETIME      NOT NULL DEFAULT GETDATE()
);
