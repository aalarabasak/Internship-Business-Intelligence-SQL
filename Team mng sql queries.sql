--Task Cycle Time 
ALTER TABLE team_management_dashboard_data
ADD COLUMN cycle_time_days INT;

UPDATE team_management_dashboard_data
SET cycle_time_days = end_date - start_date;

SELECT
  AVG(cycle_time_days) AS "Task Cycle Time"
FROM
  team_management_dashboard_data
WHERE
  status IN ('Closed', 'Validated');


-- Team Roles tablosu
SELECT
  team_role, 
  COUNT(*) AS task_count 
FROM
  team_management_dashboard_data
GROUP BY
  team_role; 

 -- Task Completion Rate
 SELECT
  SUM(CASE WHEN status IN ('Closed', 'Validated') THEN 1 ELSE 0 END) * 1.0 / COUNT(*)
FROM
  team_management_dashboard_data;

-- Bug Status Based on Priority
SELECT
  status,   
  priority, 
  COUNT(*) AS bug_count
FROM
  team_management_dashboard_data
WHERE
  task_type = 'Bug' 
GROUP BY
  status, priority; 
  
-- extra
ALTER TABLE team_management_dashboard_data
ADD COLUMN year_month TEXT;
UPDATE team_management_dashboard_data
SET year_month = TO_CHAR(creation_date, 'YYYY-MM');

ALTER TABLE team_management_dashboard_data
RENAME COLUMN year_start TO year_creation;

ALTER TABLE team_management_dashboard_data
ADD COLUMN month_creation INT;
UPDATE team_management_dashboard_data
SET month_creation = EXTRACT(MONTH FROM creation_date);

ALTER TABLE team_management_dashboard_data
ADD COLUMN year_start INT;
UPDATE team_management_dashboard_data
SET year_start = EXTRACT(YEAR FROM start_date);

ALTER TABLE team_management_dashboard_data
ADD COLUMN month_start INT;
UPDATE team_management_dashboard_data
SET month_start = EXTRACT(MONTH FROM start_date);

-- year_end sütununu ekledim ve güncelledim
ALTER TABLE team_management_dashboard_data
ADD COLUMN year_end INT;
UPDATE team_management_dashboard_data
SET year_end = EXTRACT(YEAR FROM end_date);

-- month_end sütununu ekledim ve güncelledim
ALTER TABLE team_management_dashboard_data
ADD COLUMN month_end INT;
UPDATE team_management_dashboard_data
SET month_end = EXTRACT(MONTH FROM end_date);

SELECT *
FROM team_management_dashboard_data where task_type= 'Feature'


---- KPI bugs closed this month:
DROP TABLE IF EXISTS bug_kpi_summary;

CREATE TABLE bug_kpi_summary AS
SELECT
  TO_CHAR(creation_date, 'YYYY-MM') AS year_month,
  EXTRACT(YEAR FROM creation_date)::INT AS year_creation,
  project_name,

  -- Bu ay task_type = Bug ve status = Closed olanlar
  COUNT(*) FILTER (
    WHERE task_type = 'Bug' AND status = 'Closed'
  ) AS bugs_closed_this_month,

  -- LAG ile bir önceki ayın bug sayısı
  LAG(
    COUNT(*) FILTER (
      WHERE task_type = 'Bug' AND status = 'Closed'
    )
  ) OVER (
    PARTITION BY project_name
    ORDER BY TO_CHAR(creation_date, 'YYYY-MM')
  ) AS bugs_closed_last_month

FROM team_management_dashboard_data
WHERE creation_date IS NOT NULL
GROUP BY
  TO_CHAR(creation_date, 'YYYY-MM'),
  EXTRACT(YEAR FROM creation_date),
  project_name
ORDER BY
  year_creation,
  year_month;
--bu bug_kpi_summary tablosu "Bugs Closed.csv dosyasının içinde"
ALTER TABLE bug_kpi_summary
ADD COLUMN month_creation INT;
UPDATE bug_kpi_summary
SET month_creation = CAST(SPLIT_PART(year_month, '-', 2) AS INT);

ALTER TABLE bug_kpi_summary
ADD COLUMN difference INT;
UPDATE bug_kpi_summary
SET difference = COALESCE(bugs_closed_this_month, 0) - COALESCE(bugs_closed_last_month, 0);


--
SELECT * from bug_kpi_summary where project_name = 'Project Gamma';


--kpı kontrol sorgusu
SELECT COUNT(*) AS total_closed_bugs
FROM team_management_dashboard_data
WHERE task_type = 'Bug'
  AND status = 'Closed';



-- Feature Closed kpi
DROP TABLE IF EXISTS alara_feature_kpi;

CREATE TABLE feature_kpi_summary AS
SELECT
  TO_CHAR(creation_date, 'YYYY-MM') AS year_month,

  EXTRACT(YEAR FROM creation_date)::INT AS year_creation,

  EXTRACT(MONTH FROM creation_date)::INT AS month_creation,

  project_name,

  -- Bu ay kapanan feature sayısı
  COUNT(*) FILTER (
    WHERE task_type = 'Feature' AND status = 'Closed'
  ) AS features_closed_this_month,

  -- Bir önceki ay kapanan feature sayısı LAG ile
  LAG(
    COUNT(*) FILTER (
      WHERE task_type = 'Feature' AND status = 'Closed'
    )
  ) OVER (
    PARTITION BY project_name
    ORDER BY TO_CHAR(creation_date, 'YYYY-MM')
  ) AS features_closed_last_month

FROM team_management_dashboard_data
WHERE creation_date IS NOT NULL
GROUP BY
  TO_CHAR(creation_date, 'YYYY-MM'),
  EXTRACT(YEAR FROM creation_date),
  EXTRACT(MONTH FROM creation_date),
  project_name
ORDER BY
  year_creation,
  month_creation;

SELECT * FROM feature_kpi_summary;

ALTER TABLE feature_kpi_summary
ADD COLUMN difference INT;
UPDATE feature_kpi_summary
SET difference = COALESCE(features_closed_this_month, 0) - COALESCE(features_closed_last_month, 0);

