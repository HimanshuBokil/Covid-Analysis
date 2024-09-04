
select * from CovidDeaths$
where continent is not null
order by 3,4

--1.Total cases and Total Deaths

Select location,date,total_cases, new_cases,total_deaths,population
from CovidDeaths$
order by 1,2

--2.Total cases by day and Total Deaths in India

Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
from CovidDeaths$
where location like  '%India%'
order by 1,2

--3.Total cases vs Population

Select location,date,total_cases,population,(total_cases/population)*100 as Death_Percentage
from CovidDeaths$
order by 1,2

--4.Countries with highest infection rate compared to population

Select location,MAX(total_cases)as HighestInfectionCount,population,MAX(total_cases/population)*100 as PercentPopulationInfect
from CovidDeaths$
Group By location,population
order by PercentPopulationInfect DESC

--5.Countries with highest Death rate per population

Select location,MAX(cast(total_deaths as int))as TotalDeath 
from CovidDeaths$
where continent is not null
Group By location
order by TotalDeath DESC

--6. What continent has the highest death count
SELECT continent, MAX(total_deaths) as hightestDeathCount
FROM CovidDeaths$
WHERE CONTINENT IS NOT NULL 
Group by continent
order by hightestDeathCount desc

--7.Global Numbers

select SUM(new_cases)as total_cases, SUM(CAST(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
from CovidDeaths$
where continent is not null
order by 1,2

--8 Total Population and Vaccinations

select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations
from CovidDeaths$ cd 
JOIN CovidVaccinations$ cv
on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null
order by 2,3

--9.What is the rolling count of people vaccinated, meaning after each day
--what is the total number of vaccinated people

WITH PopVsVac (continent, location, date, population,  new_vaccinations, RollingCountofPeopleVaccinated)
as
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS BIGINT))
OVER (PARTITION BY dea.location order by dea.location, dea.date) AS RollingCountofPeopleVaccinated
FROM CovidDeaths$ dea
JOIN CovidVaccinations$ vac 
    ON dea.location = vac.location AND dea.date = vac.date
where dea.continent IS NOT NULL)
SELECT *, (RollingCountofPeopleVaccinated*1.0/population) * 100 AS PercentageofVaccinatedPeople
FROM PopVsVac

--10. What are the global cases for each day

SELECT date, SUM(convert(float,new_cases)) as total_newcases, SUM(convert(float,new_deaths)) as total_newdeaths, 
    case
        WHEN SUM(convert(float,new_cases)) <> 0 THEN SUM(convert(float,new_deaths))*1.0/SUM(new_cases)*100 
        ELSE NULL
    END AS death_rate
FROM CovidDeaths$
WHERE Continent is not NULL
GROUP BY DATE
Order by date 

select MAX(date)
from CovidDeaths$
select MIN(date)
from CovidDeaths$

