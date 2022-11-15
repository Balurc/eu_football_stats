{{ config(materialized='table') }}

with home_stats as (
  select 
    dl.league_name,
    upper(dr.season) as season, 
    dt.team_name,
    'home_stats' as status,
    case when dr.full_time_result = 'H' then 1 else 0 end as wins,
    case when dr.full_time_result = 'D' then 1 else 0 end as draws,
    case when dr.full_time_result = 'A' then 1 else 0 end as loses,
    fs.full_time_home_goals as goals_for,
    fs.full_time_away_goals as goals_against,
    (fs.full_time_home_goals - fs.full_time_away_goals ) as goals_difference,
    (fs.full_time_home_goals + fs.full_time_away_goals ) as total_goals_scored,
    fs.hometeam_fulltime_points as points
  from {{ ref('fact_stats') }} fs
  join {{ ref('dim_results') }} dr
    on fs.match_id = dr.match_id
  join {{ ref('dim_teams') }} dt
    on fs.hometeam_id = dt.team_id
  join {{ ref('dim_leagues') }} dl
    on fs.league_id = dl.league_id
),
away_stats as (
  select 
    dl.league_name,
    upper(dr.season) as season, 
    dt.team_name,
    'away_stats' as status,
    case when dr.full_time_result = 'A' then 1 else 0 end as wins,
    case when dr.full_time_result = 'D' then 1 else 0 end as draws,
    case when dr.full_time_result = 'H' then 1 else 0 end as loses,
    fs.full_time_away_goals as goals_for,
    fs.full_time_home_goals as goals_against,
    (fs.full_time_away_goals - fs.full_time_home_goals ) as goals_difference,
    (fs.full_time_away_goals + fs.full_time_home_goals ) as total_goals_scored,
    fs.awayteam_fulltime_points as points
  from {{ ref('fact_stats') }} fs
  join {{ ref('dim_results') }} dr
    on fs.match_id = dr.match_id
  join {{ ref('dim_teams') }} dt
    on fs.awayteam_id = dt.team_id
  join {{ ref('dim_leagues') }} dl
    on fs.league_id = dl.league_id
),
unioned_stats as (
  select * from home_stats
  union all
  select * from away_stats
)

select * from unioned_stats