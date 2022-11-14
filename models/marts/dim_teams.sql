{{ config(materialized='view') }}

with teams as (
    select 
        distinct hometeam_id as team_id,
        hometeam_name as team_name,
        league_id
    from {{ ref('stg_football')}}
)

select * from teams