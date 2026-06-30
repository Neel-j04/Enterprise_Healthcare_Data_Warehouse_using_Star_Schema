-- How many doctors are registered in the healthcare system?
SELECT
    COUNT(*) AS "Total Doctors"
FROM warehouse.dim_doctor;


-- How many doctors are currently active and inactive?
SELECT
    "IsActive",
    COUNT(*) AS "Total Doctors"
FROM warehouse.dim_doctor
GROUP BY "IsActive"
ORDER BY "Total Doctors" DESC;


-- What is the gender distribution of doctors?
SELECT
    "Gender",
    COUNT(*) AS "Total Doctors"
FROM warehouse.dim_doctor
GROUP BY "Gender"
ORDER BY "Total Doctors" DESC;


-- How many doctors belong to each specialization?
SELECT
    "Specialization",
    COUNT(*) AS "Total Doctors"
FROM warehouse.dim_doctor
GROUP BY "Specialization"
ORDER BY "Total Doctors" DESC;


-- How many doctors belong to each qualification?
SELECT
    "Qualification",
    COUNT(*) AS "Total Doctors"
FROM warehouse.dim_doctor
GROUP BY "Qualification"
ORDER BY "Total Doctors" DESC;


-- What is the average experience of doctors by specialization?
SELECT
    "Specialization",
    ROUND(AVG("ExperienceYears"),2) AS "Average Experience"
FROM warehouse.dim_doctor
GROUP BY "Specialization"
ORDER BY "Average Experience" DESC;


-- What is the average consultation fee by specialization?
SELECT
    "Specialization",
    ROUND(AVG("ConsultationFee"),2) AS "Average Consultation Fee"
FROM warehouse.dim_doctor
GROUP BY "Specialization"
ORDER BY "Average Consultation Fee" DESC;


-- Who are the top 10 most experienced doctors?
SELECT
    "FullName",
    "Specialization",
    "ExperienceYears"
FROM warehouse.dim_doctor
ORDER BY "ExperienceYears" DESC
LIMIT 10;


-- Which doctors charge the highest consultation fees?
SELECT
    "FullName",
    "Specialization",
    "ConsultationFee"
FROM warehouse.dim_doctor
ORDER BY "ConsultationFee" DESC
LIMIT 10;


-- Which doctors have treated the highest number of patients?
SELECT
    d."FullName",
    COUNT(f."VisitKey") AS "Patients Treated"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_doctor d
ON f."DoctorKey" = d."DoctorKey"
GROUP BY d."FullName"
ORDER BY "Patients Treated" DESC
LIMIT 10;


-- Which doctors generated the highest revenue?
SELECT
    d."FullName",
    SUM(f."TotalChargeUSD") AS "Total Revenue"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_doctor d
ON f."DoctorKey" = d."DoctorKey"
GROUP BY d."FullName"
ORDER BY "Total Revenue" DESC
LIMIT 10;


-- What is the performance summary of each doctor?
SELECT
    d."FullName",
    COUNT(f."VisitKey") AS "Patients",
    ROUND(AVG(f."SatisfactionScore"),2) AS "Average Satisfaction",
    SUM(f."TotalChargeUSD") AS "Revenue"
FROM warehouse.fact_patient_visit f
JOIN warehouse.dim_doctor d
ON f."DoctorKey" = d."DoctorKey"
GROUP BY d."FullName"
ORDER BY "Revenue" DESC;


-- Doctor KPI Dashboard
SELECT
    COUNT(DISTINCT d."DoctorKey") AS "Total Doctors",
    ROUND(AVG(d."ExperienceYears"),2) AS "Average Experience",
    ROUND(AVG(d."ConsultationFee"),2) AS "Average Consultation Fee",
    SUM(f."TotalChargeUSD") AS "Total Revenue",
    COUNT(f."VisitKey") AS "Total Visits",
    ROUND(AVG(f."SatisfactionScore"),2) AS "Average Satisfaction"
FROM warehouse.dim_doctor d
LEFT JOIN warehouse.fact_patient_visit f
ON d."DoctorKey" = f."DoctorKey";