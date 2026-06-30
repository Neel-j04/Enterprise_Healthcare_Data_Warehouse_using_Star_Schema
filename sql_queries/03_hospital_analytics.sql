-- How many hospitals are available in the healthcare network?
SELECT
    COUNT(*) AS "Total Hospitals"
FROM warehouse.dim_hospital;


-- How many hospitals are active and inactive?
SELECT
    "IsActive",
    COUNT(*) AS "Total Hospitals"
FROM warehouse.dim_hospital
GROUP BY "IsActive"
ORDER BY "Total Hospitals" DESC;


-- How many hospitals are available by hospital type?
SELECT
    "HospitalType",
    COUNT(*) AS "Total Hospitals"
FROM warehouse.dim_hospital
GROUP BY "HospitalType"
ORDER BY "Total Hospitals" DESC;


-- Which states have the highest number of hospitals?
SELECT
    "State",
    COUNT(*) AS "Total Hospitals"
FROM warehouse.dim_hospital
GROUP BY "State"
ORDER BY "Total Hospitals" DESC;


-- Which cities have the highest number of hospitals?
SELECT
    "City",
    COUNT(*) AS "Total Hospitals"
FROM warehouse.dim_hospital
GROUP BY "City"
ORDER BY "Total Hospitals" DESC;


-- Which hospitals have the largest bed capacity?
SELECT
    "HospitalName",
    "BedCapacity"
FROM warehouse.dim_hospital
ORDER BY "BedCapacity" DESC
LIMIT 10;


-- What is the average bed capacity by hospital type?
SELECT
    "HospitalType",
    ROUND(AVG("BedCapacity"),2) AS "Average Bed Capacity"
FROM warehouse.dim_hospital
GROUP BY "HospitalType"
ORDER BY "Average Bed Capacity" DESC;


-- Which hospitals are the oldest?
SELECT
    "HospitalName",
    "FoundedYear"
FROM warehouse.dim_hospital
ORDER BY "FoundedYear"
LIMIT 10;


-- How many hospitals belong to each accreditation status?
SELECT
    "AccreditationStatus",
    COUNT(*) AS "Hospitals"
FROM warehouse.dim_hospital
GROUP BY "AccreditationStatus"
ORDER BY "Hospitals" DESC;


-- Which hospitals handled the highest number of patient visits?
SELECT
    h."HospitalName",
    COUNT(f."VisitKey") AS "Total Visits"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_hospital h
ON f."HospitalKey" = h."HospitalKey"
GROUP BY h."HospitalName"
ORDER BY "Total Visits" DESC
LIMIT 10;


-- Which hospitals generated the highest revenue?
SELECT
    h."HospitalName",
    SUM(f."TotalChargeUSD") AS "Total Revenue"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_hospital h
ON f."HospitalKey" = h."HospitalKey"
GROUP BY h."HospitalName"
ORDER BY "Total Revenue" DESC
LIMIT 10;


-- Which hospitals have the highest average patient satisfaction?
SELECT
    h."HospitalName",
    ROUND(AVG(f."SatisfactionScore"),2) AS "Average Satisfaction"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_hospital h
ON f."HospitalKey" = h."HospitalKey"
GROUP BY h."HospitalName"
ORDER BY "Average Satisfaction" DESC;


-- Which hospitals have the highest average length of stay?
SELECT
    h."HospitalName",
    ROUND(AVG(f."LengthOfStayDays"),2) AS "Average Stay"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_hospital h
ON f."HospitalKey" = h."HospitalKey"
GROUP BY h."HospitalName"
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


-- Which hospitals have the highest average treatment cost?
SELECT
    h."HospitalName",
    ROUND(AVG(f."TreatmentCostUSD"),2) AS "Average Treatment Cost"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_hospital h
ON f."HospitalKey" = h."HospitalKey"
GROUP BY h."HospitalName"
ORDER BY "Average Treatment Cost" DESC;


-- Overall performance summary of every hospital
SELECT
    h."HospitalName",
    COUNT(f."VisitKey") AS "Patients",
    SUM(f."TotalChargeUSD") AS "Revenue",
    ROUND(AVG(f."SatisfactionScore"),2) AS "Average Satisfaction",
    ROUND(AVG(f."LengthOfStayDays"),2) AS "Average Stay"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_hospital h
ON f."HospitalKey" = h."HospitalKey"
GROUP BY h."HospitalName"
ORDER BY "Revenue" DESC;


-- Hospital KPI Dashboard
SELECT
    COUNT(DISTINCT h."HospitalKey") AS "Total Hospitals",
    ROUND(AVG(h."BedCapacity"),2) AS "Average Bed Capacity",
    SUM(f."TotalChargeUSD") AS "Total Revenue",
    COUNT(f."VisitKey") AS "Total Visits",
    ROUND(AVG(f."SatisfactionScore"),2) AS "Average Satisfaction",
    ROUND(AVG(f."LengthOfStayDays"),2) AS "Average Length Of Stay"
FROM warehouse.dim_hospital h
LEFT JOIN warehouse.fact_patient_visit f
ON h."HospitalKey" = f."HospitalKey";