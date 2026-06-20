
-- DUPLICATE PRIMARY KEY CHECKS

SELECT customer_id, COUNT(*) AS count_rows
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT order_id, COUNT(*) AS count_rows
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT product_id, COUNT(*) AS count_rows
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT seller_id, COUNT(*) AS count_rows
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;

SELECT order_id, order_item_id, COUNT(*) AS count_rows
FROM order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

SELECT order_id, payment_sequential, COUNT(*) AS count_rows
FROM order_payments
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1;

SELECT review_id, order_id, COUNT(*) AS count_rows
FROM order_reviews
GROUP BY review_id, order_id
HAVING COUNT(*) > 1;

--FOREIGN KEY PROBLEM CHECKS

SELECT o.order_id, o.customer_id
FROM orders o
LEFT JOIN customers c
  ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT oi.order_id
FROM order_items oi
LEFT JOIN orders o
  ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT oi.order_id, oi.product_id
FROM order_items oi
LEFT JOIN products p
  ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT oi.order_id, oi.seller_id
FROM order_items oi
LEFT JOIN sellers s
  ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

SELECT op.order_id
FROM order_payments op
LEFT JOIN orders o
  ON op.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT r.review_id, r.order_id
FROM order_reviews r
LEFT JOIN orders o
  ON r.order_id = o.order_id
WHERE o.order_id IS NULL;


-- NULL CHECKS FOR IMPORTANT COLUMNS

SELECT 'customers.customer_id' AS column_name, COUNT(*) AS null_count
FROM customers WHERE customer_id IS NULL
UNION ALL
SELECT 'orders.order_id', COUNT(*) FROM orders WHERE order_id IS NULL
UNION ALL
SELECT 'orders.customer_id', COUNT(*) FROM orders WHERE customer_id IS NULL
UNION ALL
SELECT 'order_items.order_id', COUNT(*) FROM order_items WHERE order_id IS NULL
UNION ALL
SELECT 'order_items.product_id', COUNT(*) FROM order_items WHERE product_id IS NULL
UNION ALL
SELECT 'order_items.seller_id', COUNT(*) FROM order_items WHERE seller_id IS NULL
UNION ALL
SELECT 'products.product_id', COUNT(*) FROM products WHERE product_id IS NULL
UNION ALL
SELECT 'sellers.seller_id', COUNT(*) FROM sellers WHERE seller_id IS NULL
UNION ALL
SELECT 'order_payments.order_id', COUNT(*) FROM order_payments WHERE order_id IS NULL
UNION ALL
SELECT 'order_reviews.order_id', COUNT(*) FROM order_reviews WHERE order_id IS NULL;