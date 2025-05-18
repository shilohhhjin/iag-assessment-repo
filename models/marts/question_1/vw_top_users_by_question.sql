{{
    config( materialized = 'view' )
}}

with source as (
    select * from {{ ref('user_question_aggregates') }}
)

select * from source 
order by source.total_view_count desc
limit 10