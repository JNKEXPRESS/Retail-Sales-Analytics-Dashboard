<p align="center">
  <img src="https://img.shields.io/badge/SQL-PostgreSQL-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Power%20BI-DAX-yellow?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Data%20Modeling-Star%20Schema-green?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge" />
</p>

---

# Retail Sales Analytics Dashboard

An end-to-end data analytics project using **SQL, PostgreSQL, DAX, and Power BI**.

This project simulates the work of a junior data analyst at a retail company:  
you design the schema, load raw CSV files into PostgreSQL, build views, create DAX measures, and deliver interactive dashboards in Power BI.

---

## 📌 Project Overview  
This project analyzes retail sales performance across multiple years.  
The goal was to build a complete, end-to-end analytics workflow including:

- SQL-based data cleaning & transformation  
- Data modeling in PostgreSQL  
- Calculation of key KPIs using DAX  
- Interactive Power BI dashboards for insights & decision-making  

---

## 📌 Business Questions Answered

This project was designed to answer key business questions for a retail company.

### **1. Sales Performance**
- What is the total revenue for each year?
- Which categories contribute the most to sales?
- What are the sales trends over time (monthly, quarterly, yearly)?
- Which products generate the highest revenue and profit?

### **2. Customer Insights**
- How do different customer segments (gender, income, etc.) contribute to revenue?
- Which customer groups purchase the highest-margin products?

### **3. Product Performance**
- Which products have the highest gross profit?
- What are the top-performing products by revenue?
- Which categories and subcategories consistently perform well?

### **4. Returns Analysis**
- What is the return rate (%) by product category?
- Which products have high return rates and low profitability?
- Are certain territories linked to higher return volume?

### **5. Time Intelligence Analysis**
- How does monthly revenue change over time?
- What is the 3-month moving average trend?
- What is the year-over-year (YoY) revenue growth?

---

## 🛠 Tools & Technologies  
- **SQL (PostgreSQL)** – for data cleaning, joining, calculations  
- **Power BI** – for data modeling, DAX measures, visualization  
- **DAX** – custom KPI calculations  
- **GitHub** – version control & project documentation  

---

## 🧱 Dataset & Data Model

The project is built on a simple retail star schema:

### **Fact Tables**
- **fact_sales** – one row per order line (date, customer, product, territory, quantity)
- **returns_data** – product returns by date, territory, and product

### **Dimension Tables**
- **calendar** – full date table (year, quarter, month, weekdays, etc.)
- **dim_customer** – customer demographics and income
- **dim_product** – product details (SKU, name, price, cost, attributes)
- **dim_product_subcategories** – product subcategories
- **dim_product_categories** – product categories
- **dim_territory** – region, country, continent

### **Table Relationships**
- fact_sales.order_date → calendar.calendar_date  
- fact_sales.customer_key → dim_customer.customer_key  
- fact_sales.product_key → dim_product.product_key  
- fact_sales.territory_key → dim_territory.territory_key  
- dim_product.product_subcategory_key → dim_product_subcategories.product_subcategory_key  
- dim_product_subcategories.product_category_key → dim_product_categories.product_category_key  
- returns_data.product_key → dim_product.product_key  
- returns_data.territory_key → dim_territory.territory_key  
- returns_data.return_date → calendar.calendar_date

---

## 📁 Project Structure

```
Retail-Sales-Analytics-Dashboard/
│
├── README.md                       # Full project documentation
├── Retail-Sales-Analytics-Dashboard.pbix   # Final Power BI dashboard
│
├── schema.sql                      # SQL script to create all dimension & fact tables
├── view_vw_sales.sql               # SQL view used for Power BI data modeling
│
└── Screenshots/                    # Dashboard page images
    ├── Page1_ExecutiveSummary.png
    ├── Page2_SalesTrends.png
    ├── Page3_ProductInsights.png
    └── Page4_ReturnsAnalysis.png
```
---
## 📊 Dashboards Included  
### **1️⃣ Executive Summary**
- Total Revenue  
- Gross Profit  
- Profit Margin %  
- Revenue Trend Over Time  
- Revenue by Category  

