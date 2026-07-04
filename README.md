# Nexa-Retail
Exploratory data analysis of NexaRetail's sales data using MySQL — covering revenue trends, store performance, and product insights.


## 🛒 NexaRetail Sales Analysis — SQL Project

A data analysis project built on real retail transaction data from NexaRetail, a fictional FMCG distributor operating across 10 cities in Maharashtra. The goal was to answer 10 business questions using SQL — questions a real retail manager or business owner would actually care about.


## 📁 What's in this Repository

FileWhat it containsNexa_Retail_CSV.csvThe raw dataset — 15,382 rows of sales transactionsNexa_Retail_SQL.sqlAll SQL queries written to answer the 10 business questionsNexaRetail_Answers_Archit_Verma.pdfFinal report with results and plain-language business takeaways


## 📊 About the Dataset


#### 15,382 sales transactions
#### 40 stores across 10 cities in Maharashtra
#### 2 store types — Kirana stores and Supermarkets
#### Covers 2023–2024 sales data
#### Each row contains: Order Date, Store Name, City, Product, Category, Quantity Sold, and Revenue



## ❓ Business Questions Answered


#### Q1.What is the total revenue for 2023, broken down by quarter?
#### Q2.Which are the top 5 stores by total revenue? Are they all in the same city?
#### Q3.Which product category earns the most money per sale?
#### Q4.How many stores consistently met their monthly targets? (skipped — target data not available)
#### Q5.How did revenue grow or drop month by month? Which month had the worst fall?
#### Q6.Which city has customers spending the most per visit? Which has the least?
#### Q7.Do Kirana stores or Supermarkets bring in more revenue per store?
#### Q8.Which 3 products are steadily losing sales volume month after month?
#### Q9.What share of total revenue comes from just the top 10% of stores?
#### Q10.If the 3 weakest products were removed, how much revenue would be lost?



## 💡 Key Findings


#### Q3 (Jul–Sep) was the strongest quarter — over ₹1.2 crore in revenue, making it the most important period to have stock ready and promotions running.

#### Top 5 stores are spread across 5 different cities — a healthy sign that the business isn't depending too much on any one location.

#### Atta is the highest-value category — customers spend nearly ₹12,000 per purchase on average, making it the best candidate for premium placement.

#### August 2023 saw the sharpest revenue drop at -21% — worth investigating for causes like seasonal dips or supply issues.

#### Solapur customers spend the most per visit; Kolhapur the least — different cities need different strategies.

#### 10 Supermarkets are nearly matching the revenue of 30 Kirana stores — supermarkets are the more efficient format for future expansion.

#### 3 products are on a steady decline in sales volume — NexaCrunch Chips 100g, NexaCrunch Mixture 200g, and NexaGold Sunflower Oil 1L need attention.

#### Just 4 stores generate 11% of total revenue — losing even one could significantly hurt the business.

#### Removing the bottom 3 products would only cost ~3% of revenue — a safe trade-off for freeing up space.



## 🛠️ Tools Used


#### MySQL — for writing and running all queries
#### MySQL Workbench — for managing the database and importing data
#### Python (ReportLab) — for generating the final PDF report



## 🧠 SQL Concepts Used

### here's what the queries cover:


#### Aggregate functions (SUM, AVG, COUNT)
#### Window functions (LAG, RANK, PARTITION BY) for month-over-month comparisons and rankings
#### Common Table Expressions / CTEs (WITH clauses) for step-by-step query building
#### UNION ALL for combining results
#### CROSS JOIN for percentage calculations
Date functions (QUARTER, YEAR, DATE_SUB)
Data cleaning (REPLACE, ALTER TABLE, type conversion)
