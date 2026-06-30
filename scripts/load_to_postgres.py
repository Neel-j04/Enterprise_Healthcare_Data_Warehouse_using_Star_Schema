import os
import pandas as pd
from sqlalchemy import create_engine

# PostgreSQL Configuration
DB_USER = "postgres"
DB_PASSWORD = "Neel2004"
DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "healthcare_dw"

# Create Connection
engine = create_engine(
    f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

# Data Folder
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_FOLDER = os.path.join(BASE_DIR, "..", "data")

# CSV File Mapping
FILES = {
    "DimPatient.csv": "dim_patient_raw",
    "DimDoctor.csv": "dim_doctor_raw",
    "DimHospital.csv": "dim_hospital_raw",
    "DimDepartment.csv": "dim_department_raw",
    "DimTreatment.csv": "dim_treatment_raw",
    "DimMedicine.csv": "dim_medicine_raw",
    "DimInsurance.csv": "dim_insurance_raw",
    "DimDate.csv": "dim_date_raw",
    "FactPatientVisit_10M.csv": "fact_patient_visit_raw"
}

# Create Staging Schema
with engine.connect() as connection:
    connection.exec_driver_sql(
        "CREATE SCHEMA IF NOT EXISTS staging;"
    )

print("=" * 60)
print("Healthcare Data Warehouse Loader")
print("=" * 60)

# Load Every CSV
for csv_file, table_name in FILES.items():

    file_path = os.path.join(DATA_FOLDER, csv_file)

    print(f"\nLoading: {csv_file}")

    if not os.path.exists(file_path):
        print(f"File Not Found: {csv_file}")
        continue

    if csv_file == "FactPatientVisit_10M.csv":

        first_chunk = True

        chunk_number = 1

        for chunk in pd.read_csv(
            file_path,
            chunksize=100000
        ):

            chunk.to_sql(
                table_name,
                engine,
                schema="staging",
                if_exists="replace" if first_chunk else "append",
                index=False,
                method="multi"
            )

            print(f"Chunk {chunk_number} Loaded")

            chunk_number += 1

            first_chunk = False

    else:

        df = pd.read_csv(file_path)

        df.to_sql(
            table_name,
            engine,
            schema="staging",
            if_exists="replace",
            index=False,
            method="multi"
        )

        print(f"{table_name} Loaded Successfully")

print("\n")
print("=" * 60)
print("All Files Loaded Successfully")
print("=" * 60)