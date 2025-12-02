CREATE OR REPLACE VIEW t_eva_strnadova_project_SQL_secondary_final AS

WITH eu_years AS (
    -- get all years available for EU
    SELECT DISTINCT "year"
    FROM economies
    WHERE country = 'European Union'
),
european_countries AS (
    -- list of European countries
    SELECT *
    FROM countries
    WHERE country IN (
        'Austria','Belgium','Bulgaria','Croatia','Cyprus','Czech Republic','Denmark',
        'Estonia','Finland','France','Germany','Greece','Hungary',
        'Iceland','Ireland','Italy','Latvia','Lithuania','Luxembourg',
        'Malta','Netherlands','Norway','Poland','Portugal','Romania',
        'Slovakia','Slovenia','Spain','Sweden','United Kingdom'
    )
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
JOIN eu_years ey
    ON e."year" = ey."year"
ORDER BY e."year", c.country;