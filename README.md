# Nexa-Retail

Exploratory data analysis of NexaRetail's sales data using MySQL and Python — covering revenue trends, store performance, seasonality, return-rate risk, and product insights.

## 🛒 NexaRetail Sales Analysis

A data analysis project built on real retail transaction data from NexaRetail, a fictional FMCG distributor operating across 10 cities in Maharashtra. The goal was to answer the business questions a real retail manager or business owner would actually care about — first in SQL, then extended with a full Python EDA.

## 📁 What's in this Repository

- `Nexa_Retail_Raw` → Zip file, raw data, 16 excel files
- `Nexa_Retail_Consolidated` → Consolidated excel file, cleaned dataset, 15,382 rows of sales transactions
- `Nexa_Retail_SQL.sql` → All SQL queries written to answer the 10 business questions
- `NexaRetail_Answers_Archit_Verma.pdf` → Final SQL report with results and plain-language business takeaways
- `NexaRetail_EDA_Portfolio.ipynb` → Python EDA notebook covering revenue drivers, monthly/weekly seasonality, return-rate analysis, and a Business Opportunity Matrix
- `NexaRetail_Business_Observations.pdf` → 2-page summary of the 3 most consequential business observations from the Python EDA, each with a chart and a recommendation

## 📊 About the Dataset

- 15,382 sales transactions
- 40 stores across 10 cities in Maharashtra
- 2 store types — Kirana stores and Supermarkets
- Covers 2023–2024 sales data
- Each row contains: Order Date, Store Name, City, Product, Category, Quantity Sold, and Revenue

## ❓ SQL: Business Questions Answered

Q1. What is the total revenue for 2023, broken down by quarter?
Q2. Which are the top 5 stores by total revenue? Are they all in the same city?
Q3. Which product category earns the most money per sale?
Q4. How many stores consistently met their monthly targets? (skipped — target data not available)
Q5. How did revenue grow or drop month by month? Which month had the worst fall?
Q6. Which city has customers spending the most per visit? Which has the least?
Q7. Do Kirana stores or Supermarkets bring in more revenue per store?
Q8. Which 3 products are steadily losing sales volume month after month?
Q9. What share of total revenue comes from just the top 10% of stores?
Q10. If the 3 weakest products were removed, how much revenue would be lost?

### 💡 Key Findings (SQL)

- Q3 (Jul–Sep) was the strongest quarter — over ₹1.2 crore in revenue, making it the most important period to have stock ready and promotions running.
- Top 5 stores are spread across 5 different cities — a healthy sign that the business isn't depending too much on any one location.
- Atta is the highest-value category — customers spend nearly ₹12,000 per purchase on average, making it the best candidate for premium placement.
- August 2023 saw the sharpest revenue drop at -21% — worth investigating for causes like seasonal dips or supply issues.
- Solapur customers spend the most per visit; Kolhapur the least — different cities need different strategies.
- 10 Supermarkets are nearly matching the revenue of 30 Kirana stores — supermarkets are the more efficient format for future expansion.
- 3 products are on a steady decline in sales volume — NexaCrunch Chips 100g, NexaCrunch Mixture 200g, and NexaGold Sunflower Oil 1L need attention.
- Just 4 stores generate 11% of total revenue — losing even one could significantly hurt the business.
- Removing the bottom 3 products would only cost ~3% of revenue — a safe trade-off for freeing up space.

## 📓 Python EDA: Extended Analysis

The SQL project answered 10 targeted business questions. The Python notebook (`NexaRetail_EDA_Portfolio.ipynb`) goes deeper — full exploratory analysis with polished, presentation-ready visuals — covering:

- Revenue distribution across city, store type, category, and channel (online vs offline)
- Monthly and weekly seasonality patterns
- Return-rate analysis by category, city, and product
- Correlation between basket size, channel, and store type
- A Business Opportunity Matrix (revenue share vs return rate by category)
- A city-level Revenue-Risk analysis identifying which top revenue product carries the most exposure in each city

### 💡 Key Findings (Python EDA)

- Total revenue: ₹4.77 crore across 11,875 orders, with a 37.4% return rate — high enough to be a top operational priority.
- Revenue is driven by order volume, not order value — average order value barely moves city to city, but order counts do.
- Atta and Personal Care combine solid revenue share with the highest return rates of any category (~38–39%).
- Rajkot's top revenue product, NexaGold Wheat Atta 5kg, carries the largest combined revenue-at-risk of any city's top product — a 40.3% return rate on a product worth 9.2% of the city's total revenue.
- Basket size doesn't vary meaningfully by channel or store type — Online/Offline and Kirana/Supermarket customers buy about the same quantity per order.

A standalone 2-page summary of the three most important findings — each with its own chart and recommendation — is available in `NexaRetail_Business_Observations.pdf`.

## 🛠️ Tools Used

- MySQL — for writing and running all SQL queries
- MySQL Workbench — for managing the database and importing data
- Python (Pandas, Matplotlib, Seaborn) — for the extended EDA notebook
- Python (ReportLab) — for generating both PDF reports

## 🧠 SQL Concepts Used

Here's what the queries cover:

- Aggregate functions (SUM, AVG, COUNT)
- Window functions (LAG, RANK, PARTITION BY) for month-over-month comparisons and rankings
- Common Table Expressions / CTEs (WITH clauses) for step-by-step query building
- UNION ALL for combining results
- CROSS JOIN for percentage calculations
- Date functions (QUARTER, YEAR, DATE_SUB)
- Data cleaning (REPLACE, ALTER TABLE, type conversion)

## 🚧 Coming Soon

- 🔜 **RFM Segmentation** — Recency, Frequency, Monetary customer segmentation to identify high-value, at-risk, and churned customer/store groups.
- 🔜 **A/B Testing** — A statistical testing framework to validate whether observed differences (e.g. channel performance, promotional impact) are actually significant or just noise.
