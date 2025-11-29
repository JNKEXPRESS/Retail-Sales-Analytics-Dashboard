-- Logical schema used for the Retail Sales Analytics project (PostgreSQL)

-- =========================
-- Dimension Tables
-- =========================

CREATE TABLE calendar (
    calendar_date   DATE        NOT NULL,
    year            INT,
    quarter         INT,
    month           INT,
    month_name      TEXT,
    day             INT,
    day_name        TEXT,
    week            INT,
    CONSTRAINT calendar_pk
        PRIMARY KEY (calendar_date)
);

CREATE TABLE dim_customer (
    customer_key    INT         NOT NULL,
    prefix          TEXT,
    first_name      TEXT,
    last_name       TEXT,
    birth_date      DATE,
    marital_status  TEXT,
    gender          TEXT,
    email_address   TEXT,
    annual_income   NUMERIC(18,2),
    total_children  INT,
    education_level TEXT,
    occupation      TEXT,
    home_owner      TEXT,
    CONSTRAINT dim_customer_pk
        PRIMARY KEY (customer_key)
);

CREATE TABLE dim_product_categories (
    product_category_key INT    NOT NULL,
    category_name        TEXT,
    CONSTRAINT dim_product_cat_pk
        PRIMARY KEY (product_category_key)
);

CREATE TABLE dim_product_subcategories (
    product_subcategory_key INT NOT NULL,
    subcategory_name        TEXT,
    product_category_key    INT NOT NULL,
    CONSTRAINT dim_product_subcat_pk
        PRIMARY KEY (product_subcategory_key),
    CONSTRAINT dim_product_subcat_cat_fk
        FOREIGN KEY (product_category_key)
        REFERENCES dim_product_categories (product_category_key)
);

CREATE TABLE dim_product (
    product_key             INT NOT NULL,
    product_subcategory_key INT NOT NULL,
    product_sku             TEXT,
    product_name            TEXT,
    model_name              TEXT,
    product_description     TEXT,
    product_color           TEXT,
    product_size            TEXT,
    product_style           TEXT,
    product_cost            NUMERIC(18,2),
    product_price           NUMERIC(18,2),
    CONSTRAINT dim_product_pk 
        PRIMARY KEY (product_key),
    CONSTRAINT dim_product_subcat_fk
        FOREIGN KEY (product_subcategory_key)
        REFERENCES dim_product_subcategories (product_subcategory_key)
);

CREATE TABLE dim_territory (
    territory_key  INT NOT NULL,
    region         TEXT,
    country        TEXT,
    continent      TEXT,
    CONSTRAINT dim_territory_pk 
        PRIMARY KEY (territory_key)
);

-- =========================
-- Fact Tables
-- =========================

CREATE TABLE fact_sales (
    order_date      DATE        NOT NULL,
    stock_date      DATE,
    order_number    INT         NOT NULL,
    order_lineitem  INT         NOT NULL,
    product_key     INT         NOT NULL,
    customer_key    INT         NOT NULL,
    territory_key   INT         NOT NULL,
    order_quantity  INT,
    CONSTRAINT fact_sales_pk 
        PRIMARY KEY (order_number, order_lineitem),
    CONSTRAINT fact_sales_product_fk
        FOREIGN KEY (product_key)
        REFERENCES dim_product (product_key),
    CONSTRAINT fact_sales_order_date_fk
        FOREIGN KEY (order_date)
        REFERENCES calendar (calendar_date),
    CONSTRAINT fact_sales_customer_fk
        FOREIGN KEY (customer_key)
        REFERENCES dim_customer (customer_key),
    CONSTRAINT fact_sales_territory_fk
        FOREIGN KEY (territory_key)
        REFERENCES dim_territory (territory_key)
);


CREATE TABLE returns_data (
    return_date     DATE        NOT NULL,
    territory_key   INT         NOT NULL,
    product_key     INT         NOT NULL,
    return_quantity INT,
    CONSTRAINT returns_data_pk 
        PRIMARY KEY (return_date, product_key, territory_key),
    CONSTRAINT returns_data_return_date_fk
        FOREIGN KEY (return_date)
        REFERENCES calendar (calendar_date),
    CONSTRAINT returns_data_product_fk
        FOREIGN KEY (product_key)
        REFERENCES dim_product (product_key),
    CONSTRAINT returns_data_territory_fk
        FOREIGN KEY (territory_key)
        REFERENCES dim_territory (territory_key)
);
