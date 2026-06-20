
-- which review score is related to high sales
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

--how delivery affects reviews and customer satisfaction

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


