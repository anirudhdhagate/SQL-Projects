# Spotify User Listen Time — SQL Analysis

## Overview
An introductory SQL analytics project exploring music streaming behaviour using window functions, CTEs, and string aggregation on real Kaggle data loaded into BigQuery.

**Dataset:** [User Listen Time — Music Streaming History](https://www.kaggle.com/datasets/thedatasetengineer/user-listen-time-music-streaming-history?resource=download) — Kaggle  
**Tool:** Google BigQuery  
**Repo:** [anirudhdhagate/SQL-Projects](https://github.com/anirudhdhagate/SQL-Projects)

---

## Problem Statement
Given a wide-format table of user listen times per artist, answer three questions:
1. Who are each user's top 3 most listened artists?
2. What percentage of a user's total listen time does their #1 artist account for?
3. Which users share the same top 3 artists regardless of listen order?

---

## Approach

### Step 1 — Unpivot (Wide → Long Format)
The raw table had one column per artist. Used `UNPIVOT` to convert to a long format with `user_id`, `artist`, and `listen_time` columns — making it workable for window functions.

### Step 2 — Rank Artists per User
Used `ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY listen_time DESC)` to rank each user's artists by listen time.

### Step 3 — Listen Time Drop-off (LAG)
Used `LAG(listen_time) OVER (PARTITION BY user_id ORDER BY rn)` to calculate the drop-off in listen time between each user's ranked artists. NULLs for rank 1 replaced with 0 using `COALESCE`.

### Step 4 — Taste Concentration Score
Calculated what % of a user's total listen time their top artist accounts for, using `SUM(listen_time) OVER (PARTITION BY user_id)` — computed before filtering to avoid incorrect 100% results.

### Step 5 — Taste Profile Matching
Used `STRING_AGG(artist ORDER BY artist)` to create an alphabetically sorted string of each user's top 3 artists, then grouped by that string to find users with identical taste profiles.

---

## Key Insights

### 1. Taste Concentration vs Diversity
The listen time drop-off between rank 1 and rank 2 reveals listener behaviour:
- **Large drop-off** → concentrated listener with one dominant artist
- **Small drop-off** → varied listener with more evenly distributed taste

### 2. Shared Taste Profiles
By sorting artist names alphabetically before aggregating, taste profiles become order-independent — two users with the same top 3 artists in any listen-order rank as identical profiles.

---

## Concepts Used
- `UNPIVOT`
- CTEs (`WITH` clause, chained)
- `ROW_NUMBER()` window function
- `LAG()` window function
- `SUM() OVER (PARTITION BY)` for running totals
- `STRING_AGG()` for profile matching
- `COALESCE` for NULL handling
