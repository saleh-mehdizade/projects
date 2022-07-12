


-- Total Cases vs Total Deaths

SELECT 
	c.location, 
	c.date, 
	c.total_cases, 
	c.total_deaths, 
	ROUND((total_deaths/total_cases)*100,4) AS 'death and case ratio'
FROM cases AS c
	JOIN population as p 
		ON c.location = p.location and c.date = p.date
ORDER BY 1,2

-- Total cases vs Population
-- Shows the percentage of population have infected with covid

SELECT
	c.location, 
	c.date, 
	c.total_cases,
	p.population, 
	ROUND((c.total_deaths/population)*100, 4) AS 'population infection rate'
FROM cases AS c
	JOIN population as p 
		ON c.location = p.location and c.date = p.date
ORDER BY 1,2

-- Hospitalized patients vs population

SELECT
	c.location, 
	c.date, 
	c.total_cases,
	p.population, 
	ROUND((c.hosp_patients/population)*100, 4) AS 'hospitalized patience rate'
FROM cases AS c
	JOIN population as p 
		ON c.location = p.location and c.date = p.date
ORDER BY 1,2

-- Countries with highest infection rate compared to population

SELECT
	c.location,
	p.population,
	MAX(c.total_cases) AS 'highest infection rate', 
	ROUND(MAX((c.total_cases/population))*100, 4) AS 'population infection rate'
FROM cases AS c
	JOIN population as p 
		ON c.location = p.location and c.date = p.date
GROUP BY c.location, p.population
ORDER BY 4 DESC

-- Countries with highest death rate

SELECT
	c.location,
	p.population,
	MAX(CAST(c.total_deaths AS INT)) AS 'highest death count', 
	ROUND(MAX((c.total_deaths/population))*100, 4) AS 'population death rate'
FROM cases AS c
	JOIN population as p 
		ON c.location = p.location and c.date = p.date
GROUP BY c.location, p.population
ORDER BY 4 DESC

-- Breaking things down by continent


SELECT
	c.continent,
	p.population,
	MAX(CAST(c.total_deaths AS INT)) AS 'highest death count', 
	ROUND(MAX((c.total_deaths/population))*100, 4) AS 'population death rate'
FROM cases AS c
	JOIN population as p 
		ON c.location = p.location and c.date = p.date
GROUP BY c.continent, p.population
ORDER BY 4 DESC

SELECT continent  FROM cases


-- for visualization use this
SELECT
	c.location AS continent,
	MAX(CAST(c.total_deaths AS INT)) AS 'highest death count', 
	ROUND(MAX((c.total_deaths/population))*100, 4) AS 'population death rate'
FROM cases AS c
	JOIN population as p 
		ON c.location = p.location and c.date = p.date
WHERE c.continent is null and c.location != 'upper middle income' and c.location != 'lower middle income' and c.location != 'low income' and c.location != 'high income' and c.location != 'International'
GROUP BY c.location
ORDER BY 1 DESC

SELECT continent  FROM cases

-- Global numbers

SELECT 
	date,
	sum(new_cases) AS total_cases,
    sum(cast(new_deaths as int)) AS total_deaths,
	sum(cast(new_deaths as int))/NULLIF(sum(new_cases),0)*100 AS death_percentage
	FROM cases
GROUP BY date
ORDER BY date

SELECT 
	sum(new_cases) AS total_cases,
    sum(cast(new_deaths as int)) AS total_deaths,
	sum(cast(new_deaths as int))/NULLIF(sum(new_cases),0)*100 AS death_percentage
	FROM cases

-- Total Population vs vaccination

SELECT
	c.location, 
	c.date, 
	p.population, 
	v.new_vaccinations,
	SUM(CONVERT(bigint, v.new_vaccinations)) OVER (PARTITION BY c.location ORDER BY c.location, c.date
	) AS rolling_count_vaccination
FROM cases as c
	JOIN population as p
		ON c.location = p.location and c.date = p.date
	JOIN vaccination as v
		ON v.location = p.location and v.date = p.date
WHERE c.continent IS NOT NULL
ORDER BY 1,2

-- USING CTE

WITH popvac (location, date, population, new_vaccination, rolling_count_vaccination)
AS
(
SELECT
	c.location, 
	c.date, 
	p.population, 
	v.new_vaccinations,
	SUM(CONVERT(bigint, v.new_vaccinations)) OVER (PARTITION BY c.location ORDER BY c.location, c.date
	) AS rolling_count_vaccination
FROM cases as c
	JOIN population as p
		ON c.location = p.location and c.date = p.date
	JOIN vaccination as v
		ON v.location = p.location and v.date = p.date
WHERE c.continent IS NOT NULL
)

SELECT *,
	ROUND((rolling_count_vaccination/population), 4)*100 AS vaccination_ratio
FROM popvac
ORDER BY location, date


-- 

