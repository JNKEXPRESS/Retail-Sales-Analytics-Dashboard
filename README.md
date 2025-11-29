# Retail Sales Analytics Dashboard  
An end-to-end data analytics project using **SQL, PostgreSQL, DAX, and Power BI**.

---

## 📌 Project Overview  
This project analyzes retail sales performance across multiple years.  
The goal was to build a complete, end-to-end analytics workflow including:

- SQL-based data cleaning & transformation  
- Data modeling in PostgreSQL  
- Calculation of key KPIs using DAX  
- Interactive Power BI dashboards for insights & decision-making  

---

## 🛠 Tools & Technologies  
- **SQL (PostgreSQL)** – for data cleaning, joining, calculations  
- **Power BI** – for data modeling, DAX measures, visualization  
- **DAX** – custom KPI calculations  
- **GitHub** – version control & project documentation  

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
