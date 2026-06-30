-- How many patient visits were recorded in the healthcare system?
SELECT
    COUNT(*) AS "Total Visits"
FROM warehouse.fact_patient_visit;


-- How many visits were emergency visits?
SELECT
    "IsEmergency",
    COUNT(*) AS "Total Visits"
FROM warehouse.fact_patient_visit
GROUP BY "IsEmergency"
ORDER BY "Total Visits" DESC;


-- How many visits occurred for each visit type?
SELECT
    "VisitType",
    COUNT(*) AS "Total Visits"
FROM warehouse.fact_patient_visit
GROUP BY "VisitType"
ORDER BY "Total Visits" DESC;


-- What is the average waiting time?
SELECT
    ROUND(AVG("WaitTimeMinutes"),2) AS "Average Wait Time (Minutes)"
FROM warehouse.fact_patient_visit;


-- Which departments have the highest average waiting time?
SELECT
    d."DepartmentName",
    ROUND(AVG(f."WaitTimeMinutes"),2) AS "Average Wait Time"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_department d
ON f."DepartmentKey" = d."DepartmentKey"
GROUP BY d."DepartmentName"
ORDER BY "Average Wait Time" DESC;


-- Which hospitals have the highest average waiting time?
SELECT
    h."HospitalName",
    ROUND(AVG(f."WaitTimeMinutes"),2) AS "Average Wait Time"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_hospital h
ON f."HospitalKey" = h."HospitalKey"
GROUP BY h."HospitalName"
ORDER BY "Average Wait Time" DESC;


-- What is the average length of stay?
SELECT
    ROUND(AVG("LengthOfStayDays"),2) AS "Average Length Of Stay"
FROM warehouse.fact_patient_visit;


-- Which departments have the highest average length of stay?
SELECT
    d."DepartmentName",
    ROUND(AVG(f."LengthOfStayDays"),2) AS "Average Stay"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_department d
ON f."DepartmentKey" = d."DepartmentKey"
GROUP BY d."DepartmentName"
ORDER BY "Average Stay" DESC;


-- Which hospitals handled the most emergency visits?
SELECT
    h."HospitalName",
    COUNT(*) AS "Emergency Visits"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_hospital h
ON f."HospitalKey" = h."HospitalKey"
WHERE f."IsEmergency" = 1
GROUP BY h."HospitalName"
ORDER BY "Emergency Visits" DESC;


-- Which doctors handled the highest number of emergency visits?
SELECT
    d."FullName",
    COUNT(*) AS "Emergency Cases"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_doctor d
ON f."DoctorKey" = d."DoctorKey"
WHERE f."IsEmergency" = 1
GROUP BY d."FullName"
ORDER BY "Emergency Cases" DESC
LIMIT 10;


-- Which departments have the highest ICU admissions?
SELECT
    d."DepartmentName",
    COUNT(*) AS "ICU Cases"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_department d
ON f."DepartmentKey" = d."DepartmentKey"
WHERE f."HasICUStay" = 1
GROUP BY d."DepartmentName"
ORDER BY "ICU Cases" DESC;


-- Which departments handled the highest number of surgeries?
SELECT
    d."DepartmentName",
    COUNT(*) AS "Surgery Cases"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_department d
ON f."DepartmentKey" = d."DepartmentKey"
WHERE f."HasSurgery" = 1
GROUP BY d."DepartmentName"
ORDER BY "Surgery Cases" DESC;


-- What is the readmission rate?
SELECT
    "ReadmissionFlag",
    COUNT(*) AS "Patients"
FROM warehouse.fact_patient_visit
GROUP BY "ReadmissionFlag"
ORDER BY "Patients" DESC;


-- Which severity level has the highest number of visits?
SELECT
    "SeverityLevel",
    COUNT(*) AS "Visits"
FROM warehouse.fact_patient_visit
GROUP BY "SeverityLevel"
ORDER BY "Visits" DESC;


-- Which doctors handled the highest patient workload?
SELECT
    d."FullName",
    COUNT(*) AS "Patients Treated"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_doctor d
ON f."DoctorKey" = d."DoctorKey"
GROUP BY d."FullName"
ORDER BY "Patients Treated" DESC
LIMIT 10;


-- Which hospitals handled the highest patient workload?
SELECT
    h."HospitalName",
    COUNT(*) AS "Patients"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_hospital h
ON f."HospitalKey" = h."HospitalKey"
GROUP BY h."HospitalName"
ORDER BY "Patients" DESC
LIMIT 10;


-- Which departments handled the highest patient workload?
SELECT
    d."DepartmentName",
    COUNT(*) AS "Patients"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_department d
ON f."DepartmentKey" = d."DepartmentKey"
GROUP BY d."DepartmentName"
ORDER BY "Patients" DESC;


-- What is the monthly patient visit trend?
SELECT
    dt."Year",
    dt."MonthName",
    COUNT(*) AS "Total Visits"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_date dt
ON f."DateKey" = dt."DateKey"
GROUP BY
    dt."Year",
    dt."Month",
    dt."MonthName"
ORDER BY
    dt."Year",
    dt."Month";


-- Operational KPI Dashboard
SELECT
    COUNT(*) AS "Total Visits",
    ROUND(AVG("WaitTimeMinutes"),2) AS "Average Wait Time",
    ROUND(AVG("LengthOfStayDays"),2) AS "Average Stay",
    COUNT(*) FILTER (WHERE "IsEmergency" = 1) AS "Emergency Visits",
    COUNT(*) FILTER (WHERE "HasICUStay" = 1) AS "ICU Admissions",
    COUNT(*) FILTER (WHERE "HasSurgery" = 1) AS "Surgeries",
    ROUND(AVG("SatisfactionScore"),2) AS "Average Satisfaction"
FROM warehouse.fact_patient_visit;