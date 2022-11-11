{{ config(materialized='view') }}

with matches as (
    select 
        distinct match_id,
        league_id,
        season,
        home_team,
        away_team,
        full_time_result,
        half_time_result
    from {{ ref('stg_epl')}}
)

select * from matches