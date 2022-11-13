{{ config(materialized='view') }}

with teams as (
    select 
        distinct hometeam_id as team_id,
        home_team as team_name,
        league_id
    from {{ ref('stg_epl')}}
)

select * from teams