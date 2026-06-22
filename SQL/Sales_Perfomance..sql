USE olist_db;


-- Focus: revenue, customers, products, sellers, delivery,
-- payments, and reviews.
-- ============================================================

-- 1. Executive KPI summary
SELECT
  COUNT(DISTINCT o.order_id) AS total_orders,
  COUNT(DISTINCT c.customer_unique_id) AS unique_customers,
  COUNT(DISTINCT oi.product_id) AS products_sold,
  COUNT(DISTINCT oi.seller_id) AS active_sellers,
  COUNT(*) AS total_items_sold,
  ROUND(SUM(oi.price), 2) AS product_revenue,
  ROUND(SUM(oi.freight_value), 2) AS freight_revenue,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS gross_revenue,
  ROUND(SUM(oi.price + oi.freight_value) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
JOIN order_items oi
  ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';


-- 2. Monthly revenue and order trend
SELECT
  DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
  COUNT(DISTINCT o.order_id) AS total_orders,
  COUNT(*) AS total_items_sold,
  ROUND(SUM(oi.price), 2) AS product_revenue,
  ROUND(SUM(oi.freight_value), 2) AS freight_revenue,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS gross_revenue,
  ROUND(SUM(oi.price + oi.freight_value) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM orders o
JOIN order_items oi
  ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY order_month;


-- 3. Best revenue months
SELECT
  DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS gross_revenue
FROM orders o
JOIN order_items oi
  ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY gross_revenue DESC
LIMIT 10;


-- 4. Customer distribution and gross revenue by state
SELECT
  c.customer_state,
  COUNT(DISTINCT c.customer_unique_id) AS unique_customers,
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS gross_revenue,
  ROUND(SUM(oi.price + oi.freight_value) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
JOIN order_items oi
  ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY gross_revenue DESC;



-- 7. Top 20 product categories by gross revenue
SELECT
  COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
  COUNT(DISTINCT oi.order_id) AS total_orders,
  COUNT(*) AS total_items_sold,
  ROUND(SUM(oi.price), 2) AS product_revenue,
  ROUND(SUM(oi.freight_value), 2) AS freight_revenue,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS gross_revenue,
  ROUND(AVG(oi.price), 2) AS avg_item_price
FROM order_items oi
JOIN orders o
  ON oi.order_id = o.order_id
JOIN products p
  ON oi.product_id = p.product_id
LEFT JOIN product_category_translation t
  ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
ORDER BY gross_revenue DESC
LIMIT 20;


-- 8. Product categories with highest average order value
SELECT
  category,
  total_orders,
  gross_revenue,
  ROUND(gross_revenue / total_orders, 2) AS category_avg_order_value
FROM (
  SELECT
    COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.price + oi.freight_value) AS gross_revenue
  FROM order_items oi
  JOIN orders o
    ON oi.order_id = o.order_id
  JOIN products p
    ON oi.product_id = p.product_id
  LEFT JOIN product_category_translation t
    ON p.product_category_name = t.product_category_name
  WHERE o.order_status = 'delivered'
  GROUP BY COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
) category_sales
WHERE total_orders >= 100
ORDER BY category_avg_order_value DESC
LIMIT 20;


-- 9. Top 20 sellers by gross revenue
SELECT
  oi.seller_id,
  s.seller_city,
  s.seller_state,
  COUNT(DISTINCT oi.order_id) AS total_orders,
  COUNT(*) AS total_items_sold,
  ROUND(SUM(oi.price), 2) AS product_revenue,
  ROUND(SUM(oi.freight_value), 2) AS freight_revenue,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS gross_revenue
FROM order_items oi
JOIN orders o
  ON oi.order_id = o.order_id
JOIN sellers s
  ON oi.seller_id = s.seller_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id, s.seller_city, s.seller_state
ORDER BY gross_revenue DESC
LIMIT 20;
