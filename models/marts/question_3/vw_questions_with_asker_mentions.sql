{{
    config( materialized = 'view' )
}}

with source as (
    select * from {{ ref('questions_with_asker_mentions') }}
)

select * from source 

