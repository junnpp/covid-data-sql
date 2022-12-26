# Covid19 Data Analysis with MySQL

[World wide covid19 data](https://ourworldindata.org/covid-deaths) analysis with two raw datasets `CovidDeaths` (n=85172) and `CovidVacc` (n=85172) from February 2020 to April 2021. [Here](https://public.tableau.com/app/profile/junhyeok.park/viz/CovidAnalysis_16688832454930/Dashboard1) is the final visualization of this analysis.

## Preliminary Analysis

First few rows of `CovidDeaths` with columns `Location`, `date`, `total_cases`, `new_cases`, `total_deaths`, and `population` are as follows:

```mysql
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1, 2;
```

| Location    | date       | total_cases | new_cases | total_deaths | population |
| ----------- | ---------- | ----------- | --------- | ------------ | ---------- |
| Afghanistan | 2020-02-24 | 1           | 1         | NULL         | 38928341   |
| Afghanistan | 2020-02-25 | 1           | 0         | NULL         | 38928341   |
| Afghanistan | 2020-02-26 | 1           | 0         | NULL         | 38928341   |
| Afghanistan | 2020-02-27 | 1           | 0         | NULL         | 38928341   |
| Afghanistan | 2020-02-28 | 1           | 0         | NULL         | 38928341   |
| Afghanistan | 2020-02-29 | 1           | 0         | NULL         | 38928341   |
| Afghanistan | 2020-03-01 | 1           | 0         | NULL         | 38928341   |
| Afghanistan | 2020-03-02 | 1           | 0         | NULL         | 38928341   |
| Afghanistan | 2020-03-03 | 2           | 1         | NULL         | 38928341   |
| Afghanistan | 2020-03-04 | 4           | 2         | NULL         | 38928341   |


### Death rate in the United States.

Notice the number of cases in the United States has been increasing since early 2020.

```mysql
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM CovidDeaths
WHERE location LIKE "%states%"
ORDER BY 1, 2
LIMIT 100, 10;
```

| Location      | date       | total_cases | total_deaths | DeathPercentage |
| ------------- | ---------- | ----------- | ------------ | --------------- |
| United States | 2020-05-01 | 1115946     | 68140        | 6.1060          |
| United States | 2020-05-02 | 1143296     | 69871        | 6.1114          |
| United States | 2020-05-03 | 1167593     | 71061        | 6.0861          |
| United States | 2020-05-04 | 1191678     | 72440        | 6.0788          |
| United States | 2020-05-05 | 1216209     | 74682        | 6.1406          |
| United States | 2020-05-06 | 1240769     | 76996        | 6.2055          |
| United States | 2020-05-07 | 1268180     | 78925        | 6.2235          |
| United States | 2020-05-08 | 1295019     | 80688        | 6.2306          |
| United States | 2020-05-09 | 1320155     | 82156        | 6.2232          |
| United States | 2020-05-10 | 1339022     | 83134        | 6.2086          |

### Total cases vs. Population in the United States 

```mysql
SELECT date, total_cases, population, (total_cases/population) * 100 AS InfectedPercentage
FROM CovidDeaths
WHERE location LIKE "%states%"
LIMIT 50, 10;
```

| date       | total_cases | population | InfectedPercentage |
| ---------- | ----------- | ---------- | ------------------ |
| 2020-03-12 | 1586        | 331002647  | 0.0005             |
| 2020-03-13 | 2219        | 331002647  | 0.0007             |
| 2020-03-14 | 2978        | 331002647  | 0.0009             |
| 2020-03-15 | 3212        | 331002647  | 0.0010             |
| 2020-03-16 | 4679        | 331002647  | 0.0014             |
| 2020-03-17 | 6512        | 331002647  | 0.0020             |
| 2020-03-18 | 9169        | 331002647  | 0.0028             |
| 2020-03-19 | 13663       | 331002647  | 0.0041             |
| 2020-03-20 | 20030       | 331002647  | 0.0061             |
| 2020-03-21 | 26025       | 331002647  | 0.0079             |

### Countries with Higher Infection Rate

```mysql
SELECT location, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population) * 100) AS HighestInfectedPercentage
FROM CovidDeaths
WHERE
	location NOT IN ("World", "Asia", "Africa", "Europe",
					 "North America", "South America", "European Union")
GROUP BY location
ORDER BY 3 DESC
LIMIT 10;
```

| location      | HighestInfectionCount | HighestInfectedPercentage |
| ------------- | --------------------- | ------------------------- |
| Andorra       | 13232                 | 17.1255                   |
| Montenegro    | 97389                 | 15.5063                   |
| Czechia       | 1630758               | 15.2279                   |
| San Marino    | 5066                  | 14.9272                   |
| Slovenia      | 240292                | 11.5584                   |
| Luxembourg    | 67205                 | 10.7360                   |
| Bahrain       | 176934                | 10.3982                   |
| Serbia        | 689557                | 10.1337                   |
| United States | 32346971              | 9.7724                    |
| Israel        | 838481                | 9.6872                    |

### Countries with Higher Death Counts

```mysql
SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC
```

| location       | TotalDeathCount |
| -------------- | --------------- |
| United States  | 576232          |
| Brazil         | 403781          |
| Mexico         | 216907          |
| India          | 211853          |
| United Kingdom | 127775          |
| Italy          | 120807          |
| Russia         | 108290          |
| France         | 104675          |
| Germany        | 83097           |
| Spain          | 78216           |

### Continents-wise Death Counts

```mysql
SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 2 DESC;
```

| continent     | TotalDeathCount |
| ------------- | --------------- |
| North America | 576232          |
| South America | 403781          |
| Asia          | 211853          |
| Europe        | 127775          |
| Africa        | 54350           |
| Oceania       | 910             |

### Daily Global Analysis 

```mysql
SELECT
	date,
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    SUM(new_deaths) / SUM(new_cases) * 100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2 DESC
LIMIT 100, 10;
```

| date       | total_cases | total_deaths | DeathPercentage |
| ---------- | ----------- | ------------ | --------------- |
| 2020-04-10 | 85534       | 7378         | 8.6258          |
| 2020-04-11 | 74283       | 6172         | 8.3088          |
| 2020-04-12 | 119696      | 5859         | 4.8949          |
| 2020-04-13 | 70742       | 5966         | 8.4335          |
| 2020-04-14 | 84011       | 6968         | 8.2942          |
| 2020-04-15 | 77114       | 8473         | 10.9876         |
| 2020-04-16 | 95531       | 7259         | 7.5986          |
| 2020-04-17 | 87997       | 8393         | 9.5378          |
| 2020-04-18 | 77240       | 6145         | 7.9557          |
| 2020-04-19 | 76605       | 5233         | 6.8311          |

### Running Percentage of the New Vaccination Counts per Country

```mysql
DROP TABLE IF EXISTS PopulationVaccinated;
CREATE TEMPORARY TABLE PopulationVaccinated 
SELECT
	d.continent,
	d.location,
	d.date,
	d.population,
	v.new_vaccinations,
	SUM(v.new_vaccinations) OVER(PARTITION BY location ORDER BY d.location, d.date) AS running_sum_vacc_counts
FROM CovidDeaths AS d
JOIN CovidVacc AS v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent IS NOT NULL;

SELECT *, running_sum_vacc_counts/population * 100 AS PercentageVaccinated
FROM PopulationVaccinated
WHERE new_vaccinations IS NOT NULL;
```

| continent | location | date       | population | new_vaccinations | running_sum_vacc_counts | PercentageVaccinated |
| --------- | -------- | ---------- | ---------- | ---------------- | ----------------------- | -------------------- |
| Europe    | Albania  | 2021-01-13 | 2877800    | 60               | 60                      | 0.0021               |
| Europe    | Albania  | 2021-01-14 | 2877800    | 78               | 138                     | 0.0048               |
| Europe    | Albania  | 2021-01-15 | 2877800    | 42               | 180                     | 0.0063               |
| Europe    | Albania  | 2021-01-16 | 2877800    | 61               | 241                     | 0.0084               |
| Europe    | Albania  | 2021-01-17 | 2877800    | 36               | 277                     | 0.0096               |
| Europe    | Albania  | 2021-01-18 | 2877800    | 42               | 319                     | 0.0111               |
| Europe    | Albania  | 2021-01-19 | 2877800    | 36               | 355                     | 0.0123               |
| Europe    | Albania  | 2021-01-20 | 2877800    | 36               | 391                     | 0.0136               |
| Europe    | Albania  | 2021-01-21 | 2877800    | 30               | 421                     | 0.0146               |
| Europe    | Albania  | 2021-02-18 | 2877800    | 1348             | 1769                    | 0.0615               |

