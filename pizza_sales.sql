CREATE DATABASE PIZZA_SALES;
USE PIZZA_SALES;

CREATE TABLE orders(
 order_id int not null,
 order_date date not null,
 order_time time not null,
 primary key(order_id));
 
 CREATE TABLE order_details(
 order_details_id int not null,
 order_id int not null,
 pizza_id text not null,
 quantity int not null,
 primary key(order_details_id));
 
 
-- Q1 Retrieve the total number of order placed
select count(order_id) from orders;

-- Q2 T he total revenue generated from pizza sales.
select round(sum(order_details.quantity * pizzas.price),2)
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id;

-- Q3 Highest priced pizza 
select pizza_types.name, pizzas.price 
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1;

-- Q4 Identify the Most Common Pizza Size Ordered
select pizzas.size , count(order_details.order_details_id) as total_count
from pizzas join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size order by total_count desc limit 1;

-- Q5 The top 5 most ordered pizza types along with their quantities.
select pizza_types.name, sum(quantity) as count_
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id join order_details
on pizzas.pizza_id = order_details.pizza_id 
group by pizza_types.name
order by count_ desc limit 5;

-- Q6 The total quantity of each pizza category ordered.
select pizza_types.category, sum(order_details.quantity)
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.category;

-- Q7 Determine the distribution of the orders by hour of the day
select hour(order_time), count(order_id)
from orders
group by hour(order_time);

-- Q8 The category-wise distribution of pizzas.
select pizza_types.category  as cat_count, count(pizza_types.category)
from pizza_types 
group by cat_count;

-- Q9 Group the orders by date and calculate the avg no. of pizzas ordered per day
select round(avg(quantity),2) from
(select orders.order_date , sum(order_details.quantity) as quantity
from orders join order_details 
on orders.order_id = order_details.order_id 
group by orders.order_date) as order_quantity;

-- Q10 Determine the top 3 most ordered pizza based on revenue 
select pizza_types.name , sum(order_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id join order_details 
on pizzas.pizza_id = order_details.pizza_id 
group by pizza_types.name order by revenue desc limit 3;

-- Q11 Calculate the percentage contribution of each pizza type to total revenue
select pizza_types.category, round(sum(pizzas.price*order_details.quantity) /
(select round(sum(order_details.quantity * pizzas.price),2) as total_Sales
from order_details join pizzas on order_details.pizza_id = pizzas.pizza_id)*100,2) as revenue 
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id join order_details
on order_details.pizza_id = pizzas.pizza_id 
group by pizza_types.category order by revenue desc;

-- The cumulative revenue generated over time.
select order_date, sum(revenue) over(order by order_date) as cum_revenue
from
(select orders.order_date, round(sum(order_details.quantity * pizzas.price),0) as revenue 
from orders join order_details 
on orders.order_id = order_details.order_id join pizzas
on order_details.pizza_id = pizzas.pizza_id 
group by orders.order_date) as total_sales; 

-- Determine the top 3 Most ordered Pizaa based on Revenue for each pizza Category
select category, name, revenue,
rank() over(partition by category order by revenue desc ) as rn
from
(select pizza_types.category , pizza_types.name , sum(order_details.quantity*pizzas.price) as revenue 
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id join order_details
on pizzas.pizza_id = order_details.pizza_id 
group by pizza_types.category , pizza_types.name) as final;










 
 













