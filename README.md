## Project Overview
A comprehensive data analytics project demonstrating end-to-end data warehouse implementation and business intelligence analysis using SQL Server. This project showcases dimensional modeling, exploratory data analysis, and advanced SQL techniques for business insights.

## 🎯 Project Objectives
- Build a star schema data warehouse with fact and dimension tables
- Perform comprehensive business intelligence analysis
- Create customer and product performance reports
- Demonstrate advanced SQL analytical functions
- Generate actionable business insights from sales data

## 🏗️ Data Architecture

### Database Schema
- **Database**: `DataWarehouseAnalytics`
- **Schema**: `gold` (production-ready analytical layer)

### Tables Structure
```sql
📊 Fact Table:
- fact_sales (order_number, product_key, customer_key, dates, sales_amount, quantity, price)

📋 Dimension Tables:
- dim_customers (customer demographics and details)
- dim_products (product catalog with categories and costs)
```

## 📈 Analysis Categories

### 1. **Exploratory Data Analysis (EDA)**
- Data profiling and quality assessment
- Dimensional analysis (countries, categories, date ranges)
- Measure exploration (total sales, quantities, pricing)
- Business metrics summary report

### 2. **Magnitude Analysis**
- Revenue distribution across categories
- Customer distribution by geography and demographics
- Product performance by category and subcategory
- Cross-dimensional comparisons

### 3. **Ranking Analysis**
- Top/bottom performing products
- Customer revenue rankings
- Category performance rankings
- Window functions for advanced rankings

### 4. **Time Series Analysis**
- Sales performance over time (yearly, monthly)
- Cumulative analysis with running totals
- Moving averages and trend analysis
- Year-over-year growth comparisons

### 5. **Performance Analysis**
- Current vs. previous year sales comparison
- Performance vs. average benchmarking
- Growth trend identification
- Seasonal pattern analysis

### 6. **Part-to-Whole Analysis**
- Category contribution to total sales
- Market share analysis
- Percentage distribution reports
- Business dependency assessment

### 7. **Data Segmentation**
- Customer segmentation (VIP, Regular, New)
- Product cost range analysis
- Age group categorization
- Performance-based groupings

## 📊 Business Intelligence Reports

### Customer Analytics Report
**Key Metrics:**
- Total orders and sales per customer
- Customer lifetime value
- Recency analysis (months since last order)
- Average order value
- Average monthly spend
- Customer segmentation and age group analysis

### Product Performance Report
**Key Metrics:**
- Revenue performance classification
- Average order rate (AOR)
- Monthly revenue trends
- Product lifecycle analysis
- Category and subcategory performance

## 🔧 Technical Implementation

### Advanced SQL Techniques Used:
- **Window Functions**: ROW_NUMBER(), RANK(), LAG(), LEAD()
- **Aggregate Functions**: SUM(), COUNT(), AVG() with OVER clause
- **Date Functions**: DATETRUNC(), DATEDIFF(), FORMAT()
- **CTEs (Common Table Expressions)**: Complex multi-level queries
- **CASE Statements**: Dynamic categorization and segmentation
- **JOINs**: Multi-table analysis and data integration
- **Views**: Reusable analytical components

### Data Loading:
- BULK INSERT operations for CSV data ingestion
- Data validation and cleanup procedures
- Truncate and reload patterns

## 📋 Key Business Insights

1. **Revenue Concentration**: Bikes category generates majority of revenue
2. **Geographic Distribution**: US market shows highest item sales volume
3. **Customer Segmentation**: Clear VIP, Regular, and New customer tiers
4. **Product Performance**: Identified top and bottom performing products
5. **Seasonal Trends**: Monthly and yearly sales pattern analysis
6. **Customer Behavior**: Purchase frequency and value patterns

## 🎯 Skills Demonstrated

- **Data Warehousing**: Dimensional modeling, ETL processes
- **SQL Mastery**: Advanced functions, optimization, complex queries
- **Business Intelligence**: KPI development, reporting, dashboards
- **Data Analysis**: Statistical analysis, trend identification
- **Performance Tuning**: Query optimization, indexing strategies

## 📊 Sample Queries

### Top 5 Revenue Generating Products
```sql
SELECT TOP 5 
    p.product_name,
    SUM(f.sales_amount) as total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;
```

### Customer Segmentation Analysis
```sql
SELECT 
    customer_segment,
    COUNT(customer_key) as total_customers
FROM gold.report_customers
GROUP BY customer_segment
ORDER BY total_customers DESC;
```

## 🔮 Future Enhancements

- **Data Visualization**: Power BI/Tableau integration
- **Automated ETL**: SSIS package development
- **Real-time Analytics**: Streaming data integration
- **Machine Learning**: Predictive analytics implementation
- **API Development**: RESTful services for data access

## 📧 Contact
[Yuvraj Singh] - [ys62168@gmail.com]
Project Link: [https://github.com/yuvrajrajput16/SQL-Data-Warehouse---BA/tree/main]

---
*This project demonstrates practical application of SQL for business intelligence and data analytics in a real-world scenario.*
