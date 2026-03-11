# Telecom Customer Churn — SQL Analysis

## Overview
A domain-driven SQL analytics project analysing telecom customer churn using window functions and CTEs, informed by hands-on experience in L2 network operations supporting Liberty Global Europe. The analysis identifies actionable churn signals across service quality, usage patterns, and plan type.

**Dataset:** [Telecom Churn Datasets](https://www.kaggle.com/datasets/mnassrib/telecom-churn-datasets) — Kaggle  
**Tool:** Google BigQuery  
**Repo:** [anirudhdhagate/SQL-Projects](https://github.com/anirudhdhagate/SQL-Projects)

---

## Problem Statement
Given customer-level telecom data including usage minutes, service call history, plan type, and churn status, identify the key drivers of customer churn and define thresholds for proactive intervention.

Two core questions:
1. Do high customer service calls predict churn, and at what threshold does risk become critical?
2. Which usage patterns and plan types are most associated with churned customers?

---

## Approach

### Step 1 — Merge Train and Test Splits
The Kaggle dataset was split 80:20 for ML purposes. Used `UNION ALL` in the base CTE to merge both tables into a single analytical dataset of 3,333 customers.

### Step 2 — Churn Rate by Customer Service Calls
Grouped customers by number of service calls, calculated churn rate per group using `COUNTIF(Churn = true)`, and used `SUM(COUNT(*)) OVER ()` — a window function with no partition — to compute grand total and derive each group's share of the customer base.

### Step 3 — Usage Pattern Comparison (Churned vs Non-Churned)
Calculated average day, evening, night, and international minutes for churned vs non-churned customers to identify usage-based churn signals.

### Step 4 — Churn Rate by International Plan
Grouped by international plan enrollment and calculated churn rate to test whether plan type is a significant churn driver — this directly challenged the initial assumption from usage data.

---

## Key Insights

### 1. Customer Service Calls as a Churn Threshold
Churn rate spikes sharply beyond 4 customer service calls — customers with 6-7 calls churn at 56-64%, compared to ~11% for customers with 0-2 calls. Only ~7% of customers fall in this high-call segment, but they represent a near-certain churn risk. From a network operations perspective, high call volume signals repeated unresolved issues — an early warning system that triggers proactive outreach at 4+ calls could prevent the majority of preventable churn.

### 2. Heavy Daytime Users Are the Highest Churn Risk
Churned customers average 207 day minutes vs 175 for retained customers — a 18% higher usage rate. Heavy users are not leaving due to low engagement; they are leaving despite high usage, pointing to pricing dissatisfaction or service quality degradation during peak hours. Targeted pricing tiers for high day-minute consumers could improve retention among this segment.

### 3. International Plan Enrollment Drives 4x Higher Churn
Despite nearly identical international usage minutes between churned (10.7) and non-churned (10.1) customers, those enrolled in an international plan churn at 42% vs 11% — nearly four times higher. Since usage is similar, the churn gap is not driven by how much customers use the plan but by dissatisfaction with its pricing or perceived value. This is a pricing problem, not a quality or usage problem.

---

## Concepts Used
- CTEs (`WITH` clause, chained — 4 CTEs)
- `UNION ALL` to merge dataset splits
- `COUNTIF()` for conditional aggregation
- `SUM(COUNT(*)) OVER ()` — aggregate window function with no partition for grand total
- `AVG()` for usage pattern comparison
- `GROUP BY` with multiple analytical cuts
