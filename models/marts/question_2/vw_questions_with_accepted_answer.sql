{{
    config( materialized = 'view' )
}}

with source as (
    select * from {{ ref('question_with_accepted_answer') }}
)

select * from source 
order by month
