USE Cancer
GO

-- Total deaths in the world - Liver cancer for year 2019
-- The result is 6 938 035
CREATE FUNCTION FUN_TotalDeathsInTheWorldFor2019()
RETURNS DECIMAL(8,1)
AS
BEGIN
DECLARE @RESULT2019 DECIMAL(8, 1) = (SELECT SUM([Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)])
FROM [dbo].[Total-cancer-deaths-by-type]
WHERE YEAR = 2019)
RETURN @RESULT2019
END;

DECLARE @VALUE DECIMAL(8,1)
SELECT @VALUE =  dbo.FUN_TotalDeathsInTheWorldFor2019()
PRINT  @VALUE
GO


-- Total deaths in the world - Liver cancer for year 1990
-- The result is 5 183 360
CREATE FUNCTION FUN_TotalDeathsInTheWorldFor1990()
RETURNS DECIMAL(8,1)
AS
BEGIN
DECLARE @RESULT1990 DECIMAL(8, 1) = (SELECT SUM([Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)])
FROM [dbo].[Total-cancer-deaths-by-type]
WHERE YEAR = 1990)
RETURN @RESULT1990
END;

DECLARE @VALUE DECIMAL(8,1)
SELECT @VALUE =  dbo.FUN_TotalDeathsInTheWorldFor1990()
PRINT  @VALUE
GO


-- Calculate Percentage Increase Total deaths in the world - Liver cancer from 1990 to 2019
-- The result is: 33.9%
DECLARE @FINALRESULT DECIMAL(8,1) 
SET @FINALRESULT = (dbo.FUN_TotalDeathsInTheWorldFor2019() - dbo.FUN_TotalDeathsInTheWorldFor1990()) / dbo.FUN_TotalDeathsInTheWorldFor1990() * 100
PRINT  @FINALRESULT
GO


-- Calculate Total deaths in America - Liver cancer for year 2019
-- The result is: 46 132
SELECT [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)]
FROM [dbo].[Total-cancer-deaths-by-type]
WHERE YEAR = 2019 AND ENTITY = 'AMERICA';
GO


-- Calculate Total deaths in America - Liver cancer for year 1990
-- The result is 15 180
SELECT [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)]
FROM [dbo].[Total-cancer-deaths-by-type]
WHERE YEAR = 1990 AND ENTITY = 'AMERICA';
GO


-- Calculate Percentage Increase Total deaths in America - Liver cancer from 1990 to 2019
-- The result is: 203.9%
DECLARE @RESULTFOR1990AMERICA AS FLOAT
SET @RESULTFOR1990AMERICA = ((SELECT [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)]
FROM [dbo].[Total-cancer-deaths-by-type]
WHERE YEAR = 1990 AND ENTITY = 'AMERICA'));

DECLARE @RESULTFOR2019AMERICA AS FLOAT
SET @RESULTFOR2019AMERICA = (SELECT [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)]
FROM [dbo].[Total-cancer-deaths-by-type]
WHERE YEAR = 2019 AND ENTITY = 'AMERICA');

DECLARE @FINALRESULTAMERICA AS DECIMAL(8,1)
SET @FINALRESULTAMERICA = ((@RESULTFOR2019AMERICA - @RESULTFOR1990AMERICA) /  @RESULTFOR1990AMERICA) * 100
SELECT @FINALRESULTAMERICA;
GO


-- Calculate Percentage Increase Total deaths in Europe - Liver cancer from 1990 to 2019
-- The result is 79.2%
DECLARE @RESULTFOR1990EUROPE AS FLOAT
SET @RESULTFOR1990EUROPE = (SELECT [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)]
FROM [dbo].[Total-cancer-deaths-by-type]
WHERE YEAR = 1990 AND ENTITY = 'EUROPE');

DECLARE @RESULTFOR2019EUROPE AS FLOAT
SET @RESULTFOR2019EUROPE = (SELECT [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)]
FROM [dbo].[Total-cancer-deaths-by-type]
WHERE YEAR = 2019 AND ENTITY = 'EUROPE');

DECLARE @FINALRESULTEUROPE AS DECIMAL(8,1)
SET @FINALRESULTEUROPE = ((@RESULTFOR2019EUROPE - @RESULTFOR1990EUROPE) /  @RESULTFOR1990EUROPE) * 100
SELECT @FINALRESULTEUROPE;
GO


