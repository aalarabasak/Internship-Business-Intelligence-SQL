DROP TABLE IF EXISTS warehouse_performance;

-- tabloyu oluşturdum
CREATE TABLE warehouse_performance (
    order_id SERIAL PRIMARY KEY,
    warehouse_name VARCHAR(50),
    performance_month DATE,
    order_status VARCHAR(20), 
    is_on_time_ready_to_ship BOOLEAN, 
    fulfillment_duration_hours INT, 
    total_items_in_order INT, 
    items_picked_correctly INT, 
    theoretical_stock_count INT, 
    actual_stock_count INT, 
    used_storage_cubic_meters NUMERIC(10, 2), 
    total_storage_cubic_meters NUMERIC(10, 2), 
    order_spend NUMERIC(10, 2) 
);

-- Sentetik veri üretimi için oluşturduğum do bloğu
DO $$
DECLARE
   -- değişkenler
    v_warehouse_name VARCHAR(50);
    v_performance_month DATE;
    v_month_int INT;
    v_order_status VARCHAR(20);
    v_is_on_time_ready_to_ship BOOLEAN;
    v_fulfillment_duration_hours INT;
    v_total_items_in_order INT;
    v_items_picked_correctly INT;
    v_theoretical_stock_count INT;
    v_actual_stock_count INT;
    v_used_storage_cubic_meters NUMERIC(10, 2);
    v_total_storage_cubic_meters NUMERIC(10, 2);
    v_order_spend NUMERIC(10, 2);

    -- yardımcı değişkenler
    v_random_factor DOUBLE PRECISION;
    v_picking_accuracy_rate NUMERIC;
    v_stock_deviation_factor NUMERIC;
    v_capacity_utilization_rate NUMERIC;

    warehouses TEXT[] := ARRAY['Warehouse A', 'Warehouse B', 'Warehouse C', 'Warehouse D', 'Warehouse E', 'Warehouse F'];

BEGIN
    -- 4000 satırlık ham veri ürettim
    FOR i IN 1..4000 LOOP
        v_random_factor := random();

        --   Warehouse Name 
        v_warehouse_name := CASE
            WHEN v_random_factor < 0.15 THEN warehouses[1] -- Warehouse A
            WHEN v_random_factor < 0.30 THEN warehouses[2] -- Warehouse B
            WHEN v_random_factor < 0.40 THEN warehouses[3] -- Warehouse C 
            WHEN v_random_factor < 0.65 THEN warehouses[4] -- Warehouse D 
            WHEN v_random_factor < 0.80 THEN warehouses[5] -- Warehouse E
            ELSE warehouses[6] -- Warehouse F 
        END;

        --  Performance Month 
        v_month_int := floor(random() * 12) + 1;
        v_performance_month := make_date(2025, v_month_int, 1);

        -- order_status
        v_order_status := CASE WHEN random() < 0.15 THEN 'Unfulfilled' ELSE 'Fulfilled' END;

        --  is_on_time_ready_to_ship
        v_is_on_time_ready_to_ship := random() < 0.77;

        -- fulfillment_duration_hours
        v_fulfillment_duration_hours := floor(1 + (power(random(), 3) * 72));

        v_total_items_in_order := floor(random() * 20) + 1;
        
        v_picking_accuracy_rate := CASE
            WHEN v_month_int = 3 THEN 0.60 + (random()*0.05) -- Mart ayında genel düşüş
            WHEN v_month_int = 2 THEN 0.82 + (random()*0.05) -- Şubat ayında zirve
            ELSE 0.68 + (random()*0.05)
        END;
     
        v_picking_accuracy_rate := v_picking_accuracy_rate + CASE
            WHEN v_warehouse_name = 'Warehouse A' THEN 0.05 -- A daha iyi
            WHEN v_warehouse_name = 'Warehouse C' THEN -0.05 -- C daha kötü
            ELSE 0
        END;
        v_items_picked_correctly := floor(v_total_items_in_order * v_picking_accuracy_rate);
        v_items_picked_correctly := GREATEST(0, LEAST(v_total_items_in_order, v_items_picked_correctly));

        --  Stok Doğruluğu metrikleri 
        v_theoretical_stock_count := floor(random() * 200) + 50;
     
        v_stock_deviation_factor := CASE
            WHEN v_warehouse_name IN ('Warehouse C', 'Warehouse E') THEN 0.30 -- Kötü stok yönetimi
            WHEN v_warehouse_name = 'Warehouse A' THEN 0.05 -- İyi stok yönetimi
            ELSE 0.15 -- Ortalama
        END;
        v_actual_stock_count := round(v_theoretical_stock_count * (1 + (random() - 0.5) * v_stock_deviation_factor));

        --  Kapasite Kullanımı metrikleri 
        v_total_storage_cubic_meters := CASE
            WHEN v_warehouse_name = 'Warehouse C' THEN 8000
            WHEN v_warehouse_name = 'Warehouse D' THEN 18000
            WHEN v_warehouse_name = 'Warehouse B' THEN 15000
            ELSE 12000
        END;
    
        v_capacity_utilization_rate := CASE
            WHEN v_month_int = 4 THEN 0.727 
            WHEN v_month_int = 7 THEN 0.756 
            ELSE 0.74
        END + (random() - 0.5) * 0.02; 
        v_used_storage_cubic_meters := round(v_total_storage_cubic_meters * v_capacity_utilization_rate, 2);

        -- order_spend - Depoya göre değiştirdim harcama dağılımını
        v_order_spend := CASE
            WHEN v_warehouse_name = 'Warehouse C' THEN 500 + (random() * 1500)
            WHEN v_warehouse_name IN ('Warehouse B', 'Warehouse D') THEN 3000 + (random() * 4000)
            ELSE 1500 + (random() * 2500)
        END;

        -- tabloya ekledim
        INSERT INTO warehouse_performance(
            warehouse_name,
            performance_month,
            order_status,
            is_on_time_ready_to_ship,
            fulfillment_duration_hours,
            total_items_in_order,
            items_picked_correctly,
            theoretical_stock_count,
            actual_stock_count,
            used_storage_cubic_meters,
            total_storage_cubic_meters,
            order_spend
        ) VALUES (
            v_warehouse_name,
            v_performance_month,
            v_order_status,
            v_is_on_time_ready_to_ship,
            v_fulfillment_duration_hours,
            v_total_items_in_order,
            v_items_picked_correctly,
            v_theoretical_stock_count,
            v_actual_stock_count,
            v_used_storage_cubic_meters,
            v_total_storage_cubic_meters,
            v_order_spend
        );
    END LOOP;
END $$;
--


