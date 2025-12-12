CREATE DATABASE swiggy_db;
DROP TABLE swiggy;
CREATE TABLE swiggy(
state VARCHAR(35),
city VARCHAR(35),	
order_date DATE,	
restaurant_name VARCHAR(100),	
location VARCHAR(100),	
category VARCHAR(250),
dish_name VARCHAR(250),	
price FLOAT,
rating FLOAT,
rating_count INT,	
order_year INT,	
order_month INT,
order_week INT,
day_of_week VARCHAR(25),
hour INT,	
weekend BOOLEAN
);



--✅ BASIC LEVEL QUERIES (1–15)

--1. Total number of orders
SELECT COUNT(*) AS total_orders FROM swiggy;

--2. Total revenue
SELECT SUM(price) AS total_revenue FROM swiggy;

--3. Unique cities
SELECT DISTINCT city FROM swiggy;

--4. Total orders by city
SELECT city, COUNT(*) AS orders
FROM swiggy
GROUP BY city
ORDER BY orders DESC;

--5. Orders by category
SELECT category, COUNT(*) AS orders
FROM swiggy
GROUP BY category
ORDER BY orders DESC;

--6. Average rating overall
SELECT ROUND(AVG(rating::NUMERIC),2) AS avg_rating FROM swiggy;

--7. Orders by restaurant
SELECT restaurant_name, COUNT(*) AS orders
FROM swiggy
GROUP BY restaurant_name
ORDER BY orders DESC;

--8. Highest priced dishes
SELECT dish_name, price 
FROM swiggy
ORDER BY price DESC
LIMIT 10;

--9. Count weekend vs weekday orders
SELECT weekend, COUNT(*) 
FROM swiggy
GROUP BY weekend;

--10. Orders by hour
SELECT hour, COUNT(*) AS orders
FROM swiggy
GROUP BY hour
ORDER BY hour;

--11. Average price by category
SELECT category, ROUND(AVG(price::NUMERIC),2)
FROM swiggy
GROUP BY category;

--12. Number of restaurants per city
SELECT city, COUNT(DISTINCT restaurant_name)
FROM swiggy
GROUP BY city;

--13. Orders by day of week
SELECT day_of_week, COUNT(*)
FROM swiggy
GROUP BY day_of_week;

--14. Top 15 dishes
SELECT dish_name, COUNT(*) AS orders
FROM swiggy
GROUP BY dish_name
ORDER BY orders DESC
LIMIT 15;

--15. Average rating per city
SELECT city, ROUND(AVG(rating:: NUMERIC),2)
FROM swiggy
GROUP BY city;

--✅ MEDIUM LEVEL QUERIES (16–35)

--16. Revenue by city
SELECT city, SUM(price) AS revenue
FROM swiggy
GROUP BY city
ORDER BY revenue DESC;

--17. Revenue by restaurant
SELECT restaurant_name, SUM(price) AS revenue
FROM swiggy
GROUP BY restaurant_name
ORDER BY revenue DESC;

--18. Category popularity by city
SELECT city, category, COUNT(*) AS orders
FROM swiggy
GROUP BY city, category
ORDER BY city, orders DESC;

--19. Rating trend by month
SELECT order_month, ROUND(AVG(rating::NUMERIC),2) AS avg_rating
FROM swiggy
GROUP BY order_month
ORDER BY order_month;

--20. Top rated restaurants
SELECT restaurant_name, ROUND(AVG(rating::NUMERIC),2) AS avg_rating
FROM swiggy
GROUP BY restaurant_name
ORDER BY avg_rating DESC
LIMIT 10;

--21. Restaurants with poor rating (<3)
SELECT restaurant_name, ROUND(AVG(rating::NUMERIC),2)
FROM swiggy
GROUP BY restaurant_name
HAVING AVG(rating) < 3;

--22. Weekend high-demand categories
SELECT category, COUNT(*) AS weekend_orders
FROM swiggy
WHERE weekend = TRUE
GROUP BY category
ORDER BY weekend_orders DESC;

--23. Compare weekday vs weekend avg price
SELECT weekend, ROUND(AVG(price::NUMERIC),2)
FROM swiggy
GROUP BY weekend;

--24. Monthly revenue
SELECT order_month, SUM(price) AS revenue
FROM swiggy
GROUP BY order_month
ORDER BY revenue DESC;

--25. Most popular category per city
SELECT city, category, COUNT(*) AS orders
FROM swiggy
GROUP BY city, category
ORDER BY city, orders DESC;

--26. Most expensive category
SELECT category, ROUND(AVG(price::NUMERIC),2) AS avg_price
FROM swiggy
GROUP BY category
ORDER BY AVG(price) DESC;

--27. Highest rated dishes
SELECT dish_name, ROUND(AVG(rating::NUMERIC),2) AS avg_rating
FROM swiggy
GROUP BY dish_name
ORDER BY avg_rating DESC
LIMIT 20;

--28. Restaurants with high sales but low rating
SELECT restaurant_name,
       COUNT(*) AS orders,
       ROUND(AVG(rating::NUMERIC),2) AS avg_rating
FROM swiggy
GROUP BY restaurant_name
HAVING AVG(rating) < 3.5
ORDER BY orders DESC;

--29. Rating count per restaurant
SELECT restaurant_name, SUM(rating_count)
FROM swiggy
GROUP BY restaurant_name
ORDER BY 2 DESC;

--30. Category share in each city
SELECT city, category,
       COUNT(*) * 100.0 /
       SUM(COUNT(*)) OVER (PARTITION BY city) AS category_share
FROM swiggy
GROUP BY city, category;

--31. Price elasticity indicator (high rating but low orders)
SELECT dish_name, AVG(rating) AS rating, COUNT(*) AS orders, AVG(price) AS avg_price
FROM swiggy
GROUP BY dish_name
HAVING AVG(rating) > 4 AND COUNT(*) < 20
ORDER BY avg_price DESC;

--32. Top restaurants by repeat ordering hour
SELECT restaurant_name, hour, COUNT(*) AS orders
FROM swiggy
GROUP BY restaurant_name, hour
ORDER BY orders DESC;

--33. Price segmentation by city (quantiles)
SELECT city,
       percentile_cont(0.25) WITHIN GROUP (ORDER BY price) AS p25,
       percentile_cont(0.50) WITHIN GROUP (ORDER BY price) AS median,
       percentile_cont(0.75) WITHIN GROUP (ORDER BY price) AS p75
FROM swiggy
GROUP BY city;

--34. City growth pattern (year on year)
SELECT city, order_year, COUNT(*) AS orders
FROM swiggy
GROUP BY city, order_year
ORDER BY city, order_year;

--35. Most demanded dish per category in each city
SELECT city, category, dish_name, COUNT(*) AS orders
FROM swiggy
GROUP BY city, category, dish_name
ORDER BY city, category, orders DESC;

--✅ B3. ADVANCED SQL QUERIES (36–45)

--36. Price variation within each category
SELECT category,
       MAX(price) - MIN(price) AS price_range
FROM swiggy
GROUP BY category;

--37. Category rating variance
SELECT category,
       VARIANCE(rating) AS rating_variance
FROM swiggy
GROUP BY category;

--38. Top restaurant per city by revenue
SELECT city, restaurant_name, SUM(price) AS revenue
FROM swiggy
GROUP BY city, restaurant_name
ORDER BY city, revenue DESC;

--39. Dish popularity by city
SELECT city, dish_name, COUNT(*) AS orders
FROM swiggy
GROUP BY city, dish_name
ORDER BY orders DESC;

--40. Restaurant category specialization
SELECT restaurant_name, COUNT(DISTINCT category) AS category_count
FROM swiggy
GROUP BY restaurant_name
ORDER BY category_count DESC;

--41. Category market share overall
SELECT category,
       COUNT(*) * 100.0 / (SELECT COUNT(*) FROM swiggy) AS share
FROM swiggy
GROUP BY category;

--42. Detect expensive dishes (above category avg)
SELECT dish_name, category, price
FROM swiggy s
WHERE price > (
   SELECT AVG(price)
   FROM swiggy
   WHERE category = s.category
);

--43. Rating outliers
SELECT * FROM swiggy
WHERE rating > 4.9 OR rating < 2.0;

--44. Revenue share by hour
SELECT hour,
       SUM(price) AS revenue,
       SUM(price) * 100.0 / (SELECT SUM(price) FROM swiggy) AS share
FROM swiggy
GROUP BY hour;

--45. Emerging categories (MoM growth)
SELECT order_month, category, COUNT(*) AS orders
FROM swiggy
GROUP BY order_month, category
ORDER BY order_month;


--✅ B4. WINDOW FUNCTION QUERIES (46–55)



--46. Rank restaurants by revenue (global)
SELECT restaurant_name,
       SUM(price) AS revenue,
       RANK() OVER (ORDER BY SUM(price) DESC) AS revenue_rank
FROM swiggy
GROUP BY restaurant_name;

--47. Rank restaurants inside each city
SELECT city, restaurant_name,
       SUM(price) AS revenue,
       RANK() OVER (PARTITION BY city ORDER BY SUM(price) DESC) AS city_rank
FROM swiggy
GROUP BY city, restaurant_name;

--48. Running total of revenue by month
SELECT order_month,
       SUM(price) AS monthly_revenue,
       SUM(SUM(price)) OVER (ORDER BY order_month) AS running_revenue
FROM swiggy
GROUP BY order_month;

--49. Percentile rating of dishes
SELECT dish_name, rating,
       PERCENT_RANK() OVER (PARTITION BY dish_name ORDER BY rating) AS rating_percentile
FROM swiggy;

--50. Moving average rating (7 rows)
SELECT restaurant_name, order_date, rating,
       AVG(rating) OVER (
          PARTITION BY restaurant_name
          ORDER BY order_date
          ROWS BETWEEN 7 PRECEDING AND CURRENT ROW
       ) AS moving_avg_rating
FROM swiggy;

--51. Top dish per category using ROW_NUMBER
SELECT *
FROM (
    SELECT category, dish_name, COUNT(*) AS orders,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(*) DESC) AS rn
    FROM swiggy
    GROUP BY category, dish_name
) x
WHERE rn = 1;

--52. Revenue share per restaurant (window sum)
SELECT restaurant_name,
       SUM(price) AS revenue,
       SUM(price) * 100.0 / SUM(SUM(price)) OVER () AS revenue_share
FROM swiggy
GROUP BY restaurant_name;

--53. City-wise cumulative orders
SELECT city, order_date, COUNT(*) AS daily_orders,
       SUM(COUNT(*)) OVER (PARTITION BY city ORDER BY order_date) AS cumulative_orders
FROM swiggy
GROUP BY city, order_date;

--54. Difference between each order price and city average
SELECT city, dish_name, price,
       price - AVG(price) OVER (PARTITION BY city) AS price_vs_city_avg
FROM swiggy;

--55. Category popularity rank per city
SELECT city, category, COUNT(*) AS orders,
       RANK() OVER (PARTITION BY city ORDER BY COUNT(*) DESC) AS popularity_rank
FROM swiggy
GROUP BY city, category;

-- ✅  CTE(Common Table Expression)

--✅ 1. CTE – Top 5 Cities by Revenue

--Business Impact: Identify the most profitable markets.

WITH city_revenue AS (
    SELECT city, SUM(price) AS revenue
    FROM swiggy
    GROUP BY city
)
SELECT city, revenue
FROM city_revenue
ORDER BY revenue DESC
LIMIT 5;

--✅ 2. CTE – Top Category per City

--Business Impact: Helps target city-wise menu promotions.

WITH city_category AS (
    SELECT city, category, COUNT(*) AS orders,
           RANK() OVER (PARTITION BY city ORDER BY COUNT(*) DESC) AS rnk
    FROM swiggy
    GROUP BY city, category
)
SELECT city, category, orders
FROM city_category
WHERE rnk = 1;

--✅ 3. CTE – Peak Ordering Hour

--Business Impact: Helps optimize delivery partner allocation.

WITH hourly_orders AS (
    SELECT hour, COUNT(*) AS total_orders
    FROM swiggy
    GROUP BY hour
)
SELECT hour, total_orders
FROM hourly_orders
ORDER BY total_orders DESC
LIMIT 1;



--✅ 5. CTE – Best-Selling Dish in Each Category

--Business Impact: Helps create top-selling combos & recommendations.

WITH dish_rank AS (
    SELECT category, dish_name,
           COUNT(*) AS orders,
           RANK() OVER (PARTITION BY category ORDER BY COUNT(*) DESC) AS rnk
    FROM swiggy
    GROUP BY category, dish_name
)
SELECT category, dish_name, orders
FROM dish_rank
WHERE rnk = 1;

--✅ 6. CTE – Monthly Revenue Trend

--Business Impact: Tracks growth and helps forecast demand.

WITH monthly_sales AS (
    SELECT order_month, ROUND(SUM(price::NUMERIC),2) AS revenue
    FROM swiggy
    GROUP BY order_month
)
SELECT *
FROM monthly_sales
ORDER BY order_month;

--✅ 7. CTE – Category Revenue Share

--Business Impact: Reveals top categories contributing to GMV.

WITH cat_rev AS (
    SELECT category, SUM(price::NUMERIC) AS revenue
    FROM swiggy
    GROUP BY category
)
SELECT category,revenue,
       ROUND(revenue * 100.0 / SUM(revenue) OVER(), 2) AS revenue_share
FROM cat_rev
ORDER BY revenue DESC;

--✅ 8. CTE – Price vs Category Average

--Business Impact: Identifies overpriced or underpriced dishes.

WITH cat_avg AS (
    SELECT category, AVG(price::NUMERIC) AS avg_price
    FROM swiggy
    GROUP BY category
)
SELECT s.category, s.dish_name, s.price,
       ROUND(s.price - c.avg_price),2 AS price_diff
FROM swiggy s
JOIN cat_avg c USING (category);

--✅ 9. CTE – Rating Trend for Each Restaurant

--Business Impact: Detects declining quality early.

WITH daily_rating AS (
    SELECT restaurant_name, order_date,
           ROUND(AVG(rating::NUMERIC),2) AS avg_rating
    FROM swiggy
    GROUP BY restaurant_name, order_date
)
SELECT restaurant_name, order_date, avg_rating
FROM daily_rating
ORDER BY restaurant_name, order_date;

--✅ 10. CTE – Dish Popularity City-Wise

--Business Impact: Helps personalize menu recommendations per city.

WITH dish_city AS (
    SELECT city, dish_name, COUNT(*) AS orders
    FROM swiggy
    GROUP BY city, dish_name
)
SELECT *
FROM dish_city
ORDER BY orders DESC;


--THE END--


