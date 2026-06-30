from sqlalchemy import create_engine, text

# PostgreSQL Configuration
DB_USER = "postgres"
DB_PASSWORD = "Neel2004"
DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "healthcare_dw"

engine = create_engine(
    f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

# Create Warehouse Schema
with engine.begin() as conn:

    conn.execute(text("""
        CREATE SCHEMA IF NOT EXISTS warehouse;
    """))

# Mapping
TABLES = [
    ("dim_patient_raw", "dim_patient"),
    ("dim_doctor_raw", "dim_doctor"),
    ("dim_hospital_raw", "dim_hospital"),
    ("dim_department_raw", "dim_department"),
    ("dim_treatment_raw", "dim_treatment"),
    ("dim_medicine_raw", "dim_medicine"),
    ("dim_insurance_raw", "dim_insurance"),
    ("dim_date_raw", "dim_date"),
    ("fact_patient_visit_raw", "fact_patient_visit")
]

# Create Warehouse Tables
with engine.begin() as conn:
    for raw_table, warehouse_table in TABLES:
        print(f"\nCreating {warehouse_table}...")

        conn.execute(text(f"""
            DROP TABLE IF EXISTS warehouse.{warehouse_table} CASCADE;
        """))

        conn.execute(text(f"""
            CREATE TABLE warehouse.{warehouse_table}
            AS
            SELECT *
            FROM staging.{raw_table}
            WHERE 1 = 2;
        """))

        print(f"{warehouse_table} Created")

print("\n====================================")
print("Warehouse Tables Created Successfully")
print("====================================")