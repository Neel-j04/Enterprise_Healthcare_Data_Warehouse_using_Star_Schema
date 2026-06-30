-- Executive KPI 1: What is the total revenue generated?
SELECT
    SUM("TotalChargeUSD") AS "Total Revenue"
FROM warehouse.fact_patient_visit;


-- Executive KPI 2: How many patient visits were recorded?
SELECT
    COUNT(*) AS "Total Visits"
FROM warehouse.fact_patient_visit;


-- Executive KPI 3: How many unique patients visited the hospitals?
SELECT
    COUNT(DISTINCT "PatientKey") AS "Unique Patients"
FROM warehouse.fact_patient_visit;


-- Executive KPI 4: How many active hospitals are in the healthcare network?
SELECT
    COUNT(*) AS "Active Hospitals"
FROM warehouse.dim_hospital
WHERE "IsActive" = TRUE;


-- Executive KPI 5: How many active doctors are available?
SELECT
    COUNT(*) AS "Active Doctors"
FROM warehouse.dim_doctor
WHERE "IsActive" = TRUE;


-- Executive KPI 6: Which hospital generated the highest revenue?
SELECT
    h."HospitalName",
    SUM(f."TotalChargeUSD") AS "Revenue"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_hospital h
ON f."HospitalKey" = h."HospitalKey"
GROUP BY h."HospitalName"
ORDER BY "Revenue" DESC
LIMIT 1;


-- Executive KPI 7: Which department generated the highest revenue?
SELECT
    d."DepartmentName",
    SUM(f."TotalChargeUSD") AS "Revenue"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_department d
ON f."DepartmentKey" = d."DepartmentKey"
GROUP BY d."DepartmentName"
ORDER BY "Revenue" DESC
LIMIT 1;


-- Executive KPI 8: Which doctor generated the highest revenue?
SELECT
    d."FullName",
    SUM(f."TotalChargeUSD") AS "Revenue"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_doctor d
ON f."DoctorKey" = d."DoctorKey"
GROUP BY d."FullName"
ORDER BY "Revenue" DESC
LIMIT 1;


-- Executive KPI 9: What is the average patient satisfaction score?
SELECT
    ROUND(AVG("SatisfactionScore"),2) AS "Average Satisfaction"
FROM warehouse.fact_patient_visit;


-- Executive KPI 10: What is the average length of stay?
SELECT
    ROUND(AVG("LengthOfStayDays"),2) AS "Average Length Of Stay"
FROM warehouse.fact_patient_visit;


-- Executive KPI 11: Executive Dashboard Summary
SELECT
    SUM("TotalChargeUSD") AS "Total Revenue",
    COUNT(*) AS "Total Visits",
    COUNT(DISTINCT "PatientKey") AS "Unique Patients",
    ROUND(AVG("TotalChargeUSD"),2) AS "Average Bill",
    ROUND(AVG("LengthOfStayDays"),2) AS "Average Stay",
    ROUND(AVG("WaitTimeMinutes"),2) AS "Average Wait Time",
    ROUND(AVG("SatisfactionScore"),2) AS "Average Satisfaction",
    SUM("InsuranceCoverageUSD") AS "Insurance Coverage",
    SUM("PatientPaidUSD") AS "Patient Payments",
    SUM("OutstandingAmtUSD") AS "Outstanding Amount"
FROM warehouse.fact_patient_visit;