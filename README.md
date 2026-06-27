# E-Commerce Revenue Strategy Brief: Olist Marketplace Performance

##  Executive Summary
This project turns raw e-commerce transaction data into an easy-to-use, interactive sales dashboard. By setting up a clean data pipeline, the dashboard highlights exactly when customers spend the most money, which regions buy the most products, and which items drive the most business. Built specifically for sales and marketing teams, this tool provides clear, visual answers that help managers make smart decisions about where to spend their advertising budget and how to improve shipping operations.

##  Data Source & Description
* **Source:** Brazilian E-Commerce Public Dataset by Olist (hosted on Kaggle).
* **Description:** This dataset contains real, anonymized commercial data from 100,000 orders made between 2016 and 2018 on the Olist marketplace in Brazil. It is a multi-table dataset that links information across several relational dimensions, including order status, price, payment methods, freight performance, customer locations, product attributes, and actual customer reviews. This structure allows for deep analysis of real-world marketplace dynamics, consumer habits, and logistics challenges.

##  Tools and Skills
* **MySQL:** Used to manually engineer the foundational relational database schemas, write target table structures, clean up missing information, and run aggregation queries.
* **Python (Pandas & SQLAlchemy):** Used as a data loader to stream large datasets from local files directly into the pre-built MySQL tables, bypassing manual import limitations.
* **Power BI & DAX:** Used to import the clean database tables, create custom formulas (DAX) to calculate total sales numbers, and design the final visual charts.
* **Sales & Marketing Knowledge:** Used to look at charts and figures and turn them into practical business advice for growing a company.

## ⚙️ Project Methodology
To ensure the data was accurate and easy to understand, the project was broken down into five clear phases:

1. **Manual Data Acquisition:** Downloaded the raw, multi-table e-commerce CSV files directly from Kaggle onto a local computer.
2. **Database Engineering:** Built the empty relational database schemas and target table structures directly in **MySQL**, defining precise data types, primary keys, and foreign keys to link the orders, customers, and products safely.
3. **Python-to-SQL Ingestion Pipeline:** Because importing large datasets manually into MySQL can fail or cause errors, wrote a **Python Pandas** script using an SQL connector to stream the raw data directly into the pre-constructed MySQL tables.
4. **Data Cleaning & Aggregation:** Executed **SQL queries** to clean up the information within the database. This involved handling missing values (nulls) in product names, stripping out duplicate entries, and running aggregate queries to group transaction values by state and year.
5. **Data Modeling & Visualization:** Imported the clean tables into **Power BI**. Formulated custom **DAX measures** to keep track of core metrics like Total Revenue and Freight costs, and designed an interactive dashboard focusing on user-friendly layout and scannability.

##  Business Question
> *"How do regional buying habits, product popularity, and shipping fees affect our overall sales over time, and what simple changes can the sales and marketing teams make to find better sellers, target the right states, and lower delivery costs?"*

### Core Business Metrics
* **Total Gross Revenue:** 15.42M
* **Total Product Revenue:** 13.22M *(Actual cost of items sold)*
* **Total Freight Revenue:** 2.20M *(Money spent entirely on shipping costs)*
* **Total Orders:** 99,000 completed purchases

##  Key Insights

### 1. Growth Patterns Over the Years
The data shows the business grew incredibly fast over a three-year period. 
* In **2016**, sales were tiny, making up just **0.3% ($0.05M)** of total revenue. 
* The real breakthrough happened in **2017**, which brought in **44.89% ($6.92M)**. 
* The business hit its highest point in **2018**, capturing **54.81% ($8.45M)** of all sales.

### 2. Top States and Best-Selling Items
* **One Main State:** Sales are heavily concentrated in a single area. The state of **SP (São Paulo)** generates more money than the next three highest states (**RJ, MG, and RS**) combined. 
* **Favorite Categories:** Shoppers spend the most money on **Health & Beauty** and **Watches & Gifts**, followed closely by **Bed, Bath, & Table**. 

### 3. Shopping Delivery Costs and Seasonal Ups and Downs
* **High Shipping Fees:** About **14.3% ($2.20M)** of all customer spending goes directly toward delivery fees rather than the actual products. High shipping costs like this can easily scare away customers at checkout.
* **The September Drop:** Sales grow steadily starting in January and hit an absolute peak in **May**. However, business faces a major slowdown in **September**, where sales drop to their lowest point of the year before bouncing back for holiday shopping.

## Strategic Recommendations

### 1. Better Inventory and Seller Management
* **Lower Shipping Obstacles:** Since delivery costs make up a huge chunk of total sales, try setting up smaller fulfillment centers or partnering with local couriers outside of São Paulo (especially in RJ and MG) to offer cheaper shipping.
* **Help Mid-Tier Sellers:** The top-performing store accounts have highly stable sales. Study what these top sellers are doing right and share those tips with smaller sellers to help them grow.
* **Bring on the Right Suppliers:** Have the sales team focus on recruiting new suppliers who sell *Health & Beauty* and *Watches & Gifts* products to keep up with what shoppers want.

### 2. Smarter Marketing Campaigns
* **Protect the Core Market:** Spend about 60% of your regional marketing budget directly in **São Paulo** to keep your top spot, while running smaller, targeted ads in **Rio de Janeiro** and **Minas Gerais**.
* **Fix the September Slowdown:** To prevent the massive sales drop in **September**, launch a special "End of Summer" or "Early Holiday Preview" sale to get people buying during an otherwise slow month.
* **Combine Popular Products:** Take advantage of the high traffic in the *Bed, Bath, & Table* section by showing customers helpful recommendations for *Health & Beauty* items right before they check out.



![Dashboard](<https://github.com/Evelynn-atienosan/E-Commerce-Sales-Analysis-Olist-Marketplace-/blob/main/images.png/Olist_dashboard_overview.png?raw=true>)

