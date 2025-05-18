{{
    config( materialized = 'table' )
}}

with posts as (
    select * from {{ ref('stg_posts') }}
),

users as (
    select * from {{ ref('stg_users') }}
)

SELECT 
    us.user_id,
    us.user_display_name,
    SUM(po.view_count) AS total_view_count
FROM posts po
JOIN users us 
ON po.owner_user_id = us.user_id
WHERE po.post_type_id = 1  -- Only include questions
GROUP BY us.user_id,
         us.user_display_name
ORDER BY SUM(po.view_count) DESC