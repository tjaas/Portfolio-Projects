/* 

Queries used for Tableau Project

*/

--1.

Select SUM(new_cases) as Total_Cases, SUM(CAST(new_deaths as int)) as Total_Deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
where continent is not null
order by 1,2

--Just a double check based off data provided
--numbers are close so we will kepp them - The second includes "International" location

--2.
-- We take these out as they are not included in the above queries and want to stat consistent
-- "European Union" is part of Europe
Select location, SUM(CAST(new_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
Where continent is null
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

--3.
Select location, Population, MAX(total_cases) as HighestInfectedCount, MAX((total_cases/population)*100) as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths
Group by location, population
order by PercentPopulationInfected desc

--4.
Select location, population, date, MAX(total_cases) as HighestInfectedCount, MAX((total_cases/population)*100) as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths
Group by location, population, date
order by PercentPopulationInfected desc