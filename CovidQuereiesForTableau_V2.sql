--Data from these quereies will be copied into an Excel doc and imported into Tableau

-- 1. Global Death Percentage
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
where continent is not null
--and DeathRate < CONVERT(float, 1)
--Group By date
order by 1,2

-- 2. Total deaths by country

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(new_deaths) as TotalDeathCount
From CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International', 'High income', 
'Upper middle income', 'Lower middle income', 'Low income')
and DeathRate < CONVERT(float, 1)
Group by location
order by TotalDeathCount desc


-- 3. Infection Percentage by Country

Select Location, Population, MAX(CONVERT(float, total_cases)) as HighestInfectionCount,
MAX(CONVERT(float, total_cases)/population)*100 as PercentPopulationInfected
From CovidDeaths
where DeathRate < CONVERT(float, 1)
Group by Location, Population
order by PercentPopulationInfected desc

-- 4. Daily Infection Percentage by Country

Select Location, Population,date, MAX(CONVERT(float, total_cases)) as HighestInfectionCount,
Max((CONVERT(float, total_cases))/population)*100 as PercentPopulationInfected
From CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc

--5 Vaccination Percentage by Country

Select Deaths.location, Deaths.population, MAX(CONVERT(float, people_vaccinated)) as TotalVaccinations, 
MAX(CONVERT(float, people_fully_vaccinated)) as PeopleFullyVaccinated,
life_expectancy, MAX(CONVERT(float, people_vaccinated))/population as VaccinationRate
From CovidDeaths Deaths
join CovidVaccinations Vaccine
	on Deaths.location = Vaccine.location
	and Deaths.date = Vaccine.date
where Deaths.continent is not null
and DeathRate < CONVERT(float, 1)
and people_vaccinated < population
group by Deaths.location, Deaths.population, life_expectancy
order by VaccinationRate desc

--6 Daily Vaccination Percentage by Country

Select Deaths.location, Deaths.population, Deaths.date, people_fully_vaccinated,  
life_expectancy, (people_fully_vaccinated/population)*100 as VaccinationPercentage
From CovidDeaths Deaths
join CovidVaccinations Vaccine
	on Deaths.location = Vaccine.location
	and Deaths.date = Vaccine.date
where Deaths.continent is not null
and DeathRate < CONVERT(float, 1)
and people_fully_vaccinated > CONVERT(float, 0)
order by 1 asc, 3 asc
