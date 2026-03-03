# Retail Revenue & Customer Analytics (PostgreSQL)

## Overview
End-to-end SQL analytics project analyzing transactional retail data to uncover revenue trends, product concentration, and customer retention dynamics.

Dataset: ~1M transaction records  
Database: PostgreSQL  

---

## Key Insights

- 21% of products generate 80% of total revenue (Product Pareto).
- 23% of customers contribute to 80% of total revenue (Customer Pareto).
- 72% of customers are repeat buyers.
- Repeat customers drive ~97% of total revenue.

---

## Analysis Performed

### 1. Data Cleaning
- Removed cancelled invoices
- Filtered invalid quantities
- Converted date formats
- Created revenue column

### 2. Revenue Trend Analysis
- Monthly revenue
- MoM growth
- YoY growth
- Seasonal spike detection

### 3. Product Analysis
- Revenue per SKU
- Cumulative revenue modeling
- Pareto concentration analysis

### 4. Customer Analysis
- Repeat customer rate
- Revenue contribution by segment
- Customer Pareto distribution

---

## SQL Concepts Used

- CTEs
- Window Functions (LAG, ROW_NUMBER, SUM OVER)
- Cumulative calculations
- FILTER clause
- Date truncation
- Aggregations
