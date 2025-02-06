-- Exploratory Data Analysis 
/*
- country: The name of the country for which the data is reported.
- country_code: The ISO country code.
- year: The year for which the data is reported.
- health_exp: Current health expenditure as a percentage of GDP.
- life_expect: Life expectancy at birth (total years) for the population.
- maternal_mortality: The number of maternal deaths per 100,000 live births.
- infant_mortality: The number of infant deaths (under 1 year) per 1,000 live births.
- neonatal_mortality: The number of deaths of children under 28 days of age per 1,000 live births.
- under_5_mortality: The number of deaths of children under 5 years of age per 1,000 live births.
- prev_hiv: The percentage of the population aged 15-49 years living with HIV.
*/

-- Let's see what's in the table
SELECT *
FROM global_health_exp;

-- Country with the worst life expectancy
SELECT MIN(life_expect)
FROM global_health_exp;

SELECT country, year,
       MAX(life_expect) AS MaxLifeExpectancy,
       MIN(life_expect) AS MinLifeExpectancy
FROM global_health_exp
GROUP BY country, year;


SELECT  country, year, infant_mortality, maternal_mortality
FROM global_health_exp
GROUP BY country, year, infant_mortality, maternal_mortality
ORDER BY 2 ASC;

-- Avg mortality around the world
SELECT  avg(infant_mortality)
FROM global_health_exp;

-- There seems to be more countries here than in the world
select distinct(country)
from global_health_exp;

select count(distinct(country))
from global_health_exp
where country not in ('IBRD only', 'IDA & IBRD total','Africa Eastern and Southern', 'Africa Western and Central')
ORDER BY 1 ASC
;


-- DIVIDING THE COUNTRIES BASED ON CONTINENT 
SELECT Country,
    CASE
        WHEN Country IN ('China', 'India', 'Japan') THEN 'Asia'
        WHEN Country IN ('Germany', 'France', 'United Kingdom') THEN 'Europe'
        WHEN Country IN ('United States', 'Canada', 'Mexico') THEN 'North America'
        WHEN Country IN ('Brazil', 'Peru', 'Chile') THEN 'South America'
		WHEN Country IN ('South Africa', 'Botswana', 'Namibia') THEN 'Africa'
		WHEN Country IN ('Australia') THEN 'Oceania'
        ELSE 'Other'
    END AS continent
FROM global_health_exp
group by country
;


SELECT year,
    Country,
    AVG(life_expect) AS AverageLifeExpectancy,
    SUM(health_exp) AS TotalHealthExpenditure
FROM global_health_exp
GROUP BY Country, year;








