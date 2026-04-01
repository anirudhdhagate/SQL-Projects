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

)


select * from circuits limit 5;
