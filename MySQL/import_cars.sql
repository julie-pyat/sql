-- Добавление столбцов ap2023, ap2024 в таблицу cars
ALTER TABLE cars ADD COLUMN ap2024 INTEGER AFTER ap2022, 
ADD COLUMN ap2023 INTEGER AFTER ap2022;


-- Создание временной таблицы для импорта данных
DROP TABLE IF EXISTS temp_import;
CREATE TABLE temp_import (
  tecdocid VARCHAR(255),
  carid VARCHAR(255),
  ap2023 INT,
  ap2024 INT,
  type VARCHAR(10)
);


-- Загрузка данных из файла import.csv в таблицу temp_import
LOAD DATA INFILE '/var/lib/mysql-files/import.csv'
INTO TABLE temp_import
FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(tecdocid, carid, @ap2023, @ap2024, type)
set ap2023 = if(@ap2023='', null, @ap2023),
ap2024 = if(@ap2024='', null, @ap2024);


-- Создание нормализованной таблицы temp_normalized
DROP TABLE IF EXISTS temp_normalized;
CREATE TABLE temp_normalized (
  tecdocid VARCHAR(255),
  carid VARCHAR(255),
  ap2023 INT,
  ap2024 INT,
  type VARCHAR(10)
);

-- Добавление данных в таблицу temp_normalized с первыми tecdocid
INSERT INTO temp_normalized (tecdocid, carid, ap2023, ap2024, type)
SELECT
  CASE
    WHEN LOCATE(',', tecdocid) > 0 THEN SUBSTRING_INDEX(tecdocid, ',', 1)
    ELSE tecdocid
  END AS tecdocid_cleaned,
  carid,
  ap2023,
  ap2024,
  type
FROM temp_import;


-- Создание таблицы temp_aggregate и заполнение новыми агрегированными данными
DROP TABLE IF EXISTS temp_aggregated;
CREATE TABLE temp_aggregated AS
SELECT
  tecdocid,
  GROUP_CONCAT(DISTINCT carid ORDER BY carid SEPARATOR ',') AS carid,
  SUM(COALESCE(ap2023, 0)) AS ap2023,
  SUM(COALESCE(ap2024, 0)) AS ap2024,
  MAX(type) AS type
FROM temp_normalized
GROUP BY tecdocid;

-- Обновление таблицы cars по столбцу tecdocid
UPDATE cars c
JOIN temp_aggregated ta ON c.tecdocid = ta.tecdocid
SET
  c.ap2023 = ta.ap2023,
  c.ap2024 = ta.ap2024,
  c.carid = CASE
    WHEN c.carid IS NULL OR c.carid = '' OR c.carid = ta.carid OR LOCATE(c.carid, ta.carid) > 0 THEN ta.carid
    WHEN ta.carid IS NULL OR ta.carid= '' THEN c.carid
    ELSE CONCAT(c.carid, ',', ta.carid)
  END;

-- Обновление таблицы cars по столбцу carid
UPDATE cars c
JOIN temp_aggregated ta ON c.carid = ta.carid
SET
  c.ap2023 = ta.ap2023,
  c.ap2024 = ta.ap2024,
  c.tecdocid = CASE
    WHEN c.tecdocid IS NULL OR c.tecdocid ='' THEN ta.tecdocid
    ELSE c.tecdocid 
  	END
WHERE ta.tecdocid IS NULL OR c.tecdocid IS NULL OR c.tecdocid = '' OR ta.tecdocid = '';


-- Добавление остальных строк
INSERT INTO cars (tecdocid, carid, ap2023, ap2024, type)
SELECT
  ta.tecdocid,
  ta.carid,
  ta.ap2023,
  ta.ap2024,
  ta.type
FROM temp_aggregated ta
LEFT JOIN cars c ON ta.carid = c.carid
WHERE (c.tecdocid IS NULL OR c.tecdocid = '') AND (ta.tecdocid IS NULL OR ta.tecdocid = '');