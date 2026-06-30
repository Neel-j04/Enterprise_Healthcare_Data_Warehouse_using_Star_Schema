-- Validate Primary Keys

-- Patient
SELECT "PatientKey", COUNT(*)
FROM warehouse.dim_patient
GROUP BY "PatientKey"
HAVING COUNT(*) > 1;

-- Doctor
SELECT "DoctorKey", COUNT(*)
FROM warehouse.dim_doctor
GROUP BY "DoctorKey"
HAVING COUNT(*) > 1;

-- Hospital
SELECT "HospitalKey", COUNT(*)
FROM warehouse.dim_hospital
GROUP BY "HospitalKey"
HAVING COUNT(*) > 1;

-- Department
SELECT "DepartmentKey", COUNT(*)
FROM warehouse.dim_department
GROUP BY "DepartmentKey"
HAVING COUNT(*) > 1;

-- Treatment
SELECT "TreatmentKey", COUNT(*)
FROM warehouse.dim_treatment
GROUP BY "TreatmentKey"
HAVING COUNT(*) > 1;

-- Medicine
SELECT "MedicineKey", COUNT(*)
FROM warehouse.dim_medicine
GROUP BY "MedicineKey"
HAVING COUNT(*) > 1;

-- Insurance
SELECT "InsuranceKey", COUNT(*)
FROM warehouse.dim_insurance
GROUP BY "InsuranceKey"
HAVING COUNT(*) > 1;

-- Date
SELECT "DateKey", COUNT(*)
FROM warehouse.dim_date
GROUP BY "DateKey"
HAVING COUNT(*) > 1;



-- Validate Foreign Keys

-- Patient
SELECT COUNT(*) AS InvalidPatientKeys
FROM warehouse.fact_patient_visit f
LEFT JOIN warehouse.dim_patient p
ON f."PatientKey" = p."PatientKey"
WHERE p."PatientKey" IS NULL;

-- Doctor
SELECT COUNT(*) AS InvalidDoctorKeys
FROM warehouse.fact_patient_visit f
LEFT JOIN warehouse.dim_doctor d
ON f."DoctorKey" = d."DoctorKey"
WHERE d."DoctorKey" IS NULL;

-- Hospital
SELECT COUNT(*) AS InvalidHospitalKeys
FROM warehouse.fact_patient_visit f
LEFT JOIN warehouse.dim_hospital h
ON f."HospitalKey" = h."HospitalKey"
WHERE h."HospitalKey" IS NULL;

-- Department
SELECT COUNT(*) AS InvalidDepartmentKeys
FROM warehouse.fact_patient_visit f
LEFT JOIN warehouse.dim_department d
ON f."DepartmentKey" = d."DepartmentKey"
WHERE d."DepartmentKey" IS NULL;

-- Treatment
SELECT COUNT(*) AS InvalidTreatmentKeys
FROM warehouse.fact_patient_visit f
LEFT JOIN warehouse.dim_treatment t
ON f."TreatmentKey" = t."TreatmentKey"
WHERE t."TreatmentKey" IS NULL;

-- Medicine
SELECT COUNT(*) AS InvalidMedicineKeys
FROM warehouse.fact_patient_visit f
LEFT JOIN warehouse.dim_medicine m
ON f."MedicineKey" = m."MedicineKey"
WHERE m."MedicineKey" IS NULL;

-- Insurance
SELECT COUNT(*) AS InvalidInsuranceKeys
FROM warehouse.fact_patient_visit f
LEFT JOIN warehouse.dim_insurance i
ON f."InsuranceKey" = i."InsuranceKey"
WHERE i."InsuranceKey" IS NULL;

-- Date
SELECT COUNT(*) AS InvalidInsuranceKeys
FROM warehouse.fact_patient_visit f
LEFT JOIN warehouse.dim_date d
ON f."DateKey" = d."DateKey"
WHERE d."DateKey" IS NULL;