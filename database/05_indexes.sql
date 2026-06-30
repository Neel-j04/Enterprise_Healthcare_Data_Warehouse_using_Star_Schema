-- FACT TABLE INDEXES
CREATE INDEX idx_fact_patient
ON warehouse.fact_patient_visit ("PatientKey");

CREATE INDEX idx_fact_doctor
ON warehouse.fact_patient_visit ("DoctorKey");

CREATE INDEX idx_fact_hospital
ON warehouse.fact_patient_visit ("HospitalKey");

CREATE INDEX idx_fact_department
ON warehouse.fact_patient_visit ("DepartmentKey");

CREATE INDEX idx_fact_treatment
ON warehouse.fact_patient_visit ("TreatmentKey");

CREATE INDEX idx_fact_medicine
ON warehouse.fact_patient_visit ("MedicineKey");

CREATE INDEX idx_fact_insurance
ON warehouse.fact_patient_visit ("InsuranceKey");

CREATE INDEX idx_fact_date
ON warehouse.fact_patient_visit ("DateKey");


-- FILTER INDEXES
CREATE INDEX idx_fact_visit_type
ON warehouse.fact_patient_visit ("VisitType");

CREATE INDEX idx_fact_severity
ON warehouse.fact_patient_visit ("SeverityLevel");


-- COST INDEXES
CREATE INDEX idx_total_charge
ON warehouse.fact_patient_visit ("TotalChargeUSD");

CREATE INDEX idx_satisfaction
ON warehouse.fact_patient_visit ("SatisfactionScore");



-- Verify
SELECT
    schemaname,
    tablename,
    indexname
FROM pg_indexes
WHERE schemaname='warehouse'
ORDER BY tablename;