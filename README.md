# 📦 E-Commerce Analytics Data Warehouse

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white)
![SQLAlchemy](https://img.shields.io/badge/SQLAlchemy-D71F00?style=for-the-badge&logo=python&logoColor=white)

A fully functional **data warehouse** built with **PostgreSQL** and **Python**, designed to process and analyze Brazilian e-commerce data through a structured **ETL pipeline**. The project follows a layered architecture (`Raw → Staging → Warehouse → Analytics`) to transform raw transactional data into actionable business insights.

---

## 🏗️ Architecture

```mermaid
flowchart LR
    subgraph Sources["📁 Data Sources"]
        CSV["CSV Files\n(Kaggle Dataset)"]
    end

    subgraph ETL["⚙️ ETL Pipeline (Python)"]
        LOAD["Load CSVs\nto Raw Schema"]
        T1["Staging\nTransformations"]
        T2["Warehouse\nTransformations"]
        T3["Analytics\nAggregations"]
    end

    subgraph DW["🗄️ PostgreSQL Data Warehouse"]
        RAW["raw.*\n─────────────\ncustomers\norders\norder_items\nproducts\npayments"]
        STG["staging.*\n─────────────\norders\norder_items"]
        WH["warehouse.*\n─────────────\ndim_customers\ndim_products\nfact_orders"]
        AN["analytics.*\n─────────────\ncustomer_lifetime_value\ntop_customers\nrevenue_monthly"]
    end

    CSV --> LOAD --> RAW
    RAW --> T1 --> STG
    STG --> T2 --> WH
    WH --> T3 --> AN

    style Sources fill:#2d333b,stroke:#444c56,color:#adbac7
    style ETL fill:#1c2128,stroke:#444c56,color:#adbac7
    style DW fill:#1c2128,stroke:#444c56,color:#adbac7
```

---

## 📂 Project Structure

```
├── data/                  # Raw CSV data files (not committed — see Data section)
│   ├── customers.csv
│   ├── orders.csv
│   ├── order_items.csv
│   ├── order_payments.csv
│   ├── products.csv
│   └── ...
│
├── etl/
│   └── etl_pipeline.py    # Main ETL pipeline script
│
├── sql/
│   ├── create_schemas.sql  # Creates all database schemas
│   ├── staging.sql         # Raw → Staging transformations
│   ├── warehouse.sql       # Staging → Warehouse (dim/fact tables)
│   └── analytics.sql       # Warehouse → Analytics aggregations
│
├── .env.example            # Environment variable template
├── .gitignore
├── requirements.txt
└── README.md
```

---

## 🗃️ Database Schema

| Schema | Layer | Purpose | Key Tables |
|--------|-------|---------|------------|
| `raw` | Ingestion | Raw CSV data loaded as-is | `customers`, `orders`, `order_items`, `products`, `payments` |
| `staging` | Cleaning | Cleaned columns, cast types | `orders`, `order_items` |
| `warehouse` | Modeling | Star-schema dimensions & facts | `dim_customers`, `dim_products`, `fact_orders` |
| `analytics` | Reporting | Pre-aggregated business metrics | `customer_lifetime_value`, `top_customers`, `revenue_monthly` |

---

## 🚀 Getting Started

### Prerequisites

- **Python 3.8+**
- **PostgreSQL 13+** (running locally or remotely)
- **pip** (Python package manager)

### 1. Clone the Repository

```bash
git clone https://github.com/<your-username>/ecommerce-analytics-data-warehouse.git
cd ecommerce-analytics-data-warehouse
```

### 2. Install Dependencies

```bash
pip install -r requirements.txt
```

### 3. Download the Dataset

Download the [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) from Kaggle and place the CSV files in the `data/` directory.

### 4. Configure Environment Variables

```bash
cp .env.example .env
```

Edit `.env` with your PostgreSQL credentials:

```
DATABASE_URL=postgresql://username:password@localhost:5432/ecommerce_dw
```

### 5. Create the Database

```sql
CREATE DATABASE ecommerce_dw;
```

### 6. Run the ETL Pipeline

```bash
python etl/etl_pipeline.py
```

This will:
1. Create all schemas (`raw`, `staging`, `warehouse`, `analytics`)
2. Load CSV files into the `raw` schema
3. Run staging transformations (type casting, column selection)
4. Build warehouse dimension and fact tables
5. Generate analytics aggregations (CLV, top customers, monthly revenue)

---

## 📊 Analytics Outputs

| Table | Description |
|-------|-------------|
| `analytics.customer_lifetime_value` | Total orders and lifetime spend per customer |
| `analytics.top_customers` | Customers ranked by total spend |
| `analytics.revenue_monthly` | Monthly revenue trends |

**Example Query:**

```sql
-- Top 10 customers by lifetime value
SELECT customer_id, total_orders, lifetime_value
FROM analytics.customer_lifetime_value
ORDER BY lifetime_value DESC
LIMIT 10;
```

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| **PostgreSQL** | Data warehouse storage & SQL transformations |
| **Python** | ETL orchestration |
| **Pandas** | CSV ingestion and data loading |
| **SQLAlchemy** | Database connectivity & SQL execution |
| **python-dotenv** | Secure environment variable management |

---

## 📝 Data Source

This project uses the [**Brazilian E-Commerce Public Dataset by Olist**](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce), which contains ~100K orders from 2016–2018 across multiple marketplaces in Brazil. The dataset is used here strictly for educational and portfolio purposes.

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
