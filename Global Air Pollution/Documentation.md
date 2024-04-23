# Global Air Pollution Data Analysis

## Overview

This project analyzes global air pollution data to understand air quality dynamics across different cities and countries. The dataset includes information on various pollutants such as Carbon Monoxide (CO), Ozone, Nitrogen Dioxide (NO2), and Particulate Matter (PM2.5), along with overall Air Quality Index (AQI) values.

## Table of Contents

1. [Dataset Description](#dataset-description)
2. [Analysis Questions](#analysis-questions)
3. [SQL Queries](#sql-queries)
4. [Results and Insights](#results-and-insights)
5. [Future Work](#future-work)
6. [References](#references)

## Dataset Description

The dataset (`GlobalAirPollution.csv`) contains the following columns:

- `country_name`: Name of the country
- `city_name`: Name of the city
- `aqi_value`: Overall AQI value of the city
- `aqi_category`: Overall AQI category of the city
- `co_aqi_value`: AQI value of Carbon Monoxide
- `ozone_aqi_value`: AQI value of Ozone
- `no2_aqi_value`: AQI value of Nitrogen Dioxide
- `pm2.5_aqi_value`: AQI value of Particulate Matter (PM2.5)

## Analysis Questions

The following questions were addressed in this analysis:

1. What are the top 10 cities with the highest average AQI values?
2. How many cities fall under each AQI category?
3. What is the average AQI value for each country?
4. Which countries have the highest and lowest average AQI values?
5. What is the distribution of AQI categories within each country?
6. How does AQI value vary by pollutant type across different countries?
7. Which cities have the highest concentrations of Carbon Monoxide (CO)?
8. Which pollutants contribute the most to overall AQI values in each country?

## SQL Queries

The SQL queries used to answer the analysis questions are provided in the SQLQuery2.sql file.

## Results and Insights

The results of the analysis are summarized in the project documentation. Key insights include:
- There is variation in air quality across different countries, with some countries consistently showing higher or lower AQI values.
- Pollutant concentrations vary by city and country, with some cities experiencing higher levels of specific pollutants such as CO or PM2.5.


