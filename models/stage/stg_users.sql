{{
    config( materialized = 'view' )
}}

with source as (

    select 
        id as user_id,
        reputation as reputation_score,
        creationdate as creation_date,
        displayname as user_display_name,
        lastaccessdate as last_access_date,
        aboutme as about_me,
        views,
        upvotes as up_votes,
        downvotes as down_votes
    from 
       {{ ref('raw_users') }}
)

select * from source 