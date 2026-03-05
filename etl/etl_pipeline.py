"""
ETL Pipeline — E-Commerce Analytics Data Warehouse
====================================================
Extracts raw CSV data, loads it into PostgreSQL, and runs
layered SQL transformations (Staging → Warehouse → Analytics).

Usage:
    python etl/etl_pipeline.py
"""

import os
import pandas as pd
from sqlalchemy import create_engine, text
from dotenv import load_dotenv

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
load_dotenv()

DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://postgres:Hunter1102@Localhost:5432/ecommerce_dw",
)
engine = create_engine(DATABASE_URL)


# ---------------------------------------------------------------------------
# Helper Functions
# ---------------------------------------------------------------------------
def load_csv_to_raw(file_path, table_name):
    """Load a CSV file into the raw schema.

    The table is replaced on every run to ensure a clean reload.
    """
    try:
        df = pd.read_csv(file_path)
        df.to_sql(
            table_name,
            engine,
            schema="raw",
            if_exists="replace",
            index=False,
        )
        print(f"  [OK] {table_name} loaded ({len(df):,} rows)")
    except Exception as e:
        print(f"  [ERROR] Failed to load {table_name}: {e}")
        raise


def run_sql_file(file_path):
    """Execute a SQL script against the database."""
    try:
        with open(file_path, "r") as f:
            sql = f.read()

        with engine.connect() as conn:
            conn.execute(text(sql))
            conn.commit()

        print(f"  [OK] {file_path} executed")
    except Exception as e:
        print(f"  [ERROR] Failed to execute {file_path}: {e}")
        raise


# ---------------------------------------------------------------------------
# Main Pipeline
# ---------------------------------------------------------------------------
def main():
    """Run the full ETL pipeline."""
    print("=" * 60)
    print("  E-Commerce Analytics — ETL Pipeline")
    print("=" * 60)

    # Step 1: Create schemas
    print("\n📦 Creating schemas...")
    run_sql_file(r".\sql\create_schemas.sql")

    # Step 2: Load raw data from CSVs
    print("\n📥 Loading raw data...")
    load_csv_to_raw(r".\data\customers.csv", "customers")
    load_csv_to_raw(r".\data\orders.csv", "orders")
    load_csv_to_raw(r".\data\order_items.csv", "order_items")
    load_csv_to_raw(r".\data\products.csv", "products")
    load_csv_to_raw(r".\data\order_payments.csv", "payments")

    # Step 3: Staging transformations
    print("\n🔄 Running staging transformations...")
    run_sql_file(r".\sql\staging.sql")

    # Step 4: Warehouse transformations (dim/fact tables)
    print("\n🏗️  Building warehouse tables...")
    run_sql_file(r".\sql\warehouse.sql")

    # Step 5: Analytics aggregations
    print("\n📊 Generating analytics tables...")
    run_sql_file(r".\sql\analytics.sql")

    print("\n" + "=" * 60)
    print("  ✅ ETL pipeline completed successfully!")
    print("=" * 60)


if __name__ == "__main__":
    main()