{{
    config( materialized = 'table' )
}}

with questions as (
    
    select 
        post_id as question_id,
        owner_user_id as question_author_id
    from {{ ref('stg_posts') }}
    where post_type_id = 1 -- 1 = question

),

answers as (
    select 
        post_id as answer_id,
        parent_id as ori_question_id
    from {{ ref('stg_posts') }}
    where post_type_id = 2 -- 2 = answer
),

combination as (
    select q.question_id,
    q.question_id as post_id,
    q.question_author_id
    from questions q
    union all
    SELECT 
        a.answer_id,
        a.answer_id as post_id,
        q.question_author_id
    FROM answers a
    JOIN questions q ON a.ori_question_id = q.question_id
),

mentioned_comments as (
    select 
        com.post_id,
        c.comment_id,
        c.user_id as commenter_id,
        c.text as comment_text,
        u.user_display_name,
        TRIM(BOTH '@' FROM lower(mention.unnest::VARCHAR)) as mentioned_username
    from {{ ref('stg_comments') }} c
    join combination com 
        on c.post_id = com.post_id
    join {{ ref('stg_users') }} u
        on u.user_id = c.user_id,
    unnest(REGEXP_EXTRACT_ALL(c.text, '@([A-Za-z0-9_\\-]{2,})')) as mention 
    where c.user_id = com.question_author_id
),
-- Filter out the comments that are not replies to other users
reply_to_other_users as (
    select 
        post_id,
        comment_id,
        commenter_id,
        comment_text,
        mentioned_username
    from mentioned_comments
    where 
        case 
            when mentioned_username is not null and lower(mentioned_username) != lower(user_display_name) 
            then true
            else false
        end
)

select 
    count(distinct post_id) as questions_with_asker_mentions 
from reply_to_other_users