------------------------------create a function that returns 1 if the mail campaign was sent to Belgium or 0 if it was sent somewhere else.

CREATE FUNCTION
  course17.is_mail_be (journey_name STRING) AS(
    CASE
      WHEN journey_name LIKE '%nlbe%' THEN 1
      ELSE 0
  END
    )




------------------------------create the mail_be column using the new is_mail_be function

SELECT
  *,
  `qualified-root-302819.course17.is_mail_be`(journey_name) AS mail_be,
FROM
  `qualified-root-302819.course17.gwz_mail_17`





------------------------------Create a function called mail_type that contains one of the 3 mail types depending on the journey_name. newsletter - if the journey_name contains “nl” or “nlbe”. abandoned_basket - if the journey_name contains “panier_abandonne” (or “abandoned_basket” in 🇬🇧). back_in_stock - if the journey_name contains “back_in_stock”

CREATE FUNCTION
  course17.mail_type (journey_name STRING) AS(
    CASE
      WHEN journey_name LIKE '%nlbe%' THEN "newsletter"
      WHEN journey_name LIKE '%nl%' THEN "newsletter"
      WHEN journey_name LIKE '%panier_abandonne%' THEN "abandoned_basket"
      ELSE "back_in_stock"
  END
    )





------------------------------add a mail_type column to the gwz_mail_17 table by using the mail_type function

SELECT
  *,
  `qualified-root-302819.course17.mail_type`(journey_name) AS mail_type,
FROM
  `qualified-root-302819.course17.gwz_mail_17`






------------------------------add an nps column to gwz_nps_17 table that equals to -1 if they are a detractor, 0 if they are passive, and 1 if the customer is a promoter
 
SELECT
  date_date,
  orders_id,
  transporter,
  global_note,
  CASE
    WHEN global_note >8 THEN 1
    WHEN global_note <7 THEN -1
    ELSE 0
END
  AS nps
FROM
  `qualified-root-302819.course17.gwz_nps_17`






------------------------------Create an nps function in the course17 dataset that takes global_note as an input and returns the same values as the nps column created in the step above

CREATE FUNCTION
  course17.nps (global_note FLOAT64) AS(
    CASE
      WHEN global_note >8 THEN 1
      WHEN global_note <7 THEN -1
      ELSE 0
  END
    )



------------------------------Select all the columns from the gwz_nps_17 table and add an nps column to the results by using the nps function you created.

SELECT
    date_date,
    orders_id,
    transporter,
    global_note,
`qualified-root-302819.course17.nps`(global_note)AS nps
FROM `qualified-root-302819.course17.gwz_nps_17`






------------------------------Create a transporter_brand function in the course17 dataset that takes the transporter column as an input and returns Chrono or DPD transporter brand

CREATE FUNCTION
  course17.transporter_brand (transporter STRING) AS(
    CASE
      WHEN transporter LIKE "%Chrono%" THEN "Chrono"
      ELSE "DPD"
  END
    )



------------------------------Create a delivery_mode function in the course17 dataset that takes the transporter column as an input and returns Pickup point or Home delivery modes

CREATE FUNCTION
  course17.delivery_mode (transporter STRING) AS(
    CASE
      WHEN transporter LIKE "%Pickup%" THEN "Pickup point delivery"
      ELSE "Home delivery"
  END
    )



------------------------------Select all the columns from the gwz_nps_17 table and add the nps, delivery_mode, and transporter_brand columns to it using the new functions you created.

SELECT
  date_date,
  orders_id,
  transporter,
  global_note,
  `qualified-root-302819.course17.transporter_brand`(transporter) AS transporter_brand,
  `qualified-root-302819.course17.delivery_mode`(transporter) AS delivery_mode
FROM
  `qualified-root-302819.course17.gwz_nps_17`
