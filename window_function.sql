------------------------------Use the ROW_NUMBER() function to add a new column called rn (row number). For each customer, the new column should contain a number that indicates how recent the order was, with 1 being the oldest (or first) order.Use the RANK() function to achieve the same thing in another column called rk.

SELECT
  date_date,
  customers_id,
  orders_id,
  ROW_NUMBER() OVER (PARTITION BY customers_id ORDER BY date_date )AS rn,
  RANK() OVER (PARTITION BY customers_id ORDER BY date_date )AS rk,
FROM
  `qualified-root-302819.course17.gwz_orders_17`
ORDER BY
  customers_id





------------------------------compare the values in the rn and rk columns for the customers with customers_id in (212497,205343,33690). How would you explain the difference between the two values?

SELECT
  date_date,
  customers_id,
  orders_id,
  ROW_NUMBER() OVER (PARTITION BY customers_id ORDER BY date_date )AS rn,
  RANK() OVER (PARTITION BY customers_id ORDER BY date_date )AS rk,
FROM
  `qualified-root-302819.course17.gwz_orders_17`
WHERE
  customers_id = 212497
  OR customers_id = 205343
  OR customers_id = 33690
ORDER BY
  customers_id





------------------------------Add a new column is_new which is equal to 1 if the order is the first customer order and 0 otherwise. Calculate the rn column using the ROW_NUMBER() function.
Calculate the column is_new based on the rn column.

WITH
  row_number_subqery AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY customers_id ORDER BY date_date )AS rn,
    RANK() OVER (PARTITION BY customers_id ORDER BY date_date )AS rk,
  FROM
    `qualified-root-302819.course17.gwz_orders_17`
  ORDER BY
    customers_id )
SELECT
  date_date,
  customers_id,
  orders_id,
  rn,
  rk,
  CASE
    WHEN rn = 1 THEN 1
    ELSE 0
END
  AS is_new
FROM
  row_number_subqery






------------------------------Use the ROW_NUMBER() function to add a new column called rn (row number). Add orders_id after date_date in the ORDER BY clause. Use the RANK() function to achieve the same thing in another column called rk. Use the DENSE_RANK() function to achieve the same thing in another column called ds_rk. 

SELECT
  date_date,
  orders_id,
  ROW_NUMBER() OVER (PARTITION BY customers_id ORDER BY date_date )AS rn,
  RANK() OVER (PARTITION BY customers_id ORDER BY date_date )AS rk,
  DENSE_RANK() OVER (PARTITION BY customers_id ORDER BY date_date )AS ds_rk,
FROM
  `qualified-root-302819.course17.gwz_sales_17`
ORDER BY
  date_date,
  orders_id





------------------------------Compare the values in the rk and ds_rk columns for the customers with customers_id in (98869,217071,268263).

SELECT
  date_date,
  customers_id,
  orders_id,
  ROW_NUMBER() OVER (PARTITION BY customers_id ORDER BY date_date )AS rn,
  RANK() OVER (PARTITION BY customers_id ORDER BY date_date )AS rk,
  DENSE_RANK() OVER (PARTITION BY customers_id ORDER BY date_date )AS ds_rk,
FROM
  `qualified-root-302819.course17.gwz_sales_17`
WHERE
  customers_id = 98869
  OR customers_id = 217071
  OR customers_id = 268263
ORDER BY
  date_date,
  orders_id




------------------------------Add a new column is_new which is equal to 1 if the order is the first customer order and 0 otherwise. Calculate the ds_rk column using the DENSE_RANK() function. Calculate the column is_new based on the ds_rk column.

WITH
  dense_rank_subqery AS (
  SELECT
    date_date,
    customers_id,
    orders_id,
    products_id,
    ROW_NUMBER() OVER (PARTITION BY customers_id ORDER BY date_date )AS rn,
    RANK() OVER (PARTITION BY customers_id ORDER BY date_date )AS rk,
    DENSE_RANK() OVER (PARTITION BY customers_id ORDER BY date_date )AS ds_rk,
  FROM
    `qualified-root-302819.course17.gwz_sales_17`
  ORDER BY
    date_date,
    customers_id,
    orders_id,
    ds_rk )
SELECT
  date_date,
  customers_id,
  orders_id,
  products_id,
  ds_rk,
  CASE
    WHEN ds_rk = 1 THEN 1
    ELSE 0
END
  AS is_new
FROM
  dense_rank_subqery
ORDER BY
  customers_id,
  date_date,
  orders_id