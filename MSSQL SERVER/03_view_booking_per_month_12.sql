CREATE VIEW view_booking_per_month_12 AS 
WITH booking_month AS (
SELECT b.id_provider,
       p.provider_name,
       c.country_name,
       ct.city_name,
       YEAR(b.creation_date) AS creation_year,
       MONTH(b.creation_date) AS creation_month,
       COUNT(b.id_booking) AS booking_count,
       SUM(b.price) AS total_price
FROM [dbo].[booking] b
JOIN [dbo].[provider] p ON b.id_provider = p.id_provider
JOIN [dbo].[country] c ON p.id_country = c.id_country
JOIN [dbo].[city] ct ON p.id_city = ct.id_city
GROUP BY b.id_provider,
         p.provider_name,
         c.country_name,
         ct.city_name,
         YEAR(b.creation_date),
         MONTH(b.creation_date)
),
true_provider AS (
SELECT id_provider, 
       creation_year
FROM  
(SELECT id_provider,
        creation_year,
        COUNT(DISTINCT creation_month) AS months_with_bookings
FROM booking_month
GROUP BY id_provider, creation_year) t1
WHERE months_with_bookings = 12)
SELECT b.id_provider,
       b.provider_name,
       b.country_name,
       b.city_name,
       b.creation_year,
       AVG(b.booking_count) AS avg_bookings_per_month,
       AVG(b.total_price) AS avg_total_price_per_month
FROM booking_month b
JOIN true_provider tp
ON b.id_provider = tp.id_provider AND b.creation_year = tp.creation_year
GROUP BY b.id_provider,
         b.provider_name,
         b.country_name,
         b.city_name,
         b.creation_year      
 

-- SELECT * FROM view_booking_per_month_12  


