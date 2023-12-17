
--  What is the total amount each customer spent at the restaurant?
select s.customer_id, sum(m.price) as 'total spend'
from sales s join menu m
on s.product_id=m.product_id
group by s.customer_id;

--  How many days has each customer visited the restaurant?
select distinct customer_id,count(*)
 from sales
 group by customer_id;
 
 --  What was the first item from the menu purchased by each customer?
with my_tab as 
	(select 
		s.customer_id,
		s.order_date,
		m.product_name,
		row_number() over(partition by s.customer_id order by s.order_date) as 'rank'
	from sales s join menu m
	on s.product_id=m.product_id)
    select customer_id,product_name from my_tab
    where `rank` = 1;
    
--  What is the most purchased item on the menu and how many times was it purchased by all customers?
select s.customer_id, m.product_name,count(*) as 'most purchased item'
from sales s join menu m
on s.product_id=m.product_id
where m.product_name = 'ramen'
group by s.customer_id, m.product_name order by s.customer_id ;

-- 5. Which item was the most popular for each customer?
select 
	customer_id,
	product_name,
	`most popular item for customer`
from
	(select s.customer_id, m.product_name,count(*) as 'most popular item for customer',
	rank() over(partition by s.customer_id order by count(*) desc) as 'rank'
	from sales s join menu m
	on s.product_id=m.product_id
	group by s.customer_id, m.product_name) t
    where t.rank=1;
    
--  Which item was purchased first by the customer after they became a member?
with CTE as (
	select 
		s.customer_id,
		s.order_date,
		m.product_name,
		mb.join_date,
		rank() over(partition by s.customer_id order by s.order_date) as 'rank'
	 from sales s
	join members mb 
	on mb.customer_id=s.customer_id join menu m
	on s.product_id=m.product_id
	where s.order_date>=mb.join_date
)
select customer_id,product_name from CTE
where `rank`=1;

--  Which item was purchased just before the customer became a member?
with CTE as (
	select 
		s.customer_id,
		s.order_date,
		m.product_name,
		mb.join_date,
		rank() over(partition by s.customer_id order by s.order_date) as 'rank'
	 from sales s
	join members mb 
	on mb.customer_id=s.customer_id join menu m
	on s.product_id=m.product_id
	where s.order_date<mb.join_date
)
select customer_id,product_name from CTE
where `rank`=1;

--  What is the total items and amount spent for each member before they became a member?
select 
		s.customer_id,
        count(m.product_name) as 'total item',
		sum(m.price) as 'total spent'
	from sales s
	join members mb 
	on mb.customer_id=s.customer_id join menu m
	on s.product_id=m.product_id
	where s.order_date<mb.join_date
	group by s.customer_id
    order by s.customer_id;

--  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
select 
	customer_id,
	sum(case
	when product_name='sushi' then price * 20
	else price * 10
	end) points
from menu m join sales s
on s.product_id=m.product_id
group by customer_id;

