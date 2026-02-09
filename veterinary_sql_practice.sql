
-- 1) Get all records.
SELECT * FROM veterinary_records;

-- 2) List only pet name, species, and visit date.
SELECT Pet_Name, Species, Visit_Date FROM veterinary_records;

-- 3) Visits with reason “Vaccination”.
SELECT * FROM veterinary_records
WHERE Visit_Reason = 'Vaccination';

-- 4) Visits with fee ≥ 500, highest first.
SELECT * FROM veterinary_records
WHERE Fee >= 500
ORDER BY Fee DESC;

-- 5) Pets aged 10 or older.
SELECT * FROM veterinary_records
WHERE Age >= 10;

-- 6) Distinct species (alphabetical).
SELECT DISTINCT Species
FROM veterinary_records
ORDER BY Species;

-- 7) All visits in 2024.
SELECT * FROM veterinary_records
WHERE EXTRACT(YEAR FROM Visit_Date) = 2024;

-- 8) Top 5 most expensive visits.
SELECT *
FROM veterinary_records
ORDER BY Fee DESC
LIMIT 5;

-- 9) Total number of visits per species (desc).
SELECT Species, COUNT(*) AS visit_count
FROM veterinary_records
GROUP BY Species
ORDER BY visit_count DESC;

-- 10) Average fee by visit reason.
SELECT Visit_Reason, ROUND(AVG(Fee)::numeric, 2) AS avg_fee
FROM veterinary_records
GROUP BY Visit_Reason
ORDER BY avg_fee DESC;

-- 11) Total spending per owner (only ≥ 1500).
SELECT Owner_Name, SUM(Fee) AS total_spent
FROM veterinary_records
GROUP BY Owner_Name
HAVING SUM(Fee) >= 1500
ORDER BY total_spent DESC;

-- 12) Monthly visit count in 2023.
SELECT
  DATE_TRUNC('month', Visit_Date)::date AS month,
  COUNT(*) AS visit_count
FROM veterinary_records
WHERE EXTRACT(YEAR FROM Visit_Date) = 2023
GROUP BY month
ORDER BY month;

-- 13) Top 3 most common breeds among Dogs.
SELECT Breed, COUNT(*) AS cnt
FROM veterinary_records
WHERE Species = 'Dog'
GROUP BY Breed
ORDER BY cnt DESC
LIMIT 3;

-- 14) Visit count by age bands (0–3, 4–7, 8+).
SELECT
  CASE
    WHEN Age BETWEEN 0 AND 3 THEN '0-3'
    WHEN Age BETWEEN 4 AND 7 THEN '4-7'
    ELSE '8+'
  END AS age_band,
  COUNT(*) AS visit_count
FROM veterinary_records
GROUP BY age_band
ORDER BY age_band;

-- 15) Total revenue from “Surgery” between 2022–2024.
SELECT SUM(Fee) AS surgery_revenue
FROM veterinary_records
WHERE Visit_Reason = 'Surgery'
  AND Visit_Date >= DATE '2022-01-01'
  AND Visit_Date <  DATE '2025-01-01';

-- 16) Average age and average fee by species.
SELECT
  Species,
  ROUND(AVG(Age)::numeric, 2) AS avg_age,
  ROUND(AVG(Fee)::numeric, 2) AS avg_fee
FROM veterinary_records
GROUP BY Species
ORDER BY Species;

-- 17) Visits per owner × species (desc).
SELECT Owner_Name, Species, COUNT(*) AS visit_count
FROM veterinary_records
GROUP BY Owner_Name, Species
ORDER BY visit_count DESC;

-- 18) Monthly average fee for “Checkup” in 2025.
SELECT
  DATE_TRUNC('month', Visit_Date)::date AS month,
  ROUND(AVG(Fee)::numeric, 2) AS avg_fee
FROM veterinary_records
WHERE Visit_Reason = 'Checkup'
  AND EXTRACT(YEAR FROM Visit_Date) = 2025
GROUP BY month
ORDER BY month;

-- 19) Most expensive visit per species (return full rows).
SELECT t.*
FROM veterinary_records t
JOIN (
  SELECT Species, MAX(Fee) AS max_fee
  FROM veterinary_records
  GROUP BY Species
) m
ON t.Species = m.Species AND t.Fee = m.max_fee
ORDER BY t.Fee DESC;

-- 20) Median fee by species (ordered-set/window).
SELECT DISTINCT
  Species,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Fee)
    OVER (PARTITION BY Species) AS median_fee
FROM veterinary_records
ORDER BY Species;

-- 21) Last visit date and fee per owner.
WITH last_visits AS (
  SELECT
    Owner_Name,
    Visit_Date,
    Fee,
    ROW_NUMBER() OVER (PARTITION BY Owner_Name ORDER BY Visit_Date DESC) AS rn
  FROM veterinary_records
)
SELECT Owner_Name, Visit_Date AS last_date, Fee AS last_fee
FROM last_visits
WHERE rn = 1
ORDER BY last_date DESC;


-- 22) Top 3 owners by total spending for “Illness” visits.
SELECT Owner_Name, SUM(Fee) AS total_spent
FROM veterinary_records
WHERE Visit_Reason = 'Illness'
GROUP BY Owner_Name
ORDER BY total_spent DESC
LIMIT 3;

-- 23) Visits where the owner paid above their own average.
WITH owner_avg AS (
  SELECT Owner_Name, AVG(Fee) AS avg_fee
  FROM veterinary_records
  GROUP BY Owner_Name
)
SELECT v.*
FROM veterinary_records v
JOIN owner_avg a USING (Owner_Name)
WHERE v.Fee > a.avg_fee
ORDER BY v.Owner_Name, v.Fee DESC;

-- 24) Revenue share (%) by Species × Visit Reason.
WITH rev AS (
  SELECT Species, Visit_Reason, SUM(Fee) AS revenue
  FROM veterinary_records
  GROUP BY Species, Visit_Reason
),
total AS (
  SELECT SUM(revenue) AS total_revenue FROM rev
)
SELECT
  r.Species,
  r.Visit_Reason,
  r.revenue,
  ROUND(100.0 * r.revenue / t.total_revenue, 2) AS revenue_share_pct
FROM rev r CROSS JOIN total t
ORDER BY revenue_share_pct DESC;
