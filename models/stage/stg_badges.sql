{{
    config( materialized = 'view' )
}}

with source as (

    select 
        id as badge_id,
        userid as user_id,
        name as badge_name,
        date,
        class,
        tagbased as tag_based
    from 
       {{ ref('raw_badges') }}
)

select * from source 
