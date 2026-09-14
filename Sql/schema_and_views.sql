DROP TABLE IF EXISTS hr_raw_data CASCADE;

-- Raw Data Ingestion Table Creation
CREATE TABLE hr_raw_data (
    age INT,
    attrition VARCHAR(10),
    business_travel VARCHAR(50),
    daily_rate INT,
    department VARCHAR(50),
    distance_from_home INT,
    education INT,
    education_field VARCHAR(100),
    employee_count INT,
    employee_number INT PRIMARY KEY,
    environment_satisfaction INT,
    gender VARCHAR(20),
    hourly_rate INT,
    job_involvement INT,
    job_level INT,
    job_role VARCHAR(100),
    job_satisfaction INT,
    marital_status VARCHAR(20),
    monthly_income NUMERIC(10,2),
    monthly_rate INT,
    num_companies_worked INT,
    over_18 VARCHAR(5),
    over_time VARCHAR(10),
    percent_salary_hike INT,
    performance_rating INT,
    relationship_satisfaction INT,
    standard_hours INT,
    stock_option_level INT,
    total_working_years INT,
    training_times_last_year INT,
    work_life_balance INT,
    years_at_company INT,
    years_in_current_role INT,
    years_since_last_promotion INT,
    years_with_curr_manager INT
);
COPY public.hr_raw_data 
FROM 'E:/Project PSQL & BI/WA_Fn-UseC_-HR-Employee-Attrition.csv' 
WITH (
    FORMAT csv, 
    HEADER true, 
    DELIMITER ',', 
    ENCODING 'UTF8'
);
--------------------------------------------------------------------------------


-- HR Analytics: Attrition Rate & Average Salary by Department
SELECT 
    department,
    COUNT(employee_number) AS total_employees,
    COUNT(CASE WHEN attrition = 'Yes' THEN 1 END) AS total_attrition,
    ROUND(
        (COUNT(CASE WHEN attrition = 'Yes' THEN 1 END)::NUMERIC / COUNT(employee_number)) * 100, 
        2
    ) AS attrition_rate_pct,
    ROUND(AVG(monthly_income), 2) AS avg_monthly_income
FROM hr_raw_data
GROUP BY department
ORDER BY attrition_rate_pct DESC;
--------------------------------------------------------------------------------


-- Drop view if it already exists
DROP MATERIALIZED VIEW IF EXISTS mv_kpi_department_attrition;

-- Create Materialized View for BI Performance
CREATE MATERIALIZED VIEW mv_kpi_department_attrition AS
SELECT 
    department,
    COUNT(employee_number) AS total_employees,
    COUNT(CASE WHEN attrition = 'Yes' THEN 1 END) AS total_attrition,
    ROUND(
        (COUNT(CASE WHEN attrition = 'Yes' THEN 1 END)::NUMERIC / COUNT(employee_number)) * 100, 
        2
    ) AS attrition_rate_pct,
    ROUND(AVG(monthly_income), 2) AS avg_monthly_income
FROM hr_raw_data
GROUP BY department
ORDER BY attrition_rate_pct DESC;

-- Query the Materialized View
SELECT * FROM mv_kpi_department_attrition;
--------------------------------------------------------------------------------


-- Drop view if exists
DROP MATERIALIZED VIEW IF EXISTS mv_kpi_job_role_attrition;

-- Create View by Job Role
CREATE MATERIALIZED VIEW mv_kpi_job_role_attrition AS
SELECT 
    job_role,
    department,
    COUNT(employee_number) AS total_employees,
    COUNT(CASE WHEN attrition = 'Yes' THEN 1 END) AS total_attrition,
    ROUND(
        (COUNT(CASE WHEN attrition = 'Yes' THEN 1 END)::NUMERIC / COUNT(employee_number)) * 100, 
        2
    ) AS attrition_rate_pct,
    ROUND(AVG(monthly_income), 2) AS avg_monthly_income
FROM hr_raw_data
GROUP BY job_role, department
ORDER BY attrition_rate_pct DESC;

-- Query the View
SELECT * FROM mv_kpi_job_role_attrition;
--------------------------------------------------------------------------------


-- Drop view if exists
DROP MATERIALIZED VIEW IF EXISTS mv_kpi_job_overtime_attrition;
-- Create View by Over Time
CREATE MATERIALIZED VIEW mv_kpi_job_overtime_attrition AS
SELECT
    over_time,
    department,
    COUNT(employee_number) AS total_employees,
    COUNT(CASE WHEN attrition = 'Yes' THEN 1 END) AS total_attrition,
    ROUND(
        (COUNT(CASE WHEN attrition = 'Yes' THEN 1 END)::NUMERIC / COUNT(employee_number)) * 100,
        2
    ) AS attrition_rate_pct,
    ROUND(AVG(monthly_income), 2) AS avg_monthly_income
FROM hr_raw_data
GROUP BY over_time, department
ORDER BY attrition_rate_pct DESC, department ASC;

-- Query the View
SELECT * FROM mv_kpi_job_overtime_attrition;   

