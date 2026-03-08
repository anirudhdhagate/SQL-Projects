with cte as (select * from `project-06650eca-0291-4219-8cc.UserListenTime.UserListenTime`), -- raw table cte

-- unpivot wide format to long format
 unpivoted as ( 
  select user_id, artist, listen_time
  from cte
  unpivot(listen_time for artist IN (T_Swift, Drake, Queen, The_Weeknd, Eminem, Nirvana, Ed_Sheeran, T_Scott, Linkin_Park, Dua_Lipa, K_Lamar, Imag_Dragons, Ariana_G))

),  

ranked AS (
  SELECT *,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY listen_time DESC) AS rn,
    ROUND(listen_time * 100.0 / SUM(listen_time) OVER (PARTITION BY user_id), 2) AS pct_of_total
  FROM unpivoted
),

difference as (
  select *,  lag(listen_time, 1)  over (partition by user_id order by rn) - listen_time as diff from ranked
),

taste as (
select user_id, string_agg(artist order by artist) as top_3 from ranked where rn <= 3 group by user_id
)

-- Top 3 artists per user:
-- select * from ranked where rn <= 3;

-- percentage of listen time of favorite artist compared to total listen time and listen time drop-off between ranks
-- select *, coalesce(diff, 0) as diff from difference where rn <= 3;

-- total listeners per artist along with the total listen time
-- select artist, count(user_id) as total_listeners, sum(listen_time) as total_listen_time from unpivoted group by artist;

-- users with similar artist/music taste
-- select top_3, count(*) as user_count, string_agg(user_id) as users
-- from taste
-- group by top_3
-- having count(*) > 1;

