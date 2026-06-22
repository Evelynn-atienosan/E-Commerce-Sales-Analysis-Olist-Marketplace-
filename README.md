# Sales Performance Analysis and Business Recommendations (Olist Marketplace)

## Project Overview
This project analyzes the Olist E-Commerce dataset to understand key drivers of sales performance in an online marketplace.

The goal is to uncover insights around revenue, customers, sellers and products  using SQL and Power BI.

The analysis focuses on answering:

- What drives sales performance in the marketplace?
- How do customers, sellers, and product categories contribute to revenue?
- Which year has the highest sales performance?

## Dataset
- Source: Olist Brazilian E-Commerce Dataset (Kaggle)
- Includes orders, customers, products, sellers, payments, reviews, order items, and geolocation data

## Database Structure
Key tables used:
- customers
- orders
- order_items
- products
- sellers
- order_payments
- order_reviews
- product_category_translation

Relationships:
- One customer → many orders  
- One order → many order items  
- One seller → many order items  
- One product → many order items  

## Key Metrics
- Product Revenue = SUM(price)  
- Total Gross Revenue = SUM(price + freight_value) 
- Total Product Revenue = SUM(price) 
- Average Order Value (AOV) = Total revenue / number of orders  
- Order Count = COUNT(order_id)  

## Data Preparation
Data was loaded into sql using python then cleaned and prepared using SQL by removing duplicates, standardizing relationships using primary and foreign keys, validating referential integrity, and ensuring consistent data types.Tables were imported into PowerBI for visualization.

## Power BI Dashboard
The dashboard covers sales performance by state, product category revenue, seller performance, and monthly sales trends 



![Dashboard](<c:\Users\hp\Pictures\olist dashboard.png>) 


## Key Insights

### São Paulo leads in revenue
SP is the top-contributing state to gross revenue by a significant margin.

### Health & beauty drives the most revenue
It is the top performing product category, followed by watches & gifts and bed, bath & table.

### Top sellers contribute the most
A small number of sellers generate a large portion of total revenue.

### Sales trend shows a drop
Revenue remained stable from January to August but dropped sharply in September.

### 2018 is the strongest year
It contributes 54.56% of total gross revenue.

## Business Recommendations

- Focus marketing efforts and customer acquisition strategies in high-performing states such as São Paulo to maximize revenue growth.

- Increase investment in high-performing product categories such as Health & Beauty and Watches & Gifts to capitalize on strong customer demand.

- Strengthen relationships with top-performing sellers while providing support and incentives to help emerging sellers grow their sales.

- Investigate the sharp decline in sales between August and September to identify underlying causes and implement measures to sustain sales performance.