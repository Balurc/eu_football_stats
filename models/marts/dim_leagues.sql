{{ config(materialized='view') }}

with league_types as (
    select 
        distinct league_id,
        case when league_id = 'E0' then 'English Premier League'
            when league_id = 'SP1' then 'Spanish La Liga' 
            when league_id = 'I1' then 'Italian Serie-A'
            when league_id = 'D1' then 'German Bundesliga'
            when league_id = 'F1' then 'French Ligue 1'
            else NULL end as league_name
    from {{ ref('stg_football')}}
)

select * from league_types