
DROP TABLE IF EXISTS hr_employee_details_alara;

-- çalışan detayları tablosu oluşturma
CREATE TABLE hr_employee_details_alara (
    employee_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    gender VARCHAR(10),
    date_of_birth DATE,
    age INT,
    department VARCHAR(50),
    job_title VARCHAR(50),
    hire_date DATE,
    tenure_years NUMERIC(4, 2),
    termination_date DATE,
    employment_status VARCHAR(20),
    salary NUMERIC(10, 2),
    education_level VARCHAR(50),
    city VARCHAR(50),
    manager VARCHAR(100),
    performance_score INT, 
    performance_rating VARCHAR(30), 
    enps_score INT, 
    productivity_rate NUMERIC(5, 2), 
    ole_score NUMERIC(5, 2), 
    days_absent_last_year INT
);

--  Toplam 50 çalışanın verisini tabloya ekleme
INSERT INTO hr_employee_details_alara (
    employee_id, full_name, gender, date_of_birth, age, department, job_title, 
    hire_date, tenure_years, termination_date, employment_status, salary, 
    education_level, city, manager, performance_score, performance_rating, enps_score, 
    productivity_rate, ole_score, days_absent_last_year
) VALUES
-- Pazarlama Departmanı (10 Çalışan)
(1, 'Ayşe Yılmaz', 'Female', '1988-05-20', 37, 'Marketing', 'Marketing Manager', '2015-02-10', 10.47, NULL, 'Active', 180000.00, 'Master''s Degree', 'Istanbul', 'Canan Demir', 5, 'Outstanding', 10, 98.50, 96.20, 3),
(2, 'Burak Kaya', 'Male', '1995-08-15', 29, 'Marketing', 'Digital Marketing Specialist', '2019-07-01', 6.08, NULL, 'Active', 110000.00, 'Bachelor''s Degree', 'Istanbul', 'Ayşe Yılmaz', 4, 'Exceeds Expectations', 9, 95.00, 93.10, 5),
(3, 'Ceren Erol', 'Female', '1998-01-30', 27, 'Marketing', 'Content Creator', '2022-09-01', 2.91, NULL, 'Active', 85000.00, 'Bachelor''s Degree', 'Ankara', 'Ayşe Yılmaz', 4, 'Exceeds Expectations', 9, 93.20, 92.80, 6),
(4, 'Deniz Arslan', 'Male', '1993-11-25', 31, 'Marketing', 'SEO Specialist', '2018-03-12', 7.38, NULL, 'Active', 125000.00, 'Bachelor''s Degree', 'Istanbul', 'Ayşe Yılmaz', 5, 'Outstanding', 10, 99.10, 97.50, 2),
(5, 'Elif Öztürk', 'Female', '1999-06-10', 26, 'Marketing', 'Social Media Specialist', '2023-01-15', 2.54, NULL, 'Active', 80000.00, 'Bachelor''s Degree', 'Izmir', 'Ayşe Yılmaz', 3, 'Meets Expectations', 8, 91.50, 90.50, 8),
(6, 'Fırat Çetin', 'Male', '1992-04-05', 33, 'Marketing', 'Product Marketing Specialist', '2017-10-20', 7.77, NULL, 'Active', 130000.00, 'Master''s Degree', 'Istanbul', 'Ayşe Yılmaz', 4, 'Exceeds Expectations', 9, 96.30, 94.70, 4),
(7, 'Gizem Aksoy', 'Female', '1996-02-18', 29, 'Marketing', 'Marketing Analyst', '2021-06-01', 4.16, NULL, 'Active', 105000.00, 'Bachelor''s Degree', 'Ankara', 'Ayşe Yılmaz', 4, 'Exceeds Expectations', 9, 94.80, 93.50, 5),
(8, 'Hakan Vural', 'Male', '1990-09-12', 34, 'Marketing', 'Graphic Designer', '2016-08-01', 8.99, NULL, 'Active', 140000.00, 'Bachelor''s Degree', 'Istanbul', 'Ayşe Yılmaz', 5, 'Outstanding', 10, 97.80, 95.80, 3),
(9, 'Irem Sancak', 'Female', '2000-03-03', 25, 'Marketing', 'Junior Marketing Assistant', '2024-02-01', 1.49, NULL, 'Active', 65000.00, 'Bachelor''s Degree', 'Izmir', 'Ayşe Yılmaz', 3, 'Meets Expectations', 7, 88.00, 86.00, 10),
(10, 'Caner Güneş', 'Male', '1994-07-22', 31, 'Marketing', 'Content Creator', '2020-11-01', 4.74, '2024-05-31', 'Terminated', 95000.00, 'Bachelor''s Degree', 'Istanbul', 'Ayşe Yılmaz', 2, 'Needs Improvement', 5, 82.00, 80.00, 15),

