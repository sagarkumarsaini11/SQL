use music;
show tables;

--  Who is the senior most employee based on job title?
select 
	first_name 
from employee
order by levels
desc limit 1;

--  Which countries have the most Invoices?
select 
	billing_country,
	count(*) as count_invoice
from invoice
group by billing_country
order by count_invoice desc limit 1;

-- What are top 3 values of total invoice?
select
	billing_country,
    sum(total) as 'total invoice'
from invoice
group by billing_country
order by sum(total)
desc limit 3;

/* Which city has the best customers? We would like to throw a promotional Music 
Festival in the city we made the most money. Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice 
totals
*/
select 
	billing_city,
    sum(total) 'total invoice'
from invoice
group by billing_city
order by sum(total) desc
limit 1;

/* Who is the best customer? The customer who has spent the most money will be 
declared the best customer. Write a query that returns the person who has spent the 
most money
*/
select 
		c.customer_id,
		c.first_name,
		c.last_name,
		sum(inv.total)as 'total spent'
 from customer c join invoice inv
 on c.customer_id=inv.customer_id
 group by c.customer_id, c.first_name, c.last_name
order by sum(inv.total) desc
limit 1;

/*Write query to return the email, first name, last name, & Genre of all Rock Music 
listeners. Return your list ordered alphabetically by email starting with A
*/
select 
	distinct c.email,
    c.first_name,
    c.last_name,
    g.name as 'genre name'
from customer c join invoice inv
on c.customer_id=inv.customer_id
join invoice_line inv_l
on inv.invoice_id=inv_l.invoice_id
join track t
on t.track_id=inv_l.track_id
join genre g
on g.genre_id=t.genre_id
where g.name like 'Rock'
order by c.email;

/*Let's invite the artists who have written the most rock music in our dataset. Write a 
query that returns the Artist name and total track count of the top 10 rock bands
*/
select 
	art.name,
    count(t.track_id) as 'Top Rock Brand'
from artist art
join album al
on al.artist_id=art.artist_id
join track t
on t.album_id=al.album_id
join genre g 
on g.genre_id=t.genre_id
where g.name like "Rock"
group by art.name
order by count(t.track_id) desc
limit 10;

/*Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the 
longest songs listed first
*/
select 
	name,
	milliseconds
from track
where milliseconds>(select avg(milliseconds) from track)
order by milliseconds;
