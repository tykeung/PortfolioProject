Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
where continent is not null
and DeathRate < CONVERT(float, 1)
--Group By date
order by 1,2

-- 2. 

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


-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,
(Max(total_cases)/population)*100 as PercentPopulationInfected
From CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,
(Max(total_cases)/population)*100 as PercentPopulationInfected
From CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc

--5

Select Deaths.location, Deaths.population, new_vaccinations, 
Total_tests, positive_rate, total_vaccinations, hospital_beds_per_thousand,
life_expectancy, Max(total_vaccinations)/population as VaccinationRate
From CovidDeaths Deaths
join CovidVaccinations Vaccine
	on Deaths.location = Vaccine.location
	and Deaths.date = Vaccine.date
where Deaths.continent is not null
and DeathRate < CONVERT(float, 1)
group by Deaths.location, Deaths.population, new_vaccinations, total_tests,
positive_rate, total_vaccinations, hospital_beds_per_thousand,
Vaccine.life_expectancy
order by 1
