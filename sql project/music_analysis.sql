select * from  album;
-- Who is the senior most employee based on job title?
select first_name,last_name,title from employee
order by levels desc limit 1;

-- Which countries have the most Invoices?
select billing_country,count(*) as count_invoice
from invoice
group by billing_country
order by count_invoice desc limit 1;

-- What are top 3 values of total invoice?
select total
from invoice
order by total desc limit 3;

/* Which city has the best customers? We would like to throw a promotional Music 
Festival in the city we made the most money. Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice 
totals
*/
select billing_city,sum(total) as invoice_totals
from invoice
group by billing_city
order by invoice_totals desc limit 1;

/* Who is the best customer? The customer who has spent the most money will be 
declared the best customer. Write a query that returns the person who has spent the 
most money
*/
SELECT
customer.customer_id,
MAX(first_name) AS first_name, 
MAX(last_name) AS last_name,
SUM(total) AS total_spent
FROM customer join invoice
on customer.customer_id=invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total_spent DESC
LIMIT 1;

/*Write query to return the email, first name, last name, & Genre of all Rock Music 
listeners. Return your list ordered alphabetically by email starting with A
*/
select distinct
email,first_name,last_name,genre.name as name
from customer join invoice
on invoice.customer_id=customer.customer_id
join invoice_line
on invoice_line.invoice_id=invoice.invoice_id
join track
on track.track_id=invoice_line.track_id
join genre
on genre.genre_id=track.genre_id
where genre.name like "Rock"
order by email;

/*Let's invite the artists who have written the most rock music in our dataset. Write a 
query that returns the Artist name and total track count of the top 10 rock bands
*/
select artist.artist_id,
max(artist.name) as artist_name
,count(track.track_id) as numer_of_songs
from track join album
on album.album_id=track.album_id
join artist
on artist.artist_id=album.artist_id
join genre
on genre.genre_id=track.genre_id
where genre.name like "Rock"
group by artist.artist_id
order by numer_of_songs desc limit 10;

/*Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the 
longest songs listed first
*/
select name,milliseconds from track
where milliseconds>(select avg(milliseconds) from track)
order by milliseconds desc;
