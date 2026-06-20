

-- 1. Row counts
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL SELECT 'product_category_translation', COUNT(*) FROM product_category_translation;


-- 2. Order status distribution
SELECT
  order_status,
  COUNT(*) AS total_orders,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders), 2) AS pct_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- 3. Orders by year and month
SELECT
  DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
  COUNT(*) AS total_orders
FROM orders
GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY order_month;


-- 4. Revenue by year and month
SELECT
  DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
  ROUND(SUM(oi.price), 2) AS product_revenue,
  ROUND(SUM(oi.freight_value), 2) AS freight_revenue,
  COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN order_items oi
  ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY order_month;


-- 5. Overall sales summary
SELECT
  COUNT(DISTINCT o.order_id) AS total_orders,
  COUNT(oi.order_item_id) AS total_items_sold,
  ROUND(SUM(oi.price), 2) AS product_revenue,
  ROUND(SUM(oi.freight_value), 2) AS freight_revenue,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
  ROUND(AVG(oi.price), 2) AS avg_item_price,
  ROUND(AVG(oi.freight_value), 2) AS avg_freight_value
FROM orders o
JOIN order_items oi
  ON o.order_id = oi.order_id;

-- 5. Overall sales summary
SELECT
  COUNT(DISTINCT o.order_id) AS total_orders,
  COUNT(oi.order_item_id) AS total_items_sold,
  ROUND(SUM(oi.price), 2) AS product_revenue,
  ROUND(SUM(oi.freight_value), 2) AS freight_revenue,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
  ROUND(AVG(oi.price), 2) AS avg_item_price,
  ROUND(AVG(oi.freight_value), 2) AS avg_freight_value
FROM orders o
JOIN order_items oi
  ON o.order_id = oi.order_id;


-- 6. Average order value, minimum order value, maximum oreder value
WITH order_totals AS (
  SELECT
    order_id,
    SUM(price + freight_value) AS order_total
  FROM order_items
  GROUP BY order_id
)
SELECT
  COUNT(*) AS total_orders,
  ROUND(AVG(order_total), 2) AS avg_order_value,
  ROUND(MIN(order_total), 2) AS min_order_value,
  ROUND(MAX(order_total), 2) AS max_order_value
FROM order_totals;


-- 7. Top 20 product categories by revenue
SELECT
  COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
  COUNT(DISTINCT oi.order_id) AS total_orders,
  COUNT(*) AS total_items,
  ROUND(SUM(oi.price), 2) AS product_revenue,
  ROUND(SUM(oi.freight_value), 2) AS freight_revenue,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM order_items oi
JOIN products p
  ON oi.product_id = p.product_id
LEFT JOIN product_category_translation t
  ON p.product_category_name = t.product_category_name
GROUP BY COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
ORDER BY total_revenue DESC
LIMIT 20;


-- 8. Top 20 product categories by number of items sold
SELECT
  COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
  COUNT(*) AS total_items_sold,
  COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
JOIN products p
  ON oi.product_id = p.product_id
LEFT JOIN product_category_translation t
  ON p.product_category_name = t.product_category_name
GROUP BY COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
ORDER BY total_items_sold DESC
LIMIT 20;


-- 9. Top 20 products by revenue
SELECT
  oi.product_id,
  COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
  COUNT(*) AS total_items_sold,
  ROUND(SUM(oi.price), 2) AS product_revenue
FROM order_items oi
JOIN products p
  ON oi.product_id = p.product_id
LEFT JOIN product_category_translation t
  ON p.product_category_name = t.product_category_name
GROUP BY oi.product_id, COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
ORDER BY product_revenue DESC
LIMIT 20;


-- 10. Customers by state
SELECT
  customer_state,
  COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;


-- 11. Revenue by customer state
SELECT
  c.customer_state,
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
JOIN order_items oi
  ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;


-- 12. Top 20 customer cities by revenue
SELECT
  c.customer_city,
  c.customer_state,
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
JOIN order_items oi
  ON o.order_id = oi.order_id
GROUP BY c.customer_city, c.customer_state
ORDER BY total_revenue DESC
LIMIT 20;


-- 13. Sellers by state
SELECT
  seller_state,
  COUNT(*) AS total_sellers
FROM sellers
GROUP BY seller_state
ORDER BY total_sellers DESC;


