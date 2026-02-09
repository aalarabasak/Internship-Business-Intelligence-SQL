
-- Create table structure 
CREATE TABLE marketing_data (
    event_id SERIAL PRIMARY KEY,
    session_id VARCHAR(255) NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    visit_date DATE NOT NULL,
    device_used VARCHAR(50),
    platform_used VARCHAR(50),
    traffic_source VARCHAR(100),
    content_type VARCHAR(100),
    engagement_action VARCHAR(100),
    clicks INT,
    impressions INT,
    likes INT,
    shares INT,
    sent INT,
    page_views INT,
    session_duration_min FLOAT,
    time_on_page_min FLOAT,
    bounce_occurred BOOLEAN,
    conversion_occurred BOOLEAN,
    leads_generated BOOLEAN,
    keyword VARCHAR(255),
    keyword_ranking INT
);

-- uses generate_series() to create 25,000 rows of varied data
INSERT INTO marketing_data (
    session_id,
    user_id,
    visit_date,
    device_used,
    platform_used,
    traffic_source,
    content_type,
    engagement_action,
    clicks,
    impressions,
    likes,
    shares,
    sent,
    page_views,
    session_duration_min,
    time_on_page_min,
    bounce_occurred,
    conversion_occurred,
    leads_generated,
    keyword,
    keyword_ranking
)
SELECT
    -- Generate unique  session and user IDs
    's_' || (1000 + (random() * 9000))::int || '_' || s.id as session_id,
    'u_' || (10000 + (random() * 40000))::int as user_id,

    -- Generate a random date between Jan 1, 2025, and June 30, 2025
    '2025-01-01'::date + (random() * 180)::int as visit_date,

    -- Randomly assign device, platform, and traffic source 
    CASE (floor(random() * 2))::int
        WHEN 0 THEN 'Mobile'
        ELSE 'Desktop'
    END as device_used,

    CASE (floor(random() * 3))::int
        WHEN 0 THEN 'iOS'
        WHEN 1 THEN 'Android'
        ELSE 'Web'
    END as platform_used,

    CASE (floor(random() * 6))::int
        WHEN 0 THEN 'Organic Search'
        WHEN 1 THEN 'Paid Search'
        WHEN 2 THEN 'Direct Search'
        WHEN 3 THEN 'Social Media'
        WHEN 4 THEN 'Referral Traffic'
        ELSE 'Email Marketing'
    END as traffic_source,

    CASE (floor(random() * 5))::int
        WHEN 0 THEN 'Blog Posts'
        WHEN 1 THEN 'Webinars'
        WHEN 2 THEN 'Podcasts'
        WHEN 3 THEN 'Product Videos'
        ELSE 'Newsletters'
    END as content_type,

    CASE (floor(random() * 5))::int
        WHEN 0 THEN 'page_view'
        WHEN 1 THEN 'Request Demo'
        WHEN 2 THEN 'Start Trial'
        WHEN 3 THEN 'Initiate Live Chat'
        ELSE 'Exit'
    END as engagement_action,

    
    (random() > 0.6)::int as clicks,
    (random() > 0.4)::int as impressions,
    (random() > 0.85)::int as likes,
    (random() > 0.9)::int as shares,
    (random() > 0.95)::int as sent,
    1 as page_views,
    round((random() * 15 + 0.1)::numeric, 2) as session_duration_min,
    round((random() * 10 + 0.1)::numeric, 2) as time_on_page_min,

    
    (random() < 0.18) as bounce_occurred,
    (random() > 0.75) as conversion_occurred,
    (random() > 0.85) as leads_generated,

    
    CASE
        WHEN random() > 0.5 THEN 'marketing tool ' || (random()*100)::int
        ELSE 'crm for ' || (ARRAY['smb','startup','enterprise'])[(random()*3)::int]
    END as keyword,
    (floor(random() * 10) + 1)::int as keyword_ranking

FROM generate_series(1, 25000) as s(id); -- generates 25,000 rows



SELECT count(*) FROM marketing_data;


SELECT * 
FROM marketing_data;