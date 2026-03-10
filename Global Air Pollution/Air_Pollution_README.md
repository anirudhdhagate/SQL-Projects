# Global Air Pollution — SQL Analysis

## Overview
An intermediate SQL analytics project analysing global air pollution data across countries and cities, using CTEs, window functions, and UNION-based unpivoting to answer policy-relevant questions about pollution control.

**Dataset:** [Global Air Pollution Dataset](https://www.kaggle.com/datasets/hasibalmunawar/global-air-pollution-dataset) — Kaggle  
**Tool:** Google BigQuery  
**Repo:** [anirudhdhagate/SQL-Projects](https://github.com/anirudhdhagate/SQL-Projects)

---

## Problem Statement
Given a wide-format table of AQI values across four pollutant types (CO, Ozone, NO2, PM2.5) for cities worldwide, answer six analytical questions about pollution concentration, geographic hotspots, and country-level benchmarks.

---

## Approach

### Step 1 — Data Cleaning
Filtered out rows with NULL values across all pollutant columns directly in the base CTE using `COALESCE`, avoiding a separate cleaning step.

### Step 2 — Unpivot Pollutant Columns (Wide → Long)
Used `UNION ALL` to convert four separate pollutant columns into a single `pollutant_type` column with a corresponding `aqi_value` — making the data workable for aggregation and ranking across pollutant types.

### Step 3 — Average AQI per Pollutant per Country
Aggregated the long-format data to get average AQI per pollutant per country as a foundation for ranking.

### Step 4 — Rank Pollutants Within Each Country
Used `DENSE_RANK() OVER (PARTITION BY country_name ORDER BY avg_aqi DESC)` to identify the dominant pollutant in each country — rank 1 = most harmful pollutant type.

### Step 5 — Peak Pollutant Levels
Used `MAX()` per pollutant per country to surface worst-case pollution events, distinct from average behaviour.

### Step 6 — Rank Cities Within Each Country
Used `ROW_NUMBER() OVER (PARTITION BY country_name ORDER BY aqi_value DESC)` to rank cities within each country by overall AQI, then filtered to top 3 most polluted cities per country.

---

## Key Insights

### 1. Dominant Pollutant by Country
Ranking pollutants within each country reveals which emission type drives overall AQI. This identifies whether a country's pollution is industrial (CO, NO2) or environmental (Ozone, PM2.5), directly informing which sectors — transport, manufacturing, agriculture — require policy intervention.

### 2. Geographic Pollution Hotspots
Ranking cities within each country surfaces the most polluted urban centres. Combined with country-level rankings, this creates a two-level geographic view useful for targeting environmental enforcement and public health resources.

### 3. Average AQI as a Policy Benchmark
Cross-country average AQI comparison enables a global benchmark to be set. Countries above the threshold indicate weak or poorly enforced pollution control policy; countries below indicate effective regulation — making this a comparative measure of environmental governance, not just air quality.

---

## Concepts Used
- CTEs (`WITH` clause, chained — 6 CTEs)
- `UNION ALL` for unpivoting wide to long format
- `DENSE_RANK()` window function
- `ROW_NUMBER()` window function
- `PARTITION BY` for country-level windowing
- `COALESCE` for NULL filtering in base CTE
- Aggregate functions: `AVG()`, `MAX()`, `COUNT()`
