------------------------------Join gwz_sales and gwz_product tables to add the purchase_price column to the gwz_sales table. Save the result as gwz_sales_margin

SELECT
  sales.date_date,
  sales.orders_id,
  sales.products_id,
  sales.turnover,
  sales.qty,
  product.purchase_price
FROM
  `qualified-root-302819.course16.gwz_sales` AS sales
LEFT JOIN
  `qualified-root-302819.course16.gwz_product` AS product
ON
  sales.products_id = product.products_id


   

------------------------------Create a test on the primary key for the new gwz_sales_margin table

SELECT  
  products_id,
  orders_id,
  COUNT(*) AS nb,
FROM `qualified-root-302819.course16.gwz_sales_margin`
GROUP BY
  products_id,
  orders_id
HAVING
  nb>1







------------------------------Add purchase_cost and margin columns to the new gwz_sales_margin table and save the changes.To compute the purchase_cost, multiply the quantity by the purchase price. To compute the margin, subtract the purchase cost from the turnover.

SELECT
  date_date,
  orders_id,
  products_id,
  turnover,
  qty,
  purchase_price,
  ROUND(qty * purchase_price, 2) AS purchase_cost,
  ROUND(turnover - purchase_price, 2) AS margin,
FROM
  `qualified-root-302819.course16.gwz_sales_margin`






------------------------------Count the number of rows in gwz_sales_margin. Edit your query to change the LEFT JOIN to a RIGHT JOIN. LEFT JOIN is the best solution here because it retains all data from the gwz_sales table. 

SELECT
  sales.date_date,
  sales.orders_id,
  sales.products_id,
  sales.turnover,
  sales.qty,
  product.purchase_price,
  ROUND(qty * purchase_price, 2) AS purchase_cost,
  ROUND(turnover - purchase_price, 2) AS margin,
FROM
  `qualified-root-302819.course16.gwz_sales` AS sales
LEFT JOIN
  `qualified-root-302819.course16.gwz_product` AS product
ON
  sales.products_id = product.products_id






------------------------------Create a test for gwz_sales_margin to ensure purchase_price is not NULL, as this would result in missing margin values.

SELECT
  *
FROM
  `qualified-root-302819.course16.gwz_sales_margin`
WHERE
  purchase_price IS NULL







------------------------------ group the gwz_sales table by orders_id. The resulting table can then be joined with gwz_ship to calculate the operating margin to join the resulting table  with gwz_ship to calculate the operating margin.  Save the result as gwz_orders

SELECT
  date_date,
  orders_id,
  SUM (qty) AS qty,
  ROUND (SUM (turnover), 2) AS turnover,
  ROUND (SUM (purchase_cost),2) AS purchase_cost,
  ROUND(SUM (margin),2) AS margin
FROM
  `qualified-root-302819.course16.gwz_sales_margin`
GROUP BY
  orders_id,
  date_date
ORDER BY
  date_date,
  orders_id





------------------------------Primary key test for gwz_orders

SELECT
  orders_id,
  COUNT(*) AS nb,
FROM
  `qualified-root-302819.course16.gwz_orders`
GROUP BY
  orders_id
HAVING
  nb>1





------------------------------Perform a LEFT JOIN to add the columns from gwz_ship to gwz_orders. Save the result as gwz_orders_operational

SELECT
  orders.date_date,
  orders.orders_id,
  orders.qty,
  orders.turnover,
  orders.purchase_cost,
  orders.margin,
  ship.shipping_fee,
  ship.log_cost,
  ship.ship_cost
FROM
  `qualified-root-302819.course16.gwz_orders` AS orders
LEFT JOIN
  `qualified-root-302819.course16.gwz_ship` AS ship
ON
  orders.orders_id = ship.orders_id







------------------------------Test on primary key

SELECT
  orders_id,
  COUNT(*) AS nb,
FROM
  `qualified-root-302819.course16.gwz_orders_operational`
GROUP BY
  orders_id
HAVING
  nb>1





------------------------------Test to check for null values in the shipping_fee, ship_cost, or log_cost columns

SELECT
  shipping_fee,
  ship_cost,
  log_cost
FROM
  `qualified-root-302819.course16.gwz_orders_operational`
WHERE
  shipping_fee IS NULL
  OR ship_cost IS NULL
  OR log_cost IS NULL




------------------------------Add the operational_margin column to gwz_orders_operational and overwrite the table with the new result.

CREATE OR REPLACE TABLE `qualified-root-302819.course16.gwz_orders_operational` AS
SELECT
  *, 
  ROUND(margin + shipping_fee - log_cost - ship_cost, 2) AS operating_margin
FROM `qualified-root-302819.course16.gwz_orders_operational`






------------------------------Daily Financial Monitoring. Aggregate the financial KPIs from the gwz_orders_operational table for each day, and order the data by the most recent KPIs. Save the result as gwz_finance_day

SELECT
  date_date,
  SUM (qty) AS qty,
  ROUND (SUM (turnover), 2) AS turnover,
  ROUND (SUM (purchase_cost), 2) AS purchase_cost,
  ROUND (SUM (margin),2) AS margin,
  ROUND (SUM (shipping_fee),2) AS shipping_fee,
  ROUND (SUM (log_cost),2) AS log_cost,
  SUM (ship_cost) AS ship_cost,
  ROUND (SUM (operating_margin),2) AS operating_margin,
  COUNT (orders_id) AS nb_transactions,
  ROUND (AVG (turnover), 2) AS avg_basket
FROM
  `qualified-root-302819.course16.gwz_orders_operational`
GROUP BY
  date_date
ORDER BY
  date_date
