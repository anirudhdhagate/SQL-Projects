
with base as (
SELECT * FROM `Telecom_Churn.Customer_Churn1` 
union all 
select * from `Telecom_Churn.Customer_Churn2` 
),

# churn rate by customer service calls
churn_by_service_calls as 
(SELECT `Customer service calls`, 
  COUNTIF(`Churn` = true) * 100.0 / COUNT(*) AS churn_rate,
  COUNT(*) AS total_customers,
  sum(COUNT(*)) over () as grand_total,
  count(*) * 100.0 / sum(count(*)) over () as pct_of_customers

FROM base 
GROUP BY `Customer service calls`
),
--#select * from churn_by_service_calls ORDER BY `Customer service calls` limit 50;

# avg usage comparison between churned and unchurned customers
churn_by_usage as
(select Churn, avg(`Total day minutes`) as average_day_minutes, avg(`Total eve minutes`) as average_eve_minutes, avg(`Total night minutes`) as average_night_minutes, avg(`Total intl minutes`) as average_intl_minutes from base group by `Churn`),

-- select * from churn_by_usage;
# churn rate of customers who have got the international plan, confirms if the customer churn is high for international plans
churn_by_intl_plan as (
  select `International plan`,
  countif(Churn = true) * 100.0 / count(*) as churn_rate,
  count(*) as total_customers
  from base
  group by `International plan`
)

select * from churn_by_intl_plan;
