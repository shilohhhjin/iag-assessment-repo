{{
    config(
        materialized = 'incremental',
        unique_key = 'month'
    )
}}

with question_info as (

    select * 
    from {{ ref('stg_posts') }}
    where post_type_id = 1
    {{ incremental_filter_by_id_and_recent_date('post_id', 'creation_date', 12, ref('stg_posts')) }}

), 

answer_info as (

    select * 
    from {{ ref('stg_posts') }}
    where post_type_id = 2
    {{ incremental_filter_by_id_and_recent_date('post_id', 'creation_date', 12, ref('stg_posts')) }}

), 

transform as (

    select 
        question_info.post_id,
        question_info.creation_date as question_post_date,
        answer_info.post_id as accepted_answer_id,
        answer_info.creation_date as answer_post_date,
        strftime('%Y-%m', question_info.creation_date) as month,
        epoch(answer_info.creation_date - question_info.creation_date) as answer_seconds_diff

    from question_info 
    join answer_info
      on question_info.accepted_answer_id = answer_info.post_id

), 

banded as (

    select
        month,
        case
            when answer_seconds_diff < 60 then '<1 min'
            when answer_seconds_diff < 300 then '1-5 mins'
            when answer_seconds_diff < 3600 then '5 mins-1 hour'
            when answer_seconds_diff < 10800 then '1-3 hours'
            when answer_seconds_diff < 86400 then '3 hours-1 day'
            else 'etc.'
        end as time_band
    from transform

),

final as (

    select 
        month,
        count(*) filter (where time_band = '<1 min') as "<1 min",
        count(*) filter (where time_band = '1-5 mins') as "1-5 mins",
        count(*) filter (where time_band = '5 mins-1 hour') as "5 mins-1 hour",
        count(*) filter (where time_band = '1-3 hours') as "1-3 hours",
        count(*) filter (where time_band = '3 hours-1 day') as "3 hours-1 day",
        count(*) filter (where time_band = 'etc.') as "etc.."
    from banded
    group by month

)
-- Incremental Join
select final.*
from final 
left join {{ this }} target
  on final.month = target.month
where target.month is null  
order by final.month