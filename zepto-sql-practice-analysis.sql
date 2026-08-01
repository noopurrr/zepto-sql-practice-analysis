-- DATABASE SETUP


--Create database
CREATE DATABASE zepto;

--Design schema
CREATE TABLE zepto_table(
    id serial primary key,
    category varchar(50),
    name varchar(150) not null,
    mrp numeric(5,2),
    availableQuantity integer,
    discountedSellingPrice numeric(8,2),
    weightinGms integer,
    outOfStock boolean,
    quantity integer
);

--Widen mrp precision to safely hold larger values
ALTER TABLE zepto_table
ALTER COLUMN mrp TYPE NUMERIC(10,2);


--DATA EXPLORATION


--Row count 
SELECT count(*) FROM zepto_table;

--Overview of top 10 rows
SELECT * FROM zepto_table LIMIT 10;


--DATA VALIDATION


--Check for NULL tuples
SELECT * FROM zepto_table WHERE category IS NULL OR name IS NULL OR mrp IS NULL OR availablequantity IS NULL OR discountedsellingprice IS NULL OR weightingms IS NULL OR 
outofstock IS NULL OR quantity IS NULL;

--List all distinct categories
SELECT DISTINCT(category) FROM zepto_table
ORDER BY category;

--Count the number of out-of-stock products
SELECT outofstock, count(id) FROM zepto_table
GROUP BY  outofstock;

--Find duplicate product names
SELECT name, count(id)
from zepto_table
GROUP BY name
HAVING count(id) >1
ORDER BY count(id);

--Identify invalid zero-price entires
SELECT * from zepto_table
where mrp = 0 or discountedsellingprice = 0;
--Remove invalid zero-price rows
delete from zepto_table
where mrp = 0 or discountedsellingprice = 0;

--Convert price from paise to rupees
UPDATE zepto_table
set mrp = mrp/100.0, discountedsellingprice = discountedSellingPrice/100.0;
--Converted values
SELECT mrp, discountedSellingPrice from zepto_table;


--ANALYTIC QUERIES


--Cheapest 10 products by discounted price
SELECT * FROM zepto_table
ORDER BY discountedsellingprice
LIMIT 10;

--High-value products that are currently out of stock
SELECT DISTINCT NAME,mrp FROM zepto_table
WHERE outofstock = TRUE and mrp > 300
ORDER BY mrp DESC;

--Category-wise total revenue
SELECT category, sum(discountedSellingPrice*availableQuantity) total_revenue
FROM zepto_table
GROUP BY category
ORDER BY total_revenue;

--Products that costed >500 originally before discount and <500 after discount
SELECT DISTINCT name, mrp, discountedSellingPrice
FROM zepto_table 
WHERE mrp > 500 AND discountedsellingprice <500
ORDER BY mrp DESC, discountedsellingprice DESC;

--Price-per-gram for products over 100gm
SELECT DISTINCT name, round(discountedSellingPrice/weightinGms,2) as price_per_gram
FROM zepto_table
WHERE weightingms > 100
ORDER BY price_per_gram;

--Categorize products by weight : low / medium/ bulk
SELECT DISTINCT NAME, weightinGms,
CASE WHEN
    weightinGms < 1000 then 'low'
    when weightinGms <5000 then 'medium'
    else 'bulk'
    end weight_category
    from zepto_table;

--category-wise inventory weight
SELECT category, sum(weightinGms*availablequantity) as total_weight
FROM zepto_table
GROUP BY category;