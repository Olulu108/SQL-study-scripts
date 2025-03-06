------------------------------ check if product_id is a primary key in the circle_stock_cat table.

SELECT
  product_id,
  COUNT(*) AS nb,
FROM
  `qualified-root-302819.course15_day3.circle_stock_cat`
GROUP BY
  product_id
HAVING
  nb>1



------------------------------ check if the combination of model, color, and size columns serves as a primary key for the circle_stock table

SELECT
  CONCAT(model_id, color, size),
  COUNT(*) AS nb,
FROM
  `qualified-root-302819.course15.15 circle - stock`
GROUP BY
  CONCAT(model_id, color, size)
HAVING
  nb>1



------------------------------validate that model_type has no null values in the circle_stock_kpi table.

SELECT
  COUNT(*)
FROM
  `qualified-root-302819.course15_day3.circle_stock_kpi`
WHERE
  model_type IS NULL




------------------------------Create a new table named cc_stock_model_type from the circle_stock_kpi table, which will contain aggregated metrics (nb_products, nb_products_in_stock, shortage_rate, total_stock_value) at the model_type level

SELECT
  model_type,
  COUNT(*) AS nb_products,
  SUM (in_stock) nb_products_in_stock,
  1- AVG (in_stock)shortage_rate,
  SUM(stock_value) AS total_stock_value
FROM
  `qualified-root-302819.course15_day3.circle_stock_kpi`
GROUP BY
  model_type





------------------------------check if model_type is the primary key of the new cc_stock_model_type table.

SELECT
  model_type,
  COUNT(*) AS nb,
FROM
  `qualified-root-302819.course15_day3.cc_stock_model_type`
GROUP BY
  model_type
HAVING
  nb>1





------------------------------check if product_id is the primary key of circle_sales_daily.

SELECT
  product_id,
  COUNT(*) AS nb,
FROM
  `qualified-root-302819.course15_day3.circle_sales_daily`
GROUP BY
  product_id
HAVING
  nb>1





------------------------------create a test to ensure that product_name has no null values in circle_stock_kpi.

SELECT
  product_id,
  product_name
FROM
  `qualified-root-302819.course15_day3.circle_stock_kpi`
WHERE
  product_name IS NULL




------------------------------create a test to check that the stock_value in circle_stock_kpi is always positive, 0, or NULL

SELECT
  *
FROM
  `qualified-root-302819.course15_day3.circle_stock_kpi`
WHERE
  stock_value <=0
  OR stock_value IS NULL

------------------------------

SELECT
  CONCAT(t.model,"_",t.color,"_",IFNULL(t.size,"no-size")) AS product_id,
  t.model AS product_model,
  t.color AS product_color,
  t.size AS product_size,
  CASE
    WHEN REGEXP_CONTAINS(LOWER(t.model_name),'t-shirt') THEN 'T-shirt'
    WHEN REGEXP_CONTAINS(LOWER(t.model_name),'short') THEN 'Short'
    WHEN REGEXP_CONTAINS(LOWER(t.model_name),'legging') THEN 'Legging'
    WHEN REGEXP_CONTAINS(LOWER(REPLACE(t.model_name,"è","e")),'brassiere|crop-top') THEN 'Crop-top'
    WHEN REGEXP_CONTAINS(LOWER(t.model_name),'débardeur|haut') THEN 'Top'
    WHEN REGEXP_CONTAINS(LOWER(t.model_name),'tour de cou|tapis|gourde') THEN 'Accessories'
    ELSE NULL
END
  AS model_type,
  t.model_name,
  t.color_name AS color_description,
  CONCAT(t.model_name," ",t.color_name,
  IF
    (t.size IS NULL,"",CONCAT(" - Taille ",size))) AS product_name,
  t.pdt_new AS product_new,
  t.forecast_stock AS forecasted_stock_level,
  t.stock AS current_stock_level,
IF
  (t.stock>0,1,0) AS in_stock,
  t.price,
IF
  (t.stock<0,NULL,ROUND(t.stock*t.price,2)) AS stock_value
FROM
  `qualified-root-302819.course15_day3.circle_stock_kpi` AS t
WHERE
  TRUE
ORDER BY
  product_id