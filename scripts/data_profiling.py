import os
import pandas as pd
from sqlalchemy import create_engine
from datetime import datetime

# PostgreSQL Configuration
DB_USER = "postgres"
DB_PASSWORD = "Neel2004"
DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "healthcare_dw"

engine = create_engine(
    f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

# Output Folder
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

REPORT_FOLDER = os.path.join(BASE_DIR, "..", "reports")

os.makedirs(REPORT_FOLDER, exist_ok=True)

REPORT_FILE = os.path.join(
    REPORT_FOLDER,
    "profiling_report.txt"
)

# Tables
TABLES = [
    "dim_patient_raw",
    "dim_doctor_raw",
    "dim_hospital_raw",
    "dim_department_raw",
    "dim_treatment_raw",
    "dim_medicine_raw",
    "dim_insurance_raw",
    "dim_date_raw",
    "fact_patient_visit_raw"
]

# Report
report = []

report.append("=" * 80)
report.append("HEALTHCARE DATA WAREHOUSE")
report.append("DATA PROFILING REPORT")
report.append("=" * 80)
report.append(f"Generated : {datetime.now()}")
report.append("")

# Overall Score
total_checks = 0
passed_checks = 0

for table in TABLES:
    print(f"Profiling {table}")

    df = pd.read_sql(
        f"SELECT * FROM staging.{table}",
        engine
    )

    report.append("=" * 80)
    report.append(f"TABLE : {table}")
    report.append("=" * 80)


    rows = len(df)
    cols = len(df.columns)

    report.append(f"Rows : {rows:,}")
    report.append(f"Columns : {cols}")
    report.append("")


    duplicates = df.duplicated().sum()

    report.append(f"Duplicate Rows : {duplicates}")

    total_checks += 1

    if duplicates == 0:
        passed_checks += 1

    report.append("")


    report.append("NULL VALUES")

    for col in df.columns:

        nulls = df[col].isnull().sum()

        report.append(
            f"{col:<30} {nulls}"
        )

    report.append("")


    report.append("DATA TYPES")

    for col in df.columns:

        report.append(
            f"{col:<30} {df[col].dtype}"
        )

    report.append("")

    # Business Rules
    if table == "dim_patient_raw":

        invalid_age = len(
            df[(df["Age"] < 0) | (df["Age"] > 120)]
        )

        report.append(f"Invalid Age : {invalid_age}")

        total_checks += 1

        if invalid_age == 0:
            passed_checks += 1


    if table == "dim_doctor_raw":

        invalid_exp = len(
            df[df["ExperienceYears"] < 0]
        )

        report.append(
            f"Invalid Experience : {invalid_exp}"
        )

        total_checks += 1

        if invalid_exp == 0:
            passed_checks += 1


    if table == "dim_hospital_raw":

        invalid_beds = len(
            df[df["BedCapacity"] <= 0]
        )

        report.append(
            f"Invalid Bed Capacity : {invalid_beds}"
        )

        total_checks += 1

        if invalid_beds == 0:
            passed_checks += 1


    if table == "dim_treatment_raw":

        invalid_cost = len(
            df[
                df["StandardCostMin"] >
                df["StandardCostMax"]
            ]
        )

        report.append(
            f"Invalid Cost Range : {invalid_cost}"
        )

        total_checks += 1

        if invalid_cost == 0:
            passed_checks += 1


    if table == "dim_medicine_raw":

        invalid_price = len(
            df[
                df["UnitCostMin"] >
                df["UnitCostMax"]
            ]
        )

        report.append(
            f"Invalid Price Range : {invalid_price}"
        )

        total_checks += 1

        if invalid_price == 0:
            passed_checks += 1

    report.append("\n")

# Quality Score
score = (passed_checks / total_checks) * 100

report.append("=" * 80)
report.append("OVERALL DATA QUALITY")
report.append("=" * 80)
report.append(f"Passed Checks : {passed_checks}")
report.append(f"Total Checks  : {total_checks}")
report.append(f"Quality Score : {score:.2f}%")
report.append("=" * 80)

# Save Report
with open(
    REPORT_FILE,
    "w",
    encoding="utf-8"
) as f:

    for line in report:
        f.write(line + "\n")

print("\n")
print("=" * 80)
print("DATA PROFILING COMPLETED")
print("=" * 80)
print(f"Report Saved : {REPORT_FILE}")
print(f"Quality Score : {score:.2f}%")