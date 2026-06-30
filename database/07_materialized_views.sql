-- Materialized Views

-- Remove Existing Materialized Views
DROP MATERIALIZED VIEW IF EXISTS analytics.mv_monthly_revenue;
DROP MATERIALIZED VIEW IF EXISTS analytics.mv_hospital_performance;
DROP MATERIALIZED VIEW IF EXISTS analytics.mv_doctor_performance;
DROP MATERIALIZED VIEW IF EXISTS analytics.mv_insurance_summary;
DROP MATERIALIZED VIEW IF EXISTS analytics.mv_department_performance;



-- Monthly Revenue
CREATE MATERIALIZED VIEW analytics.mv_monthly_revenue AS
SELECT
	d."Year",
	d."Month",
	d."MonthName",
	SUM(f."TotalChargeUSD") AS TotalRevenue,
	COUNT(*) AS TotalVisits
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_date d
ON f."DateKey" = d."DateKey"
GROUP BY
	d."Year",
	d."Month",
	d."MonthName";

SELECT *
FROM analytics.mv_monthly_revenue
LIMIT 10;



-- Hospital Performance
CREATE MATERIALIZED VIEW analytics.mv_hospital_performance AS
SELECT
	h."HospitalName",
	COUNT(*) AS TotalVisits,
	SUM(f."TotalChargeUSD") AS Revenue,
	AVG(f."SatisfactionScore") AS AvgSatisfaction,
	AVG(f."WaitTimeMinutes") AS AvgWaitTime
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_hospital h
ON f."HospitalKey"=h."HospitalKey"
GROUP BY h."HospitalName";

SELECT *
FROM analytics.mv_hospital_performance
LIMIT 10;



-- Doctor Performance
CREATE MATERIALIZED VIEW analytics.mv_doctor_performance AS
SELECT
	doc."FullName",
	COUNT(*) AS Patients,
	SUM(f."TotalChargeUSD") AS Revenue,
	AVG(f."SatisfactionScore") AS AvgRating
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_doctor doc
ON f."DoctorKey"=doc."DoctorKey"
GROUP BY doc."FullName";

SELECT *
FROM analytics.mv_doctor_performance
LIMIT 10;



-- Department Performance
CREATE MATERIALIZED VIEW analytics.mv_department_performance AS
SELECT
	d."DepartmentName",
	COUNT(*) AS Visits,
	SUM(f."TotalChargeUSD") AS Revenue,
	AVG(f."LengthOfStayDays") AS AvgStay
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_department d
ON f."DepartmentKey"=d."DepartmentKey"
GROUP BY d."DepartmentName";

SELECT *
FROM analytics.mv_department_performance
LIMIT 10;



-- Insurance Summary
CREATE MATERIALIZED VIEW analytics.mv_insurance_summary AS
SELECT
	i."ProviderName",
	COUNT(*) AS Claims,
	SUM(f."InsuranceCoverageUSD") AS TotalCoverage,
	SUM(f."OutstandingAmtUSD") AS OutstandingAmount
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_insurance i
ON f."InsuranceKey"=i."InsuranceKey"
GROUP BY i."ProviderName";

SELECT *
FROM analytics.mv_insurance_summary
LIMIT 10;




REFRESH MATERIALIZED VIEW analytics.mv_monthly_revenue;
REFRESH MATERIALIZED VIEW analytics.mv_hospital_performance;
REFRESH MATERIALIZED VIEW analytics.mv_doctor_performance;
REFRESH MATERIALIZED VIEW analytics.mv_department_performance;
REFRESH MATERIALIZED VIEW analytics.mv_insurance_summary;