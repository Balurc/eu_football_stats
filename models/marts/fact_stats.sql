{{ config(materialized='view') }}

with results as (
    select * except (league_name, season, home_team, away_team, full_time_result, half_time_result, old_formatted_date)
    from {{ ref('stg_epl')}}
)

select * from stats