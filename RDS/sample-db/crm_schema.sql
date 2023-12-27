-- Create the CRM database
CREATE DATABASE crm;

-- Connect to the CRM database
\c crm;

-- Create the customers table
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100),
  phone VARCHAR(20),
  address VARCHAR(255)
);

-- Create the products table
CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  product_name VARCHAR(100),
  price NUMERIC(10, 2)
);

-- Create the orders table
CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  customer_id INTEGER REFERENCES customers(customer_id),
  order_date DATE,
  total_amount NUMERIC(12, 2)
);

-- Create the order_items table
CREATE TABLE order_items (
  order_item_id SERIAL PRIMARY KEY,
  order_id INTEGER REFERENCES orders(order_id),
  product_id INTEGER REFERENCES products(product_id),
  quantity INTEGER,
  subtotal NUMERIC(12, 2)
);

-- Create the employees table
CREATE TABLE employees (
  employee_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100),
  phone VARCHAR(20),
  hire_date DATE
);

-- Create the employee_roles table
CREATE TABLE employee_roles (
  employee_id INTEGER REFERENCES employees(employee_id),
  role_name VARCHAR(50),
  PRIMARY KEY (employee_id, role_name)
);

