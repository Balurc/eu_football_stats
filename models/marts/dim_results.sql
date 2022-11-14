{{ config(materialized='view') }}

with results as (
    select 
        distinct match_id,
        league_id,
        season,
        hometeam_id,
        awayteam_id,
        full_time_result,
        half_time_result
    from {{ ref('stg_football')}}
)

select * from results