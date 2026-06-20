use olist_db;
ALTER TABLE customers
  MODIFY customer_id VARCHAR(32) NOT NULL,
  MODIFY customer_unique_id VARCHAR(32),
  ADD PRIMARY KEY (customer_id);

ALTER TABLE orders
  MODIFY order_id VARCHAR(32) NOT NULL,
  MODIFY customer_id VARCHAR(32) NOT NULL,
  ADD PRIMARY KEY (order_id),
  ADD CONSTRAINT fk_orders_customers
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

ALTER TABLE products
  MODIFY product_id VARCHAR(32) NOT NULL,
  MODIFY product_category_name VARCHAR(100),
  ADD PRIMARY KEY (product_id);

ALTER TABLE sellers
  MODIFY seller_id VARCHAR(32) NOT NULL,
  ADD PRIMARY KEY (seller_id);

ALTER TABLE order_items
  MODIFY order_id VARCHAR(32) NOT NULL,
  MODIFY order_item_id INT NOT NULL,
  MODIFY product_id VARCHAR(32) NOT NULL,
  MODIFY seller_id VARCHAR(32) NOT NULL,
  ADD PRIMARY KEY (order_id, order_item_id),
  ADD CONSTRAINT fk_order_items_orders
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
  ADD CONSTRAINT fk_order_items_products
    FOREIGN KEY (product_id) REFERENCES products(product_id),
  ADD CONSTRAINT fk_order_items_sellers
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id);

ALTER TABLE order_payments
  MODIFY order_id VARCHAR(32) NOT NULL,
  MODIFY payment_sequential INT NOT NULL,
  ADD PRIMARY KEY (order_id, payment_sequential),
  ADD CONSTRAINT fk_payments_orders
    FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE order_reviews
  MODIFY review_id VARCHAR(32) NOT NULL,
  MODIFY order_id VARCHAR(32) NOT NULL,
  ADD PRIMARY KEY (review_id, order_id),
  ADD CONSTRAINT fk_reviews_orders
    FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE product_category_translation
  MODIFY product_category_name VARCHAR(100) NOT NULL,
  ADD PRIMARY KEY (product_category_name);

ALTER TABLE products
  ADD CONSTRAINT fk_products_category_translation
    FOREIGN KEY (product_category_name)
    REFERENCES product_category_translation(product_category_name);
    