{{ config(materialized='view') }}

with stats as (
    select 
        *,
        case 
            when full_time_result = 'H' then 3
            when full_time_result = 'D' then 1
            else 0 end hometeam_fulltime_points,
        case 
            when full_time_result = 'A' then 3
            when full_time_result = 'D' then 1
            else 0 end awayteam_fulltime_points,
        case 
            when half_time_result = 'H' then 3
            when half_time_result = 'D' then 1
            else 0 end hometeam_halftime_points,
        case 
            when half_time_result = 'A' then 3
            when half_time_result = 'D' then 1
            else 0 end awayteam_halftime_points

    from {{ ref('stg_football')}}
),

final as (
    select * except (season, hometeam_name, awayteam_name, full_time_result, half_time_result)
    from stats
)

select * from final