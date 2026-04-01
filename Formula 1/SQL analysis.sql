with results as (

SELECT * FROM `project-1-music-489315.Formula_1.results`

),

status as (

  select * from `project-1-music-489315.Formula_1.status`

),

drivers as (

  select * from `project-1-music-489315.Formula_1.drivers`

),

constructors as (

  select * from `project-1-music-489315.Formula_1.constructors`

),

races as (

  select * from `project-1-music-489315.Formula_1.races`

),

circuits as (

  select * from `project-1-music-489315.Formula_1.circuits`

),

constructors_clean as (

  select constructorId, name as constructor_name, nationality as constructor_nationality from constructors

),

drivers_clean as (

    select driverId, concat(forename, " ", surname) as driver_name, dob, nationality as driver_nationality from drivers

),


results_clean as (

  SELECT raceId, driverId, constructorId, grid, position, points, laps, fastestLap, statusId from results

),

races_clean as (

  select raceId, year as race_year, round as race_round, circuitId, name as race_name, date(date) as race_date from races

),

circuits_clean as (

  select circuitId, name as circuit_name, location as circuit_city, country as circuit_country, lat, lng, alt from circuits

),


status_clean as (

select statusId, case when status.status = 'Finished' or status.status like '%Laps%' then 'is_finished' else 'is_dnf' end as race_status, case when status.status = 'Finished' or status.status like '%Laps%' then 'Finished' when status.status = 'Accident' or status.status = 'Collision' or status.status = 'Spun off' then 'Driver-related failure' else 'Mechanical / reliability failure' end as failure_type from status

),

cte_results_drivers as (

  select * from results_clean a left join drivers_clean b on a.driverId = b.driverId

),

cte_results_constructors as (

  select * from cte_results_drivers a left join constructors_clean b on a.constructorId = b.constructorId

),

cte_results_races as (

  select * from cte_results_constructors a left join races_clean b on a.raceId = b.raceId

),

cte_results_circuits as (

  select * from cte_results_races a left join circuits_clean b on a.circuitId = b.circuitId -- circuitId is present in races, not in results

),


-- 26753

-- select * from status;

results_master as (
  
  select * from cte_results_circuits a left join status_clean b on a.statusId = b.statusId

)

select * from results_master limit 10;
