-- *************************************************************
-- Assignment: 4
-- Written by: Tiyana Harden
-- Date      : 2026-09-22
-- *************************************************************

use my_guitar_shop;

-- *******************************************
-- Exercise 1
-- *******************************************

SELECT DISTINCT category_name
FROM categories
WHERE category_id IN
(
	SELECT category_id
	FROM products
)
ORDER BY category_name;
 
-- *******************************************
-- Exercise 2
-- *******************************************

SELECT product_name, list_price
FROM products
WHERE list_price >
(
	SELECT AVG(list_price)
	FROM products
)
ORDER BY list_price DESC;
 
-- *******************************************
-- Exercise 3
-- *******************************************

SELECT category_name
FROM categories c
WHERE NOT EXISTS
(
	SELECT 1
	FROM products p
	WHERE p.category_id = c.category_id
)
ORDER BY category_name;

-- *******************************************
-- Exercise 4
-- *******************************************

-- First SELECT statement
SELECT c.email_address,
	   o.order_id,
	   SUM((oi.item_price - oi.discount_amount) * oi.quantity) AS order_total
FROM customers c
JOIN orders o
	ON c.customer_id = o.customer_id
JOIN order_items oi
	ON o.order_id = oi.order_id
GROUP BY c.email_address, o.order_id;

-- Second SELECT statement (uses the first statement in the FROM clause)
SELECT order_summary.email_address,
	   MAX(order_summary.order_total) AS largest_order
FROM
(
	SELECT c.email_address,
		   o.order_id,
		   SUM((oi.item_price - oi.discount_amount) * oi.quantity) AS order_total
	FROM customers c
	JOIN orders o
		ON c.customer_id = o.customer_id
	JOIN order_items oi
		ON o.order_id = oi.order_id
	GROUP BY c.email_address, o.order_id
) AS order_summary
GROUP BY order_summary.email_address
ORDER BY largest_order DESC;

-- *******************************************
-- Exercise 5
-- *******************************************

SELECT product_name,
	   discount_percent
FROM products
WHERE discount_percent IN
(
	SELECT discount_percent
	FROM products
	GROUP BY discount_percent
	HAVING COUNT(*) = 1
)
ORDER BY product_name;

-- *******************************************
-- Exercise 6
-- *******************************************

SELECT c.email_address,
	   o.order_id,
	   o.order_date
FROM customers c
JOIN orders o
	ON c.customer_id = o.customer_id
WHERE o.order_date =
(
	SELECT MIN(o2.order_date)
	FROM orders o2
	WHERE o2.customer_id = o.customer_id
)
AND o.order_id =
(
	SELECT MIN(o3.order_id)
	FROM orders o3
	WHERE o3.customer_id = o.customer_id
	  AND o3.order_date = o.order_date
)
ORDER BY o.order_date, o.order_id;


