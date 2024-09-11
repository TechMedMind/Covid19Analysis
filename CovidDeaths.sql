Select *
From [SQL Portfolio Project]..CovidDeaths
Where continent is not null 
order by 3,4



Select Location, date, total_cases, new_cases, total_deaths, population
From [SQL Portfolio Project]..CovidDeaths
Where continent is not null 
order by 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying with covid per country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [SQL Portfolio Project]..CovidDeaths
Where location = 'Kenya'
and continent is not null 
order by 1,2


-- Total Cases vs Population
-- The percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From [SQL Portfolio Project]..CovidDeaths
--Where location = 'Kenya'
order by 1,2


-- Highest Infection Rate per Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [SQL Portfolio Project]..CovidDeaths
--Where location = 'Kenya'
Group by Location, Population
order by PercentPopulationInfected desc


-- Highest Death Count per Country

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [SQL Portfolio Project]..CovidDeaths
--Where location = 'Kenya'
Where continent is not null 
Group by Location
order by TotalDeathCount desc

--Grouped by Continent

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [SQL Portfolio Project]..CovidDeaths
--Where location = 'Kenya'
Where continent is not null 
Group by continent
order by TotalDeathCount desc


--The Global Outlook

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [SQL Portfolio Project]..CovidDeaths
--Where location is 'Kenya'
where continent is not null 
--Group By date
order by 1,2



--Total population Vs Vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER(partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
from [SQL Portfolio Project]..CovidDeaths dea
join [SQL Portfolio Project]..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


--Use CTE
with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER(partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
from [SQL Portfolio Project]..CovidDeaths dea
join [SQL Portfolio Project]..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RollingPeopleVaccinated/population)*100
from PopvsVac


--temp Table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER(partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
from [SQL Portfolio Project]..CovidDeaths dea
join [SQL Portfolio Project]..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3


select *,(RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

--Creating view

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER(partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
from [SQL Portfolio Project]..CovidDeaths dea
join [SQL Portfolio Project]..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from PercentPopulationVaccinated