
SELECT * FROM warehouse_performance;
-------
-- Total Orders
SELECT
  COUNT(DISTINCT order_id) AS "COUNT_DISTINCT(order_id)"
FROM warehouse_performance;
-------
-- Unfullfilled Orders
SELECT
  COUNT(DISTINCT order_id) AS "COUNT_DISTINCT(order_id)"
FROM warehouse_performance
WHERE
  order_status = 'Unfulfilled';
-------
--Fill Rate
SELECT 
  (COUNT(CASE WHEN order_status = 'Fulfilled' THEN 1 END) * 100.0 
   / COUNT(order_id)) AS fill_rate
FROM warehouse_performance;
-------
--On time, ready to ship
SELECT 
  ROUND(
    COUNT(CASE WHEN is_on_time_ready_to_ship = TRUE THEN 1 END) * 100.0 / COUNT(order_id),
    2
  ) AS on_time_ready_to_ship_percentage
FROM warehouse_performance;
-------
--Avg. Fulfilment Time
SELECT 
  ROUND(AVG(fulfillment_duration_hours)) AS avg_fulfillment_time_hours
FROM warehouse_performance;
-------
-- Order picking accuracy
SELECT 
  ROUND(
    SUM(items_picked_correctly) * 100.0 / NULLIF(SUM(total_items_in_order), 0),
    2
  ) AS picking_accuracy_percentage
FROM warehouse_performance;
-------
--Current Capacity Utlilzation
SELECT 
  (SUM(used_storage_cubic_meters) * 100.0 
   / NULLIF(SUM(total_storage_cubic_meters), 0)) AS storage_utilization_percentage
FROM warehouse_performance;
-------
--Stock Accuracy
DO $$
BEGIN

    -- En Kötü Performanslı Depolar (C ve E)
    UPDATE warehouse_performance
    SET actual_stock_count = ROUND(theoretical_stock_count * (0.70 + (random() * 0.1 - 0.05))) -- %65 ile %75 arası bir değere ayarladım
    WHERE warehouse_name IN ('Warehouse C', 'Warehouse E');

    -- Orta Performanslı Depolar (B, D, F)
    UPDATE warehouse_performance
    SET actual_stock_count = ROUND(theoretical_stock_count * (0.78 + (random() * 0.1 - 0.05))) -- %73 ile %83 arası bir değere ayarladım
    WHERE warehouse_name IN ('Warehouse B', 'Warehouse D', 'Warehouse F');

    -- En İyi Performanslı Depo (A)
    UPDATE warehouse_performance
    SET actual_stock_count = ROUND(theoretical_stock_count * (0.90 + (random() * 0.08 - 0.04))) -- %86 ile %94 arası bir değere ayarladım
    WHERE warehouse_name = 'Warehouse A';

END $$;

-- Kontrol 
SELECT SUM(actual_stock_count) * 100.0 / SUM(theoretical_stock_count) AS calculated_stock_accuracy
FROM warehouse_performance;
-------
--Spend by Warehouse
--'month_label' sütunu ekledim
ALTER TABLE warehouse_performance
ADD COLUMN month_label VARCHAR(20);

UPDATE warehouse_performance
SET month_label = TO_CHAR(performance_month, 'Mon YYYY');

--'month' sütunu ekledim
ALTER TABLE warehouse_performance
ADD COLUMN month DATE;

UPDATE warehouse_performance
SET month = DATE_TRUNC('month', performance_month)::date;

---Kontrol 
SELECT
    warehouse_name,
    month_label,
    SUM(order_spend) AS total_order_spend
FROM warehouse_performance
GROUP BY warehouse_name, month_label, month
ORDER BY warehouse_name, month;
-------
--Capacity Utilization vs Target
SELECT
  performance_month,
  ROUND(
    SUM(used_storage_cubic_meters) * 100.0
    / NULLIF(SUM(total_storage_cubic_meters), 0),
    2
  ) AS capacity_utilization,
  80.0 AS target
FROM warehouse_performance
GROUP BY performance_month
ORDER BY performance_month;
-------
--Picking Accuracy Over Time
SELECT
  performance_month,
  ROUND(
    SUM(correct_items_picked) * 1.0
    / NULLIF(SUM(total_items_ordered), 0),
    4
  ) AS picking_accuracy
FROM warehouse_performance
GROUP BY performance_month
ORDER BY performance_month;

SELECT
  warehouse_name,
  performance_month,
  ROUND(
    SUM(correct_items_picked) * 1.0
    / NULLIF(SUM(total_items_ordered), 0),
    4
  ) AS picking_accuracy
FROM warehouse_performance
GROUP BY warehouse_name, performance_month
ORDER BY warehouse_name, performance_month;
-------
--Total Orders Over Time
SELECT
  performance_month,
  COUNT(DISTINCT order_id) AS total_orders
FROM warehouse_performance
GROUP BY performance_month
ORDER BY performance_month;

