### **2️⃣ Sales Trends Page**
- Monthly Revenue Trend  
- 3-Month Moving Average  
- YoY Revenue Change (%)  
- Year & Category slicers  

### **3️⃣ Product Insights Page**
- Top 10 Products by Revenue  
- Top 10 Products by Gross Profit  
- Detailed product table  
- Category / Subcategory slicers  

### **4️⃣ Returns Analysis Page**
- Return Rate % (KPI)  
- Return Rate by Category  
- Profitability vs Return Rate (Scatter Plot)  
- Return Details Table  

---

## 🧮 Key DAX Measures  
```DAX
Total Revenue = SUM(public_vw_sales.revenue)

Total Gross Profit = SUM(public_vw_sales.gross_profit)

Profit Margin % =
DIVIDE([Total Gross Profit], [Total Revenue])

YoY Revenue % =
VAR CurrentYear = SELECTEDVALUE(public_vw_sales.year_)
VAR PrevYear = CurrentYear - 1
VAR CurrRevenue =
    CALCULATE([Total Revenue], public_vw_sales.year_ = CurrentYear)
VAR PrevRevenue =
    CALCULATE([Total Revenue], public_vw_sales.year_ = PrevYear)
RETURN
DIVIDE(CurrRevenue - PrevRevenue, PrevRevenue)

```

---

## 🚀 How to Run This Project

You can either just explore the Power BI file, or fully recreate the backend in PostgreSQL.

### ✅ Option 1 – Open the Power BI report only

1. Download `Retail-Sales-Analytics-Dashboard.pbix` from this repository.
2. Open it in **Power BI Desktop**.
3. If the data connection fails:
   - You can view the existing visuals as-is, or  
   - Re-point the data source to your own PostgreSQL / CSV files.

---

### ✅ Option 2 – Rebuild the full SQL + Power BI pipeline

1. **Create a PostgreSQL database** (for example):

   ```sql
   CREATE DATABASE retail_sales;
   ```

2. **Run the schema script** to create all tables:

   ```sql
   schema.sql
   ```

3. **Load your data** into:

   - `calendar`
   - `dim_customer`
   - `dim_product_categories`
   - `dim_product_subcategories`
   - `dim_product`
   - `dim_territory`
   - `fact_sales`
   - `returns_data`

4. **Create the main reporting view**:

   ```sql
   view_vw_sales.sql
   ```

   This creates the `vw_sales` view that Power BI uses for most visuals.

5. **Connect Power BI to PostgreSQL**:

   - In Power BI Desktop → **Get data → PostgreSQL database**
   - Server: your Postgres server (e.g. `localhost`)
   - Database: `retail_sales`
   - Select:
     - `vw_sales`
     - `returns_data`
   - Load the data and refresh the report.

Now you have the same data model and dashboards running end-to-end.

---

## 📸 Dashboard Screenshots  
Here are the key pages from the Power BI dashboard included in this project.

---

### 📊 1️⃣ Executive Summary
High-level KPIs and overview of revenue, profitability, and customer trends.

![Executive Summary](Screenshots/Page1_ExecutiveSummary.png)

---

### 📈 2️⃣ Sales Trends
Monthly + yearly revenue trends, moving averages, and YoY analysis.

![Sales Trends](Screenshots/Page2_SalesTrends.png)

---

### 🛒 3️⃣ Product Insights
Top products by revenue, gross profit, and category performance.

![Product Insights](Screenshots/Page3_ProductInsights.png)

---

### 🔄 4️⃣ Returns Analysis
Return rate performance and profitability vs return rate.

![Returns Analysis](Screenshots/Page4_ReturnsAnalysis.png)

---

## 📬 Contact

**Author:** Shohag  

If you’d like to discuss this project, collaborate, or talk about data analyst roles:

- 💼 LinkedIn: [My LinkedIn](https://www.linkedin.com/in/dataanalystshohag/)
- 🧑‍💻 GitHub: [Shohag-DataAnalyst](https://github.com/Shohag-DataAnalyst)

