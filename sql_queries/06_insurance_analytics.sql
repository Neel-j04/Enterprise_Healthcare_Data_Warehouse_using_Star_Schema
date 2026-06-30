-- How many insurance providers are available in the healthcare system?
SELECT
    COUNT(*) AS "Total Insurance Providers"
FROM warehouse.dim_insurance;


-- How many insurance providers are active and inactive?
SELECT
    "IsActive",
    COUNT(*) AS "Total Providers"
FROM warehouse.dim_insurance
GROUP BY "IsActive"
ORDER BY "Total Providers" DESC;


-- How many providers belong to each insurance type?
SELECT
    "InsuranceType",
    COUNT(*) AS "Total Providers"
FROM warehouse.dim_insurance
GROUP BY "InsuranceType"
ORDER BY "Total Providers" DESC;


-- Which insurance providers have the highest claim coverage limit?
SELECT
    "ProviderName",
    "CoverageLimitUSD"
FROM warehouse.dim_insurance
ORDER BY "CoverageLimitUSD" DESC
LIMIT 10;


-- Which insurance providers have the highest deductible?
SELECT
    "ProviderName",
    "DeductibleUSD"
FROM warehouse.dim_insurance
ORDER BY "DeductibleUSD" DESC
LIMIT 10;


-- Which insurance providers covered the highest total amount?
SELECT
    i."ProviderName",
    SUM(f."InsuranceCoverageUSD") AS "Total Coverage"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_insurance i
ON f."InsuranceKey" = i."InsuranceKey"
GROUP BY i."ProviderName"
ORDER BY "Total Coverage" DESC;


-- Which insurance providers received the highest number of claims?
SELECT
    i."ProviderName",
    COUNT(f."VisitKey") AS "Total Claims"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_insurance i
ON f."InsuranceKey" = i."InsuranceKey"
GROUP BY i."ProviderName"
ORDER BY "Total Claims" DESC;


-- What is the average insurance coverage amount by provider?
SELECT
    i."ProviderName",
    ROUND(AVG(f."InsuranceCoverageUSD"),2) AS "Average Coverage"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_insurance i
ON f."InsuranceKey" = i."InsuranceKey"
GROUP BY i."ProviderName"
ORDER BY "Average Coverage" DESC;


-- Which insurance providers have the highest outstanding balances?
SELECT
    i."ProviderName",
    SUM(f."OutstandingAmtUSD") AS "Outstanding Amount"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_insurance i
ON f."InsuranceKey" = i."InsuranceKey"
GROUP BY i."ProviderName"
ORDER BY "Outstanding Amount" DESC;


-- Which insurance providers contributed the highest percentage of revenue?
SELECT
    i."ProviderName",
    ROUND(
        SUM(f."InsuranceCoverageUSD") * 100.0 /
        SUM(f."TotalChargeUSD"),
        2
    ) AS "Coverage Percentage"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_insurance i
ON f."InsuranceKey" = i."InsuranceKey"
GROUP BY i."ProviderName"
ORDER BY "Coverage Percentage" DESC;


-- Which insurance providers generated the highest patient payments?
SELECT
    i."ProviderName",
    SUM(f."PatientPaidUSD") AS "Patient Payments"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_insurance i
ON f."InsuranceKey" = i."InsuranceKey"
GROUP BY i."ProviderName"
ORDER BY "Patient Payments" DESC;


-- Which insurance providers provided the highest total discounts?
SELECT
    i."ProviderName",
    SUM(f."DiscountAmtUSD") AS "Total Discount"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_insurance i
ON f."InsuranceKey" = i."InsuranceKey"
GROUP BY i."ProviderName"
ORDER BY "Total Discount" DESC;


-- Insurance KPI Dashboard
SELECT
    COUNT(DISTINCT i."InsuranceKey") AS "Total Providers",
    SUM(f."InsuranceCoverageUSD") AS "Total Coverage",
    SUM(f."PatientPaidUSD") AS "Patient Payments",
    SUM(f."OutstandingAmtUSD") AS "Outstanding Amount",
    SUM(f."DiscountAmtUSD") AS "Total Discount",
    ROUND(AVG(f."InsuranceCoverageUSD"),2) AS "Average Coverage"
FROM warehouse.dim_insurance i
LEFT JOIN warehouse.fact_patient_visit f
ON i."InsuranceKey" = f."InsuranceKey";