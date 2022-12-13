Select *
from [Portfolio Project]..CovidDeaths
Where continent is not null 
order by 3,4

--select *
--from [Portfolio Project]..CovidVaccinations
--order by 3,4

-- Select the data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
from [Portfolio Project]..CovidDeaths
Where continent is not null 
order by 1,2

-- Looking at the Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [Portfolio Project]..CovidDeaths
Where continent is not null 
Where location like '%states%'
order by 1,2

-- Looking at Total Cases vs Population
-- Show what percentage of population got covid
Select location, date, population, total_cases, (total_cases/population)*100 as CasePercentage
from [Portfolio Project]..CovidDeaths
Where continent is not null 
Where location like '%states%'
order by 1,2

--Looking at countries with highest infection rate compared to Population
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from [Portfolio Project]..CovidDeaths
Where continent is not null 
--Where location like '%states%'
Group by location, population
order by PercentPopulationInfected desc

-- Showing countries with highest death count per population
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc

--LET'S BREAK DOWN BY CONTINENT
--Showing the continents with the highest death count
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS
Select SUM(new_cases)as total_cases, SUM(cast(new_deaths as int))as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from [Portfolio Project]..CovidDeaths
Where continent is not null 
--Where location like '%states%'
--Group by date
order by 1,2


--Looking Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 1,2,3

-- USE CTE
With PopvsVac (Continent, location, date, population, New_Vaccionations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 1,2,3
)
Select *, (RollingPeopleVaccinated/population)*100 as percentage
From PopvsVac

-- TEMP TABLE

DROP Table if exists #PercentPopulationsVaccinated
Create Table #PercentPopulationsVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

Insert into #PercentPopulationsVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER 
(Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--order by 1,2,3

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationsVaccinated


-- Creating View to store data for data visualizations

Create View PercentPopulationsVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER
(Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 1,2,3

Select *
From PercentPopulationsVaccinated