-- 14. Top 20 sellers by revenue
SELECT
  oi.seller_id,
  s.seller_city,
  s.seller_state,
  COUNT(DISTINCT oi.order_id) AS total_orders,
  COUNT(*) AS total_items_sold,
  ROUND(SUM(oi.price), 2) AS product_revenue
FROM order_items oi
JOIN sellers s
  ON oi.seller_id = s.seller_id
GROUP BY oi.seller_id, s.seller_city, s.seller_state
ORDER BY product_revenue DESC
LIMIT 20;


-- 15. Payment type distribution
SELECT
  payment_type,
  COUNT(*) AS payment_records,
  ROUND(SUM(payment_value), 2) AS total_payment_value,
  ROUND(AVG(payment_value), 2) AS avg_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;



-- 16. Payment installments distribution
SELECT
  payment_installments,
  COUNT(*) AS payment_records,
  ROUND(SUM(payment_value), 2) AS total_payment_value,
  ROUND(AVG(payment_value), 2) AS avg_payment_value
FROM order_payments
GROUP BY payment_installments
ORDER BY payment_installments;


-- 17. Review score distribution
SELECT
  review_score,
  COUNT(*) AS review_count,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM order_reviews), 2) AS pct_reviews
FROM order_reviews
GROUP BY review_score
ORDER BY review_score;


-- 18. Average review score by product category
SELECT
  COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
  COUNT(DISTINCT r.review_id) AS total_reviews,
  ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM order_reviews r
JOIN order_items oi
  ON r.order_id = oi.order_id
JOIN products p
  ON oi.product_id = p.product_id
LEFT JOIN product_category_translation t
  ON p.product_category_name = t.product_category_name
GROUP BY COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
HAVING total_reviews >= 50
ORDER BY avg_review_score DESC;


-- 19. Delivery time summary in days
SELECT
  COUNT(*) AS delivered_orders,
  ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 2) AS avg_delivery_days,
  MIN(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS min_delivery_days,
  MAX(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS max_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;


-- 20. Delivery performance: early, on time, late
SELECT
  CASE
    WHEN order_delivered_customer_date IS NULL THEN 'not_delivered'
    WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'on_or_before_estimate'
    ELSE 'late'
  END AS delivery_status,
  COUNT(*) AS total_orders
FROM orders
GROUP BY
  CASE
    WHEN order_delivered_customer_date IS NULL THEN 'not_delivered'
    WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'on_or_before_estimate'
    ELSE 'late'
  END
ORDER BY total_orders DESC;


-- 21. Late delivery rate by customer state
SELECT
  c.customer_state,
  COUNT(*) AS delivered_orders,
  SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END) AS late_orders,
  ROUND(
    SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS late_rate_pct
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY late_rate_pct DESC;


-- 22. Relationship between delivery time and review score
SELECT
  r.review_score,
  COUNT(*) AS total_reviews,
  ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 2) AS avg_delivery_days
FROM order_reviews r
JOIN orders o
  ON r.order_id = o.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY r.review_score
ORDER BY r.review_score;


-- 23. Freight percentage by category
SELECT
  COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
  ROUND(SUM(oi.price), 2) AS product_revenue,
  ROUND(SUM(oi.freight_value), 2) AS freight_revenue,
  ROUND(SUM(oi.freight_value) * 100.0 / NULLIF(SUM(oi.price + oi.freight_value), 0), 2) AS freight_pct_of_total
FROM order_items oi
JOIN products p
  ON oi.product_id = p.product_id
LEFT JOIN product_category_translation t
  ON p.product_category_name = t.product_category_name
GROUP BY COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
HAVING product_revenue > 10000
ORDER BY freight_pct_of_total DESC;


-- 24. Repeat customers
SELECT
  order_count,
  COUNT(*) AS total_customers
FROM (
  SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS order_count
  FROM customers c
  JOIN orders o
    ON c.customer_id = o.customer_id
  GROUP BY c.customer_unique_id
) customer_orders
GROUP BY order_count
ORDER BY order_count;


-- 25. Top repeat customers by total spend
SELECT
  c.customer_unique_id,
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS total_spend
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
JOIN order_items oi
  ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
HAVING total_orders > 1
ORDER BY total_spend DESC
LIMIT 20;
