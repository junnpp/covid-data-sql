CREATE DATABASE IF NOT EXISTS Covid;
USE Covid;
SET SQL_SAFE_UPDATES = 0;

# importing deaths dataset
CREATE TABLE CovidDeaths (
	iso_code varchar(255),
    continent varchar(255),
    location varchar(255),
    date varchar(255),
    total_cases int,
    new_cases int,
    new_cases_smoothed double,
    total_deaths int,
    new_deaths int, 
    new_deaths_smoothed double,
    total_cases_per_million double,
    new_cases_per_million double,
    new_cases_smoothed_per_million double,
    total_deaths_per_million double,
	new_deaths_per_million double,
    new_deaths_smoothed_per_million double,
    reproduction_rate double,
    icu_patients int,
    icu_patients_per_million double,
    hosp_patients int,
    hosp_patients_per_million double,
    weekly_icu_admissions double,
    weekly_icu_admissions_per_million double,
    weekly_hosp_admissions double,
    weekly_hosp_admissions_per_million double,
    new_tests int,
    total_tests int,
    total_tests_per_thousand double,
    new_tests_per_thousand double,
    new_tests_smoothed int,
    new_tests_smoothed_per_thousand double,
    positive_rate double,
    tests_per_case double,
	tests_units varchar(255),
    total_vaccinations int,
    people_vaccinated int,
    people_fully_vaccinated int,
    new_vaccinations int,
    new_vaccinations_smoothed int,
    total_vaccinations_per_hundred double,
    people_vaccinated_per_hundred double,
    people_fully_vaccinated_per_hundred double,
    new_vaccinations_smoothed_per_million double,
    stringency_index double,
    population bigint,
    population_density double,
    median_age double,
    aged_65_older double,
    aged_70_older double,
    gdp_per_capita double,
    extreme_poverty	double,
    cardiovasc_death_rate double,
    diabetes_prevalence double,
	female_smokers double,
	male_smokers double,
	handwashing_facilities double,
	hospital_beds_per_thousand double,
	life_expectancy	double,
    human_development_index double
);

# load deaths data
LOAD DATA LOCAL INFILE "~/Desktop/CovidDeaths.csv"
INTO TABLE CovidDeaths
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 LINES;

UPDATE CovidDeaths
SET date = STR_TO_DATE(date, "%m/%d/%Y");

# importing vaccination dataset
CREATE TABLE CovidVacc (
	iso_code varchar(255),
    continent varchar(255),
    location varchar(255),
    date varchar(255),
    new_tests int,
    total_tests int, 
    total_tests_per_thousand double,
    new_tests_per_thousand double,
    new_tests_smoothed int,
    new_tests_smoothed_per_thousand double,
    positive_rate double,
    tests_per_case double,
    tests_units varchar(255),
    total_vaccinations int,
    people_vaccinated int,
    people_fully_vaccinated int,
    new_vaccinations int,
    new_vaccinations_smoothed int,
    total_vaccinations_per_hundred double,
    people_vaccinated_per_hundred double,
    people_fully_vaccinated_per_hundred double,
    new_vaccinations_smoothed_per_million int,
    stringency_index int,
    population_density double,
    median_age double,
    aged_65_older double,
    aged_70_older double,
    gdp_per_capita double,
    extreme_poverty double,
    cardiovasc_death_rate double,
    diabetes_prevalence double,
    female_smokers double,
    male_smokers double,
    handwashing_facilities double,
    hospital_beds_per_thousand double,
    life_expectancy double,
    human_development_index double
);

# load Vaccination data
LOAD DATA LOCAL INFILE "~/Desktop/CovidVacc.csv"
INTO TABLE CovidVacc
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 LINES;

UPDATE CovidVacc
SET date = STR_TO_DATE(date, "%m/%d/%Y");

# specify the columns needed
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1, 2;

# Death rate per country
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM CovidDeaths
WHERE location LIKE "%states%"
ORDER BY 1, 2;

# Total Cases vs. Population
SELECT date, total_cases, population, (total_cases/population) * 100 AS InfectedPercentage
FROM CovidDeaths
WHERE location LIKE "%states%";

# Countries with Highest Infection Rate
SELECT location, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population) * 100) AS HighestInfectedPercentage
FROM CovidDeaths
WHERE
	location NOT IN ("World", "Asia", "Africa", "Europe",
					 "North America", "South America", "European Union")
GROUP BY location
ORDER BY 3 DESC;

# Countries with Highest Death Count
SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
	-- location NOT IN ("World", "Asia", "Africa", "Europe",
	-- 				 "North America", "South America", "European Union")
GROUP BY location
ORDER BY 2 DESC;

# Continents with the highest death count
SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 2 DESC;

# Global Numbers
SELECT date, SUM(new_cases) -- , total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2 DESC;














