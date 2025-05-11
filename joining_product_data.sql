------------------------------ Join the green_product and green_pdt_segment with INNER JOIN tables to return the pdt_name and pdt_segment columns.

SELECT
  pdt_name,
  pdt_segment
FROM
  `qualified-root-302819.green_catalog.green_product`
JOIN
  `qualified-root-302819.green_catalog.green_pdt_segment`
USING (products_id)





------------------------------ Add stock information to the main product details by joining the green_product and green_stock tables.

SELECT
  product.products_id,
  product.pdt_name,
  product.products_status,
  product.categories_id,
  product.promo_id,
  stock.stock,
  stock.stock_forecast
FROM
  `qualified-root-302819.green_catalog.green_product` AS product
JOIN
  `qualified-root-302819.green_catalog.green_stock` AS stock
ON
  product.products_id = stock.pdt_id




------------------------------ Select products_id, pdt_name, promo_name, and promo_pourcent from the green_product and green_promo tables. Ensure the result includes product rows without a promotion. Aim to return all products, both with and without promotions.

SELECT
  product.products_id,
  product.pdt_name,
  promo.promo_name,
  promo.promo_pourcent
FROM
  `green_catalog.green_product` AS product
LEFT JOIN
  `green_catalog.green_promo` AS promo
ON
  promo.promo_id = product.promo_id






------------------------------ Add price information from green_price to green_product.

SELECT
  product.products_id,
  product.pdt_name,
  product.products_status,
  product.categories_id,
  product.promo_id,
  price.ps_cat,
  price.pd_cat
FROM
  `qualified-root-302819.green_catalog.green_product` AS product
JOIN
  `qualified-root-302819.green_catalog.green_price` AS price
ON
  product.products_id = price.products_id





------------------------------ Return the products_id and pdt_name with all their associated category information.

SELECT
  product.products_id,
  product.pdt_name,
  product.categories_id,
  categories.category_1,
  categories.category_2,
  categories.category_3
FROM
  `qualified-root-302819.green_catalog.green_product` AS product
INNER JOIN
  `qualified-root-302819.green_catalog.green_categories` AS categories
ON
  product.categories_id = categories.categories_id




------------------------------Return the products_id, pdt_name, and their qty sold in the last 3 months. Include all products from green_product, even if they were not sold in the last 3 months. 

SELECT
  product.products_id,
  product.pdt_name,
  IFNULL(sales.qty, 0) AS qty
FROM
  `qualified-root-302819.green_catalog.green_product` AS product
LEFT JOIN
  `qualified-root-302819.green_catalog.green_sales` AS sales
ON
  product.products_id = sales.pdt_id





------------------------------Return the same result by using RIGHT JOIN

SELECT
  product.products_id,
  product.pdt_name,
  sales.qty,
FROM
  `qualified-root-302819.green_catalog.green_product` AS product
RIGHT JOIN
  `qualified-root-302819.green_catalog.green_sales` AS sales
ON
  product.products_id = sales.pdt_id









