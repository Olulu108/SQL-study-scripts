------------------------------ Check the primary key 
SELECT
  orders_id,
  COUNT(*) AS nb,
FROM
  `qualified-root-302819.course16.gz_orders`
GROUP BY
  orders_id
HAVING
  nb>1
------------------------------ orders_id - is a primary key

SELECT
  session_id,
  COUNT(*) AS nb
FROM `course16.gz_sessions`
GROUP BY
  session_id
HAVING nb>=2
------------------------------ session_id - is a primary key






------------------------------Check different join methods.The purpose of joining gz_order and gz_session tables is to add information to each order about their corresponding campaign to calculate KPIs for the different ad campaigns.

SELECT
  *
FROM
  `qualified-root-302819.course16.gz_orders`
JOIN
  `qualified-root-302819.course16.gz_sessions`
USING
  (session_id)
------------------------------61826 

SELECT
  *
FROM
  `qualified-root-302819.course16.gz_orders`
LEFT JOIN
  `qualified-root-302819.course16.gz_sessions`
USING
  (session_id)
------------------------------109569 

SELECT
  *
FROM
  `qualified-root-302819.course16.gz_orders`
RIGHT JOIN
  `qualified-root-302819.course16.gz_sessions`
USING
  (session_id)
------------------------------1855125

SELECT
  *
FROM
  `qualified-root-302819.course16.gz_orders`
FULL OUTER JOIN
  `qualified-root-302819.course16.gz_sessions`
USING
  (session_id)
------------------------------1902868
------------------------------Save the results of the INNER JOIN query in a gz_orders_ga table.




------------------------------Use UNION ALL to combine  4 different tables with campaign information (according to different data sources) into a single table named gz_campaign. 

SELECT
  *
FROM
  `qualified-root-302819.course16.gz_adwords`
UNION ALL
SELECT
  *
FROM
  `qualified-root-302819.course16.gz_bing`
UNION ALL
SELECT
  *
FROM
  `qualified-root-302819.course16.gz_criteo`
UNION ALL
SELECT
  *
FROM
  `qualified-root-302819.course16.gz_facebook`




------------------------------ Aggregate gz_orders_ga on date_date and campaign_key. Join the gz_campaign and gz_orders_ga tables to calculate the aggregated metrics (number of transactions (orders), sum of turnover, sum of new customers )

CREATE TABLE `qualified-root-302819.course16.gz_campaign_orders` AS
SELECT
  date_date,
  campaign_key,
  COUNT(DISTINCT orders_id) AS number_transactions,
  ROUND(SUM(turnover), 2) AS sum_turnover,
  SUM(news) AS new_customers
FROM
  `qualified-root-302819.course16.gz_orders_ga`
GROUP BY
  date_date,
  campaign_key




------------------------------ primary key test for the table called gz_campaign_orders_pk
SELECT  
  date_date,campaign_key,
  COUNT(*) AS nb
FROM `qualified-root-302819.course16.gz_campaign_orders`
GROUP BY
  date_date,campaign_key
HAVING
  nb>1




--------------------------- Join the gz_campaign and gz_campaign_orders tables with a LEFT JOIN. Set the values of sum_turnover and number_transactions to be "0" instead of NULL.

SELECT
  *,
  IFNULL (number_transactions,0) AS number_transactions,
  IFNULL (sum_turnover,0) AS sum_turnover,
  IFNULL(new_customers,0) AS new_customers
FROM
  `qualified-root-302819.course16.gz_campaign`
LEFT JOIN
  `qualified-root-302819.course16.gz_campaign_orders`
USING
  (date_date,campaign_key)
---------------------------Save result in the gz_campaign_join table.






--------------------------- Calculate the metrics for each paid_source and each campaign turnover generated (number of orders, number of new orders, cost, impressions, clicks, KPIs - ROAS, CAC, CPM, CPC, CTR )

WITH
  gz_campaign_ps AS (
  SELECT
    paid_source,
    ROUND (SUM (sum_turnover),2) AS turnover,
    SUM (number_transactions) AS number_transactions,
    SUM (new_customers) AS news,
    SUM (cost) AS cost,
    SUM (impression) AS impression,
    SUM (click) AS click
  FROM
    `qualified-root-302819.course16.gz_campaign_join`
  GROUP BY
    paid_source )
SELECT
  *,
  ROUND (turnover / cost, 3) AS ROAS,
  ROUND (cost / news,3) AS CAC,
  ROUND (cost / number_transactions,3) AS CAC_orders,
  ROUND ((cost / impression) *1000, 3) AS CPM,
  ROUND (cost / click, 3) AS CPC,
  ROUND ((click / impression)*100, 3) AS CTR
FROM
  gz_campaign_ps
ORDER BY paid_source

