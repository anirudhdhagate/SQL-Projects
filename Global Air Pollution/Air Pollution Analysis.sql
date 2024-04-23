
--REMOVING ROWS WITH NULL VALUES FROM NUMERICAL COLUMNS

DELETE FROM PortfolioProject.dbo.GlobalAirPollution
WHERE COALESCE(aqi_value, co_aqi_value_, ozone_aqi_value, no2_aqi_value, pm2#5_aqi_value) IS NULL;

--DATE OVERVIEW
SELECT * FROM PortfolioProject.dbo.GlobalAirPollution;

--What are the top 10 cities with the highest average AQI values?
SELECT TOP 10 city_name, country_name, AVG(aqi_value) AS avg_aqi
FROM PortfolioProject.dbo.GlobalAirPollution
GROUP BY city_name, country_name
ORDER BY avg_aqi DESC;

--How many cities fall under each AQI category?
SELECT aqi_category, COUNT(*) AS num_cities
FROM PortfolioProject.dbo.GlobalAirPollution
GROUP BY aqi_category;

--What is the average AQI value for each country?
SELECT country_name, AVG(aqi_value) AS avg_aqi
FROM PortfolioProject.dbo.GlobalAirPollution
GROUP BY country_name
ORDER BY 2;

--Which countries have the highest and lowest average AQI values?
SELECT country_name, AVG(aqi_value) AS avg_aqi
FROM PortfolioProject.dbo.GlobalAirPollution
GROUP BY country_name
ORDER BY avg_aqi ASC

--What is the distribution of AQI categories within each country?
SELECT country_name, aqi_category, COUNT(*) AS num_cities 
FROM PortfolioProject.dbo.GlobalAirPollution
GROUP BY country_name, aqi_category
ORDER BY 2 DESC;

--How does AQI VALUE vary by pollutant type(CO, Ozone, NO2, PM2.5) across different countries?
SELECT country_name, pollutant_type, AVG(aqi_value) AS avg_aqi
FROM (
	SELECT country_name, 'CO' AS pollutant_type, co_aqi_value_ AS aqi_value FROM PortfolioProject.dbo.GlobalAirPollution
	UNION ALL 
	SELECT country_name, 'Ozone' AS pollutant_type, ozone_aqi_value AS aqi_value FROM PortfolioProject.dbo.GlobalAirPollution
	UNION ALL 
	SELECT country_name, 'NO2' AS pollutant_type, no2_aqi_value AS aqi_value FROM PortfolioProject.dbo.GlobalAirPollution
	UNION ALL 
	SELECT country_name, 'PM2.5' AS pollutant_type, pm2#5_aqi_value AS aqi_value FROM PortfolioProject.dbo.GlobalAirPollution
	) AS subquery
GROUP BY country_name, pollutant_type
ORDER BY 3 DESC;

--Which cities have the highest concentrations of Carbon Monoxide (CO)?
SELECT city_name, MAX(co_aqi_value_) AS max_co_aqi
FROM PortfolioProject.dbo.GlobalAirPollution
GROUP BY city_name
ORDER BY 2 DESC;

--Which pollutants contribute the most to overall AQI values in each country?
SELECT country_name, MAX(co_aqi_value_) AS max_co_aqi, MAX(ozone_aqi_value) AS max_ozone_aqi, MAX(no2_aqi_value) AS max_no2_aqi, MAX(pm2#5_aqi_value) as max_pm25_aqi
FROM PortfolioProject.dbo.GlobalAirPollution
GROUP BY country_name;
