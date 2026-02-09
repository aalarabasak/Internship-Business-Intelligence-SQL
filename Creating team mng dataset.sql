
DROP TABLE IF EXISTS team_management_dashboard_data;

--  tabloyu oluşturdum
CREATE TABLE team_management_dashboard_data (
    task_id SERIAL PRIMARY KEY,
    project_name VARCHAR(50),
    resource_name VARCHAR(50),
    team_role VARCHAR(50),
    task_type VARCHAR(20), 
    task_title VARCHAR(255),
    status VARCHAR(20), 
    priority VARCHAR(20),
    story_points INTEGER,
    creation_date DATE,
    start_date DATE,
    end_date DATE,
    year INTEGER
);

-- Veri üretimi için bir DO bloğu kullandım
DO $$
DECLARE
    v_project_names TEXT[] := ARRAY['Project Alpha', 'Project Beta', 'Project Gamma', 'Project Delta'];
    -- Proje dağılımı
    v_project_distribution INTEGER[] := ARRAY[1,1,1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,4,4];

    -- Rol dağılımı
    v_team_roles TEXT[] := ARRAY[
        'Software Developer', 'Software Developer', 'Software Developer', 'Software Developer', 'Software Developer', 'Software Developer', 'Software Developer', 'Software Developer', 'Software Developer', 'Software Developer',
        'Graphics Designer', 'Graphics Designer', 'Graphics Designer', 'Graphics Designer',
        'Testing Engineer', 'Testing Engineer', 'Testing Engineer',
        'QA Engineer', 'QA Engineer',
        'Support Engineer'
    ];
    v_task_types TEXT[] := ARRAY['Story', 'Story', 'Story', 'Bug', 'Bug', 'Feature']; -- Görev tipleri ağırlıklı
    v_statuses TEXT[] := ARRAY['Closed', 'Closed', 'Closed', 'Closed', 'Validated', 'Validated', 'In Progress', 'In Review', 'Testing', 'Open', 'On Hold']; -- Tamamlanma oranını %67 civarında tutmak için
    v_priorities TEXT[] := ARRAY['Low', 'Normal', 'Normal', 'Normal', 'High', 'High', 'Critical'];

    -- 46 adet benzersiz resource oluşturmak için
    v_resources TEXT[46];
    v_resource_role_map JSONB := '{}'::JSONB; -- Hangi kaynağın hangi rolde olduğunu tutmak için

    i INTEGER;
    j INTEGER;
    selected_role TEXT;
    selected_status TEXT;
    selected_task_type TEXT;
    generated_creation_date DATE;
    generated_start_date DATE;
    generated_end_date DATE;
    story_point_value INTEGER;
    resource_counter INTEGER := 0;

