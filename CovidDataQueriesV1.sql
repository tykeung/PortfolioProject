--Select Data we will be using

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
where DeathRate < CONVERT(float, 1)

Select total_cases, total_tests, deathRate
From CovidDeaths

where location = 'France'

--Looking at Total cases vs Total deaths

Select location, date, total_cases, total_deaths, (CONVERT(float, total_deaths)/NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where DeathRate < CONVERT(float, 1)
order by 5 desc

--Looking at Total cases vs Population

Select location, date, total_cases, population, (total_cases/population)*100 as InfectionPercentage
From PortfolioProject..CovidDeaths
where location like 'Canada'
and DeathRate < CONVERT(float, 1)
order by 1,2

--Looking at Countries with highest infection rate

Select location, MAX(total_cases) as TotalCasesToDate, population, (Max(total_cases)/population)*100 as InfectionPercentage
From CovidDeaths
where DeathRate < CONVERT(float, 1)
group by location, population
--order by InfectionPercentage DESC


--Looking at Countries with highest death rate by population

Select location, population, Max(Total_deaths) as TotalDeathToDate,
(Max(total_deaths)/population)*100 as DeathPercentage
From CovidDeaths
where DeathRate < CONVERT(float, 1) 
group by location, population
order by DeathPercentage DESC

-- Global numbers

Select date, SUM(new_cases) as TotalCases, Sum(new_Deaths) as TotalDeaths, 
Sum(new_deaths)/NULLIF(Sum(new_cases), 0)*100 as GlobalDeathPercentage
from CovidDeaths
where continent is not null
group by date
order by 1,2 


--Looking at Total POpulation vs Vaccination
--CTE

with PopvsVac (Continent, location, date, population, new_vaccinations, TotalVaccinationPerCountry)
as
(
Select Deaths.continent, Deaths.location, Deaths.date, Deaths.population, Vaccine.new_vaccinations,
Sum(Cast(Vaccine.new_vaccinations as float)) over (partition by Deaths.location order by Deaths.location, 
Deaths.Date) as TotalVaccinationPerCountry
From CovidDeaths Deaths
join CovidVaccinations Vaccine
	on Deaths.location = Vaccine.location
	and Deaths.date = Vaccine.date
where Deaths.continent is not null
--order by 2,3
)
Select *, (TotalVaccinationPerCountry/population)*100 as VaccinatedPopulationPercentage
From PopvsVac

--Temp Table

DROP Table if exists #PercentPopVaccinated
Create Table #PercentPopVaccinated
(
Continent nvarchar(255), 
Location nvarchar(255), 
Date datetime, 
Population numeric,
New_vaccination numeric,
TotalVaccinationPerCountry numeric
)

Insert into #PercentPopVaccinated
Select Deaths.continent, Deaths.location, Deaths.date, Deaths.population, Vaccine.new_vaccinations,
Sum(Cast(Vaccine.new_vaccinations as float)) over (partition by Deaths.location order by Deaths.location, 
Deaths.Date) as TotalVaccinationPerCountry
From CovidDeaths Deaths
join CovidVaccinations Vaccine
	on Deaths.location = Vaccine.location
	and Deaths.date = Vaccine.date
where Deaths.continent is not null
--order by 2,3

Select *, (TotalVaccinationPerCountry/population)*100 as VaccinatedPopulationPercentage
From #PercentPopVaccinated


--Creating Views for later data visualization

Create view PercentPopVaccinated as
Select Deaths.continent, Deaths.location, Deaths.date, Deaths.population, Vaccine.new_vaccinations,
Sum(Cast(Vaccine.new_vaccinations as float)) over (partition by Deaths.location order by Deaths.location, 
Deaths.Date) as TotalVaccinationPerCountry
From CovidDeaths Deaths
join CovidVaccinations Vaccine
	on Deaths.location = Vaccine.location
	and Deaths.date = Vaccine.date
where Deaths.continent is not null
--order by 2,3