-- Total deaths in United States, United Kingdom, Bulgaria, Germany and France  - Liver cancer for year 1990 to 2019
-- The result is: United States: 23 807; France: 7792; Germany: 7743; United Kingdom: 5173; Bulgaria 893
SELECT ENTITY, MAX([Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)]) AS [Total Deaths Liver cancer for year 1990 to 2019]
FROM [dbo].[Total-cancer-deaths-by-type]
GROUP BY ENTITY 
HAVING (ENTITY = 'United States' or ENTITY= 'United Kingdom' or ENTITY = 'Bulgaria' or Entity = 'Germany' or Entity = 'France')
Order by [Total Deaths Liver cancer for year 1990 to 2019] DESC;
GO


-- Deaths in Europe - Liver cancer for year 1990 to 2019
-- The result is: Europe: 1990: 33 604; ... Europe: 2000: 41 423; ... Europe: 2019: 60 222;
SELECT ENTITY, YEAR, [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)]
FROM [dbo].[Total-cancer-deaths-by-type]
WHERE ENTITY = 'EUROPE';
GO


-- Select the year with maximum deaths in Europe - Liver cancer for year 1990 to 2019
-- The result is: Europe: 2019: 60 220
WITH CTE(ENTITY, YEAR, [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)])
AS
(
Select ENTITY, YEAR, [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)]
FROM [dbo].[Total-cancer-deaths-by-type]
WHERE ENTITY = 'EUROPE'
GROUP BY ENTITY, YEAR, [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)]
)

SELECT * FROM CTE
WHERE [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)] = 
(SELECT MAX([Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)]) FROM CTE);
GO


-- Select the year with minimum deaths in America - Liver cancer for year 1990 to 2019
-- The result is: America: 1990: 15 180;
WITH CTE(ENTITY, YEAR, [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)])
AS
(
Select ENTITY, YEAR, [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)]
FROM [dbo].[Total-cancer-deaths-by-type]
WHERE ENTITY = 'AMERICA'
GROUP BY ENTITY, YEAR, [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)]
)

SELECT * FROM CTE
WHERE [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)] = 
(SELECT MIN([Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)]) FROM CTE);
GO


-- Select all entities with the year with maximum deaths - Liver cancer for year 1990 to 2019
-- The Result is: Asia: 1999: 397 193; China: 1997: 296 720; European Region: 2019: 63 501...
WITH CTE(ENTITY, YEAR, [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)], RANKBYDEATHS)
AS
(
Select ENTITY, YEAR, [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)],
RANK() OVER(PARTITION BY ENTITY ORDER BY [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)]DESC) RANKBYDEATHS
FROM [dbo].[Total-cancer-deaths-by-type]
GROUP BY ENTITY, YEAR, [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)]
)

SELECT ENTITY, YEAR,  [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)]
FROM CTE
WHERE  RANKBYDEATHS = 1
ORDER BY [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)] DESC;
GO


-- Select all entities with the year with minimum deaths - Liver cancer for year 1990 to 2019
-- The result is: Nauru: 1990: 0; Austria: 1990: 387; Bulgaria: 2015: 592; Canada: 1990: 618; United Kingdom: 1990: 1681 ...
WITH CTE(ENTITY, YEAR, [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)], RANKBYDEATHS)
AS
(
Select ENTITY, YEAR, [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)],
RANK() OVER(PARTITION BY ENTITY ORDER BY [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)]ASC) RANKBYDEATHS
FROM [dbo].[Total-cancer-deaths-by-type]
GROUP BY ENTITY, YEAR, [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)]
)

SELECT ENTITY, YEAR,  [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)]
FROM CTE
WHERE  RANKBYDEATHS = 1
ORDER BY [Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)] ASC;
GO


-- Select all entities, deaths - liver cancer and total deaths- neoplasms for 2019
-- The result is: America: 2019: 46 132: 127.434663011225816; Asia: 2019: 340 603: 121.06920562199538; 
-- Europe: 2019: 60 220: 141.1704828221423...
WITH CTE (ENTITY, YEAR, DEATHS)
AS
(
SELECT ENTITY, YEAR, SUM([Deaths - Liver cancer - Sex: Both - Age: All Ages (Number)]) AS DEATHS
FROM [dbo].[Total-cancer-deaths-by-type]
GROUP BY ENTITY, YEAR
HAVING YEAR = 2019
)

SELECT DISTINCT(CTE.ENTITY), CTE.YEAR, CTE.DEATHS, [Deaths - Neoplasms - Sex: Both - Age: Age-standardized (Rate)]
FROM CTE
JOIN [dbo].[Cancer-death-rates-by-age] ON CTE.ENTITY = [dbo].[Cancer-death-rates-by-age].ENTITY AND 
CTE.YEAR = [dbo].[Cancer-death-rates-by-age].YEAR
GO

