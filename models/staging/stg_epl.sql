{{ config(materialized='view') }}

with source_epl as (
  select

    -- ids
    {{ dbt_utils.surrogate_key(['Div']) }} league_id,
    {{ dbt_utils.surrogate_key(['season','HomeTeam','AwayTeam']) }} match_id,
    {{ dbt_utils.surrogate_key(['HomeTeam']) }} hometeam_id,
    {{ dbt_utils.surrogate_key(['AwayTeam']) }} awayteam_id,

    -- dimensions
    Div as league_name,
    season as season,
    HomeTeam as home_team,
    AwayTeam as away_team,
    FTR as full_time_result,
    HTR as half_time_result,

    -- measures
    FTHG as full_time_home_goals,
    FTAG as full_time_away_goals,
    HTHG as half_time_home_goals,
    HTAG as half_time_away_goals,
    HS as home_shots,
    `AS` as away_shots,
    HST as home_shots_on_target,
    AST as away_shots_on_target,
    HC as home_corners,
    AC as away_corners,
    HF as home_fouls,
    AF as away_fouls,
    HY as home_yellow_cards,
    AY as away_yellow_cards,
    HR as home_red_cards,
    AR as away_red_cards,

    -- date/times
    coalesce(safe.parse_date('%Y-%m-%d', Date), safe.parse_date('%d/%m/%y', Date), safe.parse_date('%d/%m/%Y', Date)) as date_formatted

  from {{ source('staging','english-premier-league_external_table') }}
  order by new_formatted_date
)

select * from source_epl