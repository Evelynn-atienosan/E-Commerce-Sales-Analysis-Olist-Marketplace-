# Sales Performance Analysis and Business Recommendations (Olist Marketplace)

## Project Overview
This project analyzes the Olist E-Commerce dataset to understand key drivers of sales performance in an online marketplace.

The goal is to uncover insights around revenue, customers, sellers, products, and delivery performance using SQL and Power BI.

The analysis focuses on answering:

- What drives sales performance in the marketplace?
- How do customers, sellers, and product categories contribute to revenue?
- How does delivery performance affect customer satisfaction?

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
- Total Revenue (GMV) = SUM(price + freight_value)  
- Average Order Value (AOV) = Total revenue / number of orders  
- Order Count = COUNT(order_id)  

## Data Preparation
Data was cleaned and prepared using SQL by removing duplicates, standardizing relationships using primary and foreign keys, validating referential integrity, and ensuring consistent data types. Tables were joined to support analysis in Power BI.

## Power BI Dashboard
The dashboard covers sales performance, customer distribution by state, product category revenue, seller performance, monthly sales trends, and delivery performance compared to customer reviews.

## Key Insights

### Customer Distribution by State
São Paulo (SP) has the highest number of customers and also generates the highest sales, making it the most important region for the marketplace.

### Product Category Performance
Health & Beauty generates the highest revenue, Computers has the highest average order value, and Bed & Bath records the highest number of orders.

Each category contributes differently to performance through revenue, value, or volume.

### Seller Performance
One seller generated the highest revenue while another recorded the highest number of products sold. This shows the difference between high-value and high-volume sellers.

### Monthly Sales Trends
Sales peaked in January, March, April, and May 2018, with April recording the highest revenue, suggesting seasonal demand patterns.

### Delivery Performance and Customer Satisfaction
Late deliveries are associated with lower review scores, showing that delivery performance directly affects customer satisfaction and repeat purchases.

## Business Recommendations
Focus marketing efforts on São Paulo due to its strong customer base, improve logistics to reduce delivery delays, invest further in Health & Beauty as the top revenue category, optimize pricing and promotions in Computers due to high order value, strengthen seller support programs, and use seasonal trends to guide marketing and inventory planning.


