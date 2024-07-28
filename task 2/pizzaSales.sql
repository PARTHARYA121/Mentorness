USE sakila;
USE sakila;

SELECT COUNT(DISTINCT order_id) AS total_orders FROM `orders.csv_orders.csv`;
USE sakila;

SELECT SUM(od.quantity * p.price) AS total_revenue
FROM `order_details.csv_order_details.csv` od
JOIN `pizzas.csv_pizzas.csv` p ON od.pizza_id = p.pizza_id;

USE sakila;

SELECT pizza_id, price
FROM `pizzas.csv_pizzas.csv`
ORDER BY price DESC
LIMIT 1;

USE sakila;

SELECT size, COUNT(*) AS count
FROM `pizzas.csv_pizzas.csv` p
JOIN `order_details.csv_order_details.csv` od ON p.pizza_id = od.pizza_id
GROUP BY size
ORDER BY count DESC
LIMIT 1;
USE sakila;

SELECT p.pizza_id, SUM(od.quantity) AS total_quantity
FROM `order_details.csv_order_details.csv` od
JOIN `pizzas.csv_pizzas.csv` p ON od.pizza_id = p.pizza_id
GROUP BY p.pizza_id
ORDER BY total_quantity DESC
LIMIT 5;
USE sakila;

SELECT pt.category, SUM(od.quantity) AS total_quantity
FROM `order_details.csv_order_details.csv` od
JOIN `pizzas.csv_pizzas.csv` p ON od.pizza_id = p.pizza_id
JOIN `pizza_types.csv_pizza_types.csv` pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;
USE sakila;

SELECT HOUR(time) AS hour, COUNT(*) AS order_count
FROM `orders.csv_orders.csv`
GROUP BY HOUR(time);

USE sakila;

SELECT pt.category, COUNT(*) AS pizza_count
FROM `pizzas.csv_pizzas.csv` p
JOIN `pizza_types.csv_pizza_types.csv` pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;

USE sakila;

SELECT AVG(daily_count) AS avg_pizzas_per_day
FROM (
    SELECT date, COUNT(*) AS daily_count
    FROM `orders.csv_orders.csv`
    GROUP BY date
) AS daily_counts;

USE sakila;

SELECT p.pizza_id, SUM(od.quantity * p.price) AS total_revenue
FROM `order_details.csv_order_details.csv` od
JOIN `pizzas.csv_pizzas.csv` p ON od.pizza_id = p.pizza_id
GROUP BY p.pizza_id
ORDER BY total_revenue DESC
LIMIT 3;

USE sakila;

SELECT p.pizza_id, (SUM(od.quantity * p.price) / total_revenue.total) * 100 AS percentage_contribution
FROM `order_details.csv_order_details.csv` od
JOIN `pizzas.csv_pizzas.csv` p ON od.pizza_id = p.pizza_id
JOIN (SELECT SUM(od.quantity * p.price) AS total
      FROM `order_details.csv_order_details.csv` od
      JOIN `pizzas.csv_pizzas.csv` p ON od.pizza_id = p.pizza_id) AS total_revenue
GROUP BY p.pizza_id;

USE sakila;

SELECT date, SUM(daily_revenue) OVER (ORDER BY date) AS cumulative_revenue
FROM (
    SELECT o.date, SUM(od.quantity * p.price) AS daily_revenue
    FROM `order_details.csv_order_details.csv` od
    JOIN `pizzas.csv_pizzas.csv` p ON od.pizza_id = p.pizza_id
    JOIN `orders.csv_orders.csv` o ON od.order_id = o.order_id
    GROUP BY o.date
) AS daily_revenues;

USE sakila;

WITH pizza_revenue AS (
    SELECT p.pizza_id, pt.category, SUM(od.quantity * p.price) AS total_revenue
    FROM `order_details.csv_order_details.csv` od
    JOIN `pizzas.csv_pizzas.csv` p ON od.pizza_id = p.pizza_id
    JOIN `pizza_types.csv_pizza_types.csv` pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY p.pizza_id, pt.category
)
SELECT category, pizza_id, total_revenue
FROM (
    SELECT category, pizza_id, total_revenue,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY total_revenue DESC) AS rank
    FROM pizza_revenue
) ranked_pizzas
WHERE rank <= 3;



