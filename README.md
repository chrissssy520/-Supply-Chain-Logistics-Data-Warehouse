https://ckaportfolio.vercel.app - Portfolio Website
https://alerportfolio.vercel.app - Portfolio Website Data analytics

# Supply Chain & Logistics Data Warehouse

A end-to-end Data Warehouse project built in PostgreSQL simulating a real-world supply chain and sales analytics environment. This project covers the full data engineering workflow — from raw CSV ingestion to dimension tables, fact tables, reporting views, and ad-hoc business queries.

---

## Project Overview

This project simulates working as a Data Engineer at a Philippines-based supply chain and logistics company. The goal is to transform raw transactional data into a structured Star Schema data warehouse that can feed dashboards and business reports.

**Domain:** Supply Chain, Logistics & Sales  
**Database:** PostgreSQL  
**Schema Pattern:** Star Schema  
**Layers:** Raw → Dimensions → Facts → Views → Ad-hoc  

---

## Architecture

```
Raw CSVs (source data)
        ↓
  Dimension Tables      ← descriptive context (products, customers, suppliers, etc.)
        ↓
    Fact Tables         ← measurable events (orders, procurement, inventory)
        ↓
  Reporting Views       ← pre-built queries for dashboards
        ↓
  Ad-hoc Queries        ← business questions answered with SQL
```

---

## Dataset

8 raw CSV tables generated to simulate database exports from a source system. Data covers **2023–2024** across Philippine and Southeast Asian operations.

| File | Description | Rows |
|---|---|---|
| `raw_sales_orders.csv` | Customer sales transactions | 500 |
| `raw_purchase_orders.csv` | Supplier purchase orders | 500 |
| `raw_inventory.csv` | Monthly warehouse inventory snapshots | 500 |
| `raw_products.csv` | Product master data | 48 |
| `raw_customers.csv` | Customer master data | 60 |
| `raw_suppliers.csv` | Supplier master data | 8 |
| `raw_warehouses.csv` | Warehouse master data | 5 |
| `raw_carriers.csv` | Carrier/logistics master data | 6 |

---

## SQL Objects Built

### Dimension Tables (`dw` schema)
| Object | Description |
|---|---|
| `dim_date` | Full date spine 2023–2024 with fiscal calendar (FY starts July 1) |
| `dim_product` | Product master with margin % and margin tier classification |
| `dim_customer` | Customer master with regional zone mapping |
| `dim_supplier` | Supplier master with aggregated PO performance metrics |
| `dim_warehouse` | Warehouse master with aggregated inventory metrics |

### Fact Tables (`dw` schema)
| Object | Description |
|---|---|
| `fact_sales` | Sales orders with revenue, discount, delivery variance, and late flag |
| `fact_procurement` | Purchase orders with PO value, receipt rate, lead time, and freight per unit |
| `fact_inventory` | Inventory snapshots with available qty, inventory value, and reorder gap |

### Reporting Views (`dw` schema)
| Object | Description |
|---|---|
| `vw_sales_summary` | Monthly sales by zone, segment, and channel with cancellation rate |
| `vw_supplier_performance` | Supplier fill rate, lead time, freight cost, and on-time delivery rate |
| `vw_inventory_health` | Latest inventory snapshot per product per warehouse with utilization % |
| `vw_top_products` | Product revenue and quantity rankings with margin analysis |

### Ad-hoc Business Queries
| File | Business Question |
|---|---|
| `adhoc_customer_cancel.sql` | Which customers have the highest cancellation and return rate? |
| `adhoc_warehouse_overdue_inventory.sql` | Which products have been below reorder qty for 2+ months? |
| `adhoc_freight_cost.sql` | Total and average freight cost by carrier and incoterm |
| `adhoc_mom.sql` | Month-over-month revenue trend with running total per year |

---

## How to Run

1. Create a PostgreSQL database and connect to it
2. Load all CSV files from `/data` into the `raw` schema as tables
3. Run SQL files in this order:

```
sql/setup.sql
sql/dims/01_dim_date.sql
sql/dims/02_dim_product.sql
sql/dims/03_dim_customer.sql
sql/dims/04_dim_supplier.sql
sql/dims/05_dim_warehouse.sql
sql/facts/06_fact_sales.sql
sql/facts/07_fact_procurement.sql
sql/facts/08_fact_inventory.sql
sql/views/09_vw_sales_summary.sql
sql/views/10_vw_supplier_performance.sql
sql/views/11_vw_inventory_health.sql
sql/views/12_vw_top_products.sql
```

4. Ad-hoc queries in `/sql/adhoc` can be run independently anytime after facts are built.

---

## Key SQL Concepts Practiced

- Star Schema design and dimensional modeling
- Date spine generation with fiscal calendar logic
- Multi-table joins across raw and dimension layers
- Aggregations with NULLIF and COALESCE for safe division
- Window functions — ROW_NUMBER, RANK, LAG, SUM OVER with PARTITION BY
- CASE expressions for classification and conditional aggregation
- VARCHAR to DATE casting and empty string handling from CSV sources
- Percentage of total using grand total window functions
- Month-over-month comparison with year-partitioned running totals
- Primary keys and indexes on all warehouse objects

---

## Author

Built as a portfolio project to simulate real-world Data Engineering work in a supply chain and logistics domain using PostgreSQL.
