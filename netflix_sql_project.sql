drop table if exists netflix;
create table netflix(
show_id varchar(7),
type varchar(10),
title varchar(150),
director varchar(210),
casts varchar(1000),
country varchar(150),
date_added varchar(50),
release_year int,
rating varchar(10),
duration varchar(15),
listed_in varchar(100),
description varchar(250)
);
select * from netflix;

select count(*) from netflix;


-- 15 Business Problems & Solutions

1. Count the number of Movies vs TV Shows
2. Find the most common rating for movies and TV shows
3. List all movies released in a specific year (e.g., 2020)
4. Find the top 5 countries with the most content on Netflix
5. Identify the longest movie
6. Find content added in the last 5 years
7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
8. List all TV shows with more than 5 seasons
9. Count the number of content items in each genre
10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!
11. List all movies that are documentaries
12. Find all content without a director
13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.


-- 15 Business Problems & Solutions

--1. Count the number of Movies vs TV Shows

	select type, count(*) as total_count
	from netflix
	group by 1;


--2. Find the most common rating for movies and TV shows

	select * from netflix;
	select type, rating from netflix;
	with t1 as(
	select type, rating, count(rating) from netflix 
	where type='Movie'
	group by 1,2
	order by 3 desc
	limit 1),
	t2 as(
	select type, rating, count(rating) from netflix 
	where type='TV Show'
	group by 1,2
	order by 3 desc
	limit 1
	)
	select * from t1 union all
	select * from t2;


--3. List all movies released in a specific year (e.g., 2020)

	select * from netflix;
	select title , release_year from netflix
	where type='Movie' and release_year=2020;
	

--4. Find the top 5 countries with the most content on Netflix

	select * from netflix;
	select unnest(string_to_array(country,',')) as nw_country, 
	count(show_id) as countt from netflix
	group by 1
	order by 2 desc
	limit 5;




--5. Identify the longest movie

	select * from netflix
	where type='Movie' and duration=(select max(duration) from netflix);






--6. Find content added in the last 5 years

	select * from netflix
	where to_date(date_added,'month DD, YYYY')>= current_date-interval '5 years';
	




--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
	
	select * from netflix 
	where director like '%Rajiv Chilaka%';




--8. List all TV shows with more than 5 seasons

	select * from netflix where type = 'TV Show' and duration>'5 Seasons'



9. Count the number of content items in each genre

	select unnest(string_to_array(listed_in, ',')) as genre, count(show_id) as countt 
	from netflix
	group by 1
	order by 2 desc;



--10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!

	select * from netflix;
	select extract(year from to_date(date_added, 'month dd, yyyy')) as Yearr, count(*),
	round((count(show_id)::numeric/(select count(*) from netflix where country='India')::numeric)*100, 2) as average_content from netflix
	where country='India'
	group by 1
	order by 2 desc,3 desc;


--11. List all movies that are documentaries

	select * from netflix where listed_in ilike '%documentaries%';


--12. Find all content without a director

	select * from netflix where director is null;


--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

	select * from netflix where casts ilike '%salman khan%' and
	release_year > extract(year from current_date)-10;


--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

	select unnest(string_to_array(casts,',')) as actors, count(*) as movie_count from netflix
	where country ilike '%india%'
	group by 1
	order by 2 desc
	limit 10;


--15.
--Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.

	select category, count(*) 
	from
	(select *,
	case when description ilike '%kill%' or
			  description ilike '%violence%' then 'Bad content'
		else 'Good content'
	end as category
	from netflix) t
	group by 1
	order by 2 desc;
	



