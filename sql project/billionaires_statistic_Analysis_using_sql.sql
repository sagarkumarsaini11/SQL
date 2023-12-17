create database Analysis;
use Analysis;
SELECT * FROM bsd;
-- Top 10 world richest person
select personName, finalWorth 
FROM bsd 
order by finalWorth 
desc limit 10;
-- avg age of person
select avg(age) FROM bsd;

-- category wise Totalbillionaires
select category,count(*) as  Totalbillionaires
from bsd 
group by category 
order by Totalbillionaires desc;

-- rename table billionaires_statistics_dataset to bsd;
select * from bsd;

-- Top 10 billionaires and company name 
select personName,source from bsd
order by finalWorth desc limit 10;
--
select personName,source,country from bsd
order by finalWorth desc limit 10;

-- how many billionaires from country
select country,count(*) as cnt from bsd
group by country order by cnt desc;

select * from bsd;

-- Avrage of Finalworth group gender
select gender, avg(finalWorth) as avg_worth 
from bsd
group by gender;

-- youngest billionaire
select personName,age,source
from bsd
where age is not null
order by age asc limit 1;

-- country wise total finalworth
select country, sum(finalWorth) as total_worth
from bsd
group by country
order by total_worth desc;

--  count of source 
select source, count(*) as countofbillionaires from bsd
group by source
order by countofbillionaires
desc;

-- how many male and female billionaires 
select gender, count(*) as countofbillionaires
from bsd
group by gender
order by countofbillionaires desc;

select * from bsd;
-- category and source wise countofbillionaires
select category, source, count(*) as countofbillionaires
from bsd
group by category, source
order by countofbillionaires
desc;

--  category and country wise countofbillionaires
select category, country ,count(*) as countofbillionaires 
from bsd
group by category,country
order by countofbillionaires
desc;

-- status wise countofbillionaires
select status, count(*) as countofbillionaires
from bsd
group by status
order by countofbillionaires desc;
