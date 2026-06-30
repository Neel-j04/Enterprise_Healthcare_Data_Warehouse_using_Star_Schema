-- Business Analytics Views
CREATE SCHEMA IF NOT EXISTS analytics;


-- 1. Monthly Revenue
CREATE OR REPLACE VIEW analytics.monthly_revenue AS
SELECT
    d."Year",
    d."MonthName",
    SUM(f."TotalChargeUSD") AS TotalRevenue,
    COUNT(*) AS TotalVisits
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_date d
ON f."DateKey" = d."DateKey"
GROUP BY d."Year", d."MonthName"
ORDER BY d."Year", MIN(d."Month");

SELECT *
FROM analytics.monthly_revenue
LIMIT 10;



-- 2. Hospital Performance
CREATE OR REPLACE VIEW analytics.hospital_performance AS
SELECT
	h."HospitalName",
	COUNT(*) AS TotalVisits,
	SUM(f."TotalChargeUSD") AS Revenue,
	AVG(f."SatisfactionScore") AS AvgSatisfaction,
	AVG(f."WaitTimeMinutes") AS AvgWaitTime
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_hospital h
ON f."HospitalKey" = h."HospitalKey"
GROUP BY h."HospitalName";

SELECT *
FROM analytics.hospital_performance
LIMIT 10;



-- 3. Department Performance
CREATE OR REPLACE VIEW analytics.department_performance AS
SELECT
	d."DepartmentName",
	COUNT(*) AS TotalVisits,
	SUM(f."TotalChargeUSD") AS Revenue,
	AVG(f."LengthOfStayDays") AS AvgStay
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_department d
ON f."DepartmentKey" = d."DepartmentKey"
GROUP BY d."DepartmentName";

SELECT *
FROM analytics.department_performance
LIMIT 10;



-- 4. Doctor Performance
CREATE OR REPLACE VIEW analytics.doctor_performance AS
SELECT
	doc."FullName",
	COUNT(*) AS Patients,
	AVG(f."SatisfactionScore") AS AvgRating,
	SUM(f."TotalChargeUSD") AS RevenueGenerated
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_doctor doc
ON f."DoctorKey" = doc."DoctorKey"
GROUP BY
doc."FullName";

SELECT *
FROM analytics.doctor_performance
LIMIT 10;



-- 5. Insurance Summary
CREATE OR REPLACE VIEW analytics.insurance_summary AS
SELECT
	i."ProviderName",
	COUNT(*) AS Claims,
	SUM(f."InsuranceCoverageUSD") AS TotalCoverage,
	SUM(f."OutstandingAmtUSD") AS OutstandingAmount
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_insurance i
ON f."InsuranceKey" = i."InsuranceKey"
GROUP BY i."ProviderName";

SELECT *
FROM analytics.insurance_summary
LIMIT 10;



-- 6. Patient Demographics
CREATE OR REPLACE VIEW analytics.patient_demographics AS
SELECT
	p."Gender",
	p."BloodType",
	COUNT(*) AS TotalPatients,
	AVG(p."Age") AS AverageAge
FROM warehouse.dim_patient p
GROUP BY p."Gender", p."BloodType";

SELECT *
FROM analytics.patient_demographics
LIMIT 10;