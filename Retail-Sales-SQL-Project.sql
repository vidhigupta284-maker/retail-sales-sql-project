-- Create a database for the Retail Sales project
create database retail_sales ;

-- Select the retail database for analysis
use retail_sales;

-- View all records from the retail table
select * from retail ;

-- Convert order_id and customer_id into VARCHAR datatype
ALTER TABLE retail
MODIFY COLUMN order_id VARCHAR(20),
MODIFY COLUMN customer_id VARCHAR(20);

-- Check for invalid or NULL order dates before conversion
SET SQL_SAFE_UPDATES = 0;
SELECT DISTINCT order_date
FROM retail
WHERE order_date IS NULL
   OR TRIM(order_date) = ''
   OR STR_TO_DATE(TRIM(order_date), '%m/%d/%Y') IS NULL;
   
-- Convert order_date values into standard DATE format   
SELECT order_date,
       CASE
           WHEN order_date LIKE '%/%/%'
               THEN STR_TO_DATE(order_date, '%m/%d/%Y')
           WHEN order_date LIKE '%-%-%'
               THEN STR_TO_DATE(order_date, '%d-%b-%Y')
       END AS converted_date
FROM retail
LIMIT 10;

-- Convert order_date values from different formats into standard DATE format
SET SQL_SAFE_UPDATES = 0;
UPDATE retail
SET order_date =
    CASE
        WHEN order_date LIKE '%/%/%'
            THEN STR_TO_DATE(TRIM(order_date), '%m/%d/%Y')
        WHEN order_date LIKE '%-%-%'
            THEN STR_TO_DATE(TRIM(order_date), '%d-%b-%Y')
    END;
SET SQL_SAFE_UPDATES = 1;

-- Change order_date column datatype from TEXT to DATE
ALTER TABLE retail
MODIFY COLUMN order_date DATE;

-- Check the structure and data types of the retail table
DESCRIBE retail;

-- Check whether there are any NULL values in the dataset. 
SELECT
    COUNT(*) AS total_rows,
    SUM(order_id IS NULL) AS order_id_null,
    SUM(order_date IS NULL) AS order_date_null,
    SUM(customer_id IS NULL) AS customer_id_null,
    SUM(customer_name IS NULL) AS customer_name_null,
    SUM(age IS NULL) AS age_null,
    SUM(gender IS NULL) AS gender_null,
    SUM(region IS NULL) AS region_null,
    SUM(city IS NULL) AS city_null,
    SUM(product_category IS NULL) AS product_category_null,
    SUM(product_name IS NULL) AS product_name_null,
    SUM(quantity IS NULL) AS quantity_null,
    SUM(unit_price IS NULL) AS unit_price_null,
    SUM(discount_pct IS NULL) AS discount_pct_null,
    SUM(sales_amount IS NULL) AS sales_amount_null,
    SUM(profit IS NULL) AS profit_null,
    SUM(shipping_cost IS NULL) AS shipping_cost_null,
    SUM(payment_method IS NULL) AS payment_method_null,
    SUM(customer_satisfaction IS NULL) AS satisfaction_null,
    SUM(return_flag IS NULL) AS return_flag_null,
    SUM(order_status IS NULL) AS order_status_null,
    SUM(days_to_ship IS NULL) AS days_to_ship_null
FROM retail;   

-- Check whether there are duplicate order IDs
SELECT order_id, COUNT(*) AS order_count
FROM retail
GROUP BY order_id
HAVING COUNT(*) > 1;

-- What is the total number of orders?
select count(distinct order_id) as total_order
from retail ;

-- What is the total sales amount?
select sum(sales_amount) as total_sales 
from retail;

-- What is the total profit generated?
select sum(profit) as total_profit 
from retail ;

-- What is the average order value?
select avg(sales_amount) as avg_ordervalue 
from retail;

-- How many unique customers are there? 
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM retail;

-- How are customers distributed by gender?
SELECT
    gender,
    COUNT(DISTINCT customer_id) AS customer_count
FROM retail
GROUP BY gender;

-- Which product categories generate the highest sales?
SELECT
    product_category,
    SUM(sales_amount) AS total_sales
FROM retail
GROUP BY product_category
ORDER BY total_sales DESC;

-- Which products generate the highest profit?
SELECT
    product_name,
    SUM(profit) AS total_profit
FROM retail
GROUP BY product_name
ORDER BY total_profit DESC;

-- Which product categories have the highest quantity sold?
SELECT
    product_category,
    SUM(quantity) AS total_quantity_sold
FROM retail
GROUP BY product_category
ORDER BY total_quantity_sold DESC;

-- Which regions generate the highest sales?
SELECT
    region,
    SUM(sales_amount) AS total_sales
FROM retail
GROUP BY region
ORDER BY total_sales DESC;

-- Which cities generate the highest sales?
SELECT
    city,
    SUM(sales_amount) AS total_sales
FROM retail
GROUP BY city
ORDER BY total_sales DESC;

-- What is the average discount percentage, and how does discount level relate to average profit?
SELECT
    ROUND(AVG(discount_pct), 2) AS average_discount,
    ROUND(AVG(profit), 2) AS average_profit
FROM retail;

-- What is the return rate / distribution of returned vs non-returned orders?
SELECT
    return_flag,
    COUNT(*) AS order_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM retail), 2) AS return_percentage
FROM retail
GROUP BY return_flag;

-- Which product categories have the highest average shipping time?
SELECT
    product_category,
    ROUND(AVG(days_to_ship), 2) AS average_shipping_days
FROM retail
GROUP BY product_category
ORDER BY average_shipping_days DESC;
