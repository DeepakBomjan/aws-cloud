-- Sample Report: Customer Orders
SELECT
  c.customer_id,
  c.first_name || ' ' || c.last_name AS customer_name,
  o.order_id,
  o.order_date,
  p.product_name,
  od.quantity,
  od.unit_price
FROM
  customers c
JOIN
  orders o ON c.customer_id = o.customer_id
JOIN
  order_details od ON o.order_id = od.order_id
JOIN
  products p ON od.product_id = p.product_id
ORDER BY
  c.customer_id, o.order_id, od.line_item_id;
