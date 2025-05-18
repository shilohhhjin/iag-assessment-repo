{{
    config( materialized = 'view' )
}}

with source as (

    select 
        id as tag_id,
        tagname as tag_name,
        count,
        excerptpostid as excerpt_post_id,
        wikipostid as wiki_post_id
    from 
       {{ ref('raw_tags') }}
)

select * from source 