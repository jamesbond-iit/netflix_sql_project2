-- Netflix Data Analysis using SQL
-- Solutions of 15 Business Problems
 
-- Q1 COUNT THE NUMBER OF MOVIES VS TV SHOWS ?
      SELECT 
	   type,
	   COUNT(*) as total_content
	    FROM netflix
	   GROUP BY type

 -- Q2 FIND THE MOST COMMON RATING FOR THE MOVIES AND THE TV SHOWS ?

	SELECT
	  type,
	  rating
	  FROM 
	(SELECT  
	   type,
	   rating,
	   COUNT(*),
	   RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC ) as ranking
	  FROM netflix
	   GROUP BY 1,2
	  ) as t1
   WHERE 
     ranking = 1


-- Q3 LIST ALL MOVIES RELEASED IN THE YEAR (eg : 2020)?

    SELECT * FROM netflix
	  WHERE 
	      type = 'Movie'
		    AND 
			release_year = 2020

-- Q4 FIND THE TOP 5 COUNTRIES WITH THE MOST CONTENT ON NETFLIX ?

    SELECT 
	   UNNEST(STRING_TO_ARRAY (country, ',')) as new_country,
	   COUNT(show_id) as total_content
	   FROM netflix
	   GROUP BY 1
	    ORDER BY 2 DESC
		LIMIT 5
	
--Q5 Identify the longest movie

   SELECT * from netflix
       WHERE
	     type = 'Movie'
		 AND
		 duration = (SELECT MAX(duration) FROM netflix)
	  
	
--Q6 Find content added in the last 5 years

	 SELECT
	   * 
	 FROM netflix
	   WHERE 
	     TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL'5 years'
	 
--Q7 Find all the movies/TV shows by director 'Rajiv Chilaka'!

	 SELECT * FROM netflix
	   WHERE director ILIKE '%Rajiv Chilaka%'


--Q8 List all TV shows with more than 5 seasons

  SELECT * FROM netflix
    WHERE
	  type = 'TV Show'
	  AND
	  SPLIT_PART(duration, ' ', 1):: numeric > 5 
  
--Q9 Count the number of content items in each genre

     SELECT 
	      UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	       COUNT(show_id) as total_content
		   FROM netflix
		   GROUP BY 1

--Q10 Find each year and the average numbers of content release in India on netflix.
return top 5 year with highest avg content release!

   SELECT 
     EXTRACT (YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	 COUNT(*) as yearly_content,
	 ROUND(
	   COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE COUNTRY = 'India')::numeric * 100,2) 
	 as avg_count_per_year
	 FROM netflix
     WHERE country = 'India'
	 GROUP BY 1

--Q11  List all movies that are documentaries

    SELECT * FROM netflix
	 WHERE
	   listed_in ILIKE  '%Documentaries%'
	 

--Q12 Find all content without a director

    SELECT * FROM netflix
     WHERE director IS NULL


--Q13 Find how many movies actor 'Salman Khan' appeared in last 10 years!

    SELECT * FROM netflix
	 WHERE 
	   casts ILIKE '%Salman Khan%'
	   AND
	   release_year > EXTRACT (YEAR FROM CURRENT_DATE) - 10

--Q14 Find the top 10 actors who have appeared in the highest number of movies produced in India.

	  SELECT 
	    UNNEST (STRING_TO_ARRAY (casts,',')) as actors,
		COUNT (*) as total_content
		FROM netflix
		WHERE
		   country ILIKE '%India%'
		   GROUP BY 1
		   ORDER BY 2 DESC
		   LIMIT 10
		   

--Q15 Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
        --the description field. Label content containing these keywords as 'Bad' and all other 
            --content as 'Good'. Count how many items fall into each category.	   


WITH new_table
AS
(
   SELECT 
   *,
     CASE
	 WHEN description ILIKE '%kill%'
	 OR
	    description ILIKE '%violence%' THEN 'Bad_content'
	   ELSE 'Good_content'
     END category
	 FROM netflix
  ) 
   SELECT 
      category,
	  COUNT(*) as total_content
	   FROM new_table
	  GROUP BY 1
      ORDER BY 2

-- END OF THE PROJECT   
