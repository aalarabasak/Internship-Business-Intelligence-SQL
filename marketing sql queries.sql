-- New Subscribers KPI için new_subscribers sütunu eklenmesi
ALTER TABLE marketing_data
ADD COLUMN new_subscriber BOOLEAN;


UPDATE marketing_data
SET new_subscriber = (random() < 0.30);  -- %30'luk kısmı "true" olur

SELECT *
FROM marketing_data;

UPDATE marketing_data
SET new_subscriber = (random() < 0.10);

SELECT COUNT(*) FROM marketing_data WHERE new_subscriber = true;

------------- Content Engagement by Month chart'ı için visit_month kolonu eklendi.
ALTER TABLE marketing_data
ADD COLUMN visit_month TEXT;

UPDATE marketing_data
SET visit_month = TO_CHAR(visit_date, 'Mon YYYY');
-- Click Through Rate 
SELECT 
  visit_month,
  SUM(clicks) AS total_clicks,
  SUM(impressions) AS total_impressions,
  ROUND(
    (SUM(clicks)::FLOAT / NULLIF(SUM(impressions), 0))::NUMERIC,
    4
  ) AS ctr
FROM marketing_data
GROUP BY visit_month
ORDER BY visit_month;

--- Conversion Rate
SELECT 
  visit_month,
  COUNT(*) AS total_visits,
  COUNT(CASE WHEN conversion_occurred = true THEN 1 END) AS total_conversions,
  ROUND(
    (COUNT(CASE WHEN conversion_occurred = true THEN 1 END)::FLOAT / COUNT(*))::NUMERIC,
    4
  ) AS conversion_rate
FROM marketing_data
GROUP BY visit_month
ORDER BY visit_month;
------

