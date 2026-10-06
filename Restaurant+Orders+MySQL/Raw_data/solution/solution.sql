-- Objective 1
-- Explore the items table
-- View the menu_items table and write a query to find the number of items on the menu
select * from menu_items;
select count(*) from menu_items;

-- What are the least and most expensive items on the menu?
select * from menu_items
order by price
limit 1;
select * from menu_items
order by price desc
limit 1;

-- How many Italian dishes are on the menu?
select count(*) from menu_items
where category = 'Italian';

-- What are the least and most expensive Italian dishes on the menu?
select item_name from menu_items
where category = 'Italian'
order by price
limit 1;
select item_name from menu_items
where category = 'Italian'
order by price desc
limit 1;

-- How many dishes are in each category?
select  category,count(item_name)from menu_items
group by category;
-- What is the average dish price within each category?
select category,avg(price) from menu_items
group by category;


-- Objective 2
-- Explore the orders table
select * from order_details;
-- View the order_details table. What is the date range of the table?
select max(order_date) as a ,min(order_date)as b from order_details;

-- How many orders were made within this date range? 
select count(distinct order_id) from order_details;

-- How many items were ordered within this date range?
select count(item_id) from order_details;

-- Which orders had the most number of items?
select order_id, count(item_id) as num_items from order_details
group by order_id
order by num_items desc
limit 1;

-- How many orders had more than 12 items?
with cte as (
            select order_id, count(item_id) as num_items from order_details
group by order_id
order by num_items desc
)
select count(order_id)
from cte 
where num_items >12;
-- Objective 3
-- Analyze customer behavior
-- Combine the menu_items and order_details tables into a single table
select * from menu_items mi right join order_details od
on mi.menu_item_id = od.item_id;

-- What were the least and most ordered items? What categories were they in?
with cte as (select mi.item_name,mi.category,count(od.order_details_id) as num_purchases
from menu_items mi right join order_details od
on mi.menu_item_id = od.item_id
group by mi.item_name,mi.category)
select item_name,category,num_purchases ,'Most Ordered' AS label
from cte 
where num_purchases = (select max(num_purchases) from cte)
union
select item_name,category,num_purchases ,'Least Ordered' AS label
from cte 
where num_purchases = (select min(num_purchases) from cte);

-- What were the top 5 orders that spent the most money?
select od.order_id,sum(price) as 'Total_Spent'
from order_details od join menu_items mi
on mi.menu_item_id = od.item_id
group by od.order_id
order by Total_Spent desc
limit 5;

-- View the details of the highest spend order. Which specific items were purchased?
SELECT od.order_id,mi.item_name,mi.category,mi.price
FROM order_details od
JOIN menu_items mi ON od.item_id = mi.menu_item_id
WHERE od.order_id = 440;

-- How much was the most expensive order in the dataset?
SELECT od.order_id,sum(mi.price)
FROM order_details od
JOIN menu_items mi ON od.item_id = mi.menu_item_id
group by 1
order by sum(mi.price) desc
limit 1;