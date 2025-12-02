CREATE OR REPLACE VIEW t_eva_strnadova_project_SQL_secondary_final AS

WITH dates_of_interest as (
	SELECT DISTINCT year FROM t_eva_strnadova_project_SQL_primary_final pt
),
european_countries AS (
    -- list of European countries
    SELECT *
    FROM countries
    WHERE continent = 'Europe'
)
SELECT 
    c.country AS stat,
    e."year" AS rok,
    e.gdp,
    c.population,
    e.gini
FROM european_countries c
JOIN economies e
    ON c.country = e.country
join dates_of_interest doi
	on doi.year = e.year
ORDER BY c.country, e."year";