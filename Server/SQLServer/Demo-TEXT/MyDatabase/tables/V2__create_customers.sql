-- repo-root/dev/Server/SQLServer/Demo-TEXT/MyDatabase/tables/V2__create_customers.sql
CREATE TABLE customers (
    customer_id  INT           IDENTITY(1,1) PRIMARY KEY,
    first_name   VARCHAR(50)   NOT NULL,
    last_name    VARCHAR(50)   NOT NULL,
    email        VARCHAR(100)  NOT NULL UNIQUE,
    created_at   DATETIME      NOT NULL DEFAULT GETDATE()
);
