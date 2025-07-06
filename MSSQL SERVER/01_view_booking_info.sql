CREATE VIEW view_booking_info AS
SELECT p.id_provider,
       p.provider_name,
       c.country_name,
       ct.city_name,
       b.creation_date,
       b.start_date,
       b.nights,
       b.price AS price_local,
       b.id_currency,
       b.price * cr.rate AS price_rub
FROM [dbo].[booking] b
JOIN [dbo].[provider] p ON b.id_provider = p.id_provider
JOIN [dbo].[country] c ON p.id_country = c.id_country
JOIN [dbo].[city] ct ON p.id_city = ct.id_city
JOIN [dbo].[currency_rate] cr ON b.id_currency = cr.id_currency 
                              AND b.creation_date = CAST(cr.[date] AS date);

-- SELECT * FROM view_booking_info;