BEGIN
    -- 46 adet benzersiz resource ve rollerini burada oluşturdum
    FOREACH selected_role IN ARRAY v_team_roles

    j := 1;
    -- 22 Software Developers
    FOR i IN 1..22 LOOP v_resources[j] := 'Resource_' || j; v_resource_role_map := v_resource_role_map || jsonb_build_object('Resource_' || j, 'Software Developer'); j := j + 1; END LOOP;
    -- 9 Graphics Designers
    FOR i IN 1..9 LOOP v_resources[j] := 'Resource_' || j; v_resource_role_map := v_resource_role_map || jsonb_build_object('Resource_' || j, 'Graphics Designer'); j := j + 1; END LOOP;
    -- 7 Testing Engineers
    FOR i IN 1..7 LOOP v_resources[j] := 'Resource_' || j; v_resource_role_map := v_resource_role_map || jsonb_build_object('Resource_' || j, 'Testing Engineer'); j := j + 1; END LOOP;
    -- 4 QA Engineers
    FOR i IN 1..4 LOOP v_resources[j] := 'Resource_' || j; v_resource_role_map := v_resource_role_map || jsonb_build_object('Resource_' || j, 'QA Engineer'); j := j + 1; END LOOP;
    -- 4 Support Engineers
    FOR i IN 1..4 LOOP v_resources[j] := 'Resource_' || j; v_resource_role_map := v_resource_role_map || jsonb_build_object('Resource_' || j, 'Support Engineer'); j := j + 1; END LOOP;


    --  4000 satır veri ürettim
    FOR i IN 1..4000 LOOP
        selected_task_type := v_task_types[1 + floor(random() * array_length(v_task_types, 1))];
        selected_status := v_statuses[1 + floor(random() * array_length(v_statuses, 1))];
        
        -- Rastgele bir kaynak ve rolünü seçtim
        DECLARE
            selected_resource TEXT := v_resources[1 + floor(random() * 46)];
            assigned_role TEXT;
        BEGIN
            assigned_role := v_resource_role_map ->> selected_resource;

            -- Tarihleri oluşturdum (2022-2024 arası)
            -- Yıl dağılımını da hafifçe dengesiz yaptım:     2023 en yoğun yıl 
            DECLARE
                rand_year_picker REAL := random();
                base_year INTEGER;
            BEGIN
                IF rand_year_picker < 0.25 THEN 
                    base_year := 2022;
                ELSIF rand_year_picker < 0.75 THEN 
                    base_year := 2023;
                ELSE 
                    base_year := 2024;
                END IF;
                generated_creation_date := (DATE (base_year || '-01-01')) + (floor(random() * 365)::int * INTERVAL '1 day');
            END;

            generated_start_date := generated_creation_date + (floor(random() * 5 + 1)::int * INTERVAL '1 day');

            -- Task Cycle Time metriğini sağlamak için ortalama 32 günlük döngüler oluşturdum.
            -- Sadece tamamlanmış görevlerin bitiş tarihi olur.
            IF selected_status IN ('Closed', 'Validated') THEN
                generated_end_date := generated_start_date + (floor(random() * 50 + 5)::int * INTERVAL '1 day'); 
            ELSE
                generated_end_date := NULL;
            END IF;

            -- Avg. Story Points metriğini sağlamak için
            -- Bug'lara 0, diğerlerine 1,2,3,5 gibi değerler verdim.
            IF selected_task_type = 'Bug' THEN
                story_point_value := 0;
            ELSE
                story_point_value := (ARRAY[1, 1, 1, 2, 2, 3, 5, 8])[1 + floor(random() * 8)]; 
            END IF;

            -- Veriyi tabloya ekledim
            INSERT INTO team_management_dashboard_data (
                project_name,
                resource_name,
                team_role,
                task_type,
                task_title,
                status,
                priority,
                story_points,
                creation_date,
                start_date,
                end_date,
                year
            ) VALUES (
                v_project_names[v_project_distribution[1 + floor(random() * array_length(v_project_distribution, 1))]],
                selected_resource,
                assigned_role,
                selected_task_type,
                'Task ' || i || ' - ' || selected_task_type,
                selected_status,
                v_priorities[1 + floor(random() * array_length(v_priorities, 1))],
                story_point_value,
                generated_creation_date,
                generated_start_date,
                generated_end_date,
                EXTRACT(YEAR FROM generated_creation_date)
            );
        END;
    END LOOP;
END;
$$;

-- Oluşturulan veriyi kontrol etmek için birkaç sorgu
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT resource_name) AS total_resources
FROM team_management_dashboard_data;

SELECT
    team_role,
    COUNT(*) as count_of_role,
    ROUND(COUNT(*) * 100.0 / 4000, 2) as percentage
FROM team_management_dashboard_data
GROUP BY team_role
ORDER BY count_of_role DESC;

SELECT
    AVG(end_date - start_date) AS avg_cycle_time_in_days
FROM team_management_dashboard_data
WHERE status IN ('Closed', 'Validated');

SELECT
    AVG(story_points) AS average_story_points
FROM team_management_dashboard_data
WHERE story_points > 0;

SELECT * FROM team_management_dashboard_data;
SELECT COUNT(DISTINCT project_name) FROM team_management_dashboard_data;