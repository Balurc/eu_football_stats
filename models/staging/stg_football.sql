{{ config(materialized='view') }}

{% set tables = ['english-premier-league_external_table', 'french-ligue-1_external_table',
                'german-bundesliga_external_table', 'italian-serie-a_external_table', 
                'spanish-la-liga_external_table'] %}
with data_source as (
{% for table in tables %}
        select
            -- ids
            Div as league_id,
            {{ dbt_utils.surrogate_key(['season','HomeTeam','AwayTeam']) }} as match_id,
            {{ dbt_utils.surrogate_key(['HomeTeam']) }} as hometeam_id,
            {{ dbt_utils.surrogate_key(['AwayTeam']) }} as awayteam_id,

            -- dimensions
            season as season,
            HomeTeam as hometeam_name,
            AwayTeam as awayteam_name,
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
                                
        from {{ source('staging',table) }}
        {% if not loop.last -%} union all {%- endif %}
    {% endfor %}
)

select * from data_source