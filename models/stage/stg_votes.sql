{{
    config( materialized = 'view' )
}}

with source as (

    select 
        id as vote_id,
        postid AS post_id,
        votetypeid AS vote_type_id,
        creationdate AS creation_date
    from 
       {{ ref('raw_votes') }}
)

select * from source 