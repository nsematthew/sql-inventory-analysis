SELECT COUNT(productid) AS count_of_products
FROM product

SELECT SUM(inventoryquantity) AS total_inventory_quantity
FROM sales

SELECT SUM(productcost) AS total_product_cost
FROM sales

SELECT COUNT(promotions) AS promotion_products
FROM product
WHERE promotions = 'Yes'
--What is the total number of units sold per product SKU?
SELECT productid, SUM(inventoryquantity) AS total_units_sold
FROM sales
GROUP BY productid
ORDER BY total_units_sold DESC;

--Which product category had the highest sales volume last month?
SELECT P.productcategory, SUM(S.inventoryquantity) AS sales_volume
FROM sales S
INNER JOIN product P ON P.productid = S.productid
WHERE sales_year = 2022 AND sales_month = 11
GROUP BY P.productcategory
ORDER BY sales_volume  DESC
LIMIT 1
	
--How does the inflation rate correlate with sales volume for a specific month?
SELECT S.sales_month, S.sales_year,
ROUND(SUM(S.inventoryquantity),4) AS sales_volume,
ROUND(AVG(F.inflationrate),4) AS avg_inflation_rate
FROM sales S
JOIN factors F ON F.salesdate=S.salesdate
GROUP BY sales_month,sales_year
Order by  avg_inflation_rate DESC;

--What is the correlation between the inflation rate and sales quantity for all products 
--combined on a monthly basis over the last year?
SELECT S.sales_month, S.sales_year,
AVG(F.inflationrate) AS avg_inflation_rate, 
SUM(S.inventoryquantity) AS total_sales_quantity
FROM sales S
JOIN factors F ON F.salesdate = S.salesdate
WHERE S.salesdate >= (CURRENT_DATE - INTERVAL '1 year')
GROUP BY sales_month, sales_year
ORDER BY sales_month, sales_year;

--Did promotions significantly impact the sales quantity of products?
SELECT P.productcategory,P.promotions,
ROUND(AVG(S.inventoryquantity)) AS avg_sales_without_promotions
FROM sales S
JOIN product P ON P.productid = S.productid
WHERE P.promotions = 'No'
GROUP BY P.productcategory, P.promotions
 
UNION ALL

SELECT P.productcategory,P.promotions,
ROUND(AVG(S.inventoryquantity)) AS avg_sales_with_promotions
FROM sales S
JOIN product P ON P.productid = S.productid
WHERE P.promotions = 'Yes'
GROUP BY P.productcategory, P.promotions

--What is the average sales quantity per product category?
SELECT P.productcategory, ROUND(AVG(S.inventoryquantity)) AS avg_sales_quantity 
FROM sales S
JOIN product P ON P.productid = S.productid
GROUP BY P.productcategory
ORDER BY avg_sales_quantity DESC

--How does the GDP affect the total sales volume?
SELECT  S.sales_year,ROUND(SUM(F.gdp)) AS total_GDP, 
SUM(S.inventoryquantity) AS total_sales_volume
FROM sales S
JOIN factors F ON F.salesdate = S.salesdate
GROUP BY S.sales_year
ORDER BY total_sales_volume DESC

--What are the top 10 best-selling product SKUs
SELECT S.productid, SUM(S.inventoryquantity) AS unit_sold
FROM sales S
GROUP BY S.productid
ORDER BY unit_sold DESC
LIMIT 10

--How do seasonal factors influence sales quantities for different product categories
SELECT  P.productcategory,
ROUND(AVG(F.seasonalfactor),4) AS avg_seasonal_factor, 
SUM(S.inventoryquantity) AS sales_quantity
FROM sales S
JOIN product P ON P.productid = S.productid
JOIN factors F ON F.salesdate = S.salesdate
GROUP BY P.productcategory
ORDER BY avg_seasonal_factor DESC

--What is the average sales quantity per product category, and how many products within each
--category were part of a promotion?
SELECT P.productcategory,ROUND(AVG(S.inventoryquantity),2) 
AS avg_sales_quantity, COUNT(P.productid) AS products_by_promotion,
COUNT(CASE WHEN P.promotions = 'Yes' THEN 1 END) AS promotion_count
FROM sales S
JOIN product P ON P.productid = S.productid
GROUP BY P.productcategory,P.promotions
ORDER BY avg_sales_quantity DESC








	
SELECT salesdate, sales_year, sales_month
FROM sales
ORDER BY sales_month DESC
