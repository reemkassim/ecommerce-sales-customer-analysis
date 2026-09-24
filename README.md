# E-commerce Sales & Customer Analysis

## Project Overview

This project analyzes Brazilian e-commerce sales and customer data to identify trends in sales performance, customer purchasing behavior, payment methods, product categories, geographic performance, and delivery times.

The analysis was performed using **MySQL and Power BI** to turn raw e-commerce data into meaningful business insights and an interactive dashboard.

## Business Questions

- How did product revenue and order volume change over time?
- Which product categories generated the most revenue?
- Which payment methods were most commonly used?
- How frequently did customers make purchases?
- Which customer states generated the most revenue?
- How long did orders take to be delivered?
- How did actual delivery time compare with the estimated delivery date?
- What proportion of customers were one-time versus repeat customers?

## Tools Used

- **MySQL** – Data analysis and SQL queries
- **Power BI** – Interactive dashboard and data visualization
- **Python** – Data loading and preparation
- **PopSQL** – Writing and running SQL queries

## Dataset

**Olist Brazilian E-Commerce Public Dataset**

The dataset contains information about orders, customers, products, order items, payments, and delivery dates from a Brazilian e-commerce marketplace.

The dataset was obtained from Kaggle.

[Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

## Data Preparation

The datasets were loaded into MySQL and checked for:

- Duplicate records
- Missing values
- Unmatched records between related tables
- Invalid payment values
- Missing delivery information
- Missing product categories

The main tables used were:

- `customers`
- `orders`
- `order_items`
- `products`
- `order_payments`

## SQL Analysis

SQL was used to analyze:

- Overall sales performance
- Monthly revenue and order trends
- Product category performance
- Customer purchase frequency
- One-time vs repeat customers
- Revenue by customer state
- Payment method usage
- Delivery performance

## Key Findings

- Total product revenue from delivered orders was approximately **R$13.22M**.
- There were **96,478 delivered orders**.
- Average order value was approximately **R$137.04**.
- Average delivery time was approximately **12.5 days**.
- **Credit card** was the most frequently used payment method.
- The highest-revenue product categories included **Beauty & Health**, **Watches & Gifts**, and **Bed, Bath & Table**.
- **São Paulo (SP)** generated the highest product revenue among Brazilian states.
- Approximately **96.88% of customers made one purchase**, while **3.12% made repeat purchases**.
- Repeat customers generated higher average revenue per customer than one-time customers.
- Orders were delivered approximately **11.88 days earlier than the estimated delivery date on average**.

## Power BI Dashboard

The Power BI dashboard provides an interactive view of the analysis, including:

- Total Product Revenue
- Delivered Orders
- Average Order Value
- Average Delivery Time
- Monthly Revenue
- Monthly Orders
- Top 10 Categories by Revenue
- Orders by Payment Method
- Customer Purchase Frequency
- Revenue by State
- Average Delivery Time by Month
- Revenue by Customer Type
