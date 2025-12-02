CREATE OR REPLACE VIEW t_eva_strnadova_project_SQL_primary_final AS

WITH price_by_year_cat AS (
  SELECT
    CAST(EXTRACT(YEAR FROM COALESCE(pr.date_from, pr.date_to)) AS int) AS year,
    pc.name AS price_category,
    ROUND(AVG(pr.value)::NUMERIC, 1) AS avg_price
  FROM czechia_price pr
  JOIN czechia_price_category pc
    ON pc.code = pr.category_code
  WHERE pr.region_code IS NOT NULL
  GROUP BY year, pc.name
),
payroll_by_year_cat AS (
  SELECT
    p.payroll_year AS year,
    ib.name AS industry_branch,
    ROUND(AVG(p.value)) AS avg_wage
  FROM czechia_payroll p
  JOIN czechia_payroll_value_type vt
    ON vt.code = p.value_type_code
  JOIN czechia_payroll_industry_branch ib
  on ib.code = p.industry_branch_code
  WHERE vt.name ILIKE '%mzda%'
    AND p.value IS NOT NULL
  GROUP BY year, ib.name
),
common_years AS (
  SELECT year FROM payroll_by_year_cat
  INTERSECT
  SELECT year FROM price_by_year_cat
)
SELECT
  cy.year,
  py.industry_branch,
  py.avg_wage,
  pr.price_category,
  pr.avg_price
FROM common_years cy
JOIN payroll_by_year_cat py ON py.year = cy.year 
JOIN price_by_year_cat pr ON pr.year = cy.year
ORDER BY cy.year, py.industry_branch, pr.price_category;
