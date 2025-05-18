{{
    config( materialized = 'view' )
}}

with source as (

    select 
        id as comment_id,
        postid as post_id,
        score,
        text,
        creationdate as creation_date,
        userid as user_id,
        contentlicense as content_license
    from 
       {{ ref('raw_comments') }}
)

select * from source 
