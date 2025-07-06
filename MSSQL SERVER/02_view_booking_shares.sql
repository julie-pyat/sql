CREATE VIEW view_booking_shares AS (
SELECT p.id_provider,
       p.provider_name,
       c.country_name,
       ct.city_name,
       g.creation_year,
       g.creation_month,
       ROUND(CAST(g.count_bs_channel_manager AS FLOAT) / g.booking_total, 2) AS share_channel_manager,
       ROUND(CAST(g.channel_manager_bgc_bookings AS FLOAT) / g.booking_total, 2) AS share_channel_manager_bgc
FROM       
(SELECT id_provider,
       creation_year,
       creation_month,
       COUNT(id_provider) AS booking_total,
       SUM(CASE WHEN source_name = 'BS-CHANNEL_MANAGER' THEN 1 ELSE 0 END) AS count_bs_channel_manager,
       SUM(CASE WHEN source_name = 'BS-CHANNEL_MANAGER' AND creator = 'BGC' THEN 1 ELSE 0 END) AS channel_manager_bgc_bookings
FROM
(SELECT b.id_provider,
       YEAR(b.creation_date) AS creation_year,
       MONTH(b.creation_date) AS creation_month,
       s.source_name,
       b.creator
FROM [dbo].[booking] b
JOIN [dbo].[source] s ON b.id_source = s.id_source) booking_info
GROUP BY id_provider, creation_year, creation_month) g
JOIN [dbo].[provider] p ON g.id_provider = p.id_provider
JOIN [dbo].[country] c ON p.id_country = c.id_country
JOIN [dbo].[city] ct ON p.id_city = ct.id_city)

--SELECT * FROM view_booking_shares



