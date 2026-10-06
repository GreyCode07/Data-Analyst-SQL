-- Objective 1
-- Track changes in name popularity
-- Find the overall most popular girl and boy names and show how they have changed in popularity rankings over the years
select name,sum(births) as num_babies
from names
where Gender ='F'
group by name
order by num_babies desc
limit 1; -- Jessica
select name,sum(births) as num_babies
from names
where Gender ='M'
group by name
order by num_babies desc
limit 1; -- Michael

select * from
(with girl_names as (
select year,name,sum(births) as num_babies
from names
where gender ='F'
group by year,name)
select year,name,row_number() over(partition by year order by num_babies desc) as Popularity
from girl_names) as popular_girl_names
where name = 'Jessica';

select * from
(with boys_names as (
select year,name,sum(births) as num_babies
from names
where gender ='M'
group by year,name)
select year,name,row_number() over(partition by year order by num_babies desc) as Popularity
from boys_names) as popular_boys_names
where name = 'Michael';

-- Find the names with the biggest jumps in popularity from the first year of the data set to the last year

with names_1980 as (
with all_names as (
select year,name,sum(births) as num_babies
from names
group by year,name)
select year,name,row_number() over(partition by year order by num_babies desc) as Popularity
from all_names 
where year = '1980'),

names_2009 as (
with all_names as (
select year,name,sum(births) as num_babies
from names
group by year,name)
select year,name,row_number() over(partition by year order by num_babies desc) as Popularity
from all_names
where year = '2009')
select t1.year,t1.name,t1.popularity,t2.year,t2.name,t2.popularity,
cast(t2.popularity as signed)- cast(t1.popularity as signed) as diff
from names_1980 t1 inner join names_2009 t2 
on t1.name = t2.name
order by diff;


-- Objective 2
-- Compare popularity across decades
-- For each year, return the 3 most popular girl names and 3 most popular boy names
 
select * from
(WITH babies_by_year AS (
  SELECT year, gender, name, SUM(births) AS num_babies
  FROM names
  GROUP BY year, gender, name
)
SELECT year, gender, name, num_babies,row_number() over (partition by year,gender order by num_babies desc) as popularity
FROM babies_by_year) as top_three
where popularity<4;



-- For each decade, return the 3 most popular girl names and 3 most popular boy names

select * from
(WITH babies_by_decade AS (
  SELECT (case when year between 1980 and 1990 then 'Eighties'
			   when year between 1990 and 2000 then 'Nineties'
               when year between 2000 and 2009 then 'Two_thousands'
               else 'None' end) as Decade,
  gender, name, SUM(births) AS num_babies
  FROM names
  GROUP BY Decade, gender, name
)
SELECT Decade, gender, name, num_babies,row_number() over (partition by Decade,gender order by num_babies desc) as popularity
FROM babies_by_decade) as top_three
where popularity<4;

-- Objective 3
-- Compare popularity across regions
-- Return the number of babies born in each of the six regions (NOTE: The state of MI should be in the Midwest region)
select * from regions;
select distinct region from regions;

WITH clean_regions AS (
    SELECT state,CASE 
    WHEN region = 'New England' THEN 'New_England'
    ELSE region 
END AS clean_region FROM regions
union 
select 'MI' AS state, 'Midwest' as region
)
select clean_region,sum(Births) as num_babies
from names n left join clean_regions cr
on n.state =cr.state 
group by clean_region
order by 1 asc;

-- Return the 3 most popular girl names and 3 most popular boy names within each region

SELECT * FROM
(with babies_by_region as (
WITH clean_regions AS (
SELECT state,CASE WHEN region = 'New England' THEN 'New_England'
ELSE region END AS clean_region FROM regions
UNION
SELECT 'MI' AS state, 'Midwest' AS clean_region
)
SELECT cr.clean_region,n.gender,n.name,SUM(n.births) AS num_babies
FROM names n LEFT JOIN clean_regions cr ON n.state = cr.state
GROUP BY cr.clean_region,n.gender,n.name)

select clean_region,Gender,name,row_number() over (partition by clean_region, gender order by num_babies desc) as popularity
from babies_by_region) AS REGION_POPULARITY
WHERE POPULARITY < 4;

-- Objective 4
-- Explore unique names in the dataset
-- Find the 10 most popular androgynous names (names given to both females and males)
SELECT NAME, COUNT(DISTINCT GENDER) AS num_genders,sum(births) as num_babies
FROM NAMES
group by name
having num_genders = 2
order by num_babies desc
limit 10;

-- Find the length of the shortest and longest names, and identify the most popular short names (those with the fewest characters) and long names (those with the most characters)

select name,length(name) as name_length
from names
group by name
order by name_length;

select name,length(name) as name_length
from names
group by name
order by name_length desc;

with short_long_names as (select *
from names 
where length(name) in (2,15))
select name,sum(births) as num_babies
from short_long_names
group by name
order by num_babies desc;


-- The founder of Maven Analytics is named Chris. Find the state with the highest percent of babies named "Chris"

select state,num_chris/num_babies *100 as pct_chris
from
(with count_chris as (select state, sum(births) as num_chris
from names
where name = 'Chris'
group by state),

count_all as (select state, sum(births) as num_babies
from names
group by state)
select cc.state,cc.num_chris,ca.num_babies from count_chris cc inner join count_all ca
on cc.state =ca.state) as state_chris_all
order by pct_chris desc
limit 1;
