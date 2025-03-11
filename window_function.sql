------------------------------Use the ROW_NUMBER() function to add a new column called rn (row number). For each customer, the new column should contain a number that indicates how recent the order was, with 1 being the oldest (or first) order.

SELECT
  date_date,
  customers_id,
  orders_id,
  ROW_NUMBER() OVER (PARTITION BY customers_id ORDER BY date_date )AS rn
FROM
  `qualified-root-302819.course17.gwz_orders_17`
ORDER BY
  customers_id




------------------------------Use the RANK() function to achieve the same thing in another column called rk

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