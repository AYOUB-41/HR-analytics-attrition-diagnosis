# HR Analytics: Executive Attrition & Overtime Diagnosis

## Executive Summary

This project delivers an end-to-end Data Analytics solution designed to analyze employee attrition and quantify the impact of overtime work on turnover rates. Built using PostgreSQL for data pipeline orchestration and Power BI for executive reporting, the dashboard translates raw workforce metrics into actionable HR retention strategies.

## Key Business Insights

- **Overall Attrition Rate:** 16.12% across the organization (237 departures out of 1,470 total employees).
- **Overtime Impact:** 53.59% of all employee departures come from staff working overtime (127 out of 237 departures).
- **Department Vulnerability:** The Sales department displays the highest baseline attrition (20.63%), spiking to 37.50% among sales employees working overtime.
- **R&D Stability:** Research & Development maintains the lowest baseline attrition (13.84%), though overtime increases its rate significantly to 27.31%.

## Technical Architecture & Pipeline

```
[ Raw IBM HR Dataset ]
        │
        ▼
[ PostgreSQL Database ]
  ├── Data Ingestion & Cleaning
  └── Materialized Views Aggregation (mv_kpi_department_attrition, etc.)
        │
        ▼
[ Power BI Layer ]
  ├── Data Modeling (Star Schema)
  ├── Advanced DAX Measures (_Measures)
  └── Interactive Visual Analytics
```

## SQL Engineering & Data Preprocessing

Aggregations and metric calculations were materialized in PostgreSQL to optimize query performance and ensure business logic remains centralized at the database layer.

```sql
-- PostgreSQL: Materialized View for Department Attrition & Overtime Diagnosis
CREATE MATERIALIZED VIEW mv_kpi_job_overtime_attrition AS
SELECT 
    department,
    over_time,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS total_attrition,
    ROUND(
        (SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)::DECIMAL / COUNT(*)) * 100, 
        2
    ) AS attrition_rate_pct,
    ROUND(AVG(monthly_income), 2) AS avg_monthly_income
FROM hr_dataset
GROUP BY department, over_time;
```

## Data Modeling & DAX Measures

All Key Performance Indicators are encapsulated in a dedicated `_Measures` table within Power BI for seamless report maintenance:

**Overall Attrition Rate (%)**
```dax
Attrition Rate % = 
DIVIDE(
    SUM(mv_kpi_department_attrition[total_attrition]), 
    SUM(mv_kpi_department_attrition[total_employees]), 
    0
)
```

**Overtime Specific Attrition Rate (%)**
```dax
Attrition Rate Overtime % = 
DIVIDE(
    SUM(mv_kpi_job_overtime_attrition[total_attrition]), 
    SUM(mv_kpi_job_overtime_attrition[total_employees]), 
    0
)
```

## Dashboard Features & Layout

- **Executive KPI Cards:** Quick visibility into high-level metrics (Total Employees, Global Attrition Rate).
- **Donut Chart Analysis:** Visual split of departure volumes by Overtime status (127 Yes vs. 110 No).
- **Clustered Bar Charts:** Side-by-side comparison of baseline vs. overtime-induced attrition across departments.
- **Interactive Slicers:** Dynamic filtering by Department, and Overtime Status.

## Project Setup & Installation

### Prerequisites

- PostgreSQL 13+
- Power BI Desktop (Latest Version)

### Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/AYOUB-41/hr-analytics-attrition-diagnosis.git
   ```

2. **Setup PostgreSQL Database:**
   - Create database `rh_analytics_db`.
   - Run the SQL scripts provided in `/sql/schema_and_views.sql`.

3. **Open Report:**
   - Launch `HR_Analytics_Dashboard.pbix` in Power BI Desktop.
   - Update database credentials under `Transform Data -> Data Source Settings` to point to your local PostgreSQL instance.
