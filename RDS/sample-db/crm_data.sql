-- Insert data into the customers table
INSERT INTO customers (first_name, last_name, email, phone, address)
SELECT 
  'Customer' || id,
  'LastName' || id,
  'customer' || id || '@example.com',
  '+1 555-1234-' || LPAD(id::TEXT, 4, '0'),
  'Address' || id
FROM generate_series(1, 100000) id;

-- Insert data into the products table
INSERT INTO products (product_name, price)
SELECT 
  'Product' || id,
  ROUND(RANDOM() * 1000::NUMERIC + 10, 2)
FROM generate_series(1, 100) id;

-- Insert data into the employees table
INSERT INTO employees (first_name, last_name, email, phone, hire_date)
SELECT 
  'Employee' || id,
  'LastName' || id,
  'employee' || id || '@example.com',
  '+1 555-5678-' || LPAD(id::TEXT, 4, '0'),
  CURRENT_DATE - INTERVAL '365' * id || ' days'
FROM generate_series(1, 50) id;

-- Insert data into the employee_roles table
INSERT INTO employee_roles (employee_id, role_name)
SELECT 
  id,
  CASE WHEN id % 2 = 0 THEN 'Manager' ELSE 'Salesperson' END
FROM generate_series(1, 50) id;

-- Insert data into the orders table
INSERT INTO orders (customer_id, order_date, total_amount)
SELECT 
  id,
  CURRENT_DATE - INTERVAL '30' * id || ' days',
  ROUND(RANDOM() * 1000::NUMERIC + 10, 2)
FROM generate_series(1, 50000) id;

-- Insert data into the order_items table
INSERT INTO order_items (order_id, product_id, quantity, subtotal)
SELECT 
  order_id,
  CEIL(RANDOM() * 100),
  CEIL(RANDOM() * 10),
  0
FROM generate_series(1, 100000) order_id;

-- Update subtotal in the order_items table based on product prices
UPDATE order_items 
SET subtotal = quantity * price
FROM (
  SELECT oi.order_item_id, p.price
  FROM order_items oi
  JOIN products p ON oi.product_id = p.product_id
) AS subquery
WHERE order_items.order_item_id = subquery.order_item_id;

