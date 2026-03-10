-- ============================================
-- Global Air Pollution Analysis
-- Dataset: Kaggle - Global Air Pollution Dataset
-- Tool: Google BigQuery
-- ============================================

-- Step 1: Base CTE - load table and remove rows with NULL pollutant values
WITH GAP AS (
  SELECT * FROM `your-project-id.Global_Air_Pollution.Pollution` 
  WHERE COALESCE(aqi_value, co_aqi_value_, ozone_aqi_value, no2_aqi_value, pm2_5_aqi_value) IS NOT NULL
),

-- Step 2: Unpivot wide pollutant columns into long format (one row per pollutant per country)
pollutant_type_cte AS (
  SELECT country_name, 'CO' AS pollutant_type, co_aqi_value_ AS aqi_value FROM GAP
  UNION ALL 
  SELECT country_name, 'Ozone' AS pollutant_type, ozone_aqi_value AS aqi_value FROM GAP
  UNION ALL 
  SELECT country_name, 'NO2' AS pollutant_type, no2_aqi_value AS aqi_value FROM GAP
  UNION ALL 
  SELECT country_name, 'PM2.5' AS pollutant_type, pm2_5_aqi_value AS aqi_value FROM GAP
),

-- Step 3: Average AQI per pollutant per country
avg_pollutant AS (
  SELECT country_name, pollutant_type, AVG(aqi_value) AS avg_aqi
  FROM pollutant_type_cte 
  GROUP BY country_name, pollutant_type
),

-- Step 4: Rank pollutants within each country by average AQI (1 = most harmful)
ranked_pollutant AS (
  SELECT *,
    DENSE_RANK() OVER (PARTITION BY country_name ORDER BY avg_aqi DESC) AS rnk
  FROM avg_pollutant
),

-- Step 5: Peak pollutant levels per country across all 4 pollutant types
max_pollutants AS (
  SELECT country_name, 
    MAX(co_aqi_value_) AS max_co_aqi, 
    MAX(ozone_aqi_value) AS max_ozone_aqi, 
    MAX(no2_aqi_value) AS max_no2_aqi, 
    MAX(pm2_5_aqi_value) AS max_pm25_aqi 
  FROM GAP 
  GROUP BY country_name  
),

-- Step 6: Rank cities within each country by overall AQI (1 = most polluted)
most_polluted_cities AS (
  SELECT country_name AS country, city_name, aqi_value,
    ROW_NUMBER() OVER (PARTITION BY country_name ORDER BY aqi_value DESC) AS rnk 
  FROM GAP 
  WHERE country_name IS NOT NULL
)

-- Q1: How many cities fall under each AQI category?
-- SELECT aqi_category, COUNT(*) AS num_cities FROM GAP GROUP BY aqi_category;

-- Q2: Distribution of AQI categories within each country
-- SELECT country_name, aqi_category, COUNT(*) AS num_cities FROM GAP GROUP BY country_name, aqi_category ORDER BY 2 DESC;

-- Q3: Average AQI by pollutant type across countries
-- SELECT country_name, pollutant_type, ROUND(AVG(aqi_value), 2) AS avg_aqi FROM pollutant_type_cte GROUP BY country_name, pollutant_type ORDER BY 3 DESC;

-- Q4: Which pollutant contributes most to AQI per country (ranked)?
-- SELECT * FROM ranked_pollutant WHERE country_name IS NOT NULL AND rnk = 1;

-- Q5: Peak pollutant levels per country
-- SELECT * FROM max_pollutants WHERE country_name IS NOT NULL LIMIT 10;

-- Q6: Top 3 most polluted cities per country
-- SELECT * FROM most_polluted_cities WHERE rnk <= 3;