# Zepto Inventory Analysis: SQL-Based E-commerce Business Insights

*A practice project - SQL querying and business analysis on a public e-commerce inventory dataset.*

A SQL project that queries a real-world e-commerce inventory dataset — uncovering pricing anomalies, stock-availability trends, and category-level revenue insights from Zepto's product catalog.

## Short Description / Purpose

This is a practice project built to strengthen analytical SQL skills using a real-world e-commerce dataset. It uses PostgreSQL to explore, validate, and query product-level inventory data from Zepto, answering business questions like which categories drive the most revenue, which high-value products are out of stock, and how pricing compares across product weight and category.

## Tech Stack

- **PostgreSQL** — database and query engine
- **SQL (DDL + DML)** — table creation, schema alteration, validation, and aggregation queries
- **File Format** — `.sql` script, source data as `.csv`

## Data Source

*Source: [Zepto Inventory Dataset, Kaggle](https://www.kaggle.com/datasets/palvinder2006/zepto-inventory-dataset)*

The dataset contains product-level listings scraped from Zepto's app, covering category, product name, MRP, discounted selling price, available quantity, weight, and stock status. Duplicate product names are expected — the same product can appear multiple times across different pack sizes, weights, or categories, mirroring how real e-commerce catalogs are structured.

## Features / Highlights

### Business Problem
Quick-commerce platforms list thousands of SKUs with raw currency values and inconsistent stock/pricing data that aren't immediately analysis-ready. Without querying it properly, it's hard to answer basic questions like: which categories generate the most revenue? Which high-value items are going out of stock? Are there pricing inconsistencies worth flagging?

### Goal of the Project
To write SQL queries against a structured PostgreSQL database that:
- Validate data quality (nulls, duplicate names, zero-price entries)
- Prepare the dataset for analysis (currency normalization)
- Answer category-level and product-level business questions around pricing, stock, and value

### Walkthrough of Key Queries

- **Schema Setup** — Created the `zepto_table` with typed columns for category, name, pricing, quantity, weight, and stock status; later widened `mrp` to `NUMERIC(10,2)` to safely hold larger values.
- **Data Validation** — Scanned for `NULL`s across every column, checked for duplicate product names (`GROUP BY name HAVING COUNT(id) > 1`), and identified/removed rows where `mrp` or `discountedSellingPrice` was `0` (invalid listings).
- **Currency Normalization** — Converted `mrp` and `discountedSellingPrice` from paise to rupees (`/100.0`), since source values were stored in the smaller currency unit.
- **Stock & Category Overview** — Counted in-stock vs. out-of-stock products, and pulled the full list of distinct categories.
- **High-Value Out-of-Stock Products** — Flagged products priced above ₹300 that are currently out of stock — useful for restocking priority.
- **Category Revenue Analysis** — Calculated `discountedSellingPrice × availableQuantity` per category to rank categories by potential revenue.
- **Deep-Discount Products** — Found products where MRP exceeds ₹500 but the discounted price drops below ₹500 — a heavy-discount segment worth flagging for margin review.
- **Price-per-Gram Value Analysis** — Computed `discountedSellingPrice / weightinGms` for products over 100g, to identify best-value-per-weight items.
- **Weight Segmentation** — Categorized products into Low (<1000g), Medium (<5000g), and Bulk (≥5000g) weight bands.
- **Total Inventory Weight by Category** — Summed `weightinGms × availableQuantity` per category, giving a proxy for warehousing/logistics load per category.

### Business Impact & Insights

- **Inventory Prioritization**: Highlights high-MRP products that are out of stock — a direct restocking priority list.
- **Revenue Attribution**: Ranks categories by contribution to total potential revenue, useful for merchandising decisions.
- **Pricing Strategy**: Surfaces deep-discount products (MRP > ₹500, discounted < ₹500) that may need margin review.
- **Value Positioning**: Price-per-gram analysis identifies which products offer the best value — relevant for competitive pricing.
- **Logistics Planning**: Category-level total weight gives a rough signal for storage and delivery load distribution.

*Cooking Essentials and Munchies were the highest revenue-generating categories, each contributing around **₹3.4 crore** in potential revenue. Since both have the exact same value, it may be worth checking the data for possible duplication. Some expensive products, such as **Patanjali Cow's Ghee** (₹56,500) and **MamyPoko Pants Diapers** (₹39,900), were out of stock, although these prices appear to be unusual outliers. The biggest discounts were seen on **Popular Essentials Californian Almond** (₹695 to ₹470) and **Kellogg's Chocos – Moons & Stars** (₹660 to ₹396). In terms of price per gram, **Onion** and **Tata Salt** offered the best value at just **₹0.02 per gram**.*


## Query Results
Screenshots of key query outputs:

<img width="587" height="691" alt="Screenshot 2026-08-01 230948" src="https://github.com/user-attachments/assets/0bce0c74-955f-46ee-b0e6-bb8ca73ec1a1" />
<img width="587" height="691" alt="Screenshot 2026-08-01 230948" src="https://github.com/user-attachments/assets/89b36121-bba3-4099-89b6-cf47e3ae1293" />
<img width="588" height="206" alt="Screenshot 2026-08-01 231102" src="https://github.com/user-attachments/assets/7d1c6b18-46fc-4ddd-8fc4-65416beb3d00" />
<img width="613" height="689" alt="image" src="https://github.com/user-attachments/assets/d92145f3-2698-4376-8606-e25f3907eaf6" />
