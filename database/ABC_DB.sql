USE master
GO

CREATE DATABASE ABC_bakery
GO

USE ABC_bakery
GO

CREATE TABLE categories
(
 id   BIGINT NOT NULL IDENTITY(1,1),
 name NVARCHAR(255) NOT NULL ,
 prefix NVARCHAR(5) NOT NULL DEFAULT 'TL'

PRIMARY KEY (id)
);

CREATE TABLE products
(
 id               BIGINT NOT NULL IDENTITY(1, 1),
 category_id		BIGINT NOT NULL ,
 name            nvarchar(255) NOT NULL ,
 price           float NOT NULL ,
 is_active       bit NOT NULL ,
 amount          integer NOT NULL ,
 expiration_date date NOT NULL ,
 created_at      date NOT NULL ,
 updated_at      date NOT NULL ,
prefix NVARCHAR(5) NOT NULL DEFAULT 'SP'

PRIMARY KEY (id),
CONSTRAINT FK_1 FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE images
(
 id     BIGINT     NOT NULL  IDENTITY(1, 1),
 product_id BIGINT NOT NULL ,
 url        VARCHAR(512) NOT NULL ,

PRIMARY KEY (id),
CONSTRAINT FK_2 FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE suppliers
(
 id BIGINT NOT NULL IDENTITY(1,1),
 name NVARCHAR(255) NOT NULL,
 phone_number VARCHAR(10) NOT NULL,
 address NVARCHAR(255) NOT NULL,
 created_at DATE NOT NULL DEFAULT GETDATE(),
 updated_at DATE NOT NULL DEFAULT GETDATE(),
 prefix NVARCHAR(5) NOT NULL DEFAULT 'KH' PRIMARY KEY (id)
);

CREATE TABLE roles
(
 id  bigint  NOT NULL ,
 name varchar NOT NULL ,

PRIMARY KEY (id)
);

CREATE TABLE permissions
(
 id BIGINT NOT NULL IDENTITY(0, 1),
 allow_access VARCHAR(255) NOT NULL, PRIMARY KEY (id)
);

CREATE TABLE role_permission
(
 permission_id BIGINT NOT NULL,
 role_id BIGINT NOT NULL, PRIMARY KEY (permission_id, role_id), CONSTRAINT FK_3 FOREIGN KEY (permission_id) REFERENCES PERMISSIONS(id), CONSTRAINT FK_4 FOREIGN KEY (role_id) REFERENCES roles(id)
);

CREATE TABLE users
(
 id          BIGINT NOT NULL IDENTITY(1, 1),
 role_id     BIGINT NOT NULL ,
 name       NVARCHAR(255) NOT NULL ,
 created_at date NOT NULL DEFAULT GETDATE(),
 updated_at date NOT NULL DEFAULT GETDATE(),

PRIMARY KEY (id),
CONSTRAINT FK_7 FOREIGN KEY (role_id) REFERENCES roles(id) 
);

CREATE TABLE imports
(
 id           BIGINT NOT NULL IDENTITY(1, 1),
 supplier_id  BIGINT NOT NULL ,
 admin_id     BIGINT NOT NULL ,
 total       integer NOT NULL ,
 created_at  date NOT NULL ,
 is_inter    bit NOT NULL ,
 prefix NVARCHAR(5) NOT NULL DEFAULT 'D'

PRIMARY KEY (id),
CONSTRAINT FK_5 FOREIGN KEY (supplier_id) REFERENCES suppliers(id),
CONSTRAINT FK_6 FOREIGN KEY (admin_id) REFERENCES users(id)

);

CREATE TABLE import_product
(
 import_id   BIGINT NOT NULL ,
 product_id  BIGINT NOT NULL ,
 price      float NOT NULL ,
 amount     integer NOT NULL ,

PRIMARY KEY (import_id, product_id),
CONSTRAINT FK_8 FOREIGN KEY (import_id) REFERENCES imports(id),
CONSTRAINT FK_9 FOREIGN KEY (product_id) REFERENCES products(id)
);


CREATE TABLE promotions
(
 id BIGINT NOT NULL IDENTITY(1,1),
 name NVARCHAR(255) NOT NULL,
 is_active BIT NOT NULL,
 created_at DATE NOT NULL DEFAULT GETDATE(),
 code NVARCHAR(6) NOT NULL,
 prefix NVARCHAR(5) NOT NULL DEFAULT 'KM',
 ratio INT NOT NULL,
 PRIMARY KEY (id),
 CONSTRAINT CK_1 CHECK (ratio BETWEEN 0 AND 101)
);

CREATE TABLE receipts
(
 id BIGINT NOT NULL,
 name NVARCHAR(255) NOT NULL,
 receieved FLOAT NOT NULL,
 expense FLOAT NOT NULL,
 created_at DATE NOT NULL DEFAULT GETDATE(),
 prefix NVARCHAR(5) NOT NULL DEFAULT 'BN', PRIMARY KEY (id)
);


CREATE TABLE orders
(
 id BIGINT NOT NULL IDENTITY(1,1),
 promotion_id BIGINT NOT NULL,
 receipt_id BIGINT NOT NULL,
 cashier_id BIGINT NOT NULL,
 price FLOAT NOT NULL,
 name NVARCHAR(255) NOT NULL,
 address NVARCHAR(512) NOT NULL, 
 status INTEGER NOT NULL, 
 type INTEGER NOT NULL,
 total INTEGER NOT NULL,
 ship_fee FLOAT NOT NULL,
 payment_method INTEGER NOT NULL,
 is_paid BIT NOT NULL,
 prepay FLOAT NOT NULL,
 ordered_at DATE NOT NULL,
 note TEXT NOT NULL, 
 change INTEGER NOT NULL,
 receieved INTEGER NOT NULL,prefix NVARCHAR(5) NOT NULL DEFAULT 'HD', PRIMARY KEY (id), CONSTRAINT FK_10 FOREIGN KEY (promotion_id) REFERENCES promotions(id), CONSTRAINT FK_11 FOREIGN KEY (receipt_id) REFERENCES receipts(id), CONSTRAINT FK_12 FOREIGN KEY (cashier_id) REFERENCES users(id),
);


CREATE TABLE order_detail
(
 order_id BIGINT NOT NULL IDENTITY(1,1),
 product_id BIGINT NOT NULL,
 price FLOAT NOT NULL,
 total INTEGER NOT NULL, PRIMARY KEY (order_id, product_id), CONSTRAINT FK_13 FOREIGN KEY (order_id) REFERENCES orders(id), CONSTRAINT FK_14 FOREIGN KEY (product_id) REFERENCES products(id)
);