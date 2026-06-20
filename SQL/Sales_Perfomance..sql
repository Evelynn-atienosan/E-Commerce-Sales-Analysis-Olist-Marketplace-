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


-- 4. Customer distribution by state
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


-- 5. Top 20 cities by revenue
SELECT
  c.customer_city,
  c.customer_state,
  COUNT(DISTINCT c.customer_unique_id) AS unique_customers,
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS gross_revenue
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
JOIN order_items oi
  ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_city, c.customer_state
ORDER BY gross_revenue DESC
LIMIT 20;

 --6. Customer repeat purchase analysis
 
WITH customer_orders AS (
  SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(oi.price + oi.freight_value) AS total_spend
  FROM customers c
  JOIN orders o
    ON c.customer_id = o.customer_id
  JOIN order_items oi
    ON o.order_id = oi.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_unique_id
)
SELECT
  CASE
    WHEN order_count = 1 THEN 'one_time_customer'
    WHEN order_count BETWEEN 2 AND 3 THEN 'repeat_customer_2_to_3_orders'
    ELSE 'loyal_customer_4_plus_orders'
  END AS customer_segment,
  COUNT(*) AS total_customers,
  ROUND(SUM(total_spend), 2) AS segment_revenue,
  ROUND(AVG(total_spend), 2) AS avg_customer_spend
FROM customer_orders
GROUP BY
  CASE
    WHEN order_count = 1 THEN 'one_time_customer'
    WHEN order_count BETWEEN 2 AND 3 THEN 'repeat_customer_2_to_3_orders'
    ELSE 'loyal_customer_4_plus_orders'
  END
ORDER BY segment_revenue DESC;




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


-- 10. Seller concentration: revenue by seller state
SELECT
  s.seller_state,
  COUNT(DISTINCT s.seller_id) AS total_sellers,
  COUNT(DISTINCT oi.order_id) AS total_orders,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS gross_revenue,
  ROUND(SUM(oi.price + oi.freight_value) / COUNT(DISTINCT s.seller_id), 2) AS revenue_per_seller
FROM sellers s
JOIN order_items oi
  ON s.seller_id = oi.seller_id
JOIN orders o
  ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_state
ORDER BY gross_revenue DESC;


-- 11. Payment method performance
SELECT
  op.payment_type,
  COUNT(DISTINCT op.order_id) AS total_orders,
  ROUND(SUM(op.payment_value), 2) AS total_payment_value,
  ROUND(AVG(op.payment_value), 2) AS avg_payment_value
FROM order_payments op
JOIN orders o
  ON op.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY op.payment_type
ORDER BY total_payment_value DESC;


-- 12. Installments and average payment value
SELECT
  payment_installments,
  COUNT(DISTINCT order_id) AS total_orders,
  ROUND(SUM(payment_value), 2) AS total_payment_value,
  ROUND(AVG(payment_value), 2) AS avg_payment_value
FROM order_payments
WHERE payment_type = 'credit_card'
GROUP BY payment_installments
ORDER BY payment_installments;


-- 13. Review score impact on revenue
SELECT
  r.review_score,
  COUNT(DISTINCT r.order_id) AS reviewed_orders,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS gross_revenue,
  ROUND(SUM(oi.price + oi.freight_value) / COUNT(DISTINCT r.order_id), 2) AS avg_order_value
FROM order_reviews r
JOIN orders o
  ON r.order_id = o.order_id
JOIN order_items oi
  ON r.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY r.review_score
ORDER BY r.review_score;



-- 14. Product categories with strongest review scores
SELECT
  COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
  COUNT(DISTINCT r.review_id) AS total_reviews,
  ROUND(AVG(r.review_score), 2) AS avg_review_score,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS gross_revenue
FROM order_reviews r
JOIN order_items oi
  ON r.order_id = oi.order_id
JOIN orders o
  ON r.order_id = o.order_id
JOIN products p
  ON oi.product_id = p.product_id
LEFT JOIN product_category_translation t
  ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
HAVING total_reviews >= 100
ORDER BY avg_review_score DESC, gross_revenue DESC
LIMIT 20;


-- 15. Product categories with weakest review scores
SELECT
  COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
  COUNT(DISTINCT r.review_id) AS total_reviews,
  ROUND(AVG(r.review_score), 2) AS avg_review_score,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS gross_revenue
FROM order_reviews r
JOIN order_items oi
  ON r.order_id = oi.order_id
JOIN orders o
  ON r.order_id = o.order_id
JOIN products p
  ON oi.product_id = p.product_id
LEFT JOIN product_category_translation t
  ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
HAVING total_reviews >= 100
ORDER BY avg_review_score ASC, gross_revenue DESC
LIMIT 20;


-- 16. Delivery performance summary
SELECT
  COUNT(*) AS delivered_orders,
  ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 2) AS avg_delivery_days,
  ROUND(AVG(DATEDIFF(order_estimated_delivery_date, order_purchase_timestamp)), 2) AS avg_estimated_delivery_days,
  SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) AS late_orders,
  ROUND(
    SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS late_delivery_rate_pct
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;


-- 17. Late delivery impact on review score
SELECT
  CASE
    WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'late'
    ELSE 'on_time_or_early'
  END AS delivery_group,
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM orders o
JOIN order_reviews r
  ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY
  CASE
    WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'late'
    ELSE 'on_time_or_early'
  END;


-- 18. States with highest late delivery rate
SELECT
  c.customer_state,
  COUNT(DISTINCT o.order_id) AS delivered_orders,
  SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END) AS late_orders,
  ROUND(
    SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT o.order_id),
    2
  ) AS late_delivery_rate_pct,
  ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
LEFT JOIN order_reviews r
  ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
HAVING delivered_orders >= 100
ORDER BY late_delivery_rate_pct DESC;


-- 19. Freight burden by customer state
SELECT
  c.customer_state,
  ROUND(SUM(oi.price), 2) AS product_revenue,
  ROUND(SUM(oi.freight_value), 2) AS freight_revenue,
  ROUND(SUM(oi.freight_value) * 100.0 / NULLIF(SUM(oi.price + oi.freight_value), 0), 2) AS freight_pct_of_total,
  ROUND(AVG(oi.freight_value), 2) AS avg_freight_value
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
JOIN order_items oi
  ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY freight_pct_of_total DESC;


-- 20. Business opportunity: high revenue but weak review categories
SELECT
  COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
  COUNT(DISTINCT oi.order_id) AS total_orders,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS gross_revenue,
  ROUND(AVG(r.review_score), 2) AS avg_review_score,
  ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 2) AS avg_delivery_days
FROM order_items oi
JOIN orders o
  ON oi.order_id = o.order_id
JOIN products p
  ON oi.product_id = p.product_id
LEFT JOIN product_category_translation t
  ON p.product_category_name = t.product_category_name
LEFT JOIN order_reviews r
  ON oi.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
HAVING total_orders >= 500
ORDER BY avg_review_score ASC, gross_revenue DESC