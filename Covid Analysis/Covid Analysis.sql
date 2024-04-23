SELECT * 
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3, 4

--SELECT * 
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3, 4

SELECT Location, Date, total_cases, new_cases, total_deaths, population 
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2

--Total cases vs total deaths
--Likelihood of death in case you contract covid, as per location
SELECT Location, Date, total_cases, total_deaths, (total_deaths / total_cases) * 100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%india%'
ORDER BY 1, 2

--Percentage of population that contracted Covid
SELECT Location, Date, total_cases, Population, (total_cases / population) * 100 as CovidInfected
FROM PortfolioProject..CovidDeaths
WHERE location like '%india%'
ORDER BY 1, 2


--Countries with highest infection rate compared to population
SELECT Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases / population) * 100) as HighestInfected
FROM PortfolioProject..CovidDeaths
GROUP BY Location, Population
ORDER BY 4 DESC

--Countries with highest death count per population 
SELECT Location, MAX(CAST(Total_deaths AS INT)) as Max_deaths
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY 2 DESC


--Continents with highest death count
SELECT Location, MAX(CAST(Total_deaths AS INT)) as Max_deaths
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL
GROUP BY Location
ORDER BY 2 DESC

--Global numbers

SELECT SUM(new_cases) AS "Total Cases", SUM(CAST(new_deaths AS INT)) AS "Total Deaths", SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2


--JOINING BOTH TABLES
SELECT * 
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date

-- Total Population vs. Total Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY  dea.location, dea.date) AS RollingVaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3


--creating a cte
WITH PopulationvsVaccinations (Continent, Location, Date, Population, New_vaccinations, RollingVaccinations) AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY  dea.location, dea.date) AS RollingVaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingVaccinations / Population) * 100 AS "% of Vaccinations" FROM PopulationvsVaccinations


--Temp table
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingVaccinations numeric)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY  dea.location, dea.date) AS RollingVaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL


SELECT *, (RollingVaccinations / Population) * 100 AS "% of Vaccinations" FROM #PercentPopulationVaccinated

