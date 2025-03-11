------------------------------Aggregate gwz_sales_17 on the orders_id and date_date columns and join edgwz_orders and gwz_ship_17 on orders_id, using a WITH AS clause to perform this operation in one query.

WITH sales_subquerry AS (
  SELECT
  date_date,
  orders_id,
  ROUND (SUM (turnover), 2) AS turnover,
  ROUND (SUM(turnover) - SUM (purchase_cost), 2) AS margin,
  FROM `qualified-root-302819.course17.gwz_sales_17`
  GROUP BY
  orders_id, date_date
)
SELECT
sales.*,
ship.shipping_fee,
ship.log_cost + ship.ship_cost AS operational_cost,
FROM sales_subquerry AS sales
JOIN `qualified-root-302819.course17.gwz_ship_17` AS ship
USING (orders_id)






------------------------------Join the tables gwz_orders_join and gwz_campaign_17 to include ads cost in our financial report, using a WITH AS clause to perform this operation in one query (aggregate gwz_orders_join on date_date in a subquery using the WITH AS clause, aggregate gwz_campaign_17 on date_date using a second WITH AS clause, join orders_date and campaign_date on date_date to aggregate all order and ad statistics for each day)

WITH orders_join_subquerry AS (
  SELECT
  date_date,
  ROUND (SUM (turnover),2) AS daily_turnover,
  ROUND (SUM (margin), 2) AS daily_margin,
  ROUND (SUM (shipping_fee),2)AS daily_shipping_fee,
  ROUND (SUM (operational_cost),2) AS daily_operational_cost,
 FROM `qualified-root-302819.course17.gwz_orders_join `
 GROUP BY date_date
),

campaign_subquerry AS (
  SELECT
  date_date,
  SUM (ads_cost) AS daily_ads_cost
  FROM `qualified-root-302819.course17.gwz_campaign_17`
  GROUP BY date_date
)

SELECT
date_date,
orders.daily_turnover,
orders.daily_margin,
orders.daily_shipping_fee,
orders.daily_operational_cost,
campaign.daily_ads_cost
FROM orders_join_subquerry AS orders
JOIN campaign_subquerry AS campaign
USING (date_date)
ORDER BY date_date






------------------------------ Use the WITH AS clause to calculate sales margin metrics - margin, margin_percent, margin_level (margin_percent based on the margin and the turnover). Calculate the promo_value based on turnover_before_promo and turnover, calculate the promo_percent based on the promo_value and the turnover, add a promo_type column based on the values in promo_percent (high, low, medium)

WITH
  sales1_subquery AS (
  SELECT
    orders_id,
    products_id,
    ROUND (SUM (turnover), 2) AS turnover,
    ROUND (SUM(turnover) - SUM (purchase_cost), 2) AS margin,
    SAFE_DIVIDE(ROUND(SUM(turnover) - SUM(purchase_cost), 2), ROUND(SUM(turnover), 2)) AS margin_percent,
    CASE
      WHEN  SAFE_DIVIDE(ROUND(SUM(turnover) - SUM(purchase_cost), 2), ROUND(SUM(turnover), 2)) >= 0.40 THEN "High"
      WHEN  SAFE_DIVIDE(ROUND(SUM(turnover) - SUM(purchase_cost), 2), ROUND(SUM(turnover), 2)) < 0.05 THEN "Low"
      ELSE "Medium"
  END
    AS margin_level
  FROM
    `qualified-root-302819.course17.gwz_sales_17`
  GROUP BY
    orders_id,
    products_id),

  sales2_subquery AS (
  SELECT
    orders_id,
    products_id,
    promo_name,
    (turnover_before_promo - turnover) AS promo_value,
    SAFE_DIVIDE (turnover_before_promo - turnover,turnover) AS promo_percent,
    CASE
      WHEN LOWER(promo_name) LIKE "%dlc%" OR LOWER(promo_name) LIKE "%dluo%" THEN "short-lived"
      WHEN  SAFE_DIVIDE (turnover_before_promo - turnover,turnover) >= 0.30 THEN "High promo"
      WHEN  SAFE_DIVIDE (turnover_before_promo - turnover,turnover) < 0.10 THEN "Low promo"
      ELSE "Medium promo"
  END
    AS promo_type
  FROM
  `qualified-root-302819.course17.gwz_sales_17`)

SELECT
sales1.orders_id,
sales1.products_id,
sales1.turnover,
sales1.margin,
sales1.margin_percent,
sales1.margin_level,
Sales2.promo_name,
sales2.promo_value,
sales2.promo_percent,
sales2.promo_type
FROM sales1_subquery AS sales1
JOIN sales2_subquery AS sales2
USING (orders_id, products_id)






