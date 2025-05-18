{{
    config( materialized = 'view' )
}}

with source as (

    select 
        id as post_link_id,
        creationdate as creation_date,
        postid as post_id,
        relatedpostid as related_post_id,
        linktypeid as link_type_id
    from 
       {{ ref('raw_post_links') }}
)

select * from source 