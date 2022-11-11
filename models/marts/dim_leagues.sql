{{ config(materialized='view') }}

with league_types as (
    select 
        distinct league_id,
        league_name
    from {{ ref('stg_epl')}}
)

select * from league_types