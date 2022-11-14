{{ config(materialized='table') }}

with stats as (
    select
    concat(substr(season, (-4), 2),'/', substr(season, (-2), 2)) as season,
    t3.league_name,
    t1.match_id,
    (t2.full_time_home_goals + t2.full_time_away_goals) as total_goals,
    (t2.home_shots + t2.away_shots) as total_shots,
    (t2.home_shots_on_target + t2.away_shots_on_target) as total_shots_on_target,
    (t2.home_fouls + t2.away_fouls) as total_fouls_commited,
    (t2.home_yellow_cards + t2.away_yellow_cards) as total_yellow_cards,
    (t2.home_red_cards + t2.away_red_cards) as total_red_cards
    from {{ ref('dim_results') }} t1
    join {{ ref('fact_stats') }} t2
        on t1.match_id = t2.match_id
    join {{ ref('dim_leagues') }} t3
        on t1.league_id = t3.league_id
)

select * from stats