-- İnsan Kaynakları Departmanı (6 Çalışan)
(11, 'Jale Koç', 'Female', '1985-12-10', 39, 'Human Resources', 'HR Manager', '2014-05-15', 11.21, NULL, 'Active', 170000.00, 'Master''s Degree', 'Istanbul', 'Canan Demir', 5, 'Outstanding', 10, 94.50, 93.00, 4),
(12, 'Kerem Şahin', 'Male', '1993-02-20', 32, 'Human Resources', 'HR Specialist', '2018-09-10', 6.88, NULL, 'Active', 115000.00, 'Bachelor''s Degree', 'Istanbul', 'Jale Koç', 4, 'Exceeds Expectations', 9, 91.00, 89.80, 6),
(13, 'Leyla Doğan', 'Female', '1997-04-14', 28, 'Human Resources', 'Recruitment Specialist', '2022-01-20', 3.52, NULL, 'Active', 100000.00, 'Bachelor''s Degree', 'Ankara', 'Jale Koç', 4, 'Exceeds Expectations', 9, 92.10, 90.50, 5),
(14, 'Mert Yıldırım', 'Male', '1999-11-08', 25, 'Human Resources', 'HR Assistant', '2023-06-01', 2.16, NULL, 'Active', 70000.00, 'Bachelor''s Degree', 'Istanbul', 'Jale Koç', 3, 'Meets Expectations', 8, 88.50, 87.00, 9),
(15, 'Nihal Aydın', 'Female', '1991-03-25', 34, 'Human Resources', 'Payroll Specialist', '2017-07-18', 8.03, NULL, 'Active', 120000.00, 'Bachelor''s Degree', 'Istanbul', 'Jale Koç', 5, 'Outstanding', 10, 95.20, 94.00, 3),
(16, 'Okan Kurt', 'Male', '1995-01-05', 30, 'Human Resources', 'HR Specialist', '2020-04-01', 5.33, NULL, 'Active', 110000.00, 'Bachelor''s Degree', 'Bursa', 'Jale Koç', 3, 'Meets Expectations', 7, 89.80, 88.10, 7),

-- Müşteri Desteği Departmanı (12 Çalışan)
(17, 'Pınar Avcı', 'Female', '1990-10-02', 34, 'Customer Support', 'Support Team Lead', '2016-11-01', 8.74, NULL, 'Active', 145000.00, 'Bachelor''s Degree', 'Istanbul', 'Canan Demir', 5, 'Outstanding', 9, 90.50, 88.00, 4),
(18, 'Rıza Çelik', 'Male', '1996-08-21', 28, 'Customer Support', 'Senior Support Specialist', '2019-01-07', 6.56, NULL, 'Active', 95000.00, 'Bachelor''s Degree', 'Ankara', 'Pınar Avcı', 4, 'Exceeds Expectations', 9, 88.10, 86.50, 6),
(19, 'Selin Uzun', 'Female', '1999-05-18', 26, 'Customer Support', 'Support Specialist', '2022-08-01', 2.99, NULL, 'Active', 75000.00, 'High School', 'Izmir', 'Pınar Avcı', 3, 'Meets Expectations', 7, 85.00, 83.20, 8),
(20, 'Tarkan Polat', 'Male', '2000-02-11', 25, 'Customer Support', 'Support Specialist', '2023-03-15', 2.37, NULL, 'Active', 72000.00, 'Bachelor''s Degree', 'Istanbul', 'Pınar Avcı', 3, 'Meets Expectations', 8, 86.20, 84.50, 7),
(21, 'Sevda Gök', 'Female', '1994-09-09', 30, 'Customer Support', 'Senior Support Specialist', '2018-06-01', 7.16, NULL, 'Active', 100000.00, 'Bachelor''s Degree', 'Istanbul', 'Pınar Avcı', 4, 'Exceeds Expectations', 10, 89.30, 87.10, 5),
(22, 'Uğur Sönmez', 'Male', '1992-07-15', 33, 'Customer Support', 'Technical Support Specialist', '2017-04-10', 8.29, NULL, 'Active', 110000.00, 'Bachelor''s Degree', 'Ankara', 'Pınar Avcı', 4, 'Exceeds Expectations', 9, 88.80, 86.90, 6),
(23, 'Vildan Can', 'Female', '1998-12-30', 26, 'Customer Support', 'Support Specialist', '2022-10-03', 2.82, NULL, 'Active', 74000.00, 'High School', 'Bursa', 'Pınar Avcı', 2, 'Needs Improvement', 6, 82.10, 80.50, 12),
(24, 'Yasin Kara', 'Male', '1997-10-10', 27, 'Customer Support', 'Support Specialist', '2021-12-01', 3.66, '2024-08-15', 'Terminated', 80000.00, 'Bachelor''s Degree', 'Istanbul', 'Pınar Avcı', 3, 'Meets Expectations', 8, 85.50, 83.80, 10),
(25, 'Zeynep Taş', 'Female', '1989-01-20', 36, 'Customer Support', 'Key Account Support', '2015-09-01', 9.91, NULL, 'Active', 125000.00, 'Master''s Degree', 'Istanbul', 'Pınar Avcı', 5, 'Outstanding', 10, 91.20, 89.00, 3),
(26, 'Ahmet Tufan', 'Male', '1995-06-16', 30, 'Customer Support', 'Technical Support Specialist', '2020-08-12', 4.96, NULL, 'Active', 105000.00, 'Bachelor''s Degree', 'Izmir', 'Pınar Avcı', 4, 'Exceeds Expectations', 9, 87.90, 85.40, 5),
(27, 'Bahar Ateş', 'Female', '2001-04-04', 24, 'Customer Support', 'Junior Support Specialist', '2024-01-08', 1.55, NULL, 'Active', 60000.00, 'High School', 'Istanbul', 'Pınar Avcı', 3, 'Meets Expectations', 8, 84.00, 81.10, 9),
(28, 'Cemil Işık', 'Male', '1993-08-08', 31, 'Customer Support', 'Senior Support Specialist', '2018-11-19', 6.69, NULL, 'Active', 98000.00, 'Bachelor''s Degree', 'Ankara', 'Pınar Avcı', 4, 'Exceeds Expectations', 9, 89.00, 87.30, 6),

-- Finans Departmanı (8 Çalışan)
(29, 'Derya Bulut', 'Female', '1986-07-11', 39, 'Finance', 'Finance Manager', '2013-03-01', 12.41, NULL, 'Active', 190000.00, 'Master''s Degree', 'Istanbul', 'Canan Demir', 5, 'Outstanding', 10, 92.50, 90.80, 2),
(30, 'Emre Deniz', 'Male', '1991-09-19', 33, 'Finance', 'Senior Accountant', '2016-07-01', 9.07, NULL, 'Active', 140000.00, 'Bachelor''s Degree', 'Istanbul', 'Derya Bulut', 5, 'Outstanding', 9, 90.10, 88.20, 4),
(31, 'Fatma Kılıç', 'Female', '1994-02-14', 31, 'Finance', 'Financial Analyst', '2019-08-12', 5.96, NULL, 'Active', 125000.00, 'Bachelor''s Degree', 'Ankara', 'Derya Bulut', 4, 'Exceeds Expectations', 9, 88.30, 86.40, 6),
(32, 'Galip Özer', 'Male', '1998-05-29', 27, 'Finance', 'Accountant', '2022-03-01', 3.41, NULL, 'Active', 95000.00, 'Bachelor''s Degree', 'Istanbul', 'Derya Bulut', 3, 'Meets Expectations', 8, 85.20, 83.10, 8),
(33, 'Hale Jale', 'Female', '2000-01-01', 25, 'Finance', 'Junior Accountant', '2023-07-03', 2.07, NULL, 'Active', 75000.00, 'Bachelor''s Degree', 'Izmir', 'Derya Bulut', 3, 'Meets Expectations', 7, 83.90, 82.00, 9),
(34, 'İsmail Aslan', 'Male', '1989-06-06', 36, 'Finance', 'Controlling Specialist', '2015-10-01', 9.83, NULL, 'Active', 150000.00, 'Master''s Degree', 'Istanbul', 'Derya Bulut', 4, 'Exceeds Expectations', 10, 91.50, 89.90, 5),
(35, 'Kübra Çınar', 'Female', '1992-12-12', 32, 'Finance', 'Financial Analyst', '2018-02-01', 7.49, NULL, 'Active', 130000.00, 'Bachelor''s Degree', 'Istanbul', 'Derya Bulut', 4, 'Exceeds Expectations', 9, 87.80, 86.20, 7),
(36, 'Levent Duran', 'Male', '1996-04-30', 29, 'Finance', 'Accountant', '2021-09-01', 3.91, '2025-01-10', 'Terminated', 100000.00, 'Bachelor''s Degree', 'Ankara', 'Derya Bulut', 2, 'Needs Improvement', 4, 80.00, 78.50, 14),

-- Satış Departmanı (14 Çalışan)
(37, 'Murat Gündüz', 'Male', '1987-03-17', 38, 'Sales', 'Sales Director', '2012-08-20', 12.94, NULL, 'Active', 220000.00, 'Master''s Degree', 'Istanbul', 'Canan Demir', 5, 'Outstanding', 10, 94.10, 91.50, 3),
(38, 'Nazlı Korkmaz', 'Female', '1993-11-01', 31, 'Sales', 'Sales Manager', '2017-06-05', 8.15, NULL, 'Active', 160000.00, 'Bachelor''s Degree', 'Ankara', 'Murat Gündüz', 4, 'Exceeds Expectations', 9, 91.80, 89.20, 5),
(39, 'Onur Tekin', 'Male', '1995-07-13', 30, 'Sales', 'Key Account Manager', '2019-02-11', 6.46, NULL, 'Active', 135000.00, 'Bachelor''s Degree', 'Istanbul', 'Murat Gündüz', 5, 'Outstanding', 10, 93.20, 90.10, 4),
(40, 'Özge Sarı', 'Female', '1998-09-02', 26, 'Sales', 'Sales Representative', '2022-05-16', 3.12, NULL, 'Active', 85000.00, 'Bachelor''s Degree', 'Izmir', 'Nazlı Korkmaz', 3, 'Meets Expectations', 8, 86.40, 84.30, 8),
(41, 'Polat Demir', 'Male', '1999-04-19', 26, 'Sales', 'Sales Representative', '2023-08-21', 1.94, NULL, 'Active', 80000.00, 'High School', 'Bursa', 'Nazlı Korkmaz', 3, 'Meets Expectations', 7, 85.10, 83.50, 10),
(42, 'Reyhan Güler', 'Female', '1996-06-24', 29, 'Sales', 'Sales Representative', '2021-03-01', 4.41, NULL, 'Active', 90000.00, 'Bachelor''s Degree', 'Istanbul', 'Nazlı Korkmaz', 4, 'Exceeds Expectations', 9, 88.90, 87.20, 6),
(43, 'Salih Canpolat', 'Male', '1992-01-08', 33, 'Sales', 'Business Development Specialist', '2018-01-15', 7.53, NULL, 'Active', 140000.00, 'Bachelor''s Degree', 'Istanbul', 'Murat Gündüz', 4, 'Exceeds Expectations', 9, 90.50, 88.80, 5),
(44, 'Sultan Balcı', 'Female', '1994-08-28', 30, 'Sales', 'Sales Operations Analyst', '2020-02-03', 5.48, NULL, 'Active', 110000.00, 'Bachelor''s Degree', 'Ankara', 'Murat Gündüz', 4, 'Exceeds Expectations', 10, 89.80, 87.70, 7),
(45, 'Tolga Erdem', 'Male', '1997-05-14', 28, 'Sales', 'Sales Representative', '2022-11-01', 2.74, NULL, 'Active', 82000.00, 'Bachelor''s Degree', 'Istanbul', 'Nazlı Korkmaz', 2, 'Needs Improvement', 6, 81.30, 79.90, 13),
(46, 'Tuğba Seven', 'Female', '2001-01-23', 24, 'Sales', 'Junior Sales Representative', '2024-03-01', 1.41, NULL, 'Active', 68000.00, 'High School', 'Izmir', 'Nazlı Korkmaz', 3, 'Meets Expectations', 8, 84.50, 82.10, 9),
(47, 'Ufuk Dağ', 'Male', '1990-10-30', 34, 'Sales', 'Key Account Manager', '2016-09-01', 8.91, NULL, 'Active', 145000.00, 'Master''s Degree', 'Istanbul', 'Murat Gündüz', 5, 'Outstanding', 10, 92.70, 90.50, 4),
(48, 'Ümit Keskin', 'Male', '1995-12-05', 29, 'Sales', 'Sales Representative', '2020-10-10', 4.79, NULL, 'Active', 92000.00, 'Bachelor''s Degree', 'Bursa', 'Nazlı Korkmaz', 4, 'Exceeds Expectations', 9, 87.50, 85.90, 6),
(49, 'Volkan Tezcan', 'Male', '1991-02-02', 34, 'Sales', 'Business Development Manager', '2015-05-05', 10.23, NULL, 'Active', 175000.00, 'Master''s Degree', 'Istanbul', 'Murat Gündüz', 5, 'Outstanding', 9, 93.80, 91.10, 3),
(50, 'Zehra Parlak', 'Female', '1997-07-07', 28, 'Sales', 'Sales Representative', '2021-08-01', 4.00, NULL, 'Active', 88000.00, 'Bachelor''s Degree', 'Ankara', 'Nazlı Korkmaz', 3, 'Meets Expectations', 8, 86.90, 85.00, 7);
-----
SELECT * FROM hr_employee_details_alara;
