-- Productivity Rate by Department tablosu için yapılan değişiklikler:

-- Mevcut productivity_rate sütununu tablodan kaldırdım
ALTER TABLE hr_employee_details_alara
DROP COLUMN IF EXISTS productivity_rate;

-- productive_hours ve total_scheduled_hours sütunlarını tabloya ekledim
ALTER TABLE hr_employee_details_alara
ADD COLUMN productive_hours INT,
ADD COLUMN total_scheduled_hours INT;


UPDATE hr_employee_details_alara
SET
    total_scheduled_hours = 160,

    -- Verimli saatleri, her departmanın hedef verimlilik aralığına göre rastgele atadım.
    --  floor(random() * (max - min + 1) + min) -> min ve max dahil rastgele tam sayı üretir.
    productive_hours = floor(CASE department
        -- Pazarlama  (147-157 saat)
        WHEN 'Marketing' THEN random() * (157 - 147 + 1) + 147
        
        -- İnsan Kaynakları (139-149 saat)
        WHEN 'Human Resources' THEN random() * (149 - 139 + 1) + 139
        
        -- Müşteri Desteği (131-144 saat)
        WHEN 'Customer Support' THEN random() * (144 - 131 + 1) + 131

        -- Finans (130-142 saat)
        WHEN 'Finance' THEN random() * (142 - 130 + 1) + 130

        -- Satış  (128-141 saat)
        WHEN 'Sales' THEN random() * (141 - 128 + 1) + 128
        ELSE random() * (140 - 120 + 1) + 120
    END);


-- Her bir departman için ortalama verimlilik oranını hesaplayan sorgu
SELECT 
    department,
    ROUND(SUM(productive_hours)::NUMERIC / SUM(total_scheduled_hours) * 100, 2) AS productivity_rate_percentage
FROM 
    hr_employee_details_alara
GROUP BY 
    department
ORDER BY 
    productivity_rate_percentage DESC;

SELECT * FROM hr_employee_details_alara;
----------------------------------------------

--Overall Labor Effectiveness(OLE) için yapılanlar 
--  Mevcut ole_score sütununu tablodan kaldırdım.
ALTER TABLE hr_employee_details_alara
DROP COLUMN IF EXISTS ole_score;

ALTER TABLE hr_employee_details_alara
ADD COLUMN IF NOT EXISTS actual_output INT,
ADD COLUMN IF NOT EXISTS target_output INT;

UPDATE hr_employee_details_alara
SET
  -- Her çalışan için standart bir hedef belirledim.

  -- actual_output hesapladım.
  actual_output = floor(
    1000 * -- target_output ile aynı olmalı
    -- kalite oranı hesaplama 
    LEAST(1.0, GREATEST(0.75,
        (
            -- 1. Departmana göre bir temel kalite oranı belirledim
            (CASE department
                WHEN 'Marketing'        THEN 0.97  
                WHEN 'Human Resources'  THEN 0.99  
                WHEN 'Customer Support' THEN 0.975
                WHEN 'Finance'          THEN 0.97
                WHEN 'Sales'            THEN 0.965
                ELSE 0.95
            END)
            -- 2. performans puanına göre
            + (CASE performance_score
                WHEN 5 THEN 0.02   
                WHEN 4 THEN 0.01   
                WHEN 3 THEN 0.0    
                WHEN 2 THEN -0.05  
                WHEN 1 THEN -0.08  
                ELSE 0.0
              END)
            -- 3.  rastgele sapma ekledim 
            + (random() * 0.04 - 0.02)
        )
    ))
  )::INT; 

---- Her bir departman için OLE hesaplayan sorgu
SELECT 
  department,
  ROUND(
    (SUM(productive_hours)::NUMERIC / SUM(total_scheduled_hours))  --utilization
    * 
    (SUM(actual_output)::NUMERIC / SUM(target_output)) --productivity
    * 100, 2
  ) AS ole_percentage
FROM 
  hr_employee_details_alara
GROUP BY 
  department
ORDER BY 
  ole_percentage DESC;

SELECT * FROM hr_employee_details_alara;

-- Absentee Rate
SELECT 
  MIN(days_absent_last_year),
  MAX(days_absent_last_year),
  AVG(days_absent_last_year)
FROM hr_employee_details_alara;

-- Absentee Rate hesabı kontrol sorgusu
SELECT 
  ROUND(
    (SUM(days_absent_last_year) * 100.0) / 
    (COUNT(DISTINCT employee_id) * 250),
    2
  ) AS absentee_rate_percentage
FROM 
  hr_employee_details_alara;

-- Employee Retention Rate
SELECT 
  ROUND(
    ( 
      (COUNT(*) - SUM(CASE WHEN employment_status = 'Terminated' THEN 1 ELSE 0 END)) 
      * 100.0 
    ) / COUNT(*), 
    2
  ) AS retention_rate_percentage
FROM 
  hr_employee_details_alara;

--Extra
ALTER TABLE hr_employee_details_alara
ADD COLUMN IF NOT EXISTS hire_year INT,
ADD COLUMN IF NOT EXISTS hire_month INT,
ADD COLUMN IF NOT EXISTS termination_year INT,
ADD COLUMN IF NOT EXISTS termination_month INT;

UPDATE hr_employee_details_alara
SET 
  hire_year = EXTRACT(YEAR FROM hire_date),
  hire_month = EXTRACT(MONTH FROM hire_date),
  termination_year = CASE WHEN termination_date IS NOT NULL THEN EXTRACT(YEAR FROM termination_date) END,
  termination_month = CASE WHEN termination_date IS NOT NULL THEN EXTRACT(MONTH FROM termination_date) END;



