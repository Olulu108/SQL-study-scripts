------------------------------Create a function margin_percent

CREATE FUNCTION
  course17.margin_percent (turnover FLOAT64,
    purchase_cost FLOAT64 ) AS( ROUND (SAFE_DIVIDE((turnover - purchase_cost),turnover)*100,2) )






------------------------------Create a function promo_percent

CREATE FUNCTION
  course17.promo_percent (turnover_before_promo FLOAT64,
    turnover FLOAT64) AS ( ROUND ((turnover_before_promo - turnover) / (turnover_before_promo),2) )




------------------------------add the margin_percent and promo_percent columns by using the newly created functions.

SELECT
  date_date,
  orders_id,
  products_id,
  promo_name,
  turnover_before_promo,
  turnover,
  purchase_cost,
  `qualified-root-302819.course17.margin_percent`(turnover,
    purchase_cost) AS margin_percent,
  `qualified-root-302819.course17.promo_percent`(turnover_before_promo,
    turnover) AS promo_percent
FROM
  `qualified-root-302819.course17.gwz_sales_17`


