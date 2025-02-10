
--1. Count the number of Movies vs TV Shows
select 
	count(type),type
from 
	netflix
group by
	type;

--2. Find the most common rating for movies and TV shows

with t1
as
(
select  type,rating,count(*) as count_of_rating,
Rank() Over(partition by type order by count(*) DESC) as new_rank
from netflix
where rating is not null and type is not null
group by type,rating
--order by type,count(*) desc
)

select type,rating,count_of_rating,new_rank
	from t1
	where new_rank=1

--3. List all movies released in a specific year (e.g., 2020)

select title,type
from netflix
where release_year=2020 and type='Movie';

--4. Find the top 5 countries with the most content on Netflix

with t1 as
(
SELECT 
    value AS NEW_COUNTRY
FROM 
    NETFLIX
CROSS APPLY 
    STRING_SPLIT(COUNTRY, ',')
)
select 
		TOP 5 NEW_COUNTRY,count(*)
from 
	t1
group by NEW_COUNTRY
order by count(*) DESC

--5. Identify the longest movie

select title, max(duration) as longest_movie
from netflix
where type='movie' 
group by title
having  max(duration)='99 min'
order by longest_movie DESC

--6. Find content added in the last 5 years

with t1
as
(
SELECT 
    title,
    FORMAT(TRY_CAST(date_added AS DATE), 'yyyy') AS yearu
FROM 
    netflix
)
select title,yearu 
from
	t1
	where 
	yearu >2020 and yearu<2025


--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select * from
netflix
where director like '%Rajiv Chilaka%'


--8. List all TV shows with more than 5 seasons
select  * from netflix

WITH NetflixWithSessions AS (
    SELECT 
        *,
        TRY_CAST(SUBSTRING(duration, 1, CHARINDEX(' ', duration) - 1) AS INT) AS sessions
    FROM 
        netflix
    WHERE 
        type = 'TV Show'
)
SELECT 
    *
FROM 
    NetflixWithSessions
WHERE 
    sessions > 5;



--9. Count the number of content items in each genre
select  * from netflix;
with t1 
as 
(
select 
value as genre
from netflix
cross apply
string_split(listed_in,',')
)

select genre,count(*) as total_count
from t1
group by genre
order by count(*) DESC


--10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!
select  * from Netflix;


SELECT 
    FORMAT(TRY_CAST(date_added AS DATE), 'yyyy') AS year,
    COUNT(*) AS total_content,
    COUNT(*) * 1.0 / (SELECT COUNT(*) FROM netflix WHERE country = 'India') * 100 AS avg_content_per_year
FROM 
    netflix
WHERE 
    country = 'India'
    --AND TRY_CAST(date_added AS DATE) IS NOT NULL -- Ensure valid dates
GROUP BY 
    FORMAT(TRY_CAST(date_added AS DATE), 'yyyy')
ORDER BY 
    year;


--11. List all movies that are documentaries

select  * from netflix
where
listed_in like '%documentaries%'


--12. Find all content without a director

select  * from netflix
where director is null;

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select  * from netflix;
select count(*) from
netflix
where casts like '%salman khan%' and release_year>2014
--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

WITH
t1
AS
(
SELECT  title,value AS actors
FROM 
	netflix
	CROSS APPLY
	string_split(casts,',')
WHERE country='India'
)

select  top 10 count(*),actors
from t1
group by actors
order by count(*) DESC



--15.
--Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.

--SELECT *
--from netflix
--where description like '%kill%' or description like '%voilence%'


--SELECT  VALUE as genre
--from netflix
--CROSS APPLY
--STRING_SPLIT(listed_in,',')

with t1
as
(
select title,
value as genre,
CASE
	WHEN
		description like '%kill%' or description like '%voilence%'
	THEN 
		'Bad'
		ELSE
		'Good'
END  as label
from netflix
CROSS APPLY
STRING_SPLIT(listed_in,',')
where title is not null
)

select genre,count(genre) as repetition,label
from t1
group by genre,label;


----Group by label
with t1
as
(
select 
CASE
	WHEN
		description like '%kill%' or description like '%voilence%'
	THEN 
		'Bad_content'
		ELSE
		'Good_content'
END  as label
from netflix

)

select label, count(*)
from t1
group by label;
