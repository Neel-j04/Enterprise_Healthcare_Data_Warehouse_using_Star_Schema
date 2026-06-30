-- How many different treatments are available in the healthcare system?
SELECT
    COUNT(*) AS "Total Treatments"
FROM warehouse.dim_treatment;


-- How many treatments require hospitalization?
SELECT
    "RequiresHospitalization",
    COUNT(*) AS "Total Treatments"
FROM warehouse.dim_treatment
GROUP BY "RequiresHospitalization";


-- How many treatments require anesthesia?
SELECT
    "RequiresAnesthesia",
    COUNT(*) AS "Total Treatments"
FROM warehouse.dim_treatment
GROUP BY "RequiresAnesthesia";


-- Which treatments have the highest standard maximum cost?
SELECT
    "TreatmentName",
    "StandardCostMax"
FROM warehouse.dim_treatment
ORDER BY "StandardCostMax" DESC
LIMIT 10;


-- Which treatments have the highest standard minimum cost?
SELECT
    "TreatmentName",
    "StandardCostMin"
FROM warehouse.dim_treatment
ORDER BY "StandardCostMin" DESC
LIMIT 10;


-- What is the average treatment duration by department?
SELECT
    "Department",
    ROUND(AVG("DurationHours")::numeric, 2) AS "Average Duration (Hours)"
FROM warehouse.dim_treatment
GROUP BY "Department"
ORDER BY "Average Duration (Hours)" DESC;


-- Which treatments were performed most frequently?
SELECT
    t."TreatmentName",
    COUNT(f."VisitKey") AS "Treatment Count"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_treatment t
ON f."TreatmentKey" = t."TreatmentKey"
GROUP BY t."TreatmentName"
ORDER BY "Treatment Count" DESC
LIMIT 10;


-- Which treatments generated the highest revenue?
SELECT
    t."TreatmentName",
    SUM(f."TotalChargeUSD") AS "Revenue"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_treatment t
ON f."TreatmentKey" = t."TreatmentKey"
GROUP BY t."TreatmentName"
ORDER BY "Revenue" DESC
LIMIT 10;


-- What is the average treatment cost by treatment?
SELECT
    t."TreatmentName",
    ROUND(AVG(f."TreatmentCostUSD"),2) AS "Average Treatment Cost"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_treatment t
ON f."TreatmentKey" = t."TreatmentKey"
GROUP BY t."TreatmentName"
ORDER BY "Average Treatment Cost" DESC;


-- What is the average patient stay for each treatment?
SELECT
    t."TreatmentName",
    ROUND(AVG(f."LengthOfStayDays"),2) AS "Average Stay (Days)"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_treatment t
ON f."TreatmentKey" = t."TreatmentKey"
GROUP BY t."TreatmentName"
ORDER BY "Average Stay (Days)" DESC;


-- Which treatments have the highest patient satisfaction?
SELECT
    t."TreatmentName",
    ROUND(AVG(f."SatisfactionScore"),2) AS "Average Satisfaction"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_treatment t
ON f."TreatmentKey" = t."TreatmentKey"
GROUP BY t."TreatmentName"
ORDER BY "Average Satisfaction" DESC;


-- Which treatments resulted in the most ICU admissions?
SELECT
    t."TreatmentName",
    COUNT(*) AS "ICU Cases"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_treatment t
ON f."TreatmentKey" = t."TreatmentKey"
WHERE f."HasICUStay" = 1
GROUP BY t."TreatmentName"
ORDER BY "ICU Cases" DESC;


-- Which treatments involved the highest number of surgeries?
SELECT
    t."TreatmentName",
    COUNT(*) AS "Surgery Cases"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_treatment t
ON f."TreatmentKey" = t."TreatmentKey"
WHERE f."HasSurgery" = 1
GROUP BY t."TreatmentName"
ORDER BY "Surgery Cases" DESC;


-- Treatment KPI Dashboard
SELECT
    COUNT(DISTINCT t."TreatmentKey") AS "Total Treatments",
    ROUND(AVG(t."DurationHours")::numeric, 2) AS "Average Duration (Hours)",
    SUM(f."TreatmentCostUSD") AS "Total Treatment Cost",
    SUM(f."TotalChargeUSD") AS "Total Revenue",
    ROUND(AVG(f."LengthOfStayDays"),2) AS "Average Stay (Days)",
    ROUND(AVG(f."SatisfactionScore"),2) AS "Average Satisfaction"
FROM warehouse.dim_treatment t
LEFT JOIN warehouse.fact_patient_visit f
ON t."TreatmentKey" = f."TreatmentKey";