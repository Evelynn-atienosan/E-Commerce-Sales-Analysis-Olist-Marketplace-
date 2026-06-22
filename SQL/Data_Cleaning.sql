UPDATE products
SET product_category_name = NULL
WHERE product_category_name = '';

UPDATE product_category_translation
SET product_category_name = NULL
WHERE product_category_name = '';

UPDATE product_category_translation
SET product_category_name_english = NULL
WHERE product_category_name_english = '';

DELETE FROM order_items
WHERE price < 0
   OR freight_value < 0;

DELETE FROM order_payments
WHERE payment_value < 0
   OR payment_installments < 0;

DELETE FROM order_reviews
WHERE review_score < 1
   OR review_score > 5;

UPDATE orders
SET order_delivered_customer_date = NULL
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_purchase_timestamp;

INSERT INTO product_category_translation
  (product_category_name, product_category_name_english)
VALUES
  ('pc_gamer', 'pc_gamer'),
  ('portateis_cozinha_e_preparadores_de_alimentos', 'portable_kitchen_and_food_preparers');

SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL SELECT 'product_category_translation', COUNT(*) FROM product_category_